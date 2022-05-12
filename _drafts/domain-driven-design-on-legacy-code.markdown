---
layout: post
title:  "3 Technique ในการใช้แนวคิด Domain-driven design บน Legacy code"
date:   2022-05-12
tags: [domain-driven-design]
---

เมื่อวันก่อน ที่บริษัทมี lunch&learn เกี่ยวกับ Domain-driven design บน Legacy code ของคุณ [Chris](https://chrisza.medium.com/) โดยส่วนตัวผมคิดว่ามันมี technique ที่เรียบง่ายและสามารถนำไปปรับใช้แล้วดีขึ้นได้ทันทีโดยไม่ต้องลงแรงมากมาย มาดูกัน  

## Domain-driven design มีประโยชน์อย่างไร แบบขอสั้น ๆ

ในการพัฒนา software หนุ่งในปัญหาระดับโลกคือการทำงานร่วมกัน (collaboration) ระหว่างฝั่ง business และ technical ที่ไม่ราบรื่น จึงเกิดแนวคิด Domain-driven design (DDD) โดยมีเป้าหมายคือทำให้ความรู้ความเข้าใจในระบบ (business domain) เป็นไปตามสิ่งที่ผู้เชี่ยวชาญ (domain expert หรือ subject-matter expert) ได้บอกกล่าว ซึ่งผู้เชี่ยวชาญนั้นก็คือฝั่ง business หรือคนที่ให้ requirement กับนักพัฒนานั่นเอง  

![DDD diagram](/assets/2022-05-12-ddd-diagram.png)

<https://medium.com/nick-tune-tech-strategy-blog/domain-driven-architecture-diagrams-139a75acb578>

ในแง่ของ programming การใช้งาน DDD จะช่วยให้ class, method, variable ตรงกับ business domain ส่งผลให้

- การดูแลรักษาง่ายขึ้น เพราะ business และ technical ใช้ภาษาเดียวกัน (Ubiquitous language)
- Code สามารถต่อยอดตาม requirement ได้ง่าย เพราะ code ถูก model ตาม context ใน domain

ในบางครั้งนักพัฒนาก็ไม่สามารถหลีกเลี่ยงที่จะต้องแตะ legacy code ถึงแม้ว่าใครแตะแล้วก็จะเหม็นติดมือก็ตาม การทำตามแนวคิด DDD ก็อาจจะไม่ได้ตรงไปตรงมาเนื่องจาก code ไม่ได้ model ตาม domain context ตั้งแต่แรก ดังนั้นจึงต้องใช้ technique เข้ามาช่วย  

## Vocabulary extraction
แนวคิดคือเราจะต้องระบุ ubiquitous language จาก business ให้ได้ก่อน ซึ่งมันก็อยู่รอบ ๆ ตัวเราระหว่างทำงานทุกวันแบบไม่รู้ตัว เช่น

- User story
- เอกสารต่าง ๆ
- Discussion จากการประชุมต่าง ๆ
- บทสนทนาข้าวเที่ยง ?

![User story example](/assets/2022-05-12-user-story-example.png)

1. เริ่มต้นง่าย ๆ ด้วยการระบุคำนาม (noun) และกริยา (verb) ยกตัวอย่างใน user story  

     ![User story example vocab extraction](/assets/2022-05-12-user-story-example-vocab-extraction.png)

2. ถ้ามี class/method อยู่แล้วแต่คนละชื่อ ตกลง ubiquitous language กับ business ให้เรียบร้อยว่าจะใช้อันไหน

3. เขียน code โดยตั้งชื่อ class ตาม noun และ method ตามชื่อ verb

<script src="https://gist.github.com/raksit31667/7cbb3f4b935aed67cce8b48665e93ec3.js"></script>

ประโยชน์ที่ได้คือเราจะได้ ubiquitous language ทำให้เราสามารถต่ยอดแนวคิด DDD ได้ง่าย

## Ubiquitous language bubble
แนวคิดคือเราจะสร้าง anti-corruption layer เช่น adapter มาแปลง legacy code เป็น domain code

1. แยก legacy code ออกจาก domain code แล้วจัดกลุ่มของใครของมัน เช่น แยก package ออกมาโดยเฉพาะเลย

     ```
     ├── legacy
     │   ├── Client
     │   ├── ...
     ├── other
     │   ├── ...
     │   ├── ...
     ```

     <script src="https://gist.github.com/raksit31667/8fc35308b1a22147665d7dd929b4821e.js"></script>

2. ใช้ ubiquitous language ใน domain package

     ```
     ├── legacy
     │   ├── Client
     │   ├── ...
     ├── domain
     │   ├── Customer
     │   ├── ...
     ```

     <script src="https://gist.github.com/raksit31667/ba4837e8463c05e46e22e14f9ff463cc.js"></script>

3. สร้าง adapter มาแปลง legacy code เป็น domain code

     <script src="https://gist.github.com/raksit31667/31d0329a0541972667018fa3d1686602.js"></script>

4. Retire legacy code จนเหลือแค่ domain code

ประโยชน์ที่ได้คือ ขณะที่เรากำลังแทน legacy ด้วย domain code ตัว business logic ก็ยังคงทำงานได้อยู่ และทำให้เราเห็น context map ระหว่าง legacy และ domain code ซึ่งช่วยเพิ่มความเข้าใจในระบบมากขึ้น  

Technique นี้มีข้อควรระวังคืออย่าใช้มากเกินไปและอย่าเก็บ adapter ไว้นานเกินไป เพราะเราจะต้อง maintain code เพิ่ม ทำให้งงได้ง่ายขึ้น

## Bounded context discovery
ในการพัฒนาระบบงานใน legacy code มีโอกาสสูงมากที่เราจะเจอ class ที่รวม logic ไว้เยอะมาก ซึ่งแน่นอนว่าจะมีหลาย variable และ method เราเรียกสั้น ๆ ว่า God class มีผลเสียคือ ทำความเข้าใจยาก เวลาเกิดปัญหาใช้เวลาค้นหานานขึ้น  

ใน God class นั้นอาจจะประกอบไปด้วย context หลาย ๆ อัน ดังนั้นเราควรจะตีกรอบและแยก context ออกจากกัน (bounded context) เพราะการแก้ไข context ใด ๆ ไม่ควรส่งผลต่อ context อื่น ๆ ยกตัวอย่าง เช่น  

![User story different context](/assets/2022-05-12-user-story-different-context.png)

จะสังเกตว่าจริง ๆ ทั้งคู่ก็คือร้านอาหารแหละ แต่มันอยู่คนละบริบทกันขึ้นอยู่กับผู้ใช้งานระบบเป็น manager ของร้านอาหาร หรือ admin  

<script src="https://gist.github.com/raksit31667/0e0176d4a58cf31d4d7ad568b9fa34cb.js"></script>

<script src="https://gist.github.com/raksit31667/b99f8f6e27d881d11682c8d545ea7f68.js"></script>

จากตรงนี้เราก็สามารถที่จะแยก method ที่ใช้โดย admin ออกจาก manager ได้ละ  

<script src="https://gist.github.com/raksit31667/e8eabfeb15d54cc735e0318de70e541e.js"></script>

<script src="https://gist.github.com/raksit31667/8f839b29322a39d38ca28ba55b8f3ae3.js"></script>

<script src="https://gist.github.com/raksit31667/1ddb5dfde28131003bd6ec58de487481.js"></script>

ประโยชน์ที่ได้คือ code ดูแลรักษาง่ายขึ้น ลดความเสี่ยงในการที่ logic ส่วนอื่นได้รับผลกระทบเมื่อมีการแก้ไขส่วนใด ๆ

> มาถึงตรงนี้น่าจะเห็นแล้วว่าการนำแนวคิด DDD มันช่วยให้เราพัฒนาระบบงานได้อย่างเรียบง่ายขึ้น ลดอาการปวดหัวระหว่างฝั่ง business และ technical โดยที่เราจะให้ domain modeling เป็นตัวขับเคลื่อน technical pattern นั่นเอง