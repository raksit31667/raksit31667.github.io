---
layout: post
title:  "จะทำชุดการทดสอบอัตโนมัติกับระบบที่เชื่อมกับ AWS ได้อย่างไร"
date:   2021-10-02
tags: [aws, localstack, testcontainers, integration-testing, spring]
---

ในระบบงานที่กำลังทำอยู่ มีการเชื่อมต่อกับ AWS resources เช่น S3 เป็นต้น ถ้าเราจะทำชุดการทดสอบอัตโนมัติในส่วนนั้น ประเด็นที่น่าสนใจคือ เราควรจะเชื่อมต่อกับ AWS จริงๆ ไหม คำตอบมันก็ขึ้นอยู่กับความมั่นใจที่เรามีด้วย  

ถ้าเราจะต่อกับของจริง เราก็ต้องมาแลกกับ side effect และการจัดการข้อมูลที่ใช้ทดสอบไม่ให้มันปนกับ AWS account จริง แต่ถ้าเรามีเครื่องมือที่สามารถจำลอง AWS ขึ้นมาใน docker container ได้ การจัดการมันก็ง่ายขึ้นนะ งั้นเรามาดูกันว่ามันจะคุ้มไหมนะ ฮ่าๆๆ  

## ติดตั้ง dependencies
ระบบที่ใช้งานพัฒนาด้วย Spring Boot (อีกแล้ว) ให้ลง dependencies ตามนี้

- [spring-cloud-starter-aws](https://github.com/spring-cloud/spring-cloud-aws)
- [Localstack ใน testcontainers](https://www.testcontainers.org/modules/localstack/)

<script src="https://gist.github.com/raksit31667/c67382acc817a4b3bdbf297bb3ec8010.js"></script>

<script src="https://gist.github.com/raksit31667/111eaa94ea0efa7d46bd38bb1aaa632b.js"></script>

### คำอธิบาย
- เราเลือกใช้เครื่องมือชื่อ [Testcontainers](https://www.testcontainers.org/) ที่สามารถทำงานร่วมกับ [JUnit](https://junit.org/junit5/) เพื่อสร้าง container สำหรับการทดสอบ แล้วก็ทำลายทิ้งไปหลังจากใช้งานเสร็จ ดูตัวอย่าง code ใช้งานได้ที่นี่ <https://www.testcontainers.org/quickstart/junit_5_quickstart/>  

- เราเลือกใช้เครื่องมือชื่อ [Localstack](https://github.com/localstack/localstack) จาก Atlassian เพื่อจำลอง AWS บน local machine ซึ่งสามารถ run ผ่าน CLI หรือ [Helm](https://helm.sh/) ได้ด้วย เราสามารถนำมาประยุกต์ใช้ในการ run local development ได้ด้วย (แต่ประเด็นนี้มันมีข้อจำกัดอยู่ครับ เพราะเนื่องจาก `Localstack` เขามี feature ตาม tier ด้วย แนะนำให้เรา check ก่อนว่า [resource ที่เราต้องการมันอยู่ใน tier ไหน](https://localstack.cloud/features/)ด้วย)

- Environment ที่เราทดสอบ ไม่ว่าจะเป็น local machine หรือ CI จะต้องมี Docker engine ด้วย ถ้าไม่มีก็แนะนำเราอาจจะต้องจัดการ lifecycle ของ `Localstack` เอง

## Setup Localstack testcontainers
สมมติ implementation ของ AWS S3 ใช้การ STS assume role ที่มี permission ในการไปอ่าน object จาก S3 bucket หน้าตาของ configuration เราจะได้มาประมาณนี้

<script src="https://gist.github.com/raksit31667/e260c07ad30a999ed8df2dc342e66de0.js"></script>

- เนื่องจากใน `Localstack` ก็มี STS feature อยู่ในแบบ open-source ดังนั้นเราสามารถ setup STS assume role เองได้เหมือนกัน หรือเราจะ override AWS S3 configuration นี้ด้วย `AWS_ACCESS_KEY_ID` และ `AWS_SECRET_KEY_ACCESS` ซึ่งตรงนี้เดี๋ยว `Localstack` เค้าจัดการให้ครับ เราไม่ต้องไปสร้างเอง

- เราจะสร้าง class เพื่อ start และ stop `Localstack` container ก่อนและหลัง run test suite ตามลำดับ เพื่อให้เราสามารถ reuse ได้กับ test class อื่นๆ แนะนำให้ใช้ [JUnit Extension](https://junit.org/junit5/docs/current/user-guide/#extensions-registration-declarative) ประโยชน์ที่ได้เลยคือเราจะได้ไม่ต้องมา declare `@BeforeAll` และ `@AfterAll` method ทุกๆ test class

<script src="https://gist.github.com/raksit31667/21ccdf24056c7c90a47018b283e3e7f1.js"></script>

## เขียนชุดการทดสอบ 
ปิดท้ายด้วยการเขียนชุดการทดสอบ อย่าลืมใส่ `@ExtendWith(YourCustomAmazonS3Extension.class)` ลงไปด้วย
<script src="https://gist.github.com/raksit31667/b06727f84002c089bb97c5797ac3e27d.js"></script>

### คำอธิบาย
- อย่างที่บอกไปในหัวข้อที่แล้วคือเราจะ override AWS S3 configuration ดังนั้นเราสามารถสร้าง static inner-class ที่มี `@TestConfiguration` เพื่อ inject configuration ลงไปใน test ได้ โดยเราจะต้อง configure AWS ให้ไปหา endpoint ของ `Localstack` ซึ่งปกติจะเป็น `http://localhost:4566` แต่ใน testcontainers มันจะสุ่ม ในส่วนของ credentials เราก็ใช้ provider ที่ `Localstack` มันทำไว้ให้ สาเหตุที่ต้องเอาไปไว้ใน inner-class เพราะเราจะต้องแน่ใจว่า `Localstack` testcontainer จะต้อง run ก่อน configuration นี้เสมอ และการ override bean ได้เราก็ต้อง enable ใน Spring application config ด้วย แบบนี้

<script src="https://gist.github.com/raksit31667/503a0bdfff5fec83c99740de1925deca.js"></script>

- เราสามารถ inject configuration ที่เรา override เป็น dependency ได้แล้วก็เรียกใช้ได้เลย แนะนำว่าให้จัดการข้อมูลการทดสอบให้มันไม่มี side effect เช่น delete object และ bucket หลังจากการทดสอบทุก method

> หลังจากลองใช้แล้ว พบว่าทีมได้ความมั่นใจเพิ่มขึ้นจากการทดสอบที่ค่อนข้างเร็ว ส่วนที่เราต้องดูต่อไปคือถ้ามี resource อื่นๆ ก็จะต้องมี learning curve ในการประยุกต์ใช้กันไป หรือถ้าเลวร้ายสุดคือ resource มันไม่อยู่ใน open-source tier แล้วจะทำอย่างไร
