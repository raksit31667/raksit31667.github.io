---
layout: post
title:  "บันทึกการทำ Database migration ด้วย Flyway"
date:   2020-01-29
tags: [database-migration, database, flyway]
---
วันนี้มีรุ่นพี่ของอีกทีมมาถามว่า จะทำการ copyback (เอา data + schema จาก server หนึ่งไปอีก server หนึ่ง) ยังไง
ผมก็เลยนึกถึงโปรเจคของตัวเอง เพราะเคยมีปัญหาลักษณะแบบนี้นี้เกิดขึ้นเหมือนกัน

โดยปกติทีม development ก็จะทำบน local machine ของตัวเอง ต่างคนต่างก็มี local database instance เป็นของตัวเอง  
วันดีคืนดีมีการ update schema โดยการเพิ่ม 1 column ปัญหาที่เกิดขึ้นคือ การที่จะ update schema มันช่างยากลำบากเหลือเกินเนื่องจาก  
- ต้องส่ง SQL script ที่ update ให้ developer ทุกคน
- ต้องส่ง SQL script การสร้าง schema ทั้งหมดให้ developer คนใหม่
- ต้อง remote shell เข้าไปรัน SQL เพื่อ update ให้กับทุก environment บน server

ดังนั้นทีมจึงต้องป้องกันไม่ให้ปัญหาเหล่านี้เกิดขึ้น โดยการหา tool ที่เหมาะสมมาใช้ โดยควรจะต้องมี  
- สามารถทำงานได้บนหลาย OS ทั้ง Windows, Linux, และ macOS (แต่จริงๆ แล้ว developer ควรใช้ OS ให้เหมือนกันนะ)
- สามารถทำงานกับ database หลายๆ เจ้าได้
- มี plugin กับ framework ที่ใช้ เช่น Java Spring
- ความสามารถในการ revert หากการ update ล้มเหลว

แนะนำ [Flyway](https://flywaydb.org/) สำหรับการทำ database migration โดยจะทำการ create table `flyway_schema_history` ซึ่งเก็บ schema history ไว้
เพียงแค่เราสร้าง SQL file ไว้ใน classpath Flyway ก็จะทำการสร้าง inital state ไว้เป็น milestone เก็บไว้ใน table นั้น หากมีการ update เราก็แค่สร้าง file ใหม่
ที่มี version สูงกว่า Flyway ก็จะเก็บ version ใหม่เป็นลำดับต่อจาก version เก่าต่อไป

![Flyway migration](https://flywaydb.org/assets/balsamiq/Migration-1-2.png)
*รูปตัวอย่างอธิบายการทำงานของ Flyway [https://flywaydb.org/getstarted/how](https://flywaydb.org/getstarted/how)*

## Feature
- **Migrate** ใน Gradle plugin สามารถรันอัตโนมัติเวลาทำการ start application ได้เลย ไม่ต้องรัน command-line
- **Clean** ยากเริ่มนับ 1 ใหม่ก็สามารถลบ history ทั้งหมดได้
- **Baseline** การ integrate เข้ากับ database ที่มีอยู่โดยไม่ต้องเริ่มนับ 1 ใหม่

นอกจากนั้นยังมี Info, Validate, และ Repair **ส่วน Undo ต้อง upgrade เป็น Pro version** เสียตังค์ ฮ่าๆๆๆ

## ข้อควรระวัง
- ถ้ามีการ migrate ไปแล้วจะไม่สามารถแก้ SQL file ที่มีอยู่ได้ เพราะ Flyway เก็บ **checksum** ไว้เช็ค
- สามารถแก้ได้โดยการ clean **แต่อย่าทำบน production นะ**

> ลองนำไปใช้กันดูครับ ง่ายและมีประโยชน์มากๆ

## References
[Flyway official documentation](https://flywaydb.org/documentation/)





