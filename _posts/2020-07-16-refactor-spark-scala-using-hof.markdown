---
layout: post
title:  "ทำการ Refactor โค้ด Scala ด้วย High-order function"
date:   2020-07-16
tags: [scala, refactoring]
---

บทความนี้ได้แรงบันดาลใจจากเพื่อน ThoughtWorks ที่เคยเป็น partner กับบริษัทผม โดยเค้าเสนอให้ลองใช้ [high-order function](https://docs.scala-lang.org/tour/higher-order-functions.html) ในการเขียน Scala ซึ่งเป็น functional programming language อยู่ละ

### ตัวอย่างโค้ด

<script src="https://gist.github.com/raksit31667/f9ec16c9d9b256e9dc757a88fbdd27ca.js"></script>

เป็นตัวอย่างโค้ดของ Spark streaming application มาในรูปแบบ `Input Stream => Streaming Computation => Output Sink`  
**คำถามตอนนั้นคือ** เราจะปรับปรุง code นี้ให้ดีขึ้นไปอีกยังไง

![Spark](/assets/2020-07-16-spark-streaming-app.png)
<https://databricks.com/blog/2016/07/28/continuous-applications-evolving-streaming-in-apache-spark-2-0.html>

### ว่าด้วยเรื่องของ Functional programming
รูปแบบ code ลักษณะนี้ที่เจอคือการเขียนแบบ **Imperative style** ซึ่งจะเน้นเป็นการอธิบายขั้นตอนการทำงานไปเรื่อยๆ แต่ปัญหาที่เกิดคือ ถ้าในอนาคตมันมี computation มากขึ้นไปเรื่อยๆ แปลว่าขั้นตอนมีมากขึ้น การจัดการ ดูแลรักษาเริ่มยากขึ้น เลยนำ **Object-Oriented Programming (OOP)** มาใช้ ([Scala ก็เขียน OOP ได้นะครับ](https://docs.scala-lang.org/overviews/scala-book/oop-pizza-example.html)) ซึ่งก็ช่วยจัดกลุ่ม behavior ที่เกี่ยวข้องกันได้อยู่ แต่การเขียนใน Streaming app ก็เป็นแบบเดิมอยู่ดี  

ถ้าเราเปลี่ยนจากการเขียนแบบนี้  

```
val input = fromInputStream
val df1 = compute
val df2 = computeMore
val output = toOutputSink
```

เป็นแบบนี้หละ  
```
fromInputStream andThen
    compute andThen
        computeMore andThen
            toOutputSink
```

### เริ่มใช้ High-order function ใน Scala
อธิบายง่ายๆ คือ function ที่ return function อีกที เช่น function `map` ใน `salaries.map(x => x * 2)` หมายความว่ามัน return function ซึ่งนำ x ไปคูณ 2 อีกที  

#### ส่วนการสร้าง SparkSession
เป็นส่วนแรก return function ที่ไม่รับอะไรเลย (Void) ที่ return `SparkSession` อีกที
<script src="https://gist.github.com/raksit31667/f8c2e45da138dee1aa2745733945bad4.js"></script>

#### ส่วนการทำ Input-Output
ฝั่ง Input รับต่อมาจากการสร้าง `SparkSession` ซึ่ง return `DataFrame` อีกที  
ฝั่ง Output รับ `DataFrame` มาจากการทำ computation เสร็จ แล้วก็ return `StreamingQuery` อีกที
<script src="https://gist.github.com/raksit31667/3cebfcf4b76fa619a9e5322a8d931a4f.js"></script>

#### ส่วนการทำ computation
ตรงนี้ก็ return function ที่รับ `DataFrame` มาจาก Input stream ที่ return `DataFrame` อีกที
<script src="https://gist.github.com/raksit31667/06af7543eb7580d9fd20889ca688544e.js"></script>

### เอามารวมกันจะได้หน้าตาประมาณนี้
ทำการร้อย function เข้าด้วยกัน (compose) ผ่าน `andThen` โดย function ถือ reference ของอีก function นึงไปเรื่อยๆ จนกว่าจะจบ flow
<script src="https://gist.github.com/raksit31667/6de666bc3605e65a5598215dcd96c926.js"></script>

จริงๆ มันก็เหมือนกับการเขียนแบบนี้ แต่อ่านง่ายกว่าเยอะ ฮ่าๆๆ
<script src="https://gist.github.com/raksit31667/cbe9d7ddf54403afb5e36a27db0e6f99.js"></script>

### การแก้ชุดการทดสอบก็ไม่ใช่เรื่องใหญ่อะไร
<script src="https://gist.github.com/raksit31667/69855323747647443d8f2d3820885bb8.js"></script>

> เป็นอีกแนวทางนึงในการอธิบาย code ของเราว่าทำอะไร (what) มากกว่าทำยังไง (how) ครับ  
> ตัวอย่างโค้ด <https://github.com/raksit31667/example-spark-gradle>
