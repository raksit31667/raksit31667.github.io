---
layout: post
title:  "สร้างระบบ Web Template ใน Spring framework ด้วย Mustache"
date:   2021-06-14
tags: [spring, mustache, web-template-system]
---

## Problem statements
มี feature ใหม่ใน product ที่ทำอยู่คือทำการสร้าง report จากข้อมูลที่ user ส่งมาให้ จากนั้นให้ upload file ขึ้น Object Store แน่นอนว่าข้อมูลที่ต่างกันย่อมเกิด report ที่ต่างกัน ดังนั้นเราต้องนำข้อมูลมาแปะลงไปใน report สมมติว่า format เป็น HTML code ก็จะออกมาหน้าตาประมาณนี้  

<script src="https://gist.github.com/raksit31667/cf0ab2270486e2464710a684c869fb84.js"></script>

> ซึ่งปัญหาที่เห็นได้เลยคือ code ดูแลรักษายากมาก เนื่องจาก business logic กับ presentation logic ผูกมัดกัน

## Web Template System
อธิบายการทำงานของ web template ด้วยส่วนประกอบ 3 ส่วนหลักๆ

1. **Content** เนื้อหาที่จะนำใช้ใน template ซึ่งจะมาในรูปแบบ hash หรือ object ก็ได้ เช่น JSON หรือ database
2. **Template** รูปแบบที่ยังไม่มี content ใส่เข้าไป ซึ่งจะมาในรูปแบบ HTML หรือ config file ก็ได้
3. **Template engine** ระบบที่นำ content ไปใส่ใน template และประมวลผลออกมากลายเป็น file ใหม่

![Web Template System](/assets/2021-06-15-web-template-system.png)  
[Alfresco Customization and Java Stuffs](https://deepak-keswani.blogspot.com/2011/09/freemarker-vs-velocity-ftl-vs-vm.html)

> **ข้อดีของ web template** คือ เราสามารถจัดการส่วนของ business logic แยกกันกับ presentation logic เช่น ส่วนของการแสดงผลเป็น list เป็นต้น > ทำให้ code ของเราดูแลง่ายขึ้น (นึกถึง [Separation of concerns](https://java-design-patterns.com/principles/#separation-of-concerns))  

## Example

### Dependencies
ในตัวอย่างเราจะใช้ [Mustache](https://mustache.github.io/) เป็น template engine และ Amazon S3 เป็น Object Store ดังนั้นเราจะมาเริ่มด้วยการติดตั้ง dependencies ใน Spring framework กันก่อน
<script src="https://gist.github.com/raksit31667/dfc9f3caab6846ac3cf41f42ac89af74.js"></script>

### Content
จากนั้นทำการ define *content* ที่เราต้องการจะเอาไปใส่ใน template ครับ
<script src="https://gist.github.com/raksit31667/2fa1015bbcb6e06769f1f7e00be29920.js"></script>

<script src="https://gist.github.com/raksit31667/0f1d8e3907e1ec5beee2270a3e1f7624.js"></script>

<script src="https://gist.github.com/raksit31667/cb8f2b10b4071958e79933d05b30df13.js"></script>

<script src="https://gist.github.com/raksit31667/40731829c3bdacc5744a7211dd51d506.js"></script>

### Template
ทำการเขียน *template file* ขึ้นมา โดยเราจะใช้เป็น HTML สร้าง file extension เป็น `.mustache` และเก็บไว้ใน `classpath:/templates/` (เช่น `src/main/resources/templates` แล้วแต่ว่า configure classpath ยังไง) โดยเราจะอิง syntax ตาม [Official documentation](http://mustache.github.io/mustache.5.html) เลย ชื่อ section ของ *template file* จะล้อตาม attribute ของ *content* ครับ (ยกเว้นตรง `familyWrapper` เดี๋ยวจะมาอธิบายทีหลังครับ)
<script src="https://gist.github.com/raksit31667/ec2e103aa12eb4bc16c76afca59889d0.js"></script>

> โดยค่าตั้งต้น Mustache จะอ่าน file ที่มี extension เป็น `.mustache` ครับ แต่เราสามารถ customize มันได้ผ่าน `spring.mustache.suffix` ครับ (อ้างอิงจาก [Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/htmlsingle/#howto-customize-view-resolvers))

### Template engine
ขั้นตอนการ generate report เป็นไปตามนี้ครับ

1. ดึง *template file* มาจาก **resource classpath**
2. สร้าง file ใหม่ที่จะเป็น result จาก Mustache
3. Mustache ทำการ compile ตัว *template file*
4. Mustache ทำการ execute Object ที่ wrap *content* ไว้อีกที (เป็นเหตุผลว่าทำไมใน template ถึงใส่ `familyWrapper`)
5. บันทึก result ลง file ที่สร้างจากข้อ 2

จะได้ code หน้าตาออกมาประมาณนี้
<script src="https://gist.github.com/raksit31667/7c8b648caf60ea5604987c70e1e294be.js"></script>

> สังเกตว่า `spring-boot-starter-mustache` ถูกต่อยอดมาจาก [samskivert/jmustache](https://github.com/samskivert/jmustache) อีกที ดังนั้นเราใช้ repo นี้เป็น manuals ได้

### Upload file to S3 (ข้ามได้)
มาถึงตรงนี้เราจะนำ template ไปทำอะไรก็ได้แล้วครับ ตัวอย่างคือเราจะ upload file ขึ้น Amazon S3 เราจะทำการ configure AWS client กันก่อน 
สำหรับตัวอย่างนี้จะใช้เป็น basic credentials (access key, secret key) สามารถดูวิธีการซ่อน credentials สำหรับ local ได้ใน [blog นี้ครับ]({% post_url 2020-03-12-spring-local-configuration-file %})
<script src="https://gist.github.com/raksit31667/9f33b2afdc533402dfd5507c891a01a0.js"></script>

ปิดท้ายด้วยการ inject `AmazonS3Client` เป็น dependencies และทำการ upload file ขึ้นไป
<script src="https://gist.github.com/raksit31667/bfe0d5f0937b222fd3c18cbbd06df7f9.js"></script>

### แถม Unit test
เราใช้ [Apache Commons](https://commons.apache.org/proper/commons-io/) เพื่อตรวจสอบว่า file content เหมือนกับที่เราคาดหวังไว้ไหม
<script src="https://gist.github.com/raksit31667/16c3ce1beeeeb65d936734925d7aed9d.js"></script>


## Limitations
project ตัวอย่างนี้มี limitation ที่เราควรรู้เพื่อใช้ในการตัดสินใจในการเลือก tool ที่เหมาะสมดังนี้
1. Mustache โฆษณาไว้ว่าเป็น "Logic-less templates" ดังนั้นมันจึงไม่ได้รองรับพวก if-else statements เลย ถ้า requirement ของเรามี if-else แน่ๆ ลองเปลี่ยนไปดู [handlebars](https://handlebarsjs.com/) แทนครับ สำหรับชาว Java Spring แนะนำว่าไปดูตาม [Template Engines for Spring](https://www.baeldung.com/spring-template-engines) ดีกว่าครับ
2. AWS S3 ใน Java ใช้ได้กับแค่ Spring v2.3.x (ณ เวลาที่เขียน blog นี้) ดังนั้นใครที่จะ upgrade อาจจะต้องระวังกันหน่อยครับ