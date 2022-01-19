---
layout: post
title:  "Gradle plugin สำหรับค้นหา dependency version ใหม่"
date:   2022-01-19
tags: [dependencies, java, gradle]
---

หนึ่งในปัญหาของเราในฐานะที่เป็น developer ภาษา Java มาสักระยะคือ หลังจากที่เริ่มตั้ง project ใหม่มาแล้วคือ **ไม่ค่อยทำการ upgrade dependency อย่างสม่ำเสมอ** ซึ่งมีโอกาสที่เราจะพลาดประโยชน์ต่างๆ เช่น dependency มีการออก patch เกี่ยวกับ security หรือปรับปรุง performance เป็นต้น  

ถ้าเราอ้างว่า "เราเสียความมั่นใจถ้า upgrade dependency ขึ้นไปแล้วไม่รู้ว่ามันจะพังไหม" แน่นอนว่ามันมีโอกาส แต่เราสามารถนำชุดการทดสอบมาช่วยเพิ่มความมั่นใจให้เราได้อยู่ดี ดังนั้น น่าจะเป็นเรื่องที่ดีกว่าเสียถ้าเราทำการ upgrade dependency อย่างสม่ำเสมอ เรามาหาเครื่องมือที่จะทำให้เรารู้ว่าตอนนี้มี dependency อะไรที่ update ใหม่บ้างผ่าน Gradle plugin

## Gradle Versions Plugin
[Gradle Versions Plugin](https://github.com/ben-manes/gradle-versions-plugin) มีหลักการทำงานคือมันจะ scan ดู​ dependency ทั้งหมดของเรา แล้วเทียบกับ `repositories` URL ที่เราประกาศเอาไว้ (เช่น `mavenCentral`) จากนั้นจะ generate report ออกมาเป็น text file ระบุว่า มี dependency ไหนของเราที่มีการ update บ้าง

เริ่มติดตั้งโดยทำการเพิ่ม plugin ลงไปใน `build.gradle` ของเรา

<script src="https://gist.github.com/raksit31667/918b8cfc2f792f258c10629ca520ebf3.js"></script>

เบื้องต้นแค่นี้ก็สามารถใช้งานได้แล้วผ่านคำสั่ง

```shell
$ ./gradlew dependencyUpdates
```

configure ที่เราแนะนำให้เพิ่มไปคือ เราควรจะ filter พวก dependency ที่มันยังไม่ stable ออกไป เพราะมันมีโอกาสที่จะใช้แล้วมีปัญหาได้มากกว่าแบบ stable ซึ่งเราสามารถสังเกตได้ว่า version มี stable ได้จาก keyword ต่างๆ เช่น `RELEASE` `FINAL` หรือ `GA` นอกจากนั้นเรายังสามารถดูได้จาก [semantic versioning](https://semver.org/)

<script src="https://gist.github.com/raksit31667/aa9fdd1b4768093bfe60eaf7b364d0d3.js"></script>

ปล. ในตัวอย่างนี้จะเขียน `build.gradle` เป็นภาษา Groovy นะครับ ถ้าจะเป็นภาษา Kotlin ดูใน [GitHub README]((https://github.com/ben-manes/gradle-versions-plugin)) ของ plugin ได้เลย  

หลังจาก run คำสั่งไป report จะถูก generate เป็น plain text บน console และ `$project.buildDir/build/dependencyUpdates` ด้วย (สามารถเปลี่ยน format เป็น JSON, XML, HTML ได้)

<script src="https://gist.github.com/raksit31667/5c1938fd480d69f2d5d7cec8d0b59007.js"></script>

## มาดูข้อเสียกันหน่อย
- หลังจากลอง run ไป 2-3 ครั้ง พบว่าใช้เวลานานมากกว่า task จะเสร็จ บางทีต้องรอเกือบ 1 ชั่วโมง แนะนำว่าอย่านำไปใส่ใน continuous integration หลักของเราครับ แยกออกมาเป็น schedule หรือจะ run อาทิตย์ละครั้งก็ยังได้
- ด้วยความที่มัน run ช้า ถ้าเราอยากได้เร็วจริงๆ แนะนำว่าไปใช้ [Dependabot](https://github.com/dependabot) แทน แต่ก็แลกมากับการจัดการ pull request และบางครั้งมันก็ไปเอา patch version มาจาก Maven repository ที่ไม่ตรงกับของเรา ต้องตรวจสอบดีๆ ไม่ก็มี continuous integration สำหรับ pull request ไปเลย
