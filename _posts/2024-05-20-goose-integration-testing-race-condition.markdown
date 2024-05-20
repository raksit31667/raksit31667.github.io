---
layout: post
title: "แก้ปัญหา race condition ของการ run database migration ใน integration test ของระบบภาษา Go"
date: 2024-05-20
tags: [database-migration, docker, go, goose, testing]
---

เมื่ออาทิตย์ก่อนได้มี[โอกาสไปแบ่งปันประสบการณ์](https://medium.com/@jnuchit/%E0%B9%83%E0%B8%84%E0%B8%A3%E0%B9%84%E0%B8%A1%E0%B9%88-design-software-design-1ab127565cb0) ว่าด้วยเรื่องของ software engineering practice ผ่านการพัฒนาระบบด้วยภาษา Go ซึ่งเป็นส่วนนึงของ workshop 2 วัน เพื่อให้เห็นภาพของขั้นตอนการส่งมอบ software ว่าเป็นอย่างไรบ้าง จากนั้นทำการออกแบบระบบตาม requirement
ทำความรู้จักเครื่องมือต่าง ๆ จากนั้นก็ลง workshop ต่อไป ซึ่งแน่นอน database migration ที่ใช้งานผ่านเครื่องมือ [goose](https://github.com/pressly/goose) ก็เป็นหนึ่งในนั้น  

จาก[บทความก่อนที่เคยแบ่งปันไป]({ post_url 2024-05-15-database-migration-go-sharing }) พอมาลง workshop ปรากฎว่ามีอยู่กุล่มนึงเกิดปัญหาที่น่าสนใจระหว่างการเขียน integration test ขึ้น  

## Integration test

<script src="https://gist.github.com/raksit31667/26dbae113d500ede5e2fffde5a4e56b8.js"></script>

## Dockerfile
`Dockerfile` สำหรับเอาไว้ build Go Docker container โดยติดตั้ง dependencies และ run คำสั่งผ่าน Go CLI

<script src="https://gist.github.com/raksit31667/51725d82472aa71b29fe891c5c608340.js"></script>

## Docker Compose
`docker-compose.it.test.yaml` สำหรับเอาไว้ run integration test ที่เชื่อมต่อกับ PostgreSQL ที่ run บน Docker container
<script src="https://gist.github.com/raksit31667/0dacc7943b22fff773a9baf610d1e41c.js"></script>

ปรากฏว่าพอ run บน local machine ก็ผ่านปกติ 

```shell
docker-compose -f docker-compose.it.test.yaml down && \
	docker-compose -f docker-compose.it.test.yaml up --build --force-recreate --abort-on-container-exit --exit-code-from it_tests
```

แต่พอไป run บน CI แล้ว error ว่าหา database table ไม่เจอ แต่อีก test case นึงดันหาเจอ

```console
it_tests_1  |         	Error:      	Not equal: 
it_tests_1  |         	            	expected: 201
it_tests_1  |         	            	actual  : 500

db_1        | ERROR:  relation "..." does not exist at character 13
db_1        | STATEMENT:  INSERT INTO "..." (...) VALUES (...) RETURNING id;
```

ทีนี้สาเหตุคือ Go จะ run test แบบ concurrent หากมันอยู่คนละ package กัน เช่นเดียวกับการ compile แบบ concurrent หากอยู่คนละ package เพราะหน่วยที่เล็กที่สุดของ Go คือ package  

แปลว่า test case ที่ run เสร็จก่อนจะไป rollback migration ตามที่ได้เขียนไว้ว่า `defer migration.rollbackMigration(...)` ก่อน ทำให้ จังหวะที่ test case อีกอันที่ run อยู่แล้วเข้า statement ในการ query ของ database จะหา table ไม่เจอ (เรียกเหตุการณ์นี้ว่า race condition)  

วิธีแก้ก็คือแทนที่จะ rollback ก็ลบ record ที่เกิดจากการสร้างของแต่ละ test case **แต่ข้อควรระวังคือ ห้าม truncate table!** เพราะข้อมูลของอีก test case นึงที่กำลังจะใช้ก็อาจจะหายไปด้วย  

ข้อสังเกตอีกอย่างนึงคือเราควรจะเปลี่ยนจากการใช้ `defer` เป็น `t.Cleanup` แทนเพราะอย่างหัลงมันเจาะจงไปที่ testing มากกว่า

<script src="https://gist.github.com/raksitman/157d530d81408e143a5ed89dac198d64.js"></script>

ทีนี้พอลอง run ใหม่ปรากฏว่าผ่านแล้วทั้งบน local machine และบน CI แต่พอ run รอบถัดไปก็ดันไม่ผ่านอีก! คราวนี้น่ากลัวกว่าเดิมเพราะ run ผ่านบ้างไม่ผ่านบ้าง แสดงว่ามันยังคงเกิด race condition อยู่ผ่าน statement การ migrate `migration.ApplyMigrations(conn)` ซึ่งก็มีคนไปเปิด [GitHub issue](https://github.com/pressly/goose/issues/258) ไว้ด้วย ซึ่ง maintainer เขาก็ตอบกลับมาว่า

> This is intended behaviour. goose is meant to be run as a singleton to apply migrations sequentially, generally this is best practice.

> E.g., however your application starts up, you'd run a container, or a binary, etc. to apply your migrations and upon success continue to rollout your application.

> I'd suggest decoupling your migrations from your main application.

แปลว่าวิธีแก้ที่หายขาดคือต้องเอา process การทำ database migration แยกออกจากการทำ application นั่นเอง โดยให้เราไปลบ `migration.ApplyMigrations(conn)` ออก แล้วใน `Dockerfile.it` ให้เราไปติดตั้ง database migration tool เพิ่ม ซึ่งก็คือ `goose` นั่นเอง โดยเวลาเราติดตั้งนั้น

- ถ้าอยากได้ executable ต้องติดตั้งผ่านคำสั่ง `go install` ของที่ติดตั้งจะอยู่ใน `/go/bin`
- ถ้าอยากได้ package ต้องติดตั้งผ่านคำสั่ง `go get` ของที่ติดตั้งจะอยู่ใน `/go/pkg`

ในกรณีนี้เราเลยต้องใช้ `go install` เพราะเราจะได้ใช้ goose CLI ได้

<script src="https://gist.github.com/raksit31667/6e49445f57bfc9fba64087c0a464e432.js"></script>

ทีนี้พอเรา run ใหม่ก็เป็นผ่านตลอดแล้ว เพราะ process การทำ database migration นั้นเกิดก่อน integration test จึงการันตีได้ว่าจะไม่เกิด race condition แน่ ๆ 

![GitHub Actions passed](/assets/2024-05-20-github-actions-passed.png)

![Solution sharing](/assets/2024-05-20-solution-sharing.png)

> แน่นอนว่าเราต้องปรับแก้ script ในการ deploy ให้ database migration เป็น process แยกอีกทีด้วยเช่นกัน