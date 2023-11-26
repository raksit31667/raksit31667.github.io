---
layout: post
title: "การวิเคราะห์ code และทีมพัฒนา จาก Git Log"
date: 2023-11-21
tags: [social-code-anaylsis, codescene, git, technique]
---

เริ่มจากว่าเมื่ออาทิตย์ที่แล้วระหว่างเตรียมตัวเข้าไปทำ project ใหม่เกี่ยวกับ legacy modernization  แล้วได้เข้าไปสัมภาษณ์ developer 2-3 คนเพื่อเข้าใจปัญหามากขึ้น ซึ่งเราพบว่าปัญหาคือเวลาที่จะแก้ code ชุดเดียวกันแล้วแต่ละทีมเข้ามาแก้ไขโค้ชชุดเดียวกันทำให้เกิดการเหยียบเท้ากันบ่อยส่งผลให้เกิดการ rework มี conflict แล้วต้องทำแก้ไปแก้มาจน business รู้สึกว่าเราส่งมอบแต่ช้าลงนะ  
เนื่องจากว่าเราอยากเข้าไปสร้าง impact ให้ได้เร็วที่สุดในช่วงเวลาที่จำกัดฉะนั้นมันก็ต้องมีการเตรียมท่าที่เข้าไปทำความเข้าใจระบบปัจจุบันให้ได้เร็วที่สุดเราก็ไปพบกับเทคนิคที่ชื่อว่า [Social Code analysis](https://www.thoughtworks.com/en-th/radar/techniques/social-code-analysis)

<iframe width="560" height="315" src="https://www.youtube.com/embed/SdUewLCHWvU?si=txW9LEvyqyMxl6iG" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## ปัญหาของ code analysis ในปัจจุบัน
แนวคิด Social code analysis ถูกนำเสนอโดยคุณ [Adam Tornhill](https://www.adamtornhill.com/) ซึ่งเขาเป็นคนที่พูดถึงแนวคิดของ technical debt มาสักพักใหญ่ในช่วงหลาย ๆ ปีที่ผ่านมา  

ในการพัฒนา software ในปัจจุบัน เป็นปกติที่ทีมพัฒนาจะต้องเข้าใจและประเมินด้าน technical debt ในระบบงานของเราอยู่เป็นระยะ ๆ เพื่อให้แน่ใจว่า technical debt นั้นจะมีผลกระทบกับการส่งมอบน้อยที่สุดทั้งด้าน quality และ speed ซึ่งมันก็จะมีเครื่องมือมากมายที่เราสามารถใช้งานได้ยกตัวอย่างเช่น static code analysis ต่าง ๆ ที่ทำให้เราเห็น code smell หรือในบางครั้ง ทำให้เราเห็นปัญหาด้าน security หรือ code statement ที่ไม่ได้ถูกทดสอบโดยชุดการทดสอบอัตโนมัติในระดับ project อันใดอันหนึ่ง  

แต่เมื่อเราพูดถึง technical debt ในระดับที่ scale สูงขึ้น ที่มีทีมพัฒนามากกว่า 1 ทีม มันก็ไม่ได้เจาะจงอยู่ที่เรื่องของ code อย่างเดียวละมันก็จะมีในเรื่องของ design debt, architecture debt พ่วงมาด้วยเพราะว่าถ้าออกแบบไม่ดีก็จะมีผลให้ทีมหลาย ๆ ทีมที่เข้ามาทำงานในระบบเดียวกัน (เหยียบเท้า) ส่งผลให้ context ที่ต่างกันของแต่ละคนปนกันมั่วไปหมด รวมถึงการแก้ conflict และค่าใช้จ่ายในการทดสอบก็สูงขึ้นเพราะไม่รู้ว่าระบบส่วนของตนนั้นจะมีผลกระทบจากการเปลี่ยนแปลงของทีมอื่นไหม 
หรือว่าหากแก้ไฟล์แล้วก็ต้องแก้อีกไฟล์หนึ่งด้วย ทั้งที่จริงๆแล้วมันไม่ได้เกี่ยวข้องกันเลยในเชิง business ก็ตาม แสดงให้ถึงถึงว่ามันเกิดการ tight coupling ขึ้น เวลาเราจะแกะส่วนงานนั้นออกมามันก็จะยากมาก ๆ การ debug และการทดสอบก็เลยเยอะตามไปด้วย  

เครื่องมือที่มีกันอยู่ในปัจจุบันมันส่วนใหญ่ก็ไม่สามารถวัดได้ถึงระดับนั้นหรือถ้าวัดได้เราก็ต้องออกแรงวิเคราะห์เชื่อมโยงค่อนข้างเยอะเพราะว่า code ที่วัดนั้นมักก็จะเป็น code ชุดปัจจุบันทำให้เราไม่ได้เห็นวิวัฒนาการของการออกแบบระบบที่ผ่าน ๆ มาว่าจุดเริ่มต้นของการผูกติดกันระหว่าง code ของทีมและระบบมันอยู่ตรงไหนกันแน่ ทำให้เราเสียมุมมองด้านความสัมพันธ์ระหว่าง architecute และการสื่อสารของทีมตามกฎ [Conway's law](https://en.wikipedia.org/wiki/Conway%27s_law) เช่นกัน  

> Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure." — Melvin E. Conway

## Introducing Social code analysis

เนื่องจากปัญหาข้างต้นทำให้มีการค้นหาท่าที่สามารถวัด วัดความสัมพันธ์ของทีมกับระบบงานปัจจุบันแล้วเราก็พบว่าหนึ่งในซอสที่เราสามารถเข้าไปเก็บข้อมูลเพิ่มได้ก็คือ [Git log](https://git-scm.com/docs/git-log)

```log
[a723ddf] raksit31667 2023-11-24 :building_construction: use Spring Framework application events for inter-module communication
2       0       build.gradle
26      1       src/main/java/com/example/raksit/modulith/notification/NotificationService.java
3       0       src/main/java/com/example/raksit/modulith/notification/internal/Notification.java
8       5       src/main/java/com/example/raksit/modulith/product/ProductService.java
22      0       src/test/java/com/example/raksit/modulith/product/ProductModuleTests.java

[6a72f83] raksit31667 2023-11-23 :memo: document the relationships between the modules of a project
7       0       src/test/java/com/example/raksit/modulith/LearnSpringModulithApplicationTests.java

[c44f83e] raksit31667 2023-11-23 :art: provide Notification module encapsulation using sub-packages of the application module base package and use the NotificationDTO instance instead of the Notification in the product module.
39      0       src/main/java/com/example/raksit/modulith/notification/NotificationDTO.java
1       1       src/main/java/com/example/raksit/modulith/notification/NotificationService.java
3       3       src/main/java/com/example/raksit/modulith/product/ProductService.java
5       3       src/test/java/com/example/raksit/modulith/LearnSpringModulithApplicationTests.java
```

จากตัวอย่าง Git log ข้างต้นเราก็จะเห็นข้อมูลต่าง ๆ เช่น
- ใครที่เป็นคน commit
- มีการ commit เมื่อไหร่
- มี file ไหนถูกแก้ถูกลบหรือเปลี่ยนไปบ้าง

ซึ่งหากเรานำข้อมูลเหล่านี้ออกมาร้อยเรียงกันเป็น timeline เราก็จะสามารถวิเคราะห์ถึงวิวัฒนาการของการออกแบบและ และการทำงานร่วมกันของหลาย ๆ ทีมในระบบชุดเดียวกันได้ง่ายขึ้น เช่น
- **Hotspot**: ยิ่ง code มีหลายบรรทัดและมีการแก้ไขบ่อยมากเท่าไร มีโอกาสที่จะเกิดการเหยียบเท้ามากขึ้นเท่านั้น
- **Logical coupling**: หากมีการแก้ไข file/module นึงแล้วยิ่งมีโอกาสที่จำเป็นต้องแก้ file/module อีกอันนึงด้วยมากเท่าไร ก็หมายความว่า 2 อันนี้มันผูกติดกันมากเท่านั้น
- **Age**: หาก code ส่วนนีงยิ่งไม่ได้ถูกแก้ไขเป็นเวลานานมากเท่าไร ก็มีโอกาสที่จะต้องคง knowledge ของ code ส่วนนั้นไว้นานมากขึ้นเท่านั้น ซึ่งแสดงให้เห็นถึงหลุมดำที่ไม่มีใครกล้าไปแตะหรือไม่ก็ "อย่าไปแตะนะ ถ้าแตะแล้วพังคุณรับผิดชอบ!"
- **Code churn**: ใครจากทีมไหนมาแก้ code ส่วนไหนมากที่สุด ยิ่งถ้าเราเห็นคนจากหลาย ๆ ทีมมาแก้ไข code ชุดเดียวกัน (ยกเว้น shared infrastructure หรือ config file) แสดงว่ามันเกิดการเหยียบเท้าขึ้นแล้วหละ


![Funny code comment](/assets/2023-11-26-funny-code-comment.png)
<https://decodenatura.com/about-code-comments/>

ด้วยแนวคิดที่ว่านี้มันจึงเกิดเครื่องมือที่ใช้ในการวิเคราะห์เรื่องเหล่านี้ขึ้นโดยเฉพาะ เช่น [CodeScene](https://codescene.com/) ซึ่งถูกพัฒนาต่อยอดมาจาก open-source tool อย่าง [Code Maat](https://github.com/adamtornhill/code-maat) อีกที (ไม่แปลกใจเพราะคุณ Adam Tornhill เป็นคนก่อตั้งขึ้นเนี่ยแหละ ฮ่า ๆๆ) ซึ่งเราก็จะได้ visualisation สวย ๆ มาเป็นของแถมอีกด้วย น่าสนใจมาก ๆ

![CodeScene Hotspot](/assets/2023-11-26-codescene-hotspot.png)
![CodeScene Logical Coupling](/assets/2023-11-26-codescene-logical-coupling.png)
<https://github.com/adamtornhill/code-maat>

> โดยรวมแล้วแนวคิด Social code analysis เป็นเทคนิคที่เหมาะสำหรับการวิเคราะห์ระบบที่มีขนาดใหญ่และถูกพัฒนาโดยหลาย ๆ ทีม แน่นอนว่าการวิเคราะห์อย่างเดียวคงไม่พอ มันก็ต้องมีท่าในการแก้ไขปัญหาที่ถูกวิเคราะห์ออกมาให้ดีและยั่งยืนด้วย ซึ่งขออุบไว้อธิบายใน blog ถัด ๆ ไปครับ