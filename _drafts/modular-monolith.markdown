---
layout: post
title: "ว่าด้วยเรื่องของ Modular Monolith"
date: 2023-11-24
tags: [modular-monolith, self-contained-systems, architecture]
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/5OjqD-ow8GE?si=5HL_zs6zNlEvvllb" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

แนวคิดของ Modular Monolith มันเริ่มต้นมาจากคุณ [Simon Brown](https://simonbrown.je/) ซึ่งเป็นคนคิดค้น [C4 diagram](https://c4model.com/) ได้บอกว่า C4 มันคือ conceptual model ของระบบงานซึ่งมีประโยชน์มากในการอธิบายความซับซ้อน code ของระบบงานงานจริงใน level ต่าง ๆ ให้เข้าใจได้ง่ายขึ้่น แปลว่าในทางกลับกัน code structure ก็ควรที่จะสื่อเหมือนกับที่ architecture ต้องการจะสื่อ แต่ว่าโดยส่วนใหญ่แล้ว conceptual model กับ code ไม่ได้สอดคล้องกันหรือไปในทางเดียวกันซึ่งเราเลือกปรากฏการณ์นี้ว่า [model-code gap](https://www.georgefairbanks.com/software-architecture/model-code-gap/) ทำให้ model เหล่านี้ไร้ค่า เสียแรงเสียเวลาในการอธิบายความซับซ้อนของ code ให้เข้าใจได้ง่าย ๆ สู้ให้ทีมพัฒนาไปอ่าน code กันเองจะดีกว่าซึ่งถ้าเราบอกว่ามันไม่ควรเกิดเหตุการณ์แบบนี้ แล้วเราจะแก้ปัญหา model-code gap ได้อย่างไร  

## ประเด็นแรกคือการจัด code structure ให้เป็นกลุ่ม ๆ
หากเราลองเจาะลึกลงไปดูถึง code structure ที่มีใช้งานกันอยู่ก็จะได้รูปแบบประมาณนี้

- **Package by layer**: จัดเรียงตาม layered architecture เช่น controller-service-repository เป็นต้น จุดเด่นคือสามารถ reuse code ใน layer เดียวกันกับ feature อื่น ๆ ได้ สามารถทดสอบแยก layer กันได้ แต่ปัญหาคือในระบบงานที่ใหญ่จะเกิดความจำเป็นที่ต้องแก้ทุก layer อยู่บ่อยครั้ง เช่น มี API endpoint ใหม่ หรือเปลี่ยน data structure เป็นต้น ส่งผลให้ค่าใช้จ่ายในการเปลี่ยนแปลงนั้นมากตามไปด้วย  
- **Package by feature**: จัดเรียงตาม feature หรือ domain เช่น customer, order, pricing เป็นต้น จุดเด่นคือเวลา feature มีการเปลี่ยนแปลงก็จะไม่กระทบกับ feature อื่น ๆ สามารถทดสอบแยก feature กันได้ แต่ปัญหาคือในระบบงานที่ใหญ่จะเกิดความจำเป็นที่ต้องรวมข้อมูลจากหลาย feature หรือ domain เข้ามาด้วยกัน ทำให้ค่าใช้จ่ายในการคุม dependencies ระหว่าง feature นั้นมากตามไปด้วย
- **Ports and adapters**: แยก code ส่วนการเชื่อมระบบเข้ากับ third-party ออกจาก code ส่วน domain business logic ผลที่ตามมาคือจะทำให้ทีมพัฒนาสามารถค้นหาข้อผิดพลาดได้ง่ายขึ้น ส่งผลให้แก้ปัญหาได้รวดเร็วขึ้น แต่ปัญหาคือในการพัฒนาจริงเราก็อาจจะหลีกเลี่ยงไม่ได้ที่ต้องมีการผสมกันระหว่าง domain และ third-party ไปบ้างเพื่อลดความซับซ้อนของระบบงานลง เช่น Ruby on Rails, Django, Spring Boot framework เป็นต้น
- **Package by component**: แยก code ส่วน implementation details ของ feature หรือ domain ไว้ใช้ภายใน package แล้ว expose ออกมาให้ภายนอก package ใช้ผ่าน abstraction หรือ interface แทน (เรียกทั้งหมดว่า component) จุดเด่นคือสามารถ reuse component กับ component อื่น ๆ ได้ สามารถทดสอบแยก component กันได้ แต่ปัญหาคือในระบบงานที่ใหญ่จะเกิดความจำเป็นที่ต้องรวมข้อมูลจากหลาย component เข้ามาด้วยกัน ทำให้ค่าใช้จ่ายในการคุม dependencies ระหว่าง component นั้นมากตามไปด้วย

![Code Structure](/assets/2023-11-28-code-structure.png)

ไม่ว่าเราจะจัด structure เป็นรูปแบบไหนก็ตามมันก็มีโอกาสที่จะเละได้อยู่ดีเนื่องจากแต่ละคนก็มีการตีความ structure แต่ละแบบไม่เหมือนกัน ถ้าทุก class ใช้ assess modifier เป็น public หมดการจัด code structure ก็ไม่มีความหมายต่อไปเพราะว่าทุก class สามารถ access class อื่น ๆ ได้ทั้งหมดเลย ดังนั้นเกิดจึง architecture principle เพื่อสร้างกฎขึ้นมาไม่ให้การนำ structure ไปใช้มันออกทะเลมากจนเกินไป ซึ่งก็สามารถทำได้หลากหลายรูปแบบไม่ว่าจะเป็นการทำ code review หรือไปจนถึงกระทั่งการใช้เครื่องมือเพื่อใช้ในการทดสอบในรูปแบบของ fitness function แต่ก็ต้องแลกมาด้่วยค่าใช้จ่ายในการเตรียมที่สูงขึ้น 

เพื่อประหยัดค่าใช้จ่ายให้ได้มากที่สุดจุดเริ่มต้นที่ดีคือการใช้งาน encapsulation ในการควบคุม dependency ให้เกิดน้อยที่สุดเท่าที่จะทำได้ เพราะว่า compiler มันฟรี!

## ประเด็นในส่วนที่ 2 คือเรื่องของ architecture
การจะจัดกลุ่มผ่าน architecture นั้นก็มี trade-off เช่นเดียวกัน แต่ไม่ว่าจะเลือกท่าไหน (Monolith หรือ Microservices) architecture ที่ดีเนี่ยมันก็ควรจะส่งเสริมให้เราสามารถ deliver business value ได้เร็วอย่างต่อเนื่องโดยที่ไม่ได้เสียในด้านของ quality ไป แต่การที่เราจะเปลี่ยนจาก Monolith เป็น Microservices เพื่อประโยชน์ต่าง ๆ เช่น

- Deploy แยกกันได้
- Upgrade แยกกันได้
- Scalable แยกกันได้
- ใช้ technology stacks แยกกันตามความเหมาะสมได้

หากของเดิมมันยังไม่ได้จัดอยู่ในรูปแบบที่สามารถแยกออกจากกันได้เป็นชิ้น ๆ (module) เราจะเสียเวลาและแรงมากในการแยก ก็จะเกิดอาการ model-code gap ขึ้นซึ่งทำให้คนทำความเข้าใจระบใน architecture ที่ซับซ้อนของเราได้ยากมากขึ้นส่งผลต่อค่าใช้จ่ายในการดูแลรักษาโดยตรง และถ้าแยก module ผิดโดยที่แต่ละ module ยังมี dependencies พันกันอยู่เยอะ ค่าใช้จ่ายในการดูแลรักษาก็จะมากกว่าเดิมหลายเท่า เกิดเป็น anti-pattern อย่าง Distributed Monolith ขึ้นมานั่นเอง

![Monolith to Microservices](/assets/2023-11-28-monolith-to-microservices.jpeg)

## สรุปทั้ง 2 ประเด็นที่ว่ามา
การจะจัด architecture ให้อยู่ในรูปแบบ module ที่ดีนั้นมันต้องมีจุดเริ่มต้นมาจากการแบ่งจัด code strcuture ที่มีกรอบการทำงานของแต่ละ module ชัดเจน มีการแยก dependency ระหว่าง module อย่างชัดเจนก่อน ผลที่ตามมาคือ model และ code จะไปในทางเดียวกัน แก้ปัญหา model-code gap ได้    

แนวคิดของ Modular Monolith คือการจัดแยก code ข้างในให้เป็น module ย่อย ๆ แต่ละ module ยังคง communicate กันภายในด้วย abstraction หรือ interface อยู่ หลังจากนั้นเราค่อย focus ในการแยกแต่ละ module ออกไปเป็นหน่วยย่อย ๆ แล้ว communicate กันผ่าน network แทน ซึ่งเป็นการรวมข้อดีของ Monolith (จำนวน deployment น้อย) และ Microservices (แต่ละ module สามารถแยกกันทำงานได้)  

ในการปฏิบัติจริงวิธีการเปลี่ยน Monolith ปกติให้เป็น Modular Monolith มันจะต้องใช้อาศัยทักษะในการ refactoring ปัจจุบันรวมถึงการทำความเข้าใจ business ในเชิงกว้างและลึกโดยในท้องตลาดนั้นก็มีตัวอย่างแนวปฏิบัติในการพัฒนารวมไปถึง framework ที่ใช้ในการพัฒนาในบางภาษาด้วย เช่น

- [Self-contained System](https://scs-architecture.org/)
- [Spring Modulith](https://docs.spring.io/spring-modulith/reference/index.html)
- [Vanilla Modular Monolith in C# .NET core](https://github.com/kgrzybek/modular-monolith-with-ddd)
- [ABP](https://abp.io/)

> "Choose microservices for the benefits, not because your monolithic codebase is a mess." - Simon Brown

## References
- [Modular Monoliths • Simon Brown • GOTO 2018](https://files.gotocon.com/uploads/slides/conference_12/515/original/gotoberlin2018-modular-monoliths.pdf)
