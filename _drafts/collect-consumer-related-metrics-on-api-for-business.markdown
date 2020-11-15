---
layout: post
title:  "บันทึกการเก็บ metrics เกี่ยวกับ consumer ใน API เพื่อวัด business value"
date:   2020-11-15
tags: [spring, prometheus, monitoring]
---

## มาเข้าใจกันก่อนว่าทำไปทำไม

เรามีโจทย์ที่ทีมซึ่งมี business และ technical ต้องทำร่วมกันคือ เราจะวัดผลว่าระบบของเรามันมี business value อย่างไร ซึ่งถ้าระบบของเรามันเป็น customer-facing applications ก็ดีไป *แล้วถ้าไม่ใช่ละ จะวัดกันอย่างไร*  

ทีมจึงได้ข้อสรุปร่วมกันว่า เราจะวัดผลจากยอดการใช้งานละกัน เช่นระบบของเราหลังบ้านเป็น API เช่น วัดเอาว่า แต่ละ service แต่ละ feature ลงไปลึกถึงแต่ละ endpoint มีผู้ใช้งานกี่คน แต่ละคนเรียกใช้งานระบบกี่ครั้ง เป็นต้น  

ปัญหาคือ แล้วเราจะเก็บค่าจากไหน เนื่องจากระบบของเราไม่ได้เก็บไว้ว่ามี user คนไหนบ้าง เรา authenticate และ authorize ผ่าน OAuth authentication ดังนั้น JWT token จึงเป็นข้อมูลที่ทำให้รู้ข้อมูล user ซึ่งพบใน JWT claim ต่างๆ อย่างใน Azure Active Directory เราสามารถรู้ service principal ได้ผ่าน `appid` claim  

หนึ่งในไอเดียที่ทำร่วมกับทีมคือเราต้องเพิ่ม identifier หรือ tag ลงไปใน metrics ที่ service แสดง เพื่อจำแนกการใช้งานของ consumer  

```jsonc
{
  "aud": "...",
  "iss": "https://sts.windows.net/.../",
  "iat": 123456789,
  "nbf": 123456789,
  "exp": 123456789,
  "aio": "...",
  "appid": "...",
  "appidacr": "1",
  "idp": "https://sts.windows.net/.../",
  "oid": "...",
  "rh": "...",
  "roles": [
    "Write",
    "Read"
  ],
  "sub": "...",
  "tid": "...",
  "uti": "...",
  "ver": "1.0"
}
```

## การแก้ปัญหาแบบวิถีชาว Economy

<script src="https://gist.github.com/raksit31667/2bcfc3b06e65ada30f7569f0897f5623.js"></script>

เมื่อพูดถึงเรื่องของการทำ software development แบบ Agile ทำให้นึกย้อนกลับไปถึง 1 ใน [principle 12 ข้อ](https://agilemanifesto.org/principles.html) ที่เขียนไว้ว่า

> Our highest priority is to satisfy the customer through early and continuous delivery of valuable software.