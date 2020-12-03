---
layout: post
title:  "ข้อควรระวังการใช้งาน Lombok library ในภาษา Java"
date:   2020-12-02
tags: [java, lombok]
---

มีโอกาสได้อ่านบทความ [Be Careful With Lombok ของคุณ​ Semyon Kirekov](https://levelup.gitconnected.com/be-careful-with-lombok-2e2edfc01110) แล้ว product ที่ผมทำก็ใช้ Lombok เยอะมาก (แทบทุก repository) เนื่องจากมันลด [boilerplate code](https://en.wikipedia.org/wiki/Boilerplate_code) ที่มันซ้ำๆ กัน ทำงานคล้ายๆ กัน (เช่น getter-setter methods, constructors) จึงเอามาแปลกันหน่อย

# 1. ผูกติดกับ library มากจนเกินไป

การใช้งาน library ทั่วๆไป ก็เหมือนกับการนำ code ที่คนอื่นใช้เหมือนๆกัน มาใช้ใหม่ ดังนั้นถ้า library มี bug หรือมีการเปลี่ยนแปลงทางด้าน license ขึ้นมา เราก็จะได้รับผลกระทบไปด้วย เพราะ code ของเรามันผูกติดกับ Lombok ไปแล้ว

> คหสต. มีคนใช้ Lombok [เยอะมาก](https://github.com/rzwitserloot/lombok) เนื่องจากส่วนที่เราใช้มันเป็น opensource ยังไงก็มีการออก minor patch มาอย่างไวอยู่แล้ว ส่วนเรื่อง license ทาง [Project Lombok](https://projectlombok.org/tidelift) ประกาศมาก็ยังพอมีเวลาให้แก้อ่ะนะ (แต่ถ้าโปรเจคใครเป็น legacy ก็ขอให้โชคดี ฮ่าๆๆๆ)

# 2. เรื่องของ Code Smell

การใช้งาน Lombok อาจจะเป็นดาบสองคม 

- ด้านนึงคือมันช่วยลดโค้ดไปได้หลายบรรทัด อ่านง่ายกว่าเดิม เพียงแค่รู้ว่าแต่ละ annotation มันคืออะไร โดยเฉพาะ class ที่มีหลายๆ attribute แค่ประกาศ getter-setter ก็เป็น 100 บรรทัดละ ฮ่าๆๆๆ

- แต่อีกด้านนึงคือมันอาจจะซ่อนสิ่งที่บ่งบอกถึง [code smell](https://martinfowler.com/bliki/CodeSmell.html#:~:text=A%20code%20smell%20is%20a,me%20with%20my%20Refactoring%20book.) มีให้ดู 2 ตัวอย่าง

<script src="https://gist.github.com/SimonHarmonicMinor/9c3fe08c160d0a03018c5c3f3baaf569.js"></script>

จากโค้ดข้างบน จะเห็นว่า class นี้มี dependency หลายตัว นั่นเป็นสัญญาว่ามันมีหน้าที่รับผิดชอบเยอะเกินไปหรือเปล่า ([SOLID principle](https://stackify.com/solid-design-principles/) ลอยมาเลย)

# 3. การใช้งาน @Builder

<script src="https://gist.github.com/SimonHarmonicMinor/17a418fe874c94e01193a5e0e4f87513.js"></script>

หนึ่งใน annotation ที่ใช้บ่อยมากคือ `@Builder` สำหรับการสร้าง Object โดยไม่ต้องมาปวดหัวกับ

- Constructor ใหญ่ (สามารถแก้ด้วยการ group attributes)
- Overloading constructor เนื่องจากบาง attribute เป็น optional เลยต้องมีหลาย constructor
- การ Default attribute โดยใช้ `@Builder.Default` ไม่ต้องใช้ setter

เราต้องระวังการใช้ Builder pattern ให้ดี ถ้าทุก attribute เป็น required แล้วใช้ Builder อาจจะลืม set attribute นั้นโดยไม่มี syntax error ใดๆ ทำให้โค้ดของเราเกิด runtime exception ได้ เช่น NullPointerException เราสามารถแก้ด้วยการใช้ `@RequiredArgsConstructor`

# ปิดท้ายด้วยแนวทางการใช้งาน Lombok สั้นๆ

- หมั่นตรวจสอบความซับซ้อนของ code อยู่เสมอ อาจจะใช้ static code analysis มาช่วย หรือผ่าน peer review ก็ได้
- ระวังการใช้งาน Builder กับ required attributes
- หลีกเลี่ยงการเพิ่ม business logic ผ่าน Lombok (เช่น custom builder method)
- จำกัด code style กับการใช้ Lombok (เช่น [field injection vs constructor injection]({% post_url 2020-05-13-spring-field-injection-drawback %}))