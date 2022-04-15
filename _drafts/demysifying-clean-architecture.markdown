---
layout: post
title:  "Clean architecture มันดีสำหรับปี 2022 ไหม"
date:   2022-04-15
tags: [clean-architecture, architecture]
---

เมื่ออาทิตย์ที่แล้วมีโอกาสได้เข้า session ของคุณ [Chris](https://chrisza.medium.com/) เกี่ยวกับ Clean architecture โดยส่วนตัวผมคิดว่ามันมีแนวทางที่น่าสนใจในการทำความเข้าใจกับเรื่องของ architecture ดังนั้นมาดูกันหน่อย  

## What and Why?

Clean architecture ถูกคิดค้นขึ้นเมื่อปี 2005 เกิดจากปัญหาการเชื่อมระบบเข้ากับ third-party เยอะแยะมากมายบน software ในระดับ enterprise เช่น การเชื่อมกับ Enterprise resource planning (ERP), core system, financial service ต่าง ๆ ซึ่งส่วนใหญ่จะเป็นระบบที่มีความซับซ้อนในตัวของมันเอง ซึ่งในความซับซ้อนนี้ย่อมมีผลตามมา ได้แก่

### ค้นหาต้นเหตุยากเมื่อมีปัญหาเกิดขึ้น

โดยปกติแล้ว การที่เราจะบอกว่า code มันทำงานได้อย่างถูกต้อง จะต้องประกอบไปด้วย 2 อย่างคือ

1. Code ทำงานตรงตาม requirement ได้ถูกต้อง
2. Code ได้ถูก integrate เข้ากับระบบได้อย่างถูกต้อง

ปัญหาของ code ในระดับ enterprise ที่กล่าวมาข้างต้นคือ เราจะใช้เวลาในการค้นหาต้นเหตุยากเมื่อมีปัญหาเกิดขึ้น เพราะ code ส่วน domain business logic และส่วน integration มันมารวมอยู่ในที่เดียวกันนั่นเอง สุดท้ายก็ลงเอยที่การโทษกันไปโทษกันมาเพราะหาไม่เจอว่ามันผิดที่ตรงไหน

### การเชื่อมระบบเข้ากับ third-party เป็นไปด้วยความยากลำบาก
ระบบ third-party มักจะมี protocol เฉพาะเป็นของตนเอง ซึ่งไม่ได้เหมือนกับ protocol ยอดนิยมอย่าง HTTP สักเท่าไร จึงต้องมี domain expert ที่มีความรู้ในการเชื่อมระบบ เช่น ERP หรือ mainframe แต่ในชีวิตจริงเราก็ไม่สามารถหาคนเหล่านี้มาเข้าทีมได้ทันเวลา ทำให้ทีมพัฒนาต้องศึกษาเพิ่มเติมเอง มีผลโดยตรงต่อการส่งมอบคุณค่าทาง business แน่นอน


## Clean architecture ช่วยได้อย่างไร
Clean architecture มีแนวคิดหลักๆ อยู่ 2 อย่างคือ

1. แยก code ส่วนการเชื่อมระบบเข้ากับ third-party ออกจาก code ส่วน domain business logic ผลที่ตามมาคือจะทำให้ทีมพัฒนาสามารถค้นหาข้อผิดพลาดได้ง่ายขึ้น ส่งผลให้แก้ปัญหาได้รวดเร็วขึ้น
2. Domain จะเป็นหัวใจหลัก เนื่องจากต่อให้รูปแบบของเชื่อมต่อเปลี่ยนไป business logic ก็มีแนวโน้มในการเปลี่ยนแปลงน้่อยมาก ดังนั้น code ส่วนการเชื่อมระบบเข้ากับ third-party สามารถเรียกใช้ code ส่วน domain ได้ แต่กลับกัน domain ไม่ควรผูกติดกับส่วน third-party ใด ๆ เลย

![The clean architecture](/assets/2022-04-15-the-clean-architecture.jpeg)
<https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html>

## ตัวอย่างการทำงานของทีมใน enterprise ใหญ่ ๆ

### Domain team
ทุกอย่างเริ่มจาก domain team โดยการทำการวาง *Entities* ที่จะประกอบไปด้วย business logic สังเกตว่าจะไม่มี dependencies กับ third-party ใด ๆ เลย เช่น database

<script src="https://gist.github.com/raksit31667/f352e01f7c02963208efbe2d769e3aca.js"></script>

### Database team
ในขณะเดียวกัน logic ของเราก็ต้องมีการเชื่อมต่อกับ database เหมือนกัน เราก็ให้ domain team เตรียม *Interface Adapters* ไว้ สำหรับเข้าถึง database แล้ว format ข้อมูลมาเป็น *Entities* ที่เราต้องการ

<script src="https://gist.github.com/raksit31667/ea3786f119b31107a5288da562cc483c.js"></script>

จากนั้น database team ก็ไปทำ implementation จริง ๆ ตาม *Interface Adapters* ที่ domain team ทำไว้

<script src="https://gist.github.com/raksit31667/059cc2877c7217de5ef8544d119e20a4.js"></script>

### Application team
เราจะนำส่วน *Entities* และ *Interface Adapters* มาประกอบเป็น application ใน layer *Use Cases* โดยที่เราใส่ business logic ตาม application ไปเพิ่มได้ สังเกตว่า application team จะไม่เรียกใช้ `PurchaseRequestRepositoryImpl` ที่เป็น implementation จริงของ Database team แต่จะ inject `PurchaseRequestRepository` ที่เป็น *Interface Adapters* เป็น dependencies ในการเข้าถึง database layer แทน

<script src="https://gist.github.com/raksit31667/b48c10033f2cbd98536c366dc61cf076.js"></script>

สิ่งที่ตามมาคือ แต่ละส่วนไม่ได้ผูกติดกันในที่เดียว ส่งผลให้หาจุดผิดพลาดง่ายขึ้น การทดสอบง่ายขึ้น เวลา third-party dependencies แก้ไข implementation ก็จะไม่มีผลกระทบต่อผลการทดสอบของเรา

## การใช้งานจริง
ถ้าเราดูจากตัวอย่างแล้ว จะสังเกตว่ามันไม่ค่อยสมเหตุสมผลกับปี 2022 เท่าไร เหตุผลคือการเชื่อมระหว่าง application กับ third-party สามารถทำได้ง่ายโดยที่ไม่จำเป็นต้องแยกเป็นหลาย ๆ ทีมเลย ปัจจุบันเป็นเรื่องปกติมากที่ทีมพัฒนาจะดูแลทั้ง application และ dependencies ไปพร้อม ๆ กันด้วยซ้ำ แต่ตอนที่ Clean architecture ถูกคิดค้นเมื่อปี 2005 การเชื่อมกันยังเป็นไปด้วยความยากลำบาก มันเลยดูสมเหตุสมผล ณ ขณะนั้นนั่นเอง  

ถ้าเราทำตาม Clean architecture แบบเป๊ะ ๆ เราจะพบว่าเราไม่สามารถเอา code ที่เราเขียนจะไปผูกติดอยู่กับ framework ได้เลย เช่น object-relation mapping (ORM) เพราะ framework ก็ถือว่าเป็น third-party เหมือนกัน แต่ในการใช้จริงก็จะมีข้อสังเกตว่า

- มีโอกาสที่ระบบของเราจะเปลี่ยนไปใช้ framework อื่นไหม
- จะเขียน code ที่ทำงานได้เหมือนกับ framework หมายความว่าเราสร้าง framework ขึ้นมาเองใหม่โดยไม่รู้ตัวหรือเปล่า
- เราจะหา developer ที่สามารถเขียน code สร้างระบบโดยไม่ใช้ framework ได้จากไหน

ดังนั้นในการใช้จริง เราก็อาจจะหลีกเลี่ยงไม่ได้ที่ต้องมีการผสมกันระหว่าง domain และ third-party ไปบ้าง ซึ่งทีมก็ต้องมาตัดสินใจว่าเราจะเลือกที่จะผสมในส่วนไหนบ้าง เพื่อไม่ให้มันมีผลกระทบกับ productivity มากจนเกินไปนั่นเอง

> โดยสรุปแล้ว Clean architecture เป็นแนวคิดที่ดีในการแยก domain business logic ออกจาก third-party โดยเราใช้เทคนิคการทำ dependency injection และ program to interfaces มาสร้าง productivity ที่ทำให้เราสามารถค้นหาข้อผิดพลาดได้ง่ายขึ้น ส่งผลให้แก้ปัญหาได้รวดเร็วขึ้น

## Further reading
- [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)