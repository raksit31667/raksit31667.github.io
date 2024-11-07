---
layout: post
title: "แนะนำ Dive เครื่องมือสำหรับวิเคราะห์ Docker image แบบละเอียด"
date: 2024-11-07
tags: [docker, dive, tools]
---

ช่วงที่ผ่านมามีงานต้อง maintain ระบบ infrastructure platform ที่เป็น legacy หนึ่งในปัญหาที่เจอคือไม่สามารถค้นหา Dockerfile ของ legacy Docker image ซึ่งถูกใช้ run อยู่ในระบบได้ เพราะต้นฉบับน่าจะอยู่กับคนที่ลาออกไปแล้ว (แม่งโคตรเศร้าเลย ฮ่า ๆๆ)  

วันนี้เราเจอเครื่องมือเจ๋ง ๆ ที่ช่วยให้เราสามารถสำรวจ content ของ Docker image แต่ละ layer ได้แบบละเอียดยิบ นั่นก็คือ [Dive](https://github.com/wagoodman/dive)

## Dive คืออะไร
[Dive](https://github.com/wagoodman/dive) เป็นเครื่องมือที่ให้เราดูรายละเอียดภายในของแต่ละ layer ใน Docker image ไม่ว่าจะเป็น file ที่ถูก update, command ที่ถูก run ทั้ง build-time และ runtime นอกจากนั้น Dive ยังช่วยวิเคราะห์และประเมินว่า Docker image ของเรามีประสิทธิภาพแค่ไหน มี wasted space มากน้อยเพียงใด

วิธีใช้งาน Dive ก็ง่ายนิดเดียว เพียง run คำสั่งนี้

```shell
dive <your-image-tag>
```

เราสามารถสร้างและวิเคราะห์ Docker image ในคำสั่งเดียวได้เลย ด้วยการใช้

```shell
dive build -t some-tag /path/to/Dockerfile
```

## Feature เด่น ๆ ของ Dive 🕵️

![Dive Demo](/assets/2024-11-05-dive-demo.gif)
<https://github.com/wagoodman/dive>

### 1. แสดง content ของ Docker image แบ่งตาม layer
เมื่อเราเปิด Dive ขึ้นมา ด้านซ้ายจะแสดง layer ของ image แต่ละชั้น ส่วนด้านขวาจะแสดง file ที่อยู่ใน layer นั้นรวมกับ layer ก่อนหน้า เรียกว่าเห็นหมดว่าแต่ละชั้นมีอะไรบ้าง เราสามารถใช้ปุ่มลูกศรเลื่อนเพื่อดู file ทั้งหมดใน tree ได้ด้วยนะ

### 2. ประเมินประสิทธิภาพของ image
ด้านซ้ายล่าง Dive จะมีส่วนที่บอกประสิทธิภาพของ image ว่า wasted space มีมากน้อยเพียงใด เช่น มี file ซ้ำกันระหว่าง layer, ย้าย file ข้าม layer เป็นต้น

### 3. ใช้ใน CI/CD ได้
Dive ยังสามารถใช้ใน CI/CD pipeline ได้อีกด้วย โดยเราสามารถกำหนดให้ image ต้องผ่านเกณฑ์ที่ตั้งไว้ (เช่น มี wasted space ไม่เกิน % ที่กำหนด) ก่อนจะ deploy ขึ้น production แค่ตั้งค่า `CI=true` ใน environment แล้วใช้คำสั่ง Dive ที่ต้องการ เท่านี้ Dive ก็จะให้ pass/fail ตามเงื่อนไขที่เรากำหนด

> หวังว่า Dive จะเป็นตัวช่วยให้ทุกคนที่ต้องทำงานกับ Docker เพื่อสำรวจวิเคราะห์เพื่อจัดการหรือปรับปรุง image ให้ดีขึ้นไป