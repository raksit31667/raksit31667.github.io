---
layout: post
title: "สิ่งที่ได้เรียนรู้จากการทำ Composite Refactoring"
date: 2023-07-29
tags: [java, refactoring]
---

ช่วงเดือนที่ผ่านมาได้มีโอกาสเข้าไปฟัง session เกี่ยวกับการ refactoring มา 2-3 session พบว่าจริง ๆ แล้วแนวทางการทำ refactoring เป็นทักษะมากกว่าเครื่องมือ แล้วมันมีกระบวนการคิดอย่างไร มาดูกัน

## Refactoring เป็นทักษะมากกว่าเครื่องมือ
เมื่อ refactoring คือการปรับปรุงโครงสร้างของ code ให้ดีขึ้นโดยที่ไม่เปลี่ยนแปลงพฤติกรรมภายนอกของมัน ปัจจุบัน technology ในการ coding มันไปไกลมากแล้ว ตั้งแต่ program ต่าง ๆ ที่เราใช้เขียน code (IDE, editor) ไปจนถึง Generative AI ต่าง ๆ ที่มาช่วยให้การ refactoring ง่ายดายขึ้น คำถามคือแล้วต่อไปนี้ refactoring มันจะยากตรงไหนล่ะ  

ที่ technology มันสามารถช่วยได้คือการ refactoring ในระดับล่างสุดของ code ซึ่งหลังจากทำไป 1 ครั้งแล้วเราก็จะพบว่า

- มันไม่เพียงพอที่จะไปถึงภาพที่เราอยากจะให้มันเป็นจริง ๆ
- มันแสดงภาพที่เราอยากจะให้มันเป็นจริง ๆ แต่ไม่ได้บอกว่าจะไปถึงจุดนั้นต้องทำอย่างไรบ้างเป็นทีละขั้นทีละตอน

การที่จะไปให้ถึงนั้นจะต้องอาศัยกระบวนท่าหลาย ๆ อันผสมผสานกัน หลังจากจบแต่ละขั้นตอนจะต้องไม่เปลี่ยนพฤติกรรมภายนอกและไม่ควรใช้เวลานานเกิน 5 นาที เพื่อให้ได้ code ที่สามารถแก้ไขได้ง่ายเมื่อมี requirement จาก business เข้ามา เมื่อต้องไปพูดคุยกับ business ในการซื้อแนวคิด refactoring เราสามารถขายได้เลยว่า "เนี่ย เราใช้เวลาปรับปรุง code ให้พร้อมต่อ requirement ใหม่ภายใน 5 นาที"

ยกตัวอย่างเช่นเรามี code ของ program เครื่องคิดเลขอยู่โดยที่แต่ละตัวอักษรในเครื่องคิดเลขจะเรียกว่า `Node` โดยมี properties คือ `Node` ซ้ายกับขวาเพื่อเก็บตัวเลขหรือเครื่องหมาย

![Ultimate Calculator example](/assets/2023-07-29-ultimate-calculator-example.png)

<script src="https://gist.github.com/raksit31667/7e2e1dcfd82aae6c20092267ed024070.js"></script>

จะพบว่า code ส่วนนี้สามารถปรับปรุงได้หลายส่วนเลย ยกตัวอย่างเช่น

- Duplicate code ใน method `display()`
- การทำ error handling เมื่อเครื่องหมายไม่ใช่ `+`, `-` หรือ `*`
- Class นี้มันทำงานหลายอย่างเพราะรวม logic ของ `Node` ที่เป็นเครื่องหมายกับตัวเลขไว้ด้วยกัน เมื่อมี requirement ในการเพิ่มเครื่องหมายใหม่เข้ามาเราก็จะต้องแก้ code class นี้แน่ ๆ ทำให้ต่อมามันจะเริ่มโตขึ้นไปเรื่อย ๆ อ่านยากเข้าใจยาก (Single Responsibility Principle)

ดังนั้นวิธีการ refactoring คร่าว ๆ คือเราจะต้องแยกส่วน logic ของ `Node` ที่เป็นเครื่องหมายกับตัวเลขออกจากกันก่อน ก็จะได้หน้าตาประมาณนี้

![Ultimate Calculator design](/assets/2023-07-29-ultimate-calculator-design.png)

พอลองเอาไปเข้า ChatGPT ให้ลอง refactoring ก็พบว่าได้หน้าตามาประมาณนี้

<script src="https://gist.github.com/raksit31667/d82945ffda4c18008eef1d94810a9d9a.js"></script>

แต่การจะไปถึงจุดที่แยกกันได้จะต้องทำขั้นตอนอะไรบ้างล่ะ แน่นอนว่ามีหลายทางแต่เราควรจะเลือกกินคำเล็ก ๆ ที่แต่ละคำต้องไม่เปลี่ยนพฤติกรรมภายนอกและไม่ควรใช้เวลานานเกิน 5 นาที มีดังนี้

1. เราต้องมีชุดการทดสอบก่อนครับ เพื่อให้แน่ใจว่าหลังจาก refactoring เราจะไม่เปลี่ยนพฤติกรรมภายนอก หากไม่มีแล้วการ refactoring จะยากขึ้นมาก ๆ นะ และ**หลังจากที่ลงมือ refactor ในแต่ละขั้นตอนแล้วให้ทำการ run ชุดการทดสอบทุกครั้ง เมื่อผ่านแล้วเราสามารถ commit code ได้ถือว่าจบขั้นตอนการ refactoring** ทีนี้ก็แล้วแต่เราละว่าอยากให้มันจบขั้นตอนไหนก็อิงตาม requirement ได้เลย

    <script src="https://gist.github.com/raksit31667/8f172c5154add8d26f5c5e60b1d33c1a.js"></script>

2. สังเกตว่าใน `Node` จะมี constructor อยู่ 2 อันสำหรับเครื่องหมายกับตัวเลข เพื่อจะแยกออกจากกัน ในเมื่อเราไม่สามารถเปลี่ยน constructor ให้ return อีก class นึงได้ เราสามารถเอา logic ของตัวเลขแยกเป็น class ใหม่ชื่อ `ValueNode` แล้วเปลี่ยนชื่อ `Node` เป็น `OperatorNode` สำหรับ logic ของเครื่องหมาย แต่ถ้าลงมือทำปุ๊บ constructor จะถูกย้ายไปด้วยชุดการทดสอบจะต้องแก้เยอะ ดังนั้นขั้นตอนนี้เราแค่ทำการ [Replace constructor with factory method](https://refactoring.guru/replace-constructor-with-factory-method) ก็พอ หากทำผ่าน IDE แล้วมันก็จะแก้ชุดการทดสอบให้ไปใช้ factory method ด้วย ทีนี้เราก็สามารถโยก constructor ได้ง่ายขึ้นละ

    <script src="https://gist.github.com/raksit31667/36c8fbca1869e83a29acd1dd1fbe41ec.js"></script>

3. [แยก interface ออกมา](https://refactoring.guru/extract-interface)รวมพฤติกรรมของ `Node` ทั้ง 2 รูปแบบคือจะต้องมี `compute()` และ `display()` จะเป็นประโยชน์สำหรับ `Node` ของเครื่องหมายที่มันไม่ต้องสนใจว่าข้างซ้าย-ขวาเป็น `Node` ประเภทไหน ใช้แค่ inteface ก็จบ ทีนี้ถ้า interface มีชื่อว่า `Node` ก็ต้องแก้ชื่อ class เดิมด้วย (ในตัวอย่างจะเรียกว่า `GodNode` ละ) แต่การเอาไปใช้ในชุดการทดสอบให้ใช้ `Node` เหมือนเดิม

    ![Extract interface](/assets/2023-07-29-extract-interface.png)

    <script src="https://gist.github.com/raksit31667/40b0bb21fa0baf7449c42d2b9074e02d.js"></script>
    <script src="https://gist.github.com/raksit31667/7d90028a71c3a01e2298b076d414f9b0.js"></script>

4. ถึงเวลาแยก logic ของ `Node` ส่วนตัวเลขออกมา (ในตัวอย่างจะเรียกว่า `ValueNode`) แต่ว่าตอนนี้ `GodNode` ยังต้องใช้ properties `value` อยู่ เราเลยต้องทำ `ValueNode` [ให้เป็น superclass](https://refactoring.guru/extract-superclass) ของ `GodNode` ก่อน  โดยที่ดึง properties `value` ของ `GodNode` ออกมาแล้วก็ให้ `ValueNode` ไปใช้ `Node` interface ในการย้าย logic `compute()` และ `display()` ส่วนของตัวเลขออกมาอีกที

    ![Extract superclass](/assets/2023-07-29-extract-superclass.png)

    <script src="https://gist.github.com/raksit31667/10f9d45e3b0eb06ddd7a1688a74c3c8d.js"></script>
    <script src="https://gist.github.com/raksit31667/6dcf9326b86df3db43412b71a389191c.js"></script>

5. จะพบว่า factory method `valueNode` เราสามารถแทน `GodNode` ด้วย `ValueNode` ได้ ทำให้เราสามารถลบ private constructor 1 ตัวที่เกี่ยวกับตัวเลขใน `GodNode` ออกไปได้ แยก inheritance ของ `GodNode` ออกจาก `ValueNode` ได้ และลบ logic `compute()` และ `display()` ส่วนของ `ValueNode` ออกจาก `GodNode` ได้

    <script src="https://gist.github.com/raksit31667/e8a18f1b0ae8cdc835a3ea50dd0b35eb.js"></script>
    <script src="https://gist.github.com/raksit31667/ed7dc3d03e13fdfcf7cdfbba0ae19084.js"></script>

6. เมื่อ `GodNode` มีแต่ logic ของเครื่องหมายอย่างเดียวแล้ว เราก็ปิดท้ายด้วยการเปลี่ยนชื่อ class จาก `GodNode` เป็น `OperatorNode` เป็นอันเสร็จ

    <script src="https://gist.github.com/raksit31667/71f0571bf6a43e63b6149d96f2039cd4.js"></script>

## สรุป
![Ultimate Calculator transition](/assets/2023-07-29-ultimate-calculator-transition.png)

จากตัวอย่างของ Ultimate calculator จะเห็นได้ว่า

- การ refactor เพื่อเปลี่ยนแปลงโครงสร้างนั้นจะต้องใช้ทักษะในการสังเกต วิเคราะห์ และเลือกใช้กระบวนท่าหลาย ๆ อันผสมผสานกัน (composite) โดยที่ไม่เปลี่ยนแปลงพฤติกรรมภายนอกของมัน เครื่องมือเป็นแค่ตัวช่วยที่จะพาเราไปถึงโครงสร้างใหม่ที่เราอยากให่้เป็นได้เร็วขึ้น
- เราต่อยอดการ refactor ขึ้นไปในระดับ scale ที่ใหญ่ได้ง่ายขึ้น เพราะเราสามารถเลือกที่จะหยุด refactor ได้ทันท่วงทีเมื่อเกิดการเปลี่ยนแปลงด้าน business หลีกเลี่ยงการทำ design เผื่ออนาคตมากจนเกินไป (over-engineering)
- ชุดการทดสอบเป็นหัวใจหลักของการทำ refactoring หากขาดมันไปแล้วเราก็ขาดความมั่นใจไปด้วยว่าหลัง refactor แล้วพฤติกรรมมันยังเป็นแบบเดิมอยู่ไหม

ปล. เรายังสามารถต่อยอดการ refactor ต่อได้ด้วยการกำจัด switch statement ใน method `compute()` และ `display()` ด้วย [Replace Conditional with Polymorphism](https://refactoring.guru/replace-conditional-with-polymorphism) ได้อีกนะ ไปลองดูกันฮะ

<iframe width="560" height="315" src="https://www.youtube.com/embed/GBfBAAZkN6g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
