---
layout: post
title:  "สร้างระบบ Web Template ใน Spring framework ด้วย Mustache"
date:   2021-06-14
tags: [spring, mustache, web-template-system]
---

## Problem statements
มี feature ใหม่ใน product ที่ทำอยู่คือทำการสร้าง report จากข้อมูลที่ user ส่งมาให้ จากนั้นให้ upload file ขึ้น Object Store วาดหน้าตาระบบคร่าวๆ ก็จะเป็นประมาณนี้

![Event notification](/assets/2021-04-27-event-notification.png)  

แน่นอนว่าข้อมูลที่ต่างกันย่อมเกิด report ที่ต่างกัน ดังนั้นเราต้องนำข้อมูลมาแปะลงไปใน report สมมติว่า format เป็น HTML code ก็จะออกมาหน้าตาประมาณนี้  

<แสดง code ที่ business logic กับ presentation logic ปนกัน>

ซึ่งปัญหาที่เห็นได้เลยคือ code ดูแลรักษายากมาก เนื่องจาก business logic กับ presentation logic ผูกมัดกัน

## Web Template System
อธิบายการทำงานของ web template ด้วยส่วนประกอบ 3 ส่วนหลักๆ

1. **Content**
2. **Template**
3. **Template engine**

ข้อดีของ web template คือ เราสามารถจัดการส่วนของ business logic แยกกันกับ presentation logic เช่น ส่วนของการแสดงผลเป็น list เป็นต้น ทำให้ code ของเราดูแลง่ายขึ้น (นึกถึง [Separation of concerns](https://java-design-patterns.com/principles/#separation-of-concerns))  

## Example

<script src="https://gist.github.com/raksit31667/dfc9f3caab6846ac3cf41f42ac89af74.js"></script>

<define-content>
<script src="https://gist.github.com/raksit31667/2fa1015bbcb6e06769f1f7e00be29920.js"></script>

<script src="https://gist.github.com/raksit31667/0f1d8e3907e1ec5beee2270a3e1f7624.js"></script>

<script src="https://gist.github.com/raksit31667/cb8f2b10b4071958e79933d05b30df13.js"></script>

<script src="https://gist.github.com/raksit31667/40731829c3bdacc5744a7211dd51d506.js"></script>

<define-tempalte>
<script src="https://gist.github.com/raksit31667/ec2e103aa12eb4bc16c76afca59889d0.js"></script>

<http://mustache.github.io/mustache.5.html>

<script src="https://gist.github.com/raksit31667/7c8b648caf60ea5604987c70e1e294be.js"></script>

<script src="https://gist.github.com/raksit31667/bfe0d5f0937b222fd3c18cbbd06df7f9.js"></script>
