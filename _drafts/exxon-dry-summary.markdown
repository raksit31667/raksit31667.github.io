---
layout: post
title:  "สิ่งที่น่าสนใจจากงาน Don’t Repeat Yourself: Accelerate the initial phase of software development with common framework and enablement tools"
date:   2020-07-07
tags: [conference]
---

![Exxon DRY](/assets/2020-07-07-exxon-dry.jpg)
<https://www.facebook.com/thoughtworksthailand/>

เริ่มต้นจาก user มีการใช้งาน internet มากขึ้นในทุกๆ industry รวมถึงธุรกิจ oil & gas และ technology เข้ามามีบทบาทในการแข่งขันในตลาด (มีการยกตัวอย่าง disruption ระหว่าง Blockbuster และ Netflix) ดังนั้น ExxonMobil จะทำยังไงให้ product ไปอยู่บน online channel เพื่อเพิ่ม experience และรักษาลูกค้าไว้ เรื่องของ **Digital transformation** หรือการนำ technology ที่มีอยู่มาใช้ จึงเข้ามาเพื่อแก้ปัญหาในองค์กร  

ด้วยความที่ ExxonMobil เป็นบริษัทสเกลใหญ่ การเปลี่ยนแปลงจึงไม่ได้อยู่ที่ product อย่างเดียว แต่รวมถึงองค์กรด้วย จึงเกิดคำถามและ concern ขึ้นมา เช่น

- จะรวม business logic ที่เป็นแบบ global เข้าด้วยกันได้อย่างไร
- การที่จะออก product ใหม่แล้วปังเลยมันยาก ทำไงเราจะ innovate ได้เร็วและเจ็บน้อยสุด ลด friction ลง
- ฝั่ง business อยากปรับตัวให้ customer centric มากขึ้น ดังนั้นต้องมี data ของลูกค้าหรือเปล่า
- บริษัท innovate ช้า เพราะระบบผูกติดกับ core ERP system ไม่เหมือน startup ที่มี flexibility มากกว่า
- อยากเอา advanced IT system แต่ไม่มีประสบการณ์ในการทำ ละก็ไม่ค่อยมี resource ซะด้วย
- เอา Product owner มา รู้ไม่หมด กว่าจะได้ requirement มาก็ยากละ

จากเรื่องดัวกล่าว ทำให้การพูดคุยย้อนกลับไปทำแรกๆ มี 6 product หนึ่งในนั้นคือ application ซึ่ง track ว่ารถส่งของอยู่ไหนแล้ว ทำให้ customer service ทำงานง่ายขึ้น แต่งาน development กระจายไปทำกันคนละประเทศ ทำให้เกิดปัญหามากเพราะแก้ปัญหาซ้ำไปซ้ำมา ติดปัญหาคล้ายๆ กัน เสียเวลาลงทุน tech foundation ซึ่งการมาของ microservices ทำให้เร่งให้เกิดปัญหาข้างต้น เพราะเป็น distributed architecture ซึ่งได้มอบ scalability resiliency ทุกคนไม่จำเป็นต้องรู้ว่าทั้งระบบทำงานอย่างไร  

พอมีหลายทีม มันจะมีงาน infrastructure ที่ทุกทีมใช้้เหมือนกันหมด เช่น security load-balancing secret audit โดยธรรมชาติพวกนี้ต้องการ governance เพื่อ manage alignment ทั้งระบบพร้อมกับ flexiblility จึงเกิดความคิดที่จะสร้าง platform engineering team เกิดจากการรวมกันของคนจากหลายๆ domain ที่ทำหน้าที่ serve ทีมที่จะมาพัฒนาอีกทีนึง มีข้อดีคือ
- developer focus มากขึ้นกับการ deliver value ให้กับ business
- สามารถ customize ให้ตรงกับความต้องการได้
- มีบทบาทในการช่วย switch technology stack
- ทำให้ cross-functional requirement มันเข้าไปอยู่ใน architecture

Product แรกที่ออกมาคือ **Starter kit** มีแนวคิดคล้ายๆ กับ Spring Initializr ประกอบไปด้วย seed project รวม best practices ในการทำ security logging exception-handling รวมถึง CICD pipeline ที่มี quality control ในการ build และ test strategy (unit testing, integration testing, end-to-end testing)  

ใน session มีการพูดถึง platform ที่ดีต้องมีช่องทางในการ optimize สามารถมี plugin ให้ fit กับงานของเค้า ถ้าจะให้ทุกทีม maintain k8s cluster ต้องลงอะไรมากมาย ดูแล security เยอะ
การใช้ IaC ทำให้ security และ quality เป็นไปตามที่บริษัทต้องการ รวมถึงการใช้งาน istio ช่วยทำให้ developer ไม่ต้องมาปวดหัวเกี่ยวกับ cross-functional requirement  

ปิดท้ายด้วยคำถาม-ตอบ ที่น่าสนใจ หยิบมาให้ดูกันนิดหน่อย  

**Q:** หมายความว่าถ้าอยากสร้าง web app เราสามารถใช้ starter kit ในการสร้าง application ได้เลยใช่รึป่าว มันจะเชื่อมต่อ database หรือ external connection ต่างๆให้เราเรียบร้อยแล้ว โดยที่เราแค่เข้าไปสร้าง frontend บนนั้นได้เลย?
**A:** ใช่ แต่เรา provide ecosystem เพิ่มให้ด้วย เช่น BFF  

**Q:** platform ที่ทีมนำมาใช้ ถ้าเป็น ของสำเร็จรูป แค่เอามา implement ต้องคำนึงถึงอะไรบ้างครับ
**A:** เป็นกึ่งสำเร็จรูป ยังต้องเติมน้ำร้อนอยู่ ต้องเข้าใจว่ามันต้องทำอะไร  

**Q:** กรณีที่มีการ update หรือ patch ตัว starter kit มีแนวทางในการ update project อื่นๆที่นำ starter kit ไปใช้แล้วอย่างไรครับ
**A:** ต้อง track ว่าใครยังไง patch เก่าบ้าง ต้องเปิด pull request ให้เค้าดูว่า ต้อง upgrade ละนะ  

**Q:** สงสัยว่า ปกติมันมี opensource ที่เป็นคลังของ starter kit ใดใดอยุ่แล้วมั้ย หรือว่าจริงๆแล้วแต่ละบุคคล/องค์กร ต้องสร้างกันเอง
**A:** ในทีมก็ใช้ opensource ไม่ได้กะทำมาแข่งอยู่แล้ว เราแค่มา build on top อีกที โดยการสร้าง abstraction มันช่วยลดงาน ลด friction ลง และอย่าลืมที่จะต้องเก็บ feedback เพื่อให้แน่ใจว่าเราช่วยเค้าจริงๆ  

**Q:** การมี starter kit มีผลเสียอะไรบ้างไหมครับ
**A:** มี 2 ข้อหลักๆ 
- High Cognitive load เนื่องจาก abstraction มันไม่ได้ถูกซ่อนไว้ คนที่แก้ต้องเข้าใจว่าต้องทำไง ถ้าเค้าอยากจะเข้าใจ ก็ต้องไปอ่าน code ว่ามันทำยังไงบ้าง บริษัทที่มี technical maturity สูงกว่าจึง move ออกไปเป็น api service หรือ abstraction บ้าง ตัด complexity ไป แต่ก็แลกกับ customize ได้น้อยลง (มีการยกตัวอย่างการใช้งาน Internal Heroku)  

- มีโอกาสที่ development team ต้องเจอกับ complexity ที่สูงๆ ใน use case ง่ายๆ

ผู้พูดได้ยกตัวอย่างวิธีการแก้ไข เช่น การ onboard การใช้งาน starter kit หรืออาจจะเป็นการทำ rotation เพื่อ share knowledge ผ่านการทำงานด้วยกันประมาณ 2-4 อาทิตย์ (synergy sprint)  

**Q:** เรื่อง customize platform ของ starter kit ที่ generate ยากมั่ย? ถ้าไม่ค่อยมีความรู้เท่าไหร่ และมือใหม่จะรู้สึกว่า เป็น black box มั่ยเพราะมันสำเร็จรูปมาแล้ว พอเจอปัญหา อาจจะไม่รู้จะแก้ไขยังไง?
**A:** สอดคล้องกับเรื่องของ High cognitive load ที่ได้ตอบไปจากคำถามที่แล้ว การเก็บ feedback เพื่อเช็ค friction ก็เป็นการเข้าใจแก้ปัญหาเพื่อจะได้แก้อย่างถูกจุด  

**Q:** เทคโนโลยีเปลี่ยนเร็วมากค่ะ เราจะรับมือกับมันยังไงถ้าในอีก7วันข้างหน้า แอพที่เราสร้างมามันล่าหลังมันช้า ไม่มีใครใช้บริการเรา แปลว่าเราต้อง digital trans  ไปตลอดชีวิตรึป่าวคะ? ความมั่นคงของเทคโนโลยีจริงๆ มันคืออะไร อยากทราบความเห็นหน่อยค่ะ
**A:** technology มัน pace ไป exponential ละ ทั้งตัวเราและบอถูก disrupt มากขนาดไหน ผู้พูดได้แนะนำให้องค์กรลองทำ tech radar ของตัวเอง เพื่อที่จะเราจะได้ตาม tech ทัน  

ปิดท้ายด้วยคำแนะนำจากผู้พูดที่ฝากถึง developer ใหม่
> soft skill สำคัญของ developer คือการเรียนรู้ได้กว้างและลึกกว่าชาวบ้าน