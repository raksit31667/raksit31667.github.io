---
layout: post
title:  "สรุปสิ่งที่ได้เรียนรู้จาก Architecture Night November 2021"
date:   2021-11-08
tags: [architecture]
---

> TL;DR
> 1. สิ่งสำคัญอันดับแรกที่เราควรตั้งคำถามกับลูกค้าคือ เรื่องของความสำคัญก่อน-หลัง
> 2. การเน้นไปที่การ copy architecture เดิมไปไว้บน cloud เป็นสิ่งนึงที่อันตราย

เมื่ออาทิตย์ที่แล้วได้มีโอกาสเข้า workshop เกี่ยวกับ software architecture ที่จัดขึ้นทุกเดือน เป็นพื้นที่ที่เราสามารถมาเรียนรู้ได้นอกจากในงานจริง ซึ่งในเดือนนี้เป็น theme เกี่ยวกับ evolutionary architecture ในส่วนของการ capture ผมได้เขียน[บทความก่อนหน้า]({% post_url 2020-02-02-capturing-evolutionary-architecture-using-adr %})ไว้แล้วครับ ดังนั้นบทความนี้จะมาเน้นในเรื่องของ technical solution design กัน ซึ่งแน่นอนว่า**ไม่มีผิด-ถูก**  

## โจทย์ตัวอย่าง
สมมติว่ามีระบบ online financial ที่ไม่มีสาขาหน้าร้านใดๆ ซึ่งประสบความสำเร็จในประเทศหนึ่ง โดยระบบประกิบไปด้วย load balancer ซึ่งต่อกับ web app ที่รองรับทั้ง customer จากข้างนอก (1k requests/sec) และ user ภายในกันเอง (100 requests/sec) โดยเชื่อมต่อกับ RDBMS database (80% read - 20% write operations) และระบบ 3rd party อยู่ เป็นไปตาม diagram ดังรูป
![Problem diagram](/assets/2021-11-08/2021-11-08-problem-diagram.png)

**ภายใน 1 ปี ระบบจะสามารถ**  
- ออก product เกี่ยวกับ financial ตัวใหม่ (ต้องมีการแก้ไข web app และ database)
- ให้ข้อมูลส่วนตัวและการเงินของลูกค้าแก่ตำรวจ

**ภายใน 2 ปี ระบบจะสามารถ**  
- รองรับ mobile application
- รองรับลูกค้าที่มาจากต่างประเทศได้
- รองรับ request customer จากข้างนอกได้ 100k requests/sec และ user ภายในกันเองได้ 10k requests/sec

**ปัญหาของระบบเดิม**  
- Scale ไม่ได้ เพราะ deploy อยู่ใน Virtual machine (VM) บน data center ของตัวเอง
- Performance กาก
- ระบบมี Service level agreement (SLA) 98% เมื่อระบบเกิดปัญหาจนล่มเพราะเอา bug ขึ้น production จนต้อง restart ใหม่ด้วยตัวเอง (แต่ตอน deploy เป็น automated นะ)
- ลูกค้ามีงบจำกัด มีทีมพัฒนาไม่กี่คน การจะเสนอ technology ใหม่ทั้งหมดอาจจะเป็นเรื่องยาก

> หากใครพัฒนา software มาสักพัก จะพบว่ามันเป็นปัญหา classic ที่หลายๆ คนอาจจะพบเจอระหว่างการปรับปรุงระบบเดิม

## การแก้ปัญหา
จากปัญหาดังกล่าว เราสามารถใช้วิธีแก้คร่าวๆ ได้ อย่างเช่น
- เริ่มจากการ scale up ก่อน (เพิ่ม CPU หรือ memory) ถ้ายังไม่ไหว ก็ scale out (เพิ่มจำนวนเครื่อง)
- ปรับปรุงการทำงานของ database ไม่ว่าจะเป็น query หรือ indexing
- upgrade dependencies ของฝั่ง web app ที่ใช้ หรือ refactor code ให้มันยืดหยุ่นมากขึ้น
- ปรับปรุงระบบ continuous integration และ delivery เพื่อเก็บ feedback ด้วยการทดสอบแบบต่างๆ หรือมี environment แยกก่อนนำขึ้น production

แต่ในเมื่อมีงบจำกัด ทีมพัฒนาก็น้อย ดังนั้นปัญหาพวกนี้มันไม่สามารถแก้ได้พร้อมกันทีเดียว สิ่งสำคัญอันดับแรกที่เราควรตั้งคำถามกับลูกค้าคือ **เรื่องของความสำคัญก่อน-หลัง** เพราะต่อให้เรามี architecture ที่แก้ปัญหาได้สวยงาม แต่ถ้ามันไม่ตอบโจทย์ ณ ขณะนั้น มันก็ไม่น่าจะดีนะ  

ตัวอย่างเช่น ถ้าความสำคัญแรกคือการ scale สิ่งถัดมาคือเราจะ scale สิ่งไหนก่อนระหว่าง web app หรือ database จากการ present ในแต่ละกลุ่มพบว่าเลือกไปในทาง database ก่อน จากความรู้ว่าอัตราส่วนในการ read-write ข้อมูลเป็น 80:20 เราสามารถทำการแยก database เป็น read-write แยกกัน ตามนี้

![Architecture version 1](/assets/2021-11-08/2021-11-08-architecture-version-1.png)

- ถ้าเรา scale web app ก่อน เดาว่าคอขวดมันก็ไปตกที่ database อยู่ดี (ควรจะมีการทำ monitor ก่อนว่าคอขวดจริงๆ มันอยู่ที่ไหน)
- ถ้าเป้าหมายของเราคือการนำระบบจาก data center ของตนเองไปไว้ใน cloud ตัว database เป็นส่วนแรกที่ต้องคำนึงถึงเพราะอาจจะมีความซัับซ้อนในการ migrate ข้อมูลและการจัดการกับข้อมูลส่วนตัวได้ รองลงมาคือ infrastructure เช่น networking ต่างๆ เพราะสมมติย้าย database ขึ้นไปบน cloud แต่ web app ยังต้องเชื่อมต่อจาก data center มันจะไปเพิ่ม latency ไหม (?) ตรงนี้ต้องมาดู option เพิ่ม เช่น hybrid cloud แต่ต้องแลกกับค่าใช้จ่ายที่สูงขึ้น ก็ต้องไปว่าด้วยเรื่องความสำคัญก่อน-หลังอีกที  

ดังนั้นใน version ถัดไป เราอาจจะวางแผนในการย้ายเฉพาะส่วน read database ขึ้น cloud ไปก่อน เพื่อ check ว่า assumption ที่เราวางไว้แต่แรกมันถูกไหม มันมีความเสี่ยงในด้านต่างๆ เช่น performance หรือ security หรือไม่

![Architecture version 2](/assets/2021-11-08/2021-11-08-architecture-version-2.png)

ถ้าทุกอย่างไปได้ดี เราค่อยย้ายส่วนที่เป็น write database ขึ้นไป
![Architecture version 3](/assets/2021-11-08/2021-11-08-architecture-version-3.png)

ในส่วนของ web app ก็แล้วแต่ technique ว่าจะใช้ infrastructure แบบไหน สำหรับกลุ่มของเราเลือกเป็น serverless เนื่องจาก focus ไปที่ ทีมพัฒนา แลกกับ trade-off คือค่าใช้จ่ายที่แพง
- cloud provider จัดการเรื่อง scale ให้
- deploy ง่าย
- สามารถเลือกตาม region ที่เราต้องการได้ โดยปกติก็จะเลือกที่เดียวกับ database

![Architecture version 4](/assets/2021-11-08/2021-11-08-architecture-version-4.png)

### ประเด็น Lift & Shift
จาก solution แต่ละกลุ่ม การเน้นไปที่การ copy architecture เดิมไปไว้บน cloud หรือเรียกว่า [Lift & Shift](https://www.thoughtworks.com/radar/techniques/cloud-lift-and-shift) ซึ่งเป็นสิ่งนึงที่อันตราย เนื่องจากถ้าเราย้ายขึ้นไปโดยไม่ได้ปรับปรุงด้าน architecture เลย ปัญหาบางส่วนก็ยังคงอยู่เหมือนเดิม ดังนั้นการทำความเข้าใจกับลูกค้าในส่วนของการเปลี่ยนแปลงต่อไปนี้

- ทำความเข้าใจเกี่ยวกับ [zero trust architecture](https://www.thoughtworks.com/radar/techniques/zero-trust-architecture) เพื่อลดความเสี่ยงในกรณีที่ระบบถูกเจาะจากภายนอกแล้วเข้าถึงระบบภายในได้ทันทีเพราะไม่ได้ป้องกันไว้
- ปรับปรุงขั้นตอนการทำงานของ IT operation ให้ไปในทาง automated ให้ได้มากที่สุด
- ปรับปรุงระบบการทดสอบทั้งในส่วนของ application และ infrastructure

> จากการเข้า workshop ครั้งนี้ นอกจากได้เรียนรู้แนวทางการแก้ปัญหาใหม่ๆ ยังทำให้กลับมามองระบบปัจจุบันที่ทำอยู่ด้วย ถ้ามีโอกาสได้เข้าอีกจะเอามาสรุปให้ดูเรื่อยๆ ครับ



