---
layout: post
title:  "การ migrate Java project ไป version ใหม่ต้องคำนึงถึงอะไรบ้าง"
date:   2022-02-20
tags: [java, cicd, gradle]
---

ปัจจุบัน project ที่กำลังทำอยู่นั้น run อยู่บน Java version 11 ทีมเราก็มีแผนที่จะทำการ migrate ขึ้นไปเป็น version 17 เนื่องจากมี feature ใหม่ๆ ที่น่าสนใจ เช่น

- Multi-line text block รองรับหลายบรรทัด ไม่ต้องมาต่อ `+` String ยาวๆ ละ
- Switch expressions ไม่ต้องใส่ `break` statement แล้ว
- Record สำหรับ object ที่ไม่สามารถแก้ไขค่าได้ (immutable)
- Sealed class สำหรับควบคุม inheritance ของ class ใดๆ โดยการเลือกเลยว่าจะให้ class ไหน `extend` ได้บ้าง เหมาะสำหรับการเขียน code ไปใช้เป็น library
- `NullPointerException` ที่มีประโยชน์มากขึ้น โดยการปรับปรุง stack trace ว่า method ไหนที่ return `null`
- เพิ่ม `Stream.toList()` ให้แทนที่การใช้งาน `Collectors.toList()` ทำให้ code สั้่นลงแต่ยังเข้าใจมากขึ้น
- Performance ที่ดีขึ้น กิน memory น้อยลงจาก garbage collection ที่ดีขึ้น
- การอุดช่องโหว่ทาง security ต่างๆ

แต่การจะ migrate ขึ้นไป มัันก็ต้องมีค่าใช้จ่ายคือ "เวลา" ที่เราต้องเสียไป ซึ่งคำถามที่จะตามมาอย่างแน่นอนคือ
- การ migrate มันต้องมีขั้นตอนอะไรบ้าง
- การ migrate มันคุ้มไหม เอาเวลาไปทำ business requirement ดีกว่าไหม

การที่เราจะตอบคำถามเหล่านี้ได้ เราต้องคำนึงถึงอะไรบ้าง มาดูกัน

- Lombok compatibility
- JUnit test running with Maven surefire plugins
- Code coverage should not change
- CICD good
