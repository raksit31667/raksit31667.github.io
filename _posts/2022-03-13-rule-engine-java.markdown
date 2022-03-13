---
layout: post
title:  "ทำความรู้จักกับ Rule engine บนภาษา Java"
date:   2022-03-13
tags: [rule-engine, java]
---

![Rule engine terminologies](/assets/2022-03-13-rule-engine-terminologies.png)
<https://www.toptal.com/java/rules-engines-power-to-the-smeople>

## เริ่มต้นจากปัญหาก่อน
สมมติว่ามีระบบเกี่ยวกับ membership program ซึ่งมี feature เกี่ยวกับการสะสมแต้มเพื่อนำไปแลกเป็นส่วนลด โดยมี requirement ใหม่ว่า

> ถ้าผู้ใช้งานทำกิจกรรม เช่น สอบ certificate หรือดู video conference ภายในวันที่กำหนด จะได้แต้ม bonus เพิ่ม

requirement นี้ประกอบไปด้วย 2 ส่วน คือ 

1. กฎกติกา (rule) ในการได้มาซึ่งแต้ม ประกอบไปด้วย เงื่อนไข (condition) และผลลัพธ์ที่จะเกิดขึ้น (action)
2. input ที่จะนำมาเข้าเงื่อนไข (fact) เราก็จะได้ code หน้าตาลักษณะหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/88c382d6b521751a34317beca1de6e16.js"></script>

<script src="https://gist.github.com/raksit31667/edff83849c928334f51a1217d4fec66c.js"></script>

ปัญหาคือ

- ถ้ามี rule เพิ่มเข้ามา ก็ต้องเพิ่มเงื่อนไขเข้าไป ทำให้เราต้องแก้ไข code ส่งผลต่อการทดสอบที่ซับซ้อนขึ้นและ code ที่ต้องดูแลรักษามีความซับซ้อนขึ้น
- ส่งมอบคุณค่าทาง business ได้ช้าลง เมื่อเทียบกับการแค่เพิ่ม rule เข้าไปเท่านั้น
- rule ดูแลแก้ไขได้โดยแค่คนที่เข้าใจ code เท่านั้น

## Rule engine เข้ามาแก้ปัญหาอย่างไร
Rule engine เป็นแนวคิดที่ช่วยลดความซับซ้อนของ code ในการเขียน if-else statements ที่มีเงื่อนไขคล้ายๆ กัน โดยให้เรากำหนด rule ที่มีทั้งเงื่อนไข และผลลัพธ์ที่จะเกิดขึ้น จากให้เราป้อน fact เข้ามาเพื่อให้ได้ผลลัพธ์ที่ต้องการ  

ในส่วนของเครื่องมือนั้น เราสามารถสร้าง rule engine ได้ง่ายๆ โดยไม่ต้องใช้ library หรือ framework เลยก็ได้ เช่น สร้าง collection ที่เก็บ rule ไว้ แล้วก็วน loop เพื่อหา rule ที่ใช่ จะได้ code ประมาณนี้

<script src="https://gist.github.com/raksit31667/fd7f1a3b91efa1b0224526a29d52db8c.js"></script>

<script src="https://gist.github.com/raksit31667/fab5974635faa8166d7254e30d75d7b7.js"></script>

<script src="https://gist.github.com/raksit31667/a049699a512a531687e22db72ad0b3fc.js"></script>

<script src="https://gist.github.com/raksit31667/c076da0b3e63081caeffbe1f64b12e46.js"></script>

เพียงเท่านี้เราก็ได้ rule engine แบบง่ายๆ แล้วนะ  

แต่การใช้ library หรือ framework ก็จะมี feature เพิ่มเข้ามาเพื่อรองรับ use case ที่ซัยซ้อนมากขึ้น เช่น

- **Chaining**: การที่ action ของ rule นึงเปลี่ยนแปลง fact ซึ่งนำไปสู่เงื่อนไขของอีก rule นึง แล้วทำไปเรื่อยๆ จนกว่า action ไม่ได้เปลี่ยนแปลง fact อีกแล้ว
- **Rule composition**: การประกอบ rule เข้าด้วยกันในกรณีที่ต้องการให้ fact เข้าเงื่อนไขจาก rule หลายๆ อัน
- **Domain specific language**: มีภาษาเฉพาะในการกำหนด rule ซึ่งคนที่ไม่มีประสบการณ์ด้าน technical ทำเข้าใจได้ง่ายกว่า code เครื่องมือบางตัวมากับ user interface ที่สามารถลากวางได้อย่างง่ายดาย

## เราจำเป็นต้องใช้งาน rule engine ไหม
การใช้งาน rule engine ก็มีข้อดีที่สามารถแก้ปัญหาที่กล่าวไว้ข้างบนได้ แต่ก็มีข้อเสียเช่นเดียวกัน หาก use case ที่นำมาใช้ไม่เหมาะสม

- จำนวนของ rule ไม่น้อยจนเกินไป เพราะถ้า rule น้อยเกินไป การเขียน if-else statements จะเรียบง่ายกว่า
- Rule ไม่ควรจะมีความหลากหลายมากจนเกินไป เพราะถ้ามากเกินไป ย่อมมีผลต่อ performance ของระบบได้ เราจะรู้จำนวนที่เหมาะสมของ rule นั้นก็ต้องมีการวัด performance ของระบบเมื่อมีการเปลี่ยนแปลง rule
- การใช้งาน chaining ทำให้ยากต่อการ debug เมื่อเกิดปัญหา เพราะต้องมาไล่ flow ของทั้ง chain ที่เกิดขึ้น

## เครื่องมือที่แนะนำ
เราจะมาเจาะลึกการใช้งานเครื่องมือเหล่านี้ในบทความถัดๆ ไป

- [Drools](https://drools.org/)
- [EasyRules](https://github.com/j-easy/easy-rules)

## Reference website
- [RulesEngine by Martin Fowler](https://martinfowler.com/bliki/RulesEngine.html)
