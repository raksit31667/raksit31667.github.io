---
layout: post
title:  "เปรียบเทียบการเขียนชุดการทดสอบแบบ Classicist vs Mockist"
date:   2022-02-17
tags: [testing, unit-testing, test-driven-development]
---

ระหว่างที่ทำ pair programming กับเพื่อน developer อยู่ มี discussion ที่น่าสนใจอยู่เกี่ยวกับการเขียนชุดการทดสอบ ก็คือมี code ที่ต้องการจะ implement คร่าวๆ ประมาณนี้

<script src="https://gist.github.com/raksit31667/3db4f162c2c40502d38d04dc87393e94.js"></script>

<script src="https://gist.github.com/raksit31667/a9abb5325efb8bbe0745fb48ab15726b.js"></script>

<script src="https://gist.github.com/raksit31667/3f5ad4a5bd6d0e7490ee07e1f5a82669.js"></script>

เนื่องจากมันมี dependencies ติดกับ class นึง คำถามคือ หน้าตาของชุดการทดสอบจะออกมาประมาณไหน จากการพูดคุยกันพบว่าจะได้ 2 รูปแบบ

- สาย Classicist หลีกเลี่ยงการ mock dependency ใดๆ
- สาย Mockist ตรงกันข้าม mock dependency เท่าที่จะเป็นไปได้

แล้วทั้ง 2 รูปแบบมันต่างกันอย่างไรล่ะ

## Classicist
การเขียนชุดการทดสอบของ object ใดๆ ในส่วนของ dependency ของ object นั้น เราจะต้อง hard code ผลลัพธ์ที่ควรจะเป็นลงไปใน implementation code ของ dependency ก่อน เพื่อให้ชุดการทดสอบของ object ผ่าน จากนั้นตอนเราเขียนชุดการทดสอบของ dependency นั้นๆ เราค่อยแทน hard code ด้วย implementation code จริง ทำการ run ชุดการทดสอบใหม่ ทำวนลงไปตาม layer เรื่อยๆ  

<script src="https://gist.github.com/raksit31667/05e50f5824fff3cc68a4409a5f5254bf.js"></script>

<script src="https://gist.github.com/raksit31667/5884f17b30b16683595a06d7c5327b32.js"></script>

## Mockist
การเขียนชุดการทดสอบของ object ใดๆ ในส่วนของ dependency ของ object นั้น เราก็จะทำการ mock ผลลัพธ์ที่ควรจะเป็นลงไปในชุดการทดสอบ เพื่อให้ชุดการทดสอบของ object ผ่าน จากนั้นเราเขียนชุดการทดสอบของ dependency นั้นๆ ทำลงไปตาม layer เรื่อยๆ  

<script src="https://gist.github.com/raksit31667/c27477f631fd75e5a11325d827182e35.js"></script>

<script src="https://gist.github.com/raksit31667/f099bb84d41f52e52e34cf413aafbe4f.js"></script>

## จะ Classicist หรือ Mockist ดีล่ะ
จากข้อดี-ข้อเสียของทั้ง 2 รูปแบบ เราควรพิจารณาการใช้งานตามนี้

### การ Setup
classicist จะต้องเตรียมระบบที่ต้องการทดสอบ และ dependency เหล่านั้น และ data ที่ใช้สำหรับการทดสอบเอง ปัญหาจะเบาบางลงไปบ้างถ้าเรา reuse การ setup เหล่านั้น แต่ก็มีข้อจำกัดเรื่องการอ่านทำความเข้าใจ code ที่ต้องกระโดดไปมาระหว่าง test suite และ test data บ่อยกว่า  

mockist จะใช้เครื่องมือช่วยเตรียมระบบที่ต้องการทดสอบ และ dependency เหล่านั้นให้ แต่ในส่วนของ data ที่ใช้สำหรับการทดสอบก็ยังต้องเตรียมเองอยู่ มีข้อจำกัดที่ทุกๆ ชุดการทดสอบจะต้องมี statement ในการเตรียม mock เสมอ  

### ความเป็นอิสระต่อกัน
สำหรับ classicist การแก้ไข implementation code ไม่ว่าจะ object ไหนก็ตามย่อมมีผลทำให้ชุดการทดสอบของเราพังหมด ในอีกแง่มันก็เป็นข้อดีเพราะจะทำให้เรารู้ว่าการแก้ไขมันมีผลกระทบต่อ object ไหนอื่นๆ บ้าง  

กลับกันในส่วนของ mockist การแก้ไข object อื่นๆ ก็ไม่มีผลต่อ object ที่เราทดสอบอยู่ แต่เวลามีการแก้ไขแล้วก็มีโอกาสที่เราจะหาข้อผิดพลาดได้ยากและนานกว่า นอกจากนั้นชุดการทดสอบก็มีโอกาสที่จะพังถ้ามีการ refactor เพราะ mockist จะสนใจด้วยว่ามีการเรียกใช้ dependency ด้วย method และ argument ที่ถูกต้อง แต่ classicist สนใจแต่ state สุดท้าย  

> จะสังเกตได้ว่าการเลือกใช้ classicist หรือ mockist มันขึ้นอยู่กับบริบทของ object ที่ต้องการจะทดสอบล้วนๆ ส่วนตัวแล้วเราจะเลือกไปทาง classicist ให้ได้มากที่สุด จนกว่าเราจะพบว่า object ของเรามี dependency ที่ยากต่อการ setup เช่น การเชื่อมต่อกับ database ถึงจะเลือกใช้เป็น mockist

## Further reading
[Mocks Aren't Stubs by Martin Fowler](https://martinfowler.com/articles/mocksArentStubs.html)