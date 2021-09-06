---
layout: post
title:  "บันทึกการทดสอบ Database ด้วย Testcontainers ใน Docker environment"
date:   2021-09-06
tags: [docker, docker-compose, testcontainers, integration-testing]
---

เมื่ออาทิตย์ก่อนจะต้องนำระบบงานขึ้นผ่าน CI pipeline ที่ agent run อยู่บน Docker container ซึ่งในชุดการทดสอบเกี่ยวกับ database นั้นจะต้อง run database server บน Docker container เช่นเดียวกัน จึงเอามาจดวิธีทำไว้กันลืม

## ว่าด้วยเรื่องของ Integration testing
ในการทดสอบระบบ software เราสามารถแบ่งการทดสอบออกเป็นกลุ่มๆ ซึ่งจำนวนของการทดสอบในแต่ละกลุ่ม นั้นขึ้นอยู่กับ ค่าใช้จ่าย (effort และเวลาที่ใช้สร้างการทดสอบ) ความเร็วที่ใช้ run และความมั่นใจที่ได้รับกลับมา โดยเรียงออกมาเป็น แนวคิด test pyramid ตามรูป
![Test pyramid](/assets/2021-09-06-test-pyramid.png)
<https://martinfowler.com/bliki/TestPyramid.html>

กลับมาที่ระบบที่ต้องการทดสอบการ integrate กันระหว่าง service กับ database นั้นน่าจะอยู่บริเวณตรงกลาง เพราะ มีค่าใช้จ่ายบ้าง (ไม่งั้นคงไม่เขียน blog นี้ ฮ่าๆๆ) ความเร็วก็กลางๆ ไม่ต้องรอเป็นนาทีหรือชั่วโมง (?) ส่วนความมั่นใจก็กลางๆ อย่างน้อยพอมันเชื่อมกันก็ทำงานถูกละกัน  

ในการทำ integration testing จริงๆ แล้วเราสามารถใช้ [test double](https://martinfowler.com/bliki/TestDouble.html) ในการ mock database ได้ ซึ่งอาจจะเป็น embedded in-memory database ก็ได้ ข้อดีคือมันง่าย ค่าใช้จ่ายถูกเพราะไม่ต้อง setup database เอง แต่สิ่งที่เสียไปคือความมั่นใจในการทดสอบ เนื่องจากระบบงานจริงเราก็ไม่ได้ใช้ embedded database อยู่ดี แถมถ้าเราต้องการทดสอบ query DSL ที่เป็นของเจ้านั้นโดยเฉพาะ ก็จบเห่

## การ run Docker บน CI agent
ระบบ CI ที่ใช้คือ [Buildkite](https://buildkite.com/) ซึ่งมี agent ที่ run อยู่บน Docker container หมายความว่าเราจะไม่สามารถ run คำสั่ง Gradle ตรงๆ เหมือนกับพวก Java agent ได้แล้ว เป็นแนวคิดที่น่าสนใจมาก เนื่องจากคน maintain agent ไม่จำเป็นต้องมา configure ให้ตาม programming language แล้ว อยากจะใช้อะไรก็ pull Docker image เอา สะดวกไปอีกแบบ

![Buildkite agent](/assets/2021-09-06-buildkite-agent.png)

ตัวอย่างระบบพัฒนาด้วยภาษา Java ใน build step เราสามารถใช้คำสั่ง Docker ในการ pull image `openjdk` แล้ว run คำสั่ง Gradle ได้

<script src="https://gist.github.com/raksit31667/4913e2e4f597b75f7ce96b15f7714b3e.js"></script>

หรือเราจะใช้ [Docker Compose](https://docs.docker.com/compose/) ก็ได้ ที่จะทำให้ code ใน pipeline clean ขึ้น เพราะไม่ต้องมาเขียนคำสั่ง Docker ยาวๆ นอกจากนั้นถ้าเรามี task อื่นๆ ใน CI เราก็สามารถนำมา define ใน `docker-compose` file ได้เหมือนกัน

<script src="https://gist.github.com/raksit31667/4f078deeffbb29242c37239167b4aeca.js"></script>

<script src="https://gist.github.com/raksit31667/c2676dbfdad5c5720a77c93de67e1745.js"></script>

## การ run docker container ใน docker container
สืบเนื่องจากความเจ็บปวดในการทดสอบ ทั้งในเรื่องความมั่นใจและความครอบคลุม บวกกับบน CI agent มี Docker อยู่แล้ว ดังนั้นบนภาษา Java เราสามารถเลือกใช้เครื่องมือชื่อ [Testcontainers](https://www.testcontainers.org/) ที่สามารถทำงานร่วมกับ [JUnit](https://junit.org/junit5/) เพื่อสร้าง container สำหรับการทดสอบ แล้วก็ทำลายทิ้งไปหลังจากใช้งานเสร็จ ดูตัวอย่าง code ใช้งานได้ที่นี่ <https://www.testcontainers.org/quickstart/junit_5_quickstart/>

การที่เราจะต้อง run docker container ใน docker container ได้จะต้องทำผ่าน [Docker daemon API](https://docs.docker.com/get-started/overview/#the-docker-daemon) ซึ่งใช้สำหรับให้ client run คำสั่งเกี่ยวกับ Docker เช่น build, pull, run เป็นต้น ซึ่งจะเป็น REST API หรือ Unix socket ก็ได้ (อันหลังจะใช้เพื่อความปลอดภัยโดยเฉพาะ) โดย daemon จะรอคำสั่งผ่าน `/var/run/docker.sock`

![Docker architecture](/assets/2021-09-06-docker-architecture.png)

สมมติว่าเราทำ Docker container อันนึงที่ทำหน้าที่คล้ายๆ Docker desktop สิ่งที่ container นั้นทำคือมันจะ communicate กับ Docker daemon ในเครื่องเราผ่าน `/var/run/docker.sock` นั่นเอง  

เมื่อเทียบกับระบบงานของเรา เราต้องการ run `testcontainers` บน `openjdk` บน CI agent โดยที่ `testcontainers` นั้นจะต้อง host บน `localhost` ของ CI agent สิ่งที่ต้องทำคือเชื่อม daemon ของ CI agent เข้ากับ `openjdk` ด้วยท่า [volume mounting](https://docs.docker.com/storage/volumes/) ตามนี้

<script src="https://gist.github.com/raksit31667/aad6bc61932e094666e72a6598902213.js"></script>

สิ่งที่เกิดขึ้นคือ `openjdk` run คำสั่งใน Gradle ซึ่งจะใช้ `testcontainers` library ในการ spawn container ใหม่ขึ้นมาผ่าน Docker daemon ของ CI agent ดังนั้นระบบสามารถ access container นั้นจาก `localhost` ได้เลย

> Example code: <https://github.com/raksit31667/example-spring-loyalty>

