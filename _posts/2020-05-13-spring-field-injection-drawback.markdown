---
layout: post
title:  "ว่าด้วยข้อเสียของ field injection ใน Spring framework"
date:   2020-05-13
tags: [spring, solid]
---
เมื่อวานตอนทำ code review มี discussion ที่น่าสนใจในเรื่องของ Dependency injection ใน Spring framework ซึ่งมีอยู่ด้วยกัน 3 วิธี

1. Constructor injection
<script src="https://gist.github.com/raksit31667/9670c969c69fb3abe1e05e4c709ebbe4.js"></script>

2. Setter injection
<script src="https://gist.github.com/raksit31667/e29303b59102440642aa91c79be62786.js"></script>

3. Field injection
<script src="https://gist.github.com/raksit31667/9d8c48e9a1bf1d04a39c9ec2bc9e5474.js"></script>

ซึ่งแต่เดิม ผมชอบใช้ **Field injection** มากที่สุด เพราะมันง่าย ไม่ต้องประกาศ constructor หรือ setter method ให้รกเลย แต่พอกลับไปศึกษาเพิ่มเติมจาก feedback ที่เพื่อน developer ด้วยกันให้มา พบว่ามี warning ใน IDE ว่า

> Field injection is not recommended 
> Inspection info: Spring Team recommends: "Always use constructor based dependency injection in your beans. Always use assertions for mandatory dependencies".

คำถามคือ ทำไมถึงไม่แนะนำให้ใช้ constructor injection แล้ว field injection มันมีข้อเสียอย่างไร ไปหาเพิ่มมีคนเขียนไว้[หลายบทความ](https://gangmax.me/blog/2019/12/09/field-injection-is-not-recommended/)เลย สรุปได้ดังนี้

### ไม่สามารถสร้าง Immutable objects ได้
ซึ่งเสี่ยงต่อการเกิด side-effect ได้หากใช้อย่างไม่ระวัง ใช้งานได้เฉพาะ constructor injection เท่านั้น

### ผูกติดกับ Dependency injection container
ไม่สามารถใช้ที่ไหนได้เลย นอกจาก Spring container ด้วยกันเท่านั้น ในขณะที่เราพยายามจะ decouple dependency จาก class นั้น เราดันไป couple กับ class injector (ซึ่งในที่นี้คือ Spring) ซะงั้น แปลกไหมล่ะ  

สำหรับการทดสอบนอก Spring ก็ทำไม่ได้เพราะต้องใช้ Spring container ในการ instantiate นอกจากจะใช้ [ReflectionTestUtils](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/test/util/ReflectionTestUtils.html)

### ง่ายต่อการผิดกฎ single responsibility ใน SOLID principle
สมมติว่าใน class เรามี 10 dependency (คงไม่มีใครทำนะ ฮ่าๆๆ) ถ้าเราใช้ field injection ก็ดูเหมือนไม่มีอะไร ง่ายไปหมด  
ในทางกลับกัน ถ้าใช้ constructor injection ต้องประกาศ constructor ตั้ง 10 ตัวแหนะ แบบนี้มันคือสัญญาณของ [code smell](https://refactoring.guru/smells/long-parameter-list) ว่า class นี้ทำหลายอย่างเกินไปหรือเปล่านะ

### ไม่เห็น Dependency อย่างชัดเจน
ในเมื่อเราใช้ dependency injection เพื่อไม่ให้ class ต้องมาจัดการกับ dependency เอง เราก็ควรจะต้องบอกให้ชัดเจนว่า dependency ของ class นั้นมันมีอะไรบ้าง ซึ่ง constructor injection เห็นชัดเจนกว่า field injection แน่นอน หรือประกาศเป็น interface ไปเลย
  
### แล้วเมื่อไรจะต้องใช้ constructor หรือ setter injection ละ
- **ถ้า dependency ที่จำเป็นต้องมี และเป็น immutable** แนะนำให่้ใช้ constructor injection
- **ถ้า dependency เป็น optional หรือเป็น mutable** แนะนำให้ใช้ setter injection
 
> หลังจากนี้ต้องสนใจ warning ใน IDE ให้มากขึ้นอีก

### Recommendation reading
- [SOLID Design Principles Explained: The Single Responsibility Principle](https://stackify.com/solid-design-principles/)
- [Field Dependency Injection Considered Harmful](https://www.vojtechruzicka.com/field-dependency-injection-considered-harmful/)
- [Constructor-based or setter-based DI?](https://docs.spring.io/spring/docs/5.2.x/spring-framework-reference/core.html#beans-definition)