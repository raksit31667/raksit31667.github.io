---
layout: post
title:  "9 แนวทางปฏิบัติที่ส่งเสริมต่อคุณภาพของการส่งมอบ software"
date:   2022-04-19
tags: [practice]
---

ในการพัฒนา software คุณภาพขององค์กรมีผลเกี่ยวข้องกับคุณภาพของการส่งมอบ software หนึ่งในเทคนิคที่เราสามารถนำมาวัดได้คือ 4 key metrics ได้แก่

- **Lead time for changes:** ทีมของเราใช้เวลาตั้งแต่เริ่มนำงานเข้ามาจนกระทั่งส่งมอบถึงลูกค้าเท่าไร
- **Deployment frequency:** ทีมของเรา deploy ระบบงานบ่อยแค่ไหน
- **Mean time to restore (MTTR):** เมื่อระบบงานเกิดปัญหา เช่น service outage ทีมของเราใช้เวลาเท่าไรถึงในการแก้ไขให้ระบบกลับมาทำงานได้เหมือนเดิม
- **Change fail percentage:** เมื่อนำระบบงานขึ้น production มีโอกาสที่ระบบจะไม่สามารถ deploy ได้หรือเกิด major issue ขึ้นกี่เปอร์เซ็นต์

สิ่งที่น่าสนใจมากกว่าผลที่ได้คือ เราจะปรับปรุงให้มันดีขึ้นได้อย่างไร ซึ่งคำว่า "ดี" นั้นหมายความว่า

- Deployment frequency มากขึ้น ⬆️
- Lead time for changes น้อยลง ⬇️
- MTTR น้อยลง ⬇️
- Change fail percentage น้อยลง ⬇️

ในบทความนี้เรามีแนวทางปฏิบัติที่ส่งเสริมต่อคุณภาพของการส่งมอบ software โดยแนวทางทั้งหมดจะยึดหลักการ 3 ข้อ

1. **Fast feedback:** เราจะต้องรู้ว่าสิ่งที่เราทำมันได้ feedback ไม่ว่าจะถูกผิด ได้เร็วขนาดไหน ซึ่งอาจจะมาจากชุดการทดสอบ หรือ การ release เสร็จเรียบร้อยดี หรือ ลูกค้าโอเคกับคุณค่าที่เราส่งมอบให้

2. **Repeatability:** แนวทางที่เราทำจะต้องสามารถทำซำ้ได้ ทำให้ความมั่นใจใน software ของเรามีมากขึ้น เนื่องจาก human error ลดลง นอกจากนั้นเวลาก็เหลือ เราสามารถไปทำอย่างอื่นที่มีคุณค่ามากกว่าได้อีก

3. **Simplicity:** Software ที่ได้ควรจะออกมาให้เน้นเรียบง่าย (ซึ่งต่างจาก "ง่าย") โดยไม่ต้องไปทำเผื่ออนาคตมาก แต่เราก็ต้องมั่นใจด้วยว่าถ้ามีการเปลี่ยนแปลง เราสามารถแก้ไขได้ง่ายอยู่

เรามาดูกันว่าแนวทางทั้งหมด 9 ข้อนั้นมีอะไรบ้าง  

## 1. Trunk-based development

เป็นแนวทางในการทำงานร่วมกันบน version control เดียวกัน โดยทีมพัฒนาจะต้อง

- Integrate code ของเราขึ้นไปบน version control ใน trunk (เช่น `main` หรือ `master` branch ใน Git) บ่อย ๆ หลาย ๆ ครั้งต่อวัน
- Code ที่อยู่ใน trunk จะต้องพร้อมนำขึ้น production อยู่ตลอด แล้วทีมจะต้องมีแนวทางในการรวม code เข้าด้วยกันโดยแน่ใจว่าบน trunk ไม่พัง (เช่น การแก้ Git conflict)
- ในกรณีที่มี code ส่วนอื่นที่ไม่ได้อยู่ใน trunk (เช่น `development` branch ใน Git) จะต้องมีอายุที่สั้น ไม่ควรอยู่เป็นวันหรือสัปดาห์

ประโยชน์ที่จะได้รับคือ

- Fast feedback เพราะเมื่อนำ code มารวมกันบ่อย ๆ ทีมจะมาแก้ไข conflict ของ code ที่ถูกแก้ไขในส่วนเดียวกัน ส่งผลให้เจอปัญหาได้เร็วขึ้น พร้อมนำขึ้น production ได้เร็วขึ้น
- เนื่องจาก code ส่วนอื่นที่ไม่ได้อยู่ใน trunk มีอายุที่สั้น ทำให้ code ที่แก้พร้อมนำขึ้น production น้อยลง ส่งผลให้ลดความเสี่ยงในการเจอปัญหา หรือถ้าเจอ ก็สามารถหาได้เร็วขึ้น

> Deployment frequency มากขึ้น ⬆️  
> MTTR น้อยลง ⬇️   

แนวทางที่ขัดกันกับ Trunk-based development

- มี Feature branch ที่จะนำมารวมตอนที่ feature เสร็จแล้ว
- นำ code ขึ้น trunk ทีเดียวตอนที่ feature เสร็จแล้ว
- นำ code ขึ้น trunk ที่ไม่พร้อมนำขึ้น production แล้วไปขวางการ ทดสอบ หรือ release ของทีม
- ห้ามใช้ Git branching เลยแม้แต่นิดเดียว

## 2. Test-driven development

TDD เป็นเทคนิคการพัฒนาที่มีการเขียนชุดการทดสอบ มาเป็นตัวนำในการพัฒนา software โดยมี 3 ขั้นตอน

1. เขียนชุดการทดสอบสำหรับ implementation code ส่วนที่ต้องการจะเพิ่มเข้าไป ซึ่งเพียงพอที่จะทำให้ผลการทดสอบไม่ผ่าน
2. เขียน implementation code เพียงพอที่จะทำให้ผลการทดสอบผ่าน
3. Refactor code โดยที่ผลการทดสอบยังคงผ่านอยู่

ประโยชน์ของ TDD คือ code ของเราจะเรียบง่าย (Simplicity) เพียงพอที่จะทำให้ผลการทดสอบผ่าน นอกจากนั้นเราจะได้ Fast feedback เพราะชุดการทดสอบจะถูก run ทุกครั้งที่ code มีการเปลี่ยนแปลงเพียงเล็กน้อยเท่านั้น แล้วถ้าชุดการทดสอบของเราเป็นอัตโนมัติ เราก็สามารถที่จะ run ซ้ำ ๆ ได้ (Repeatability)

> MTTR น้อยลง ⬇️   
> Change fail percentage น้อยลง ⬇️   

## 3. Pair development

เป็นแนวทางในการจับคู่กับคนในทีมในการทำงานในแต่ละชิ้น โดยที่

- งานที่จับคู่กันนอกจากเขียน code แล้ว ยังรวมถึงงานอื่น ๆ เช่น แก้ infrastructure หรือ งานดูแลรักษา (operational) ต่าง ๆ ด้วย
- แต่ละคู่จะใช้จอเดียวกัน (ถ้าทำ remote ก็ใช้ screen-sharing program) โดยที่งานส่วนใหญ่จะต้องถูกผ่านสายตาของทั้งคู่ด้วย
- สำหรับงานที่ทำเดี่ยว (solo) จะต้องถูก review ผ่านคู่ก่อนที่จะนำงานขึ้นไป
- ไม่ควรจะมีคนในทีมที่ solo นาน ๆ
- ควรจะสลับคู่กันภายในทีมอย่างสม่ำเสมอ

ประโยชน์ของ Pair development คือ Fast feedback เพราะอย่างน้อยก็มีอีกคนที่ให้ feedback กับงานได้ ลดการ rework ลง เพิ่มโอกาสที่ได้งานที่เรียบง่ายขึ้น (Simplicity) สุดท้ายคือได้ Repeatability เนื่องจากมีโอกาสที่คู่ของเราสามารถทำงานซ้ำได้หากเราไม่อยู่

> MTTR น้อยลง ⬇️   
> Change fail percentage น้อยลง ⬇️   

## 4. Build security in

เป็นแนวทางในการนำ security เข้ามาในการพัฒนา software ตั้งแต่เริ่มต้น เช่น

- มีการตรวจสอบหาช่องโหว่ทางด้าน security บ่อย ๆ ผ่าน code review หรือการ scan พวก dependency และ secret ซึ่งควรจะเป็นเครื่องมือแบบอัตโนมัติ
- มีการจัดเก็บ secret ในที่ปลอดภัย เช่น บริการ secret management ต่าง ๆ
- มีการทำ Threat modelling เมื่อมีการเปลี่ยนแปลง architecture หรือระหว่างการพัฒนา feature จากนั้นนำชิ้นงานที่จะปรับปรุงด้าน security เข้าไปจัดลำดับความสำคัญ (prioritisation) กับงานทั้งหมดต่อไป
- เหตุการณ์ที่ส่งผลต่อ security จะต้องถูกจัดการให้ไว มีระบบ monitoring และทำ patching ที่รองรับการ roll back/forward
- ข้อมูล sensitive จะต้องถูกจัดเก็บอย่างปลอดภัย เช่น มีการทำ encryption

ประโยชน์ของ Build security in คือ Fast feedback เพราะเราทำสิ่งที่กล่าวมาข้างต้นตั้งแต่เริ่มต้น การตัดสินใจทางด้าน technical เร็วขึ้น และถ้าชุดการทดสอบของเราเป็นอัตโนมัติ เราก็สามารถที่จะ run ซ้ำ ๆ ได้ (Repeatability)

> MTTR น้อยลง ⬇️   
> Change fail percentage น้อยลง ⬇️   

## 5. Fast automated build

เป็นระบบอัตโนมัติที่มีขั้นตอนการจัดเตรียม code ให้กลายเป็น artifact (build) ให้พร้อมสำหรับนำขึ้น production โดยที่

- ระบบ build จะต้องบอกผลการ build ว่าผ่านหรือไม่ผ่าน ภายในเวลาที่สั้น
- มีระบบที่ build บนเครื่องของนักพัฒนาก่อน เพื่อเพิ่มความมั่นใจว่า เมื่อนำ code ขึ้นไประบบกลางแล้วผลการ build จะผ่าน
- มีการปรับปรุงระบบ build ให้ดีขึ้นอย่างสม่ำเสมอ ทั้งระยะเวลาที่ใช้ build และมีความเสถียร ไม่ใช่ว่า code ชุดเดียวกัน แต่ build ผ่านบ้างไม่ผ่านบ้าง

ประโยชน์ของ Fast automated build คือ Fast feedback เพราะการที่ระบบเป็นอัตโนมัติแล้วมันเร็ว ทำให้เรารู้ผลการ build ได้เร็วกว่า และเราก็สามารถที่จะ run ซ้ำ ๆ ได้ (Repeatability)

> Deployment frequency มากขึ้น ⬆️  
> Lead time for changes น้อยลง ⬇️   
> Change fail percentage น้อยลง ⬇️   

## 6. Automated deployment pipeline

เป็นระบบที่รวมการ build และ deploy เข้าไว้ด้วยกัน โดยที่

- ขั้นตอนทุกอย่างจะต้องอยู่ในรูปแบบของ script
- สามารถ run ขั้นตอนเป็นแบบ manual ได้ (เช่น one-click approval) แต่ต้องไม่เยอะและมี input มากจนเกินไป
- ขั้นตอนการ deploy นั้นรวม infrastructure ด้วย เช่น การ update resource หรือ run data/schema migration
- ในการ build เราจะนำ artifact version เดียวกันที่ได้ไป deploy ในหลาย ๆ environment คู่กันกับ configuration ของ environment นั้น ๆ
- มีขั้นตอนในการตรวจสอบ configuration ที่คลาดเคลื่อนจาก configuration จาก environment อื่น ๆ แบบอัตโนมัติ

ประโยชน์ของ Automated deployment pipeline คือ Fast feedback เพราะการที่ระบบเป็นอัตโนมัติแล้วมันเร็ว ทำให้เรารู้ผลการ deploy ได้เร็วกว่า สามารถทดสอบได้เร็วกว่า และเราก็สามารถที่จะ run ซ้ำ ๆ ได้ (Repeatability)

> Deployment frequency มากขึ้น ⬆️  
> Lead time for changes น้อยลง ⬇️   

## 7. Early and Continuous deployment

เป็นแนวทางการ deploy ที่สนับสนุนให้เกิดขึ้นตั้งแต่เนิ่น ๆ และบ่อย ๆ โดยที่

- การ deploy ขึ้น production ไม่ควรจะเกิดในช่วงท้ายของ project
- มีการ deploy เกิดขึ้นบ่อย ๆ ใน environment ใด ๆ ก็ตาม นั่นรวมถึง production ด้วย
- อย่างน้อยก็ต้องมีการ deploy ครั้งละห่างเกินไม่ควรเกิน 1 เดือน ในกรณีที่ไม่สามารถขึ้นบ่อย ๆ ได้ เนื่องจากเหตุผลสุดวิสัย เช่น 
  - มีขั้นตอน approval ภายในองค์กร
  - ไม่มีการแก้ไข code
  - ต้องรอ publication ในกรณีที่เป็น native หรือ mobile application

ประโยชน์ของ Early and Continuous deployment คือ Fast feedback เพราะเราจะรู้ว่าระบบพร้อมขึ้น production ได้เร็ว และลดความเสี่ยงในการ rework ลง ถ้าเป็นการ deploy แบบอัตโนมัติ เราก็สามารถที่จะ run ซ้ำ ๆ ได้ (Repeatability)

> Deployment frequency มากขึ้น ⬆️  
> Lead time for changes น้อยลง ⬇️   

## 8. Quality and Debt effectively managed

ทีมพัฒนามีขั้นตอนในการควบคุมคุณภาพของ software โดยที่

- คุณภาพของ code ต้องถูกวัดออกมาเป็นตัวเลขได้ เช่น code coverage หรือ cyclomatic complexity เพื่อให้ทีมใช้เป็นเครื่องมือในการ review และปรับปรุง code ให้ดีขึ้น
- Refactoring ควรจะถูกรวมไปใน definition of done ของแต่ละชิ้นงาน
- ในกรณีที่มี tech debt ที่ต้องใช้เวลาในการแก้สูง ให้นำไป prioritise กับงานอื่น ๆ ด้วย
- ทุกคนที่เกี่ยวข้องตระหนักถึงประโยชน์ของ tech debt ที่ถูกแก้ เช่น productivity และ การลดความเสี่ยงที่จะเกิดข้อผิดพลาด

ประโยชน์ คือ Simplicity จากการแก้ไข tech debt เพื่อส่งมอบคุณค่าอย่างต่อเนื่อง

> MTTR น้อยลง ⬇️   
> Change fail percentage น้อยลง ⬇️   

## 9. Build for production

Definition of done ของ feature ควรจะสิ่งเหล่านี้เป็นอย่างน้อย

- Application มีการ observe (monitoring, tracing, logging) และ support บน production
- มีระบบ alert เมื่อเกิดปัญหา
- ทีมพัฒนามี access เข้า production และ how-to guide ในการแก้ปัญหา ในกรณีที่ระบบมีปัญหาหนัก เช่น ระบบล่ม

ประโยชน์ของ Build for production คึอ Fast feedback เนื่องจากเราสามารถรู้ต้นเหตุของปัญหาที่เกิดขึ้นจาก observability ที่เรามี

> Deployment frequency มากขึ้น ⬆️  
> Lead time for changes น้อยลง ⬇️   

น่าจะเห็นภาพกันมากขึ้นว่า เราจะมีแนวทางในการปรับปรุงแนวทางการทำงานของเราให้มันดีขึ้นได้อย่างไร