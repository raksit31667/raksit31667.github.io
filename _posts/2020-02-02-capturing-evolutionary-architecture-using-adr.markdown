---
layout: post
title:  "ว่าด้วยเรื่องของ Evolutionary architecture กับทีม development"
date:   2020-02-01
tags: [architecture, adr]
---
![Evolutionary architecture](http://blog.shippable.com/hubfs/Blog_images/software-architecture-evolution.png)
[http://blog.shippable.com/why-you-should-adopt-microservices](http://blog.shippable.com/why-you-should-adopt-microservices)

จากหนังสือ [Design It!: From Programmer to Software Architect (The Pragmatic Programmers)](https://www.amazon.com/Design-Programmer-Architect-Pragmatic-Programmers/dp/1680502093) ได้ให้คำนิยามนี่น่าสนใจสำหรับ Software architecture ไว้ว่า

> Software architecture is a set of **significant design decisions** about how the software is **organized** to promote desired **quality attributes** and other properties.

## ประเด็นที่ 1 บริบท (Context)
บริทที่ใช้ในการตัดสินใจย่อมแตกต่างกันไปตามสภาพของทีมและ environment ดังนั้นการตัดสินใจของอีกทีมหนึ่ง อาจจะใช้กับอีกทีมหนึ่งไม่ได้เพราะ
- **Change** เพราะ software มักเปลี่ยนแปลงอยู่เสมอ
- **Information** ที่ได้จากเดือนมกรา อาจจะไม่เหมือนกับเดือนกุมภา
- **Pragmatism** จังหวะที่ต้องตัดสินใจ ช้า-เร็วไม่เท่ากัน หรือบางทีไม่ต้องตัดสินใจเลย
- **Budget** เรื่องของการ build vs buy หรือการเอาเงินไปใช้ในเรื่องอื่นๆ ที่จำเป็นก่อน

## ประเด็นที่ 2 การตัดสินใจ (Decision)
เมื่อผลลัพธ์ของการตัดสินใจที่สำคัญๆ จะแสดงออกมาเป็น architecture คำถามคืออะไรที่สำคัญบ้างล่ะ
- **Organization** ก็สำคัญ
- **Business** ก็สำคัญ
- **Technology** ก็สำคัญ
- **Quality attributes** (non-functional requirements) ก็สำคัญ

**คำตอบคือ วัดกันที่ค่าใช้จ่ายที่ใช้ในการเปลี่ยนแปลง** (cost of change) ว่ามันยากและแพงมากแค่ไหนในการเปลี่ยน  ซึ่งแต่ละทีมก็มีแนวทางในการจัดการค่าใช้จ่ายเหล่านั้นให้น้อยที่สุด และนำมาสู่วิวัฒนาการของ architecture

## ประเด็นที่ 3 ผลที่ตามมา (Consequences)
แน่นอนว่าการตัดสินใจแต่ละอย่าง ย่อมส่งผลลัพธ์ตามมา ทั้งดีและไม่ดี ถ้าตัดสินใจเร็วเกินไป ก็จะมีค่าเสียโอกาสให้กับ decision ที่ดีกว่า แต่ถ้าตัดสินใจช้าเกินไป ก็เกิดค่าเสียเวลาของทีมและบริษัท รวมถึงสมาชิกใหม่ที่เข้ามาเป็นส่วนหนึ่งของทีม ก็ต้องประสบกับการตัดสินใจจากคนรุ่นก่อนๆ ด้วย  

ประเด็นต่างๆ เหล่านี้จึงเป็นที่มาว่า ทำไมเราถึงต้อง capture การตัดสินใจในบริบทต่างๆ ที่ทำให้เกิดผลตามมา เพื่อเป็นประโยชน์ให้กับสมาชิกใหม่ การตัดสินใจจากคนรุ่นเก่าที่สามารถจับต้องได้ จะเป็น information ที่สำคัญในการเติบโตของ architecture ในทางที่ถูกต้องมากขึ้นนั่นเอง  

สำหรับเทคนิคก็มีหลายแบบ ทั้งการวาด diagram การทำ documentation ก็ขึ้นอยู่กับทีมละ เทคนิคที่ีทีมผมใช้เรียกว่า **Lightweight architecture decision record** ซึ้่งนำมาจาก [ThoughtWorks Technology Radar](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records)  
  
แทนที่จะเขียน solution architecture เป็นร้อยๆ หน้า ที่มีโอกาสสูงที่จะไม่อัพเดท เขียนเป็น decision log เก็บไว้ใน source code น่าจะดีกว่า
แนะนำให้เก็บเป็น markdown ไว้ใน codebase นั่นแหละ เพื่อความง่ายต่อการอ่านและอยู่ใกล้กับความจริง (code ไม่เคยโกหก ฮ่าๆๆ)

## Format
- Title สรุปสั้นๆ
- Context บริบท
- Decision ตัดสินใจ
- Status สถานะของการตัดสินใจ (proposed, accepted, deprecated, suspended)
- Consequences ผลที่ตามมา

สำหรับ developer มี [command-line tool](https://github.com/npryce/adr-tools) ให้พร้อมเสร็จสรรพ ไปลองใช้กันได้

> เพราะการยอมรับในสิ่งที่ผิด หรือ ทำการเปลี่ยนแปลงแบบผิดๆ โดยที่ไม่เข้าใจบริบทและผลที่ตามมา มีผลเสียต่อคุณค่าของทีม ชิ้นงานและยริษัท

## References
- [The layperson's guide to software architecture by Liauw Fendy](https://www.slideshare.net/ThoughtWorks/the-laypersons-guide-to-software-architecture)
- [Documenting Architecture Decisions by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions)






