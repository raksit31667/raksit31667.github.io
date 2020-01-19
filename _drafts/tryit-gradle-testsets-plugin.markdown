---
layout: post
title:  "จัดกลุ่มการทดสอบด้วย Gradle TestSets plugin บน Spring Boot"
date:   2020-01-17 15:30:00 +0700
tags: [spring, gradle, testing, integration-testing, acceptance-testing]
---
จาการแบ่งชุดการทดสอบตามแนวคิด [Test pyramid](https://martinfowler.com/bliki/TestPyramid.html) นั้น
จะเห็นได้ว่า

> การทดสอบแต่ละระดับก็จะให้ Feedback ที่เร็วและช้าต่างกัน Cost ที่จ่ายก็ต่างกัน และความเชื่อมั่นในการทดสอบก็ต่างกัน

| Test          | Unit test     | Integration test  | End-to-end test  |
| ------------- |:-------------:|:-----------------:|:----------------:|
| Feedback      | Fast          | Medium            | High             |
| Cost          | Cheap         | Affordable        | Expensive        |
| Confidence    | Low           | Medium            | High             |

ดังนั้นเราควรจะแบ่งการทดสอบให้เหมาะสมกับ Feedback และ Confidence ที่เราอยากได้

สำหรับใน Spring Boot เราสามารถทำได้โดยใช้ Gradle TestSets plugin ตามนี้

<script src="https://gist.github.com/raksit31667/699b8e5cb9cdad6fb5e7f7d1e3c85d78.js"></script>

**คำอธิบาย**
1. ติดตั้ง [plugin](https://plugins.gradle.org/plugin/org.unbroken-dome.test-sets) ผ่าน Gradle โดยเข้าไปเพิ่มในไฟล์ `build.gradle` ส่วน Initial

2. เพิ่มส่วน `testSets` ลงไปใน `build.gradle` จากนั้นเพิ่มชื่อประเภทของการทดสอบ (เราสามารถเก็บ unit test ไว้ใน module `test` ได้เหมือนเดิม)
```
testSets {
    integrationTest
}
```
กลุ่ม integration test จะอยู่ใน directory `src/integrationTest` แต่เราสามารถเปลี่ยน directory name ได้โดยเพิ่ม `dirName` ลงไป
```
testSets {
    integrationTest {
        dirName = 'integration-test'
    }
}
```
directory ก็จะเปลี่ยนเป็น `src/integration-test` แทนละ
3. สร้าง directory ใหม่ตามที่เราประกาศเอาไว้จากข้อ 2 จากตัวอย่างจะได้หน้าตาประมาณนี้
```
src
│   main
│   test // สำหรับ unit test
|   integration-test // สำหรับ integration test
```

4. เพิ่ม task ใน `build.gradle` ตามชื่อของประเภทการทดสอบของเรา เพื่อให้ gradle รู้ว่า directory นี้มี test อยู่ ตกอย่างเช่น
```
integrationTest {
    useJUnitPlatform()
}
```  

เป็นอันเสร็จพิธี เท่านี้ก็สามารถรัน unit test ได้ผ่านคำสั่ง`./gradlew test` และ integration test ผ่านคำสั่ง `./gradlew integrationTest`

> นอกจากนี้ยังมี feature ที่น่าสนใจอย่างเช่น test extension, publishing artifact และ Kotlin support ด้วย ลองไปเล่นกันได้ครับ




