---
layout: post
title:  "ประยุกต์แนวคิด Event-driven architecture pattern กับ messaging queue"
date:   2021-04-27
tags: [event-driven-architecture, messaging-queue, activemq]
---

## เริ่มจาก Event-driven architecture pattern
Event-driven architecture pattern มี 4 แบบ แต่จะขอยกมาแค่ 2 แบบ

### Event notification

เริ่มจากระบบหลักทำการส่ง event ผ่าน Messaging หรือ Event Bus จากนั้น Consumer ที่สนใจก็ทำการ subscribe event เอาไว้ เมื่อได้รับแล้วจะทำการดึงข้อมูลจากระบบหลักอีกครั้ง  

#### ข้อดี
ข้อมูลที่ได้เป็นของล่าสุดแน่นอน (Consistency)  
#### ข้อเสีย
ระบบผูกมัดกัน เนื่องจากถ้าระบบหลักตาย ก็จะส่งผลต่อ subscriber ด้วย

![Event notification](/assets/2021-04-27-event-notification.png)

### Event-carried state transfer

เริ่มจากระบบหลักทำการส่ง event _ที่มีข้อมูลครบ_ ผ่าน Messaging หรือ Event Bus จากนั้น Consumer ที่สนใจก็ทำการ subscribe event เอาไว้ เมื่อได้รับแล้วก็นำไปใช้ต่อได้เลย ไม่ต้องดึงจากระบบหลักอีกครั้ง

#### ข้อดี
ระบบไม่ผูกมัดกัน + ได้ availability มาเพิ่ม  
#### ข้อเสีย
ข้อมูลที่ได้อาจจะไม่ล่าสุด เช่นถ้ามีการ update ข้อมูล ก็จะมี delay ระหว่าง subscriber กำลังจัดการกับ event ใหม่ (Eventual consistency)  

![Event-carried state transfer](/assets/2021-04-27-event-carried-state-transfer.png)

## พูดถึง Messaging queue
เช่น ActiveMQ หรือ RabbitMQ จะมี queue อยู่ด้วยกันหลักๆ 3 แบบคือ
1. **Normal queue** เป็น queue ที่ sender ส่ง message ไปหา receiver ปกติ
2. **Dead letter queue** เป็น queue เก็บ message ที่ sender ส่งไปหา queue ที่เต็มหรือไม่มีอยู่ หรือ receiver ไม่สามารถ process message ที่รับมาจาก normal queue ได้
3. **Expiry queue** เป็น queue เก็บ message ที่เคยอยู่ใน normal queue เกินระยะเวลาที่กำหนด (time to live) นั่นหมายถึงว่า consumer ไม่สามารถรับ message ได้

## ตัวอย่าง
- มีระบบงาน food delivery แบ่งเป็น 2 ส่วนคือ *OrderService* กับ *DriverService* อย่างละ 1 instance
- 2 service นี้ integrate กันด้วย messaging queue
- เมื่อมี **Order** ใหม่เข้ามา ระบบจะทำการค้นหา **Driver** เพื่อไปส่งอาหารให้ลูกค้า
- ลูกค้าสามารถเปลี่ยนที่อยู่จัดส่งใน **Order** ได้หลังจากภายในเวลาที่กำหนด
- มี limitation ว่า *OrderService* ไม่สามารถรับ request พร้อมกันมากๆ ได้

![Food delivery example](/assets/2021-04-27-food-delivery-example.png)

แน่นอนว่า *DriverService* จะ receive *OrderCreatedEvent* ผ่าน main queue
- ในส่วนของ Happy path เราสามารถใช้ **Event-carried state transfer** เพื่อลดการ query ไปที่ *OrderService* ได้
- สำหรับ Unhappy path เราจะแบ่งเป็น 2 เหตุการณ์
  - *DriverService* สามารถรับ *OrderCreatedEvent* มา แต่ไม่สามารถ process ได้ กรณีนี้ message จะตกไปที่ **Dead letter queue**
  - *DriverService* เกิดล่มขึ้นมา ทำให้ *OrderCreatedEvent* ไม่ถูก receive จาก queue ถ้าเราจะ receive ต่อ ก็ต้องไปต่อที่ **Expiry queue** แทน ปัญหาหลังจากที่เรารับคือ **Order** มันอาจจะไม่ consistent แล้วเนื่องจาก *OrderCreatedEvent* อาจจะไม่ได้มีที่อยู่ล่าสุดก็ได้ ในกรณีนี้เราสามารถนำ **Event notification** มาช่วยได้ โดยการกลับไป query **Order** จาก *OrderService* แล้วค่อย process ต่ออีกที
