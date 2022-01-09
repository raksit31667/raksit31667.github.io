---
layout: post
title:  "ทำความรู้จักกับ PIT mutation testing"
date:   2022-01-10
tags: [pit, mutation-testing, testing, java]
---

## ชุดการทดสอบของเรามันดีพอหรือยัง
เมื่อพูดถึงการพัฒนา software ในปัจจุบัน เรื่องของการทดสอบแบบอัตโนมัติกลายเป็นเรื่องที่ปกติไปแล้ว เพราะมันถือเป็นสิ่งที่เพิ่มความมั่นใจได้ในระดับนึงเลยว่า ระบบงานของเรายังทำงานได้อย่างถูกต้อง ซึ่งการทดสอบก็มีได้หลายหลายรูปแบบขึ้นอยู่กับระบบงานไป แต่โดยส่วนใหญ่ก็จะยึดได้ตาม [Test pyramid](https://martinfowler.com/bliki/TestPyramid.html)

![Test pyramid](/assets/2021-09-06-test-pyramid.png)
<https://martinfowler.com/bliki/TestPyramid.html>

แต่ในเมื่อชุดการทดสอบของเราก็เป็น code เหมือนกัน แล้วเราจะมั่นใจได้ยังไงว่าชุดการทดสอบของเรามันดีพอหรือยัง ซึ่งคำว่า "ดีพอ" มันก็หมายถึงว่าชุดการทดสอบมันครอบคลุมทุกกรณีหรือเงื่อนไขของ logic ใน code ของเรานั่นเอง  

หนึ่งในเครื่องมือที่สามารถนำมาใช้ได้คือ "test coverage" ซึ่งมันสามารถวัดได้ว่ามี code ส่วนไหนที่ถูก **execute** โดยชุดการทดสอบของเรา ดังนั้นถ้ามันมี code ที่ไม่ได้ execute เราก็ไปเพิ่มชุดการทดสอบให้มันครอบคลุมซะ  

ปัญหาของ test coverage คือมันแค่ดูว่า code ส่วนไหนที่ถูก **execute** ไม่ใช่ถูก **test** ดังนั้นเราสามารถ "โกง" โดยการเขียนชุดการทดสอบที่ไม่มีการทดสอบอะไรเลยก็ได้

### ตัวอย่าง
เรามี class `MaxCalculator` ที่ใช้สำหรับการคำนวณเลขที่มีค่ามากที่สุด 

<script src="https://gist.github.com/raksit31667/f67d8692d015e7e6319946cb1e7c6019.js"></script>

<script src="https://gist.github.com/raksit31667/0743aaf74cd86089bce8ca6c3db7638c.js"></script>

จะเห็นได้ว่า test coverage ของเราก็ดีหมด

![Test coverage example](/assets/2022-01-10-test-coverage-example.png)

แต่ชุดการทดสอบของเราไม่มีการ check ว่าผลลัพธ์จาก method `findMax` มันถูกต้องหรือไม่ ถ้าเกิด developer สักคนมาแก้ไข code ส่วนนี้ แน่นอนว่าชุดการทดสอบของเราก็ผ่านฉลุย ทางแก้คือเราก็ตรวจสอบผลลัพธ์สิ

<script src="https://gist.github.com/raksit31667/24c3b06b807be598a89f8083e6d11e47.js"></script>

จบปัญหาไปหนึ่งอย่าง...  

วันต่อมา พบว่า `MaxCalculator` ของเรามีปัญหา สืบไปสืบมาพบว่ามีการแก้ไข code 1 บรรทัด

<script src="https://gist.github.com/raksit31667/f0e90c4cff5d326e2108e8d3e5c5acab.js"></script>

แต่ชุดการทดสอบของเราดันผ่าน แสดงว่าชุดการทดสอบของเรายังไม่ครอบคลุมพอ เพราะเราตกไป 1 กรณี ก็คือถ้า `numbers` มี element แค่อันเดียวที่มีค่ามากกว่า `Integer.MIN_VALUE` เมื่อรู้ปัญหาแล้วทำการแก้ไข code พร้อมกับเพิ่มชุดการทดสอบลงไป  

> เราสามารถลดความเสี่ยงที่จะเกิดปัญหานี้ในอนาคตได้อย่างไร

code review / peer review ก็เป็นอีกหนึ่งทางที่ช่วยได้ เพราะเราได้ feedback จาก developer คนอื่นๆ แต่ถ้า review ไม่ดีก็มีหลุดเหมือนกัน ถ้างั้นเรามาหา technique ที่ช่วยตรวจสุขภาพของชุดการทดสอบของเรากัน  

## Mutation testing
หลักการของ mutation testing ก็คือเราทำการแก้ไข code ของเราเล็กน้อย เช่น เปลี่ยน operator `>` `!=` หรือ แทนค่าตัวแปรใหม่ จากนั้นทำการ run ชุดการทดสอบ เพื่อดูว่าผ่านหรือไม่ เราสามารถเปรียบการแก้ไข code ของเราเป็นสารก่อกลายพันธุ์ (mutagen) ของ virus และ code ที่ถูกแก้ไขคือตัวกลายพันธุ์ (mutant) นั่นเอง

![COVID mutation](/assets/2022-01-10-covid-mutation.jpeg)

<https://www1.racgp.org.au/newsgp/clinical/what-s-the-difference-between-mutations-variants-a>

- ถ้าชุดการทดสอบไม่ผ่าน แปลว่าชุดการทดสอบเราแข็งแรง มีภูมิคุ้มกันมากพอที่จะกำจัด mutant นั้นได้
- ถ้าชุดการทดสอบผ่าน แปลว่าชุดการทดสอบเราอาจจะมีจุดอ่อน ไม่สามารถกำจัด mutant นั้นได้

นั่นหมายความว่าถ้าเรากำจัด mutant ได้เยอะ แปลว่าชุดการทดสอบเราดีนั่นเอง

> Mutation score = (Mutant ทีฆ่าได้ / Mutant ทั้งหมดที่มี) * 100

เราสามารถทำ mutation testing แบบอัตโนมือก็ได้ครับ แต่น่าจะดีกว่าถ้าเราหาเครื่องมือมาช่วยทุ่นแรงเราได้

- [Stryker สำหรับ JavaScript, C#, Scala](https://stryker-mutator.io/)
- [mutant สำหรับ Ruby](https://github.com/mbj/mutant)
- [Pitest สำหรับ Java](https://pitest.org/)

โดยตัวอย่างในบทความนี้ จะใช้ Pitest

## Pitest
Pitest มาพร้อมกับ built-in mutator สามารถดู list เต็มๆ ได้ที่ [Available mutators and groups](https://pitest.org/quickstart/mutators/) นอกจากนั้นยังสามารถติดตั้งได้ผ่าน `Maven` หรือ `Gradle` ได้เลย

- [Maven plugin](https://pitest.org/quickstart/maven/)
- [Gradle plugin](https://gradle-pitest-plugin.solidsoft.info/)

โดยเราสามารถกำหนด configuration ต่างๆ เหมือนการทดสอบแบบอื่นๆ ได้ เช่น 

- report format (พวก XML หรือ HTML) 
- จำนวน thread ที่ใช้ run เพื่อความรวดเร็วเพราะจากที่ลองแล้วใช้เวลาพอสมควร
- plugin เสริมต่างๆ เช่น การใช้งานกับ [JUnit 5](https://junit.org/junit5/)

<script src="https://gist.github.com/raksit31667/0d8639cb552d5421d0763c0429f9c9f4.js"></script>

จากนั้นทำการ run ด้วยคำสั่ง

```shell
$ ./gradlew pitest
```

เข้าไปดูผลลัพธ์ report ของ Pitest ได้ใน `${PROJECT_DIR}/build/reports/pitest`

![Pitest report](/assets/2022-01-10-pitest-report.png)

จะเห็นว่าตัว Pitest ทำการเพิ่ม mutation เข้าไปด้วยวิธีการต่างๆ เช่น
- กลับข้าง condition จาก `==` เป็น `!=`
- แปลง condition จาก `<` เป็น `<=`
- เปลี่ยน `i++` เป็น `i--`
- เปลี่ยน return value เป็น `0`

ซึ่งส่วนใหญ่ mutant จะถูก `KILLED` แปลว่าชุดการทดสอบเราแข็งแรง แต่จะมี 1 mutant ที่ `SURVIVED` ซึ่งก็ไม่เป็นไร เพราะไม่ว่าจะเปลี่ยน `<` เป็น `<=` การคำนวณของเราก็ยังถูกต้องอยู่ดี

## การนำไปใช้จริง
มาถึงตรงนี้น่าจะให้ข้อดีของการทำ mutation testing กันแล้ว เราขอแนะนำการนำไปใช้งานจริงกันหน่อย เนื่องจากมันก็มีข้อเสียเหมือนกับการทดสอบแบบอื่นๆ เช่นเดียวกัน ซึ่งก็คือ ความเร็วในการ run ที่ช้าพอสมควร

- Configure class ที่ไม่จำเป็นต้องทำ mutation จริงๆ ออกไป
- Configure จำนวน thread ที่ใช้ในการ run
- ไม่จำเป็นต้อง run ทุก commit หรือทุก build เพราะมันช้า แนะนำว่า run เป็น schedule ไปดีกว่า
- ไม่จำเป็นต้องฆ่าทุก mutant ให้ครบหมด 100% ดูเป็นตัวๆ ไปครับ อย่างตัวอย่างข้างบนเราก็ปล่อยไว้นะ เพราะมันไม่มีผลอะไรอยู่แล้ว

หลังจากได้ผลการทดสอบออกมาแล้ว แนะนำให้วิเคราะห์ดูผลต่อยอดไป เช่น
- ถ้า mutant ถูกฆ่าในการ run ครั้งล่าสุด แล้ว run ใหม่โดยไม่ได้แก้ code ตัว mutant นั้นก็ยังต้องถูกฆ่าอยู่ดี
- ถ้า mutant รอดในการ run ครั้งล่าสุด แล้ว run ใหม่โดยไม่ได้แก้ code หรือ test ตัว mutant นั้นก็ยังต้องรอดอยู่ดี
- ถ้า mutant ถูกฆ่าในการ run ครั้งล่าสุด แก้ไขชุดการทดสอบแล้ว run ใหม่ ตัว mutant นั้นก็ควรต้องถูกฆ่าอยู่ดี

> การทำ mutation testing เปรียบเสมือนเป็นการตรวจภูมิคุ้มกันของชุดการทดสอบของเรา เพื่อที่เราจะได้มั่นใจว่าชุดการทดสอบมีคุณภาพมากพอที่จะทำให้เรามั่นใจได้ว่ามันครอบคลุม code ของเราตามการเปลี่ยนแปลงที่เกิดขึ้น