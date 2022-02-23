---
layout: post
title:  "การ migrate Java project ไป version ใหม่ต้องคำนึงถึงอะไรบ้าง"
date:   2022-02-20
tags: [java, cicd, gradle]
---

ปัจจุบัน project ที่กำลังทำอยู่นั้น run อยู่บน Java version 11 ทีมเราก็มีแผนที่จะทำการ migrate ขึ้นไปเป็น version 17 เนื่องจากมี feature ใหม่ๆ ที่น่าสนใจ เช่น

- Multi-line text block รองรับหลายบรรทัด ไม่ต้องมาต่อ `+` String ยาวๆ ละ
- Switch expressions ไม่ต้องใส่ `break` statement แล้ว
- Record สำหรับ object ที่ไม่สามารถแก้ไขค่าได้ (immutable)
- Sealed class สำหรับควบคุม inheritance ของ class ใดๆ โดยการเลือกเลยว่าจะให้ class ไหน `extend` ได้บ้าง เหมาะสำหรับการเขียน code ไปใช้เป็น library
- `NullPointerException` ที่มีประโยชน์มากขึ้น โดยการปรับปรุง stack trace ว่า method ไหนที่ return `null`
- เพิ่ม `Stream.toList()` ให้แทนที่การใช้งาน `Collectors.toList()` ทำให้ code สั้นลงแต่ยังเข้าใจมากขึ้น
- Performance ที่ดีขึ้น กิน memory น้อยลงจาก garbage collection ที่ดีขึ้น
- การอุดช่องโหว่ทาง security ต่างๆ

แต่การจะ migrate ขึ้นไป มันก็ต้องมีค่าใช้จ่ายคือ "เวลา" ที่เราต้องเสียไป ซึ่งคำถามที่จะตามมาอย่างแน่นอนคือ
- การ migrate มันต้องมีขั้นตอนอะไรบ้าง
- การ migrate มันคุ้มไหม เอาเวลาไปทำ business requirement ดีกว่าไหม

การที่เราจะตอบคำถามเหล่านี้ได้ เราต้องคำนึงถึงอะไรบ้าง มาดูกัน

## Library หรือ dependencies
การ upgrade มันไม่ได้มีเพียงแค่ตัว Java Development Kit (JDK) เท่านั้น มันยังรวมถึงว่า library หรือ dependencies ที่เราเรียกใช้งานก็จะได้รับผลกระทบด้วย ยกตัวอย่าง library มาตรฐานโลก

### Lombok
Lombok เป็น library ที่ใช้ลด bolierplate code เช่น getter-setter-equals-toString method หรือประกาศ immutable object (เหมือน `Record` ของ Java) ด้วยการประกาศ annotation จาก Lombok  

จากใน [changelog ของ Lombok](https://projectlombok.org/changelog) เราก็จะพบว่า version `v1.18.4` เริ่ม support ใน Java 11 ในขณะเดียวกัน `v1.18.22` เริ่ม support ใน Java 17 หมายความว่าถ้าเราไม่ upgrade Lombok version ตาม JDK version ก็จะทำให้ application ใช้งานไม่ได้  

### Jackson
Jackson เป็น library ที่ใช้ serialise-deserialise ข้อมูลในรูปแบบของ JSON ณ ขณะที่เขียนบทความนี้ Jackson มีปัญหาในการใช้งานกับ Java 17 ตาม [GitHub issues นี้](https://github.com/fasterxml/jackson-databind/issues/3168)

### JaCoCo
JaCoCo เป็น library สำหรับตรวจสอบ [test coverage](https://martinfowler.com/bliki/TestCoverage.html) เพื่อดูว่ามี code ส่วนไหนที่ยังไม่ได้ถูก execute จากการ run ชุดการทดสอบบ้าง นอกจากนั้นยังสามารถสร้าง report ออกมาใน format ต่างๆ ได้ด้วย  

จากใน [changelog ของ JaCoCo](https://www.jacoco.org/jacoco/trunk/doc/changes.html) เราก็จะพบว่า version `v0.8.7` เริ่ม support ใน Java 17 **แบบ Experimental** หมายความว่าถ้าเรา upgrade JaCoCo version ตาม JDK version ก็มีโอกาสที่ test coverage ของเราจะผิดเพี้ยนไป 

> 1. เราจะ upgrade ได้เร็วที่สุดเมื่อไร ก็ขึ้นอยู่กับ library และ dependency ตัวสุดท้ายที่เริ่มสามารถใช้งานได้ใน Java version ใหม่
> 2. หลังการ upgrade ตรวจสอบว่าชุดการทดสอบยังผ่านอยู่ และ test coverage ต้องได้ค่าเท่าเดิม

## Java version ต้องเป็น LTS ไหม
Java version ที่มี Long-term support (LTS) หมายความว่า จะมีคนสนับสนุน version นี้เป็นเวลาหลายเดือนหรือหลายปีซึ่งนานกว่า version ทั่วๆ ไป ประเด็นคือถ้าปัญหาเกี่ยวกับ security เกิดขึ้น Java version ที่เป็น LTS เท่านั้น (8, 11, 17) ที่จะได้รับการแก้ไข ในขณะที่ version ธรรมดาจะไม่ได้ ดังนั้นเราจะต้องประเมินความคุ้มค่าด้วย ไม่ใช่มองแค่ upgrade เพราะอยากได้ feature ใหม่อย่างเดียว

## CICD สำหรับการ migrate ไป Java version ใหม่
Continuous integration and delivery (CICD) เป็นแนวคิดที่ช่วยทำให้เราตอบคำถามว่า
- **Continuous integration (CI)** เมื่อแต่ละคนนำสิ่งที่ตัวเองสร้างมารวมกัน (integrate) เราจะมั่นใจได้ไงว่า มันยังทำงานได้อย่างถูกต้อง
- **Continuous delivery (CD)** เมื่อทำการ deploy ระบบงาน เราจะมั่นใจได้ไงว่ามันยังทำงานได้อย่างถูกต้อง

ดังนั้นเราสามารถนำแนวคิดของ CICD มาปรับใช้เพื่อทำการตรวจสอบการ migrate ได้ดังนี้

![Java migration CICD](/assets/2022-02-23-java-migration-cicd.png)

1. ใน Java version เก่า ก่อน deploy ขึ้น production เพิ่มชุดการทดสอบในรูปแบบของ unit & integration testing รวมถึง [functional testing](https://www.javatpoint.com/functional-testing) (ถ้ายังไม่มี) โดย functional testing ควรจะมาในรูปแบบของ black box ก็คือสนใจแต่ตัว application ในรูปแบบของ artifact หรือ binaries (JAR file) แทนที่จะเป็น code เช่น เราใช้ [Testcontainers](https://www.testcontainers.org/) ในการทดสอบ container ที่ไปเอา image ที่เรา build มา (เพื่อความกระชับ จะขอยกไปไว้ในบทความอื่นละกันครับ)
2. สร้าง option ใน code ของเราให้ package manager อย่าง Maven หรือ Gradle เลือก Java version ที่ใช้ในการ run ได้

    <script src="https://gist.github.com/raksit31667/6cd1ceecff94af6c7a29ebd963abea38.js"></script>

    ```shell
    $ ./gradlew test -Dapp.new.java.version=true
    ```

3. สร้าง step แยกออกมา สำหรับการทดสอบ functional testing ที่ run บน Java version ใหม่ ทำการปรับแก้ code จนกว่าการทดสอบจะผ่าน โดยที่ artifact ที่เราเอามาทดสอบจะต้องเป็นตัวเดียวกันกับที่ใช้บน Java version เดิม
4. สร้าง step แยกออกมา สำหรับการทดสอบ unit & integration testing ที่ run บน Java version ใหม่ ทำการปรับแก้ code จนกว่าการทดสอบจะผ่าน โดยที่ source code ที่เราเอามาทดสอบจะต้องเป็นตัวเดียวกันกับที่ใช้บน Java version เดิม
5. แก้ไข step ในการ deploy ขึ้น production จากที่เลือก artifact ของ Java version เดิม เป็น version ใหม่แทน ยังไม่ต้องลบ step อื่นๆ ใน Java version เดิมออกนะครับ เผื่อ version ใหม่มีปัญหาจะได้สับกลับมาได้
6. เมื่อทุกอย่างโอเคแล้ว ก็ลบ step อื่นๆ ใน Java version เดิมออก รวมถึงลบ option ใน package manager ที่เลือก Java version ที่ใช้ในการ run ได้

### ข้อสังเกต
- Functional testing จะ focus ไปกับ application ใดๆ อันนึงเท่านั้น เพราะการ migrate จะค่อยๆ ทำไปทีละ application ไม่แนะนำให้ทำรวดเดียวเลยนะครับ เวลามีปัญหาจนต้อง rollback change ทั้งหมด มันใช้ effort ในการแก้เยอะ
- การแยก unit & integration testing ออกจาก functional testing ทำให้เราสามารถแยกแยะและทยอยแก้ปัญหาต่างกันที่พบเจอในการทดสอบต่างกันได้
- ค่อยๆ upgrade ทีละ LTS version ก็คือ 8 -> 11 -> 17 การกระโดดข้ามจะมีความเสี่ยงและมี effort มากกว่า

## ว่าด้วยเรื่องของ Business
เป็นเรื่องที่หลีกเลี่ยงไม่ได้ที่เราจะเจอคำถามจากฝั่ง business ว่าการ migrate มันคุ้มไหม มันให้คุณค่าอะไรต่อ business บ้าง แน่นอนว่าประโยชน์ของมันคือ มี performance ที่ดีขึ้น การจัดการ memory ที่ดีขึ้น ทำให้ค่าใช้จ่ายในการดูแลรักษาลดลง แต่ก็แลกมากับความเสี่ยงที่ระบบจะมีปัญหาหลังการ migrate ถึงแม้จะมีชุดการทดสอบก็ตามเถอะ มันก็ไม่ได้การันตีว่าเราจะไม่เจอปัญหาอะไรเลย จากข้อดี-ข้อเสียที่ว่ามา เราสามารถประเมินความคุ้มค่าและร่วมกันตัดสินใจกับ business ได้

## ปิดท้ายด้วย video จาก session

[Albert Attard](https://www.linkedin.com/in/albertattard/)

<iframe width="560" height="315" src="https://www.youtube.com/embed/aUBRf8HUZPk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
