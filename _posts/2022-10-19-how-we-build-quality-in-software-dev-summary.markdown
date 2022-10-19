---
layout: post
title:  "สรุปสิ่งที่น่าสนใจจาก session หัวข้อ How do we build quality in the software development process?"
date:   2022-10-19
tags: [practice]
---

วันนี้มีโอกาสได้ไปฟัง session หัวข้อ **How do we build quality in the software development process?** ที่บริษัท Thoughtworks พบว่าคนที่เข้ามาฟังส่วนใหญ่สวม role เป็น Developer กับ Quality analyst (QA) จึงนำมาสรุปไว้สักหน่อย

## Quality คืออะไร
ผู้พูดเริ่มจากการตั้งคำถามก่อนว่า Software Quality มันคืออะไรกันแน่ เพราะมันสามารถตอบได้จากหลากหลายมุมมอง

- ในมุมมองของ User ซึ่งไม่ได้มี background ของระบบเรา สนใจแค่ว่ามันทำงานได้ตามที่คาดหวังไว้ก็พอ
- ในมุมมองของ Business ก็จะนึกถึงระยะเวลาที่ชิ้นงานใช้ในการส่งมอบ (time to market) และ งบที่ใช้ในการทำชิ้นงานให้เสร็จ (budget)
- ในมุมมองของ Developer ก็จะนึกถึงคุณภาพของ code และแง่มุมและ technical ด้านอื่น ๆ

พอเรากลับมาดูที่ daily work แน่นอนว่าบางครั้งเราก็จะเจอกับปัญหา บางอันก็กระทบกับ quality แบบเต็ม ๆ จนมันกลายเป็น bug ขึ้นมา ซึ่งผลกระทบของ bug ก็อย่างเช่น

- ในมุมมองของ User ระบบไม่สามารถใช้งานได้ตามที่คาดหวังไว้
- ในมุมมองของ Business กระทบกับ time to market
- ในมุมมองของ Developer หากแก้ไขไม่ทัน ก็ต้องหาวิธีแก้ปัญหาไปก่อนโดยไม่ได้คิดถึงผลในระยะยาวมากมาย (workaround) จนกลายเป็นหนี้ (technical debt)

หากเรามาดูที่ Software development lifecycle อย่างคร่าว ๆ ก็จะมี 

1. วิเคราะห์ requirement ที่ได้รับ (Analyse)
2. ออกแบบ solution เพื่อตอบโจทย์ requirement (Design)
3. ลงมือทำ (Implement)
4. ทดสอบ (Test)
5. นำชิ้นงานขึ้นระบบใช้จริง (Deploy)

กราฟจากหนังสือ [Applied Software Measurement: Global Analysis of Productivity and Quality ของ Capers Jones](https://www.amazon.com/Applied-Software-Measurement-Analysis-Productivity/dp/0071502440) พบว่า มี bug 85% ถูกสร้างจากตอน Implement แต่แทบจะไม่เจอตอน Implement แต่ไปเจออีกทีก็ตอน Test เลย นอกจากนั้นก่อน Deploy ก็มีโอกาสที่จะเจอ bug เยอะขึ้น  

![Capers Jones defect graph](/assets/2022-10-19-capers-jones-defect-graph.png)

## แล้วเราจะป้องกัน bug ไม่ให้เกิดได้อย่างไร

### Shift left testing - Analyse
ย้ายการทดสอบมาไว้ข้างหน้าในั้นตอนการ analyse เพื่อมั่นใจว่าจะป้องกันไม่ให้ bug เกิดได้ตั้งแต่แรก โดย technique ที่ผู้พูดนำเสนอคือ [Acceptance test driven development (ATDD)](https://en.wikipedia.org/wiki/Acceptance_test-driven_development) โดยมีแนวคิดที่ทุกคนมาร่วมกันเขียน test เพื่อมา drive implementation ตามมุมมองของ user ในรูปแบบต่าง ๆ เช่น spreadsheet, [Given-When-Then](https://martinfowler.com/bliki/GivenWhenThen.html) จากนั้นมา review ชิ้นงานที่จะทำกับ acceptance test อีกที

![ATDD cycle](/assets/2022-10-19-atdd-cycle.png)

ประโยชน์ของ ATDD คือเกิดการพูดคุยเพื่อสร้างความเข้าใจตรงกันในทีม และ user

**ข้อควรระวังในการใช้ ATDD**  
- แล้วทีมใหญ่ทำไง -> ชวนคนบาง role เช่น Business Analyst (BA) มาช่วยกันเขียน
- หลีกเลี่ยง technical language เพราะในทีมอาจจะมี business people ด้วย
- ระวังค่าใช้จ่ายในการทำ automation สำหรับ acceptance test ว่ามันคุ้มไหม ซึ่งถ้าไม่คุ้มเราอาจจะดูว่ามันสามารถทดสอบ ในระดับ ที่ต่ำลงมากกว่านี้ได้ไหม

![Test pyramid](/assets/2021-09-06-test-pyramid.png)

> สิ่งที่ได้จาก ATDD คือ ผลลัพธ์ที่ได้คือชิ้นงานเราพร้อมสำหรับ development

> คำถามคือแล้วมันพร้อมจริง ๆ หรือเปล่า ยกตัวอย่างเช่น planning มีชิ้นงานเยอะ ลืม context ไปแล้ว คุยกับ PO ว่าเข้าใจถูกไหม แล้วก็มา update test case ต่อมาคุยกับ DEV แล้วเข้าใจอีกแบบนึง

### Kickoff - Ready to Implement
จัด meeting เพื่อ confirm ว่าชิ้นงานนั้นมันพร้อมจริง ๆ ด้วยการพูดคุยกับคนที่เกี่ยวข้องกับชิ้นงานนั้น เช่น Product Owner (PO) หรือ Business Analyst (BA) หรือ Experience Designer (XD) มา review กันว่ามันมีข้อมูลครบถ้วน update แล้ว เข้าใจตรงกันไหม มีอะไรติดขัดหรือต้องทำอะไรก่อนหน้าไหม (blocker & dependencies)  

ประโยชน์ของ Kickoff คือสร้างความเข้าใจตรงกันภายในทีม และลดการพูดคุยไป ๆ มา ๆ หลาย ๆ รอบ (private conversation)

### Pair programming - Implement
เนื่องจากว่าเวลาทำชิ้นงานคนเดียวมันมีโอกาสที่จะเกิด bias อาจจะไม่ได้ระวัง bug ที่อาจจะเกิดขึ้น จึงมีแนวคิดของ [pair programming](https://developerexperience.io/practices/pair-programming) โดยจะมีอีกคนมาช่วยกัน ก็จะลดโอกาสในการเกิด bug ไป โดยมีรูปแบบต่าง ๆ เช่น driver-navigator  

นอกจากนี้ยังมี technique อย่าง [cross-role pairing](https://www.thoughtworks.com/en-th/insights/blog/developers-and-designers-can-pair-too) มีข้อแตกต่างจาก pair programming คือ แทนที่จะเป็น Developer คู่กับ Developer ก็ให้คนมาจากต่าง role มา pair กันทำงานชิ้นนึงแทน  

ประโยชน์ของ cross-role pairing คือ เกิดการแบ่งปันมุมองที่ต่างกันจาก role ที่ต่างกัน ทำให้เกิดความเข้าใจคนอีก role เช่น Devloper คู่กับ QA จากการที่ design-test ด้วยกัน ก็มีโอกาสที่จะลดชุดการทดสอบที่อาจจะซ้ำ ๆ กัน นอกจากนี้ยังช่วยให้การทดสอบครอบคลุมขึ้นเพราะลดการคิดไปเองว่าคนอีก role ทดสอบไปแล้ว สุดท้ายทั้งคู่ก็จะเห็นมุมมองว่าตอนเขียนชุดการทดสอบ แต่ละคน focus ที่อะไร

> ปัญหาเกิดขึ้นเมื่อ Developer บอกว่าเสร็จแล้วแต่จริง ๆ ยังไม่เสร็จ QA ทำให้ตอนทดสอบ QA ก็ไม่แน่ใจว่ามันเป็น bug ไหม (หรือว่าเป็น feature กันแน่) design ตรงตามหรือเปล่า ทำให้เสียเวลาไปกับการพูดคุยข้ามไปข้ามมา

### Deskcheck - Ready to Test
คล้าย ๆ kickoff แต่ review กันว่าของชิ้นนั้นมันตรงตามที่คาดหวังกันไหม เช่น

- ชิ้นงานที่ออกมามันทำงานได้ตาม acceptance test ไหม
- ชิ้นงานที่ออกมาตรงกับ design ที่วางไว้ไหม
- มีชิ้นงานไหนที่ต้อง share กันคนอื่นหรือเปล่า
- ถ้าเจอปัญหาเล็ก ๆ ที่ไม่ได้มีผลกระทบหลักกับ user หรือ ไม่ได้อยู่ใน scope ของชิ้นงานสักเท่าไร เราจะย้ายไปปรับปรุงทีหลังดีไหม

ประโยชน์ของ Deskcheck ก็จะคล้าย ๆ กับ Kickoff เป็นเพียงแค่คนละด้านซึ่งกันและกัน (ก่อน-หลัง Implement)

### Bug bash - Test
สืบเนื่องจากแต่ละคนมี bias เลยมองข้ามมุมมองบางอย่างไป มีความเข้าใจเกี่ยวกับ product ของตนเองมากขึ้น จึงมีแนวทางปฏิบัติอย่าง Bug bash โดยมีขั้นตอนคือ

1. หากลุ่มทดสอบคละ role
2. เตรียมข้อมูลที่จะใช้ทดสอบ
3. ช่วยกันค้นหา bug ด้วยวิธีการไหนก็ได้
4. Review และนำสิ่งที่ต้องแก้ไขตามผลลัพธ์มาจัดความสำคัญเข้างานต่อไป (prioritization)

## แล้วเราจะรู้ได้อย่างไรว่าหากทำตามที่ว่ามาแล้วมันดีขึ้นจริง ๆ
- พฤติกรรมของทีมที่เปลี่ยนไปในทางที่ดีขึ้น เช่น มีความมั่นใจมากขึ้น ทีมเห็นภาพตรงกันมากขึ้น มีการพูดคุยช่วยเหลือกันมากขึ้น ได้รับ feedback จากการเปลี่ยนแปลงเร็วขึ้น
- คุณภาพของ product เปลี่ยนไปในทางที่ดีขึ้น เช่น ระบบตรงกับความต้องการของ user มากขึ้น เจอเหตุการณ์ไม่คาดฝันน้อยลง

## ปิดท้ายด้วยสรุปจากผู้พูด
- ก่อนอื่นคือทีมพัฒนาจะต้องเห็นภาพกันก่อนว่า "Quality" มันมีอะไรบ้าง
- Quality ที่ดีขึ้นมันไม่ได้เกิดในตอน Test อย่างเดียว แต่มันเกิดจากทุกขั้นตอนใน Software development lifecycle
- Quality ไม่ใช่ความรับผิดชอบของใครคนใดคนนึง แต่เป็นความรับผิดชอบขอบทีม
- การทดสอบไม่ใช่การค้นหาและแก้ไข bug แต่เป็นการป้องกันไม่ให้ bug เกิดขึ้นตั้งแต่แรกต่างหาก
- การสื่อสาร (communication) และการทำงานร่วมกัน (collaboration) เป็นหัวใจหลักในการสร้าง Quality ที่ดี
