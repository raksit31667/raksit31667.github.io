---
layout: post
title: "บันทึกการแบ่งปัน Database migration บน Go"
date: 2024-05-15
tags: [database, database-migration, practice, go, goose]
---

![Go Workshop Summer](/assets/2024-05-15-go-workshop-summer.jpg)

เมื่ออาทิตย์ได้มี[โอกาสไปแบ่งปันประสบการณ์](https://medium.com/@rpithaksiripan/%E0%B9%81%E0%B8%9A%E0%B9%88%E0%B8%87%E0%B8%9B%E0%B8%B1%E0%B8%99%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B8%AA%E0%B8%9A%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%93%E0%B9%8C-kbtg-go-software-engineering-bootcamp-%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%81%E0%B8%B4%E0%B8%88%E0%B8%81%E0%B8%A3%E0%B8%A3%E0%B8%A1-go-summer-workshop-3dd615ba265b)การทำ database migration บนระบบที่พัฒนาด้วยภาษา Go ซึ่งเป็นส่วนนึงของ workshop 2 วัน เพื่อให้เห็นภาพของขั้นตอนการส่งมอบ software ว่าเป็นอย่างไรบ้าง จากนั้นทำการออกแบบระบบตาม requirement
ทำความรู้จักเครื่องมือต่าง ๆ จากนั้นก็ลง workshop ต่อไป ซึ่งแน่นอน database migration ก็เป็นหนึ่งในนั้น  

## Database migration tool คืออะไร
หนึ่งในปัญหาที่ใหญ่ที่สุดของการพัฒนา software คือการทำงานร่วมกันกับทีม เนื่องจากจังหวะที่คนเข้าไปปรับแก้ไข database นั้น อาจจะเกิดข้อผิดพลาดจากการลงมือทำแบบอัตโนมือ ยิ่งหากมีหลาย environment แล้วยิ่งแล้วใหญ่ ต่างคนต่างทำแล้วออกมาไม่เหมือนกัน ทำให้ environment ไม่เท่ากัน เวลา deploy ขึ้นไปแล้วเกิดปัญหาก็ต้องไปงมกันต่อ  

บางทีมแก้ปัญหาด้วยการมี script กลางสำหรับทุกคน แต่ก็ยังไม่สุดเพราะเราไม่รู้ว่า file ไหนที่ถูก run ไปแล้ว จะต้องเริ่ม run จาก file ไหน ยิ่งมีหลาย environment แล้วทีมจะต้องสื่อสารกันอย่างดี ไม่งั้นตอน run จะเกิด error ได้  

ในกรณีที่มีการ deployment แล้วไม่ผ่านแล้วเราจำเป็นจะต้อง rollback การไม่มีเครื่องมือก็จะซับซ้อนมาก แล้วถ้าเกิดปัญหาขึ้นมา ข้อมูลก็อาจจะหายไปได้ ส่งผลโดยตรงต่อ user  

ด้วยเหตุผลที่ว่ามานี้ จึงเกิดเครื่องมือ data migration ขึ้นเพื่อทำให้ขั้นตอนการจัดการการเปลี่ยนแปลงของ database นั้นเป็นไปแบบอัตโนมัติ 

![Database migration](/assets/2024-05-15-database-migration.png)

ซึ่งจะมี feature คร่าว ๆ ประมาณนี้

- **Version control**: เปรียบเสมือนเป็น Git ของ database ซึ่งเครื่องมือจะสร้าง table ขึ้นมาหนึ่งอันเพื่อทำการ track ว่า migration file ไหนที่ถูก run ไปแล้วเมื่อไร เมื่อเรา run migration อีกครั้ง file ที่เคยถูก run ไปก็จะไม่ถูก run ซ้ำ นอกจากนั้นแล้วเราก็สามารถเลือกที่จะ rollback กลับไปที่ version ที่ต้องการได้ ซึ่งสามารถสั่งได้ผ่าน application code หรือ command-line
- **Migration script**: สามารถเลือกเขียนได้หลากหลาย format ทั้ง SQL และ YAML หรือแม้กระทั่งมี custom domain-specific language (DSL) เป็นของตัวเอง
- **Automation**: เราสามารถตั้งให้ migration run โดยอัตโนมัติไปพร้อมกับการ deploy application โดย migration จะ run ไปเป็นลำดับทีละ file เพื่อป้องกันไม่ให้เกิด conflict กันระหว่าง file
- **Logging**: รองรับการ logging สามารถตรวจสอบได้เมื่อเกิดปัญหาในการ migration

## ตัวอย่าง database migration ใน Go
ในตัวอย่างเราจะใช้ [goose](https://github.com/pressly/goose) เป็น database migration tool บนระบบที่พัฒนาด้วยภาษา Go โดยขั้นตอนแรกคือให้เราติดตั้ง goose ด้วยคำสั่ง

```shell
$ go install github.com/pressly/goose/v3/cmd/goose@latest
```

จากนั้นใน root directory ของ Go project ให้เราสร้าง Go package สำหรับเก็บ database migration file และ function ที่จะใช้ในการ run และหรือ rollback (ในตัวอย่างจะใช้ชื่อ `migration`) จากนั้นให้สร้าง Go file ขึ้นมาประมาณนี้

<script src="https://gist.github.com/raksit31667/fb4e12d2a2b686d3115c77c7f0a261d4.js"></script>

ด้วยความสามารถของ Go ใน version 1.16 ขึ้นไปนั้นคือมันสามารถแนบ static file ลงไปขณะ compile ได้ ([compile-time embedding](https://pkg.go.dev/embed)) เราก็เลยแนบ file ทั้งหมดที่ลงท้ายด้วย `.sql` ทั้งหมดใน file system ที่อยู่ใน package `migration` นี้ผ่านตัวแปร `embedMigrations` เพื่อนำไปใช้ใน function `ApplyMigrations` และ `RollbackMigrations` นั่นเอง  

ในส่วนของการสร้าง-เขียน migration file เราก็สามารถ run คำสั่งดังนี้ใน package `migration` โดยเราจะเปลี่ยน `sql` เป็น `go` ก็ได้หากต้องการจะเขียนด้วยภาษา Go

```shell
$ goose create <migration_name_with_underscore> sql
```

ทีนี้เราก็จะได้ file ใหม่ที่มีชื่อ `<timestamp>_<migration_name_with_underscore>.sql` ที่มีหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/16369c52677a8b7bba4207f286f1ee5d.js"></script>

จากนั้นก็ทำการเขียน SQL statement ที่ต้องการ  

ต่อมาเราก็จะทำการ run migration ทุกครั้งเมื่อ deploy วิธีเรียบง่ายที่สุดก็คือใส่ไว้ใน function `main` ใน package `main` ประมาณนี้

<script src="https://gist.github.com/raksit31667/144b6a1b1f7e9668f1ed42f7ce4e152b.js"></script>

พอเรา start server ขึ้นมา จะสังเกตว่า migration ถูก run โดยสามารถเข้าไปดูผ่าน log และ database ได้เลย

```shell
$ go run main.go

OK   00_example.sql (24.12ms)
goose: successfully migrated database to version: 0
```

คราวนี้เราลอง restart application ก็จะพบว่า file ที่เคย run ไปก็จะไม่ถูก run แล้ว

```shell
$ go run main.go

goose: no migrations to run. current version: 0
```

ในส่วนของ database ก็จะเห็น table ชื่อ `goose_db_version` ถูกสร้างขึ้นมาพร้อมกับของที่เราสร้างตามใน migration file

![Goose DB version](/assets/2024-05-15-goose-db-version.png)

ทีนี้เราลองแก้ไข migration file ที่เคยถูก run ไปแล้ว จากนั้นลอง restart ดูใหม่ จะพบว่าไม่มีการเปลี่ยนแปลงบน database เพราะเครื่องมือของเราป้องกันไม่ให้ script มันผิดเพี้ยนไปจากของบน database จริง (เกิดอีหรอบเดิม) นอกจากนั้นแล้วการ track version ก็จะยากขึ้นอีก 

## การใช้ database migration tool ช่วยในการทดสอบ
ในการทดสอบระบบที่เชื่อมต่อกับ database เราสามารถทดสอบได้หลายระดับไล่ตั้งแต่

![Test pyramid](/assets/2021-09-06-test-pyramid.png)
<https://martinfowler.com/bliki/TestPyramid.html>

- **Unit test**: ทดสอบว่าส่วนของ code ทำงานได้ตรงตามที่คาดหวังไว้ไหม เช่น code execute SQL statement ตรงตามที่คาดหวังไว้หรือไม่ แต่ปัญหาคือไม่สามารถทดสอบได้ว่า SQL statement นั้นมัน execute กับ database จริงได้ไหม

<script src="https://gist.github.com/raksit31667/7aceacb4779353f5cbfe04e5c6f03c0c.js"></script>

- **Integration test**: ทดสอบว่าเมื่อนำส่วนของ code มาเชื่อมกันแล้วยัง ทำงานได้ตรงตามที่คาดหวังไว้ไหม เช่น run application คู่กับ database จริงเพื่อทดสอบได้ว่า SQL statement นั้นมัน execute กับ database ได้ผลลัพธ์จริง ซึ่งเราควรจะทำการ rollback แล้ว re-run migration กับ database ที่ใช้ test เพื่อป้องกันไม่ให้ผลลัพธ์จาก test case นึงไปกระทบกับผลลัพธ์อีก test case นึง (เราเรียกเหตุการณ์นี้ว่า side-effect) แต่ปัญหาคือบน deployment environment จริงเราจะไม่สามารถ rollback แล้วล้างข้อมูลทิ้งได้เพราะมันมีข้อมูลใช้งานจริงอยู่

<script src="https://gist.github.com/raksit31667/26dbae113d500ede5e2fffde5a4e56b8.js"></script>

- **End-to-end test**: ทดสอบว่าบนระบบบน deployment environment จริงทำงานได้ตรงตามที่คาดหวังไว้ไหม เช่น บน API application ส่ง request ไปได้ response กลับมาถูกหรือไม่ เป็นต้น ซึ่งก็เป็นการทดสอบ database migration กลาย ๆ ว่าหลังจาก run ไปแล้วระบบมันเป็นอย่างไรด้วย

## คำถามที่น่าสนใจจากใน session

### Q: เราควรจะนำ migration ในส่วนของการสร้างข้อมูลไปรวมกับ schema หรือไม่
คำตอบคือได้! ถ้าข้อมูลของเรามันเหมือนกันในทุก ๆ environment ประเด็นคือแล้วมันควรจะเป็นข้อมูลใน database ไหม มันเปลี่ยนแปลงบ่อยแค่ไหน หรือจริง ๆ แล้วมันเป็นแค่ configuration

### Q: ในกรณีที่มีการเปลี่ยนแบบ breaking change เช่น เปลี่ยนหรือลบ column จะจัดการอย่างไร
การทำ migration ลักษณะนี้เราจะมีขั้นตอนดังนี้

1. เพิ่ม migration ในการสร้าง column ใหม่ขึ้นมาก่อนโดยที่เก็บ column เดิมไว้
2. ทำการ migrate หรือแปลงข้อมูลจาก column เก่ามาที่ column ใหม่ โดยนะนำให้ทำเป็น process แยกจาก database migration ของ application หลักเพราะจังหวะที่เราไป run บน database ใหม่ก็ไม่จำเป็นต้อง migrate เพราะไม่มีข้อมูลอะไร
3. เปลี่ยน application ให้มาใช้งาน column ใหม่
4. เมื่อ column เดิมไม่ได้ใช้แล้วก็ค่อยเพิ่ม migration สำหรับการลบ column นั้นทิ้งไป

> จะเห็นว่า database migration tool นั้นถูกสร้างมาเพื่อช่วยในด้าน software engineering เนื่องจากการทำงานร่วมกับของคนในทีมอาจจะเกิดความผิดพลาดขึ้นจากการไปแตะส่วนสำคัญของระบบ นอกจากนั้นแล้วยังสามารถใช้ทดสอบระบบได้อีกด้วย
