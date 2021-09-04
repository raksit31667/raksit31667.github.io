---
layout: post
title:  "ข้อมูลน่าสนใจที่นำมาแสดงใน Spring Boot Actuator"
date:   2021-09-04
tags: [spring, spring-boot-actuator, monitoring]
---

ในการ monitor และ audit application ของระบบที่พัฒนาด้วย Spring Boot framework เราสามารถใช้ [Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html) เลือกนำข้อมูลต่างๆ มาแสดงผ่าน endpoint `/actuator` ย่อยๆ จะมาจากของที่ให้มาอยู่แล้วหรือจะใช้ library หรือ plugin ก็ได้ ดังนั้นมาดูตัวอย่างกันว่าข้อมูลอะไรที่เป็นประโยชน์สำหรับระบบแบบ production-grade บ้าง  

ก่อนจะเริ่มก็ต้องติดตั้ง dependency กันก่อน

<script src="https://gist.github.com/raksit31667/b5feb5da42dc5dda324ab22163bca165.js"></script>

## Configuration
เราสามารถตรวจสอบ configuration รวมถึง environment variable ผ่าน endpoint `/configprops` และ `/env` ซึ่งมีข้อมูลในระดับ JVM ด้วย เป็นประโยชน์สำหรับการ check ว่า configuration หรือ secret นั้นถูก pass เข้าไป เช่น ผ่าน `@ConfigurationProperties` หรือ `-Dyour.custom.credentials` อย่างถูกต้องครบถ้วนหรือไม่ 

<script src="https://gist.github.com/raksit31667/1c0a88cab8d9cb251ad067f056049c60.js"></script>

**ข้อควรระวัง**
- การ expose credentials สำหรับ Actuator โดยปกติจะทำการ censored เป็น `******` ให้ ซึ่งมันจะดูจาก keyword เช่น `password` หรือ `credentials` เป็นต้น แนะนำว่าควรจะตรวจสอบให้ดีก่อนนำขึ้น production
- การ expose configuration ผ่าน production ควรจะเลือกอันที่จำเป็นเท่านั้น เพราะการ expose มากเกินไปอาจจะเป็นช่องโหว่ทาง security ได้ โดยเราสามรถ configure ได้ผ่าน application configuration ได้ตาม snippet นี้

<script src="https://gist.github.com/raksit31667/6cbd5c29f4ee0889624736c4d67acbd4.js"></script>

## Data migration
เราสามารถตรวจสอบ database migration ของระบบเราได้ผ่าน endpoint `/flyway` หรือ `/liquibase` แล้วแต่ว่าใช้ตัวไหน

## Healthcheck
เป็นมาตรฐานโลกเลยที่จะต้องใช้ endpoint นี้ในการทำ healthcheck เพื่อดูว่าระบบเรามัน live หรือเปล่า มีประโยชน์ในการตรวจสอบ deployment และ alert เมื่อระบบเกิดปัญหา สำหรับระบบที่ deploy ผ่าน Kubernetes สามารถ configure `livenessProbe` และ `readinessProbe` ตามนี้

<script src="https://gist.github.com/raksit31667/6955ab8267ce6fe38ea32e124301d8a5.js"></script>

## Prometheus
เปิด endpoint `prometheus` หากระบบเราใช้ Prometheus หรือเจ้าอื่นที่สามารถรองรับได้ เช่น Datadog โดย metrics จะอ้างอิงจาก endpoint `/metrics` อีกที ข้อควรระวังคือ เปิดเฉพาะอันที่คิดว่าเป็นประโยชน์ต่อระบบเราเท่านั้น เพราะมันเปลืองค่าใช้จ่ายจาก storage และ metrics ที่เก็บไป แต่ถ้าเราไม่รู้ว่าจะใช้ metrics ไหน แรกเริ่มเราอาจจะเปิดหมดเลยก็ได้ หลังจาก analyse แล้วค่อยไปปิดทีหลังก็ไม่เสียหายนะ

<script src="https://gist.github.com/raksit31667/10f309091ec831d13ae3fff2ef27d200.js"></script>

<script src="https://gist.github.com/raksit31667/fd74c756a4c7e638b170144f1e1ebcc6.js"></script>

## Git
ในกรณีที่เราอยากตรวจสอบว่าระบบที่นำขึ้นไปนั้นมันมาจาก Git revision ไหน เราสามารถใช้ Gradle plugin [gradle-git-properties](https://github.com/n0mer/gradle-git-properties) ได้ ซึ่งจะแสดงผ่าน endpoint `/info`

<script src="https://gist.github.com/raksit31667/8f21cda59842355ddc230380161db6cb.js"></script>

<script src="https://gist.github.com/raksit31667/fde1d858a4794b61e50f94d9397e7af3.js"></script>

## Property
เราสามารถนำ property มาแสดงผ่าน endpoint `/info` ได้ผ่าน Maven หรือ Gradle และ configure [Property Expansion](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.properties-and-configuration) ได้เลย ตัวอย่างใน Gradle ก็จะเป็นประมาณนี้

<script src="https://gist.github.com/raksit31667/1bb62403e48a3e88fe6258977a02606f.js"></script>

<script src="https://gist.github.com/raksit31667/51231e253997bc9403e184e16e6a53aa.js"></script>

<script src="https://gist.github.com/raksit31667/ca9cc54306566188c4ab392e521dd9a2.js"></script>

สำหรับใครที่ใช้ Gradle ถ้าตอน start server แล้วมันขึ้น error ประมาณนี้

```
Missing property (version) for Groovy template expansion. Defined keys [parent, jib, classLoaderScope, ...].
```

แปลว่า property ตัวใดตัวนึงที่เรา expand นั้นไม่ได้เป็นของ Gradle แต่อาจจะเป็นของ Java หรือ Spring Boot เผอิญมันดันใช้ syntax `${propertyName}` เหมือนกับ Gradle วิธีแก้คือเราต้องเติม `\` ลงไปเพื่อบอกว่าไอ property นั้นๆ ไม่ได้มาจาก Gradle นะ (ดูจากตัวอย่างข้างบนเอา)

> ลองเลือกไปใช้ตามความเหมาะสมของระบบดูนะครับ อย่าลืมว่า expose ข้อมูลที่จำเป็นและเป็นประโยชน์ต่อเราเท่านั้น ทั้งนี้ก็ขึ้นอยู่กับ security หรือ cost หรือ environment ที่ใช้งานด้วย


