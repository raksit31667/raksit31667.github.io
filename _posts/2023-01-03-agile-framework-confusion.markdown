---
layout: post
title:  "พูดถึงความสับสนที่มีในตัวเองใน Agile Framework ต่าง ๆ"
date:   2023-01-03
tags: [agile, scrum, extreme-programming]
---

ในการทำงานที่ปัจจุบันหลายองค์กรเริ่มหันไปใช้แนวคิดของ Agile โดยแนวคิดพื้นฐานก็คือ 

> Agile = Deliver outcome, early and often

หมายความว่าเราต้องส่งมอบผลลัพธ์ที่ business ต้องการอย่างรวดเร็วและบ่อย ซึ่งก็ดูเหมือนว่ามันง่ายนะ แต่การประยุกต์ใช้เนี่ยมันไม่ง่ายเลย จึงมีการคิดค้น framework มากมายขึ้นว่า โดยในระดับ project level จะเรียกว่า **Dynamic systems development method (DSDM)**

![DSDM framework](/assets/2023-01-03-dsdm-framework.png)

<https://www.knowledgetrain.co.uk/agile/agile-project-management/agile-project-management-course/dsdm-principles>

ในระดับย่อยลงมาจะเรียกว่า delivery level ก็จะมีหลาย ๆ ตัวที่เราคุ้นชื่อเช่น Scrum, Extreme Programming (XP), Kanban เป็นต้น ทำให้เวลานำไปใช้จริงทำให้เกิดความสับสนมาก เลยหยิบจับ framework ต่าง ๆ มายำรวมกันมั่วไปหมด เช่น

## Sprint และ Iteration

คำว่า Sprint และ Iteration ที่ใช้แทนกันได้ แต่จริง ๆ แล้ว

- Sprint เป็นแนวคิดของ Scrum
- Iteration เป็นแนวคิดของ XP

ืที่จริงแล้ว Scrum ไม่ได้ลงรายละเอียดเรื่อง software development เท่าไรนัก จะไปเน้น project management มากกว่า ทำให้เวลาเรานำไปใช้โดยควบคู่ไปกับ [Scrum guide](https://scrumguides.org/scrum-guide.html) หรือจะมีตำแหน่ง Scrum Master ก็ตามมันไม่ได้เจาะจงเรื่องของการพัฒนา software เท่าไร เน้นไปที่การ self-organization ของทีมเนื่องจากทีมพัฒนาสามารถเลือกชิ้นงาน (backlog) มาทำได้ด้วยตัวเอง ในขณะที่ XP จะให้ลูกค้าเลือกชิ้นงาน (user story) มาจาก release plan ที่วางไว้ พอกลับมาคิดก็ไม่แปลกใจแล้วว่าทำไมแต่ก่อนคิดว่า

> Agile == ใช้ Scrum ทำงานเป็น Sprint + Software Engineering Practices (XP)

อีกเรื่องนึงคือคุณค่าและจุดประสงค์ของการนำ framework มาใช้ โดยที่

- Scrum เน้นที่ความเปิดเผยตรงไปตรงมาจากทีมพัฒนา และความมุ่งมั่นที่จะทำตามเป้าหมายที่ตั้งไว้ในแต่ละ Sprint
- XP เน้นที่การสื่อสารระหว่างลูกค้าและทีมพัฒนา ความเรียบง่ายของการนำแนวทางปฏิบัติการพัฒนา software มาใช้ และ feedback ที่ได้รับจากการส่งมอบในแต่ละ Iteration

![Extreme programming](/assets/2023-01-03-extreme-programming.gif)

<http://www.extremeprogramming.org/rules.html>

## Acceptance Criteria และ Definition of Done

- **Acceptance Criteria**: ชุดของการทดสอบในกรณีต่าง ๆ เพื่อไว้ยืนยันว่า software สามารถทำงานได้ตามที่ user story นั้น ๆ กล่าวไว้จริง ๆ เป้าหมายเพื่อทำให้ทุกคนเข้าใจปัญหาที่จะแก้ตรงกัน และเป็นสัญญาณบอกว่า user story นั้น ๆ เสร็จแล้วหรือยัง
- **Definition of Done**: checklist เพื่อเป็นสัญญาณบอกว่า user story เสร็จแล้วหรือยัง โดยไม่ได้เจาะจงไปที่ user story เป็นอัน ๆ แต่จะบอกรวม ๆ มากกว่า เช่น ชิ้นงานผ่านการ review โดย Product Owner แล้วหรือยัง มีเป้าหมายเพื่อทำให้ทุกคนเห็นภาพของคุณภาพของงานร่วมกัน และทำให้แน่ใจว่าชิ้นงานที่ส่งมอบมีคุณภาพ

แน่นอนว่าทั้ง 2 อย่างเหมือนกันตรงที่เป็นสิ่งที่ต้องทำถึงจะบอกได้ว่า user story เสร็จ แต่ในการใช้งานจริงก็แตกต่างปลีกย่อยกันไปอีก ดูจากตัวอย่างการเขียน user story ที่ประกอบไปด้วย **functional/non-functional) requirements + (functional/non-functional) test scenarios**

![User story example](/assets/2023-01-03-user-story-example.jpeg)

<http://caboose.work/mydoc_pm_agile.html>

## รู้แล้วยังไงต่อ

เมื่อรู้ตามนี้แล้ว ในฐานะที่อยู่ในวงการพัฒนา software ส่วนตัวเราจึงต้องมาเน้นถึงแนวคิดของ XP ให้มากขึ้น โดยแนวคิดประกอบไปด้วย

- **Test-first development**: นำการทดสอบมาอยู่ในทุกจุดของการพัฒนา software ตั้งแต่วิเคราะห์ requirement จนถึงส่งมอบ
- **Customer on staff**: ลูกค้าอยู่กับทีมพัฒนาตลอด (เปรียบเทียบคือ Customer = PO, Staff = Development team ของ Scrum team)
- **Just-in-time requirements**: พัฒนา requirement ที่สำคัญต่อลูกค้าก่อนโดยมีความรู้ความเข้าใจที่เพียงพอที่จะเริ่มชิ้นงานได้ก็พอ ไม่ต้องรอให้รู้ทั้งหมด 100%
- **Customer controls requirements**: ลูกค้ากำหนดทิศทางของ project โดยให้ลูกค้าเลือก user story มาจาก release plan ที่วางไว้

XP มีต้นกำเนิดมาจาก iterative & incremental development ซึ่งว่าด้วยวงจรของการพัฒนา software ใน project ประกอบไปด้วย 4 ระยะคือ 

- **Inception**: กำหนดและออกแบบ vision, business case, scope และคำนวนค่าใช้จ่ายโดยคร่าว ๆ เป็นช่วงที่ควรจะสั้นที่สุด ถ้ายาวแปลว่าอาจจะมีการออกแบบมากเกินความจำเป็น (up-front specification)
- **Elaboration**: เก็บและวิเคราะห์ requirement ออกแบบ architecture เพื่อระบุความเสี่ยง สมมติฐาน ปัญหา และส่วนที่เกี่ยวข้่อง (RAIDs)
- **Construction**: เริ่มพัฒนา software เป็นรอบ ๆ (iteration) โดยผลลัพธ์จากการพัฒนาคือ software ที่สามารถส่งมอบได้
- **Transition**: ส่งมอบระบบและเก็บ feedback ไปพัฒนาต่อไป

![Rational Unified Process](/assets/2023-01-03-rational-unified-process.png)

<https://en.wikipedia.org/wiki/Unified_Process>

## สรุป

ในฐานะ consultant อยากจะจดกันลืมไว้สักหน่อยว่า

- ต้องตอบคำถามให้ได้ว่า แนวทางการทำงานที่เราเสนอนั้นมันทำไปทำไม ทำแล้วมันดีขึ้นยังไง เพราะเราเข้าไปเปลี่ยนแนวทางการทำงานของลูกค้า เป็นเรื่องธรรมดาที่เค้าจะต้องสงสัยแน่นอนว่าเปลี่ยนแล้วมันได้ประโยชน์อะไร
- ค้นหาและระบุให้ได้ว่า หน้าตาของ Agile ของลูกค้าแต่ละที่คืออะไร
- จะต้องตกลงกับลูกค้าก่อนว่าเราจะแก้ปัญหาที่เกิดขึ้นจากการพัฒนา ตรวจสอบ ทดสอบ เพื่อส่งมอบผลลัพธ์จาก software
- จะต้องมี goal setting กับลูกค้าก่อนว่าการพัฒนา ตรวจสอบ ทดสอบ เพื่อส่งมอบผลลัพธ์จาก software ต้องปรับเปลี่ยนไปเป็นแบบใดที่จะสนับสนุนธุรกิจขององค์กร

> ก่อนจะนำเอาอะไรมาใช้ ควรรู้ความต้องการและปัญหาของตัวเองก่อน ไม่งั้นมันอาจจะต่อยอดหรือ sustain ไม่ได้