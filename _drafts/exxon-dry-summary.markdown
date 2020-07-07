---
layout: post
title:  "สิ่งที่น่าสนใจจากงาน Don’t Repeat Yourself: Accelerate the initial phase of software development with common framework and enablement tools"
date:   2020-07-07
tags: [conference]
---

Digital transformation การนำ technology ที่มีอยู่มาใช้เพื่อแก้ปัญหาในองค์กร
เกี่ยวไรกับบอน้ำมัน experience ในการใช้กับ internet เช่น customer experience revenue maintain ลูกค้า
ถูก disrupt blockbuster -> netflix
ทำยังไงให้ product ไปอยู่บน online channel
product เปลี่ยนแปลง บอต้องเปลี่ยนแปลงด้วย
รวม logic global เข้าด้วยกัน
innovate ช้า เพราะ core ERP system ไม่เหมือน startup
อยากเอา advanced IT system ต้องมีประสบการณ์ในการทำ เราจะไม่ค่อยมี resource
ฝั่ง business ปรับตัวให้ customer centric มากขึ้น ชอบอะไร ต้องมี data ของลูกค้า
การที่จะออก product ใหม่แล้วปังเลยมันยาก
ทำไงเราจะ innovate ได้เร็วและเจ็บน้อยสุด ลด friction ลง
เอา PO มา รู้ไม่หมด กว่าจะได้ requirement มาก็ยากละ

speed to market
ย้อนกลับไปทำแรกๆ มี 6 product กระจายไปทำแต่ละประเทศด้วย
app นึง track ว่ารถส่งของอยู่ไหนแล้ว
ทำให้ customer service ทำงานง่ายขึ้น
เกิดปัญหามากเพราะแก้ปัญหาซ้ำไปซ้ำมา ติดปัญหาคล้ายๆ กัน เสียเวลาลงทุน tech foundation
การมาของ microservices ทำให้เร่งให้เกิดปัญหาข้างต้น เพราะเป็น distributed
microservices promise scale resiliency ทุกคนไม่ต้องรู้ทั้งระบบ
พอมีหลายทีม มันจะมีงาน infra ที่ทุกทีมใช้้เหมือนกันหมด เช่น security load-balancing secret audit
โดยธรรมชาติพวกนี้ต้องการ governance เพื่อ manage alignment ทั้งระบบพร้อมกับ flexiblility
สร้าง platform engineering team ทำหน้าที่ serve ทีมที่จะมาพัฒนาอีกทีนึง
provide heroku internal ในองค์กร launch ปุ๊บมี pipeline ต่อ database
developer focus กับการ deliver สามารถ customize ได้
PO ต้องเข้าใจว่า platform แต่ละทีมต้องการอะไร ค่อยๆ มา evolve
Starter kit คล้ายๆ กับ Spring Initializr เป็น seed project เป็น best practice
CICD pipeline quality control การ build ทำไง มี test กี่แบบ
ข้อเสียคือ abstraction มันไม่ได้ถูกซ่อนไว้ คนที่แก้ต้องเข้าใจว่าต้องทำไง
ถ้าเค้าตั้งใจเข้าใจ ต้องอ่านว่า code มันทำยังไงบ้าง
องค์กรที่ mature กว่านี้เค้าล่วงไปไกลละ
หลายๆ อย่าง move ออกไปเป็น api service หรือ abstraction บ้าง ตัด complexity ไป แต่ customize ได้น้อยลง
platform ต้องมีช่องทางในการ optimize สามารถมี plugin ให้ fit กับงานของเค้า
ถ้าจะให้ทุกทีม maintain k8s cluster ต้องลงอะไรมากมาย ดูแล security เยอะ
การใช้ IaC ทำให้ security และ quality เป็นไปตามที่บริษัทต้องการ
platform engineering รวมกันของคนจากหลายๆ domain
platform engineering ช่วยเรื่อง switch technology stack
ทำไงให้ cross functional requirement มันเข้าไปอยู่ใน architecture
การใช้งาน istio ช่วยเรื่อง dev ไม่ต้องมาปวดหัวเกี่ยวกับ cross functional requirement


Q: หมายความว่าถ้าอยากสร้าง web app เราสามารถใช้ starter kit ในการสร้าง application ได้เลยใช่รึป่าว มันจะเชื่อมต่อ data base หรือ connection ต่างๆให้เราเรียบร้อยแล้ว โดยที่เราแค่เข้าไปสร้าง front end บนนั้นได้เลย?
A: ใช่ แต่เรา provide ecosystem ให้ด้วย เช่น BFF

Q: platform  ที่ทีมนำมาใช้ ถ้าเป็น ของสำเร็จรูป แค่เอามา implement ต้องคำนึงถึงอะไรบ้างครับ
A: เป็นกึ่งสำเร็จรูป ยังต้องเติมน้ำร้อนอยู่ ต้องเข้าใจว่ามันต้องทำอะไร

Q: กรณีที่มีการ update หรือ patch ตัว starter kit มีแนวทางในการ update project อื่นๆที่นำ starter kit ไปใช้แล้วอย่างไรครับ
A: ต้อง track ว่าใครยังไง patch เก่าบ้าง ต้องเปิด pull request ให้เค้าดูว่า ต้อง upgrade ละนะ

Q: สงสัยว่า ปกติมันมี opensource ที่เป็นคลังของ startkit ใดใดอยุ่แล้วมั้ย หรือว่าจริงๆแล้วแต่ละบุคคล/องค์กร ต้องสร้างกันเอง
A: favor การใช้ opensource ไม่ได้ทำมาแข่ง starterkit เรามา build ontop อีกที สร้าง abstraction อีกที มันช่วยลดงาน ลด friction ลง เก็บ feedback

Q: การมี starter kit มีผลเสียอะไรบ้างไหมครับ
A: High Cognitive load และ development team takes responsibility และ อยากจะทำอะไรง่ายๆ ดันยาก

การ onboard การใช้งาน starter kit เรียนรู้ได้ง่าย ใช้ได้เร็ว
การรับ rotation หรือ intern เพื่อ share knowledge มาทำ synergy sprint แล้วมาเผยแผ่ต่อไป

Q: เรื่อง customize platform ของ starter kit ที่ generate ยากมั่ย? ถ้าไม่ค่อยมีความรู้เท่าไหร่ และมือใหม่จะรู้สึกว่า เป็น black box มั่ยเพราะมันสำเร็จรูปมาแล้ว พอเจอปัญหา อาจจะไม่รู้จะแก้ไขยังไง?
A: การเก็บ feedback เพื่อเช็ค friction

Q: เทคโนโลยีเปลี่ยนเร็วมากค่ะ เราจะรับมือกับมันยังไงถ้าในอีก7วันข้างหน้า แอพที่เราสร้างมามันล่าหลังมันช้า ไม่มีใครใช้บริการเรา แปลว่าเราต้อง digital trans  ไปตลอดชีวิตรึป่าวคะ? ความมั่นคงของเทคโนโลยีจริงๆ มันคืออะไร อยากทราบความเห็นหน่อยค่ะ
A: technology มัน pace ไป exponential ละ ทั้งตัวเราและบอถูก disrupt มากขนาดไหน ให้องค์กรลองทำ tech radar ของตัวเอง เพื่อที่จะเราจะได้ตาม tech ทัน
passionate developer ตื่นเต้นที่เราจะได้เรียนรู้ไปด้วยกัน ไม่ต้องกลัวว่าจะเปลี่ยนไม่ทัน
soft skill สำคัญของ developer คือการเรียนรู้ได้กว้างและลึกกว่าชาวบ้าน เป็นศิลปะ