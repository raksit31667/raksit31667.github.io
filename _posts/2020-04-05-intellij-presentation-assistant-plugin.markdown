---
layout: post
title:  "แสดง Shortcut แบบ real-time บน IntelliJ IDEA ด้วย Presentation Assistant Plugin"
date:   2020-04-05
tags: [intellij, ide, productivity]
---
ช่วงนี้หลายๆ บริษัท (รวมถึงผมด้วย) ต้อง work from home ดังนั้นหลายๆ กิจกรรมอย่างเช่น code review ก็เป็นแบบ virtual กันหมด  เมื่ออาทิตย์ที่แล้วมีรุ่นพี่เข้ามาใหม่ในทีม เขางงว่าเรากด shortcut อะไรยังไง ทำไมอยู่ screen ใน IDE เราเปลี่ยนไปไวขนาดนั้น ผมก็บอกว่าผมใช้ shortcut เพราะว่ามันสะดวกดี พอพี่เค้าถามว่ากดยังไง งงตัวเองที่ผมต้องใช้เวลาคิดแปปนึง เพราะว่าเหมือนกดจนชินไปละ ฮ่าๆๆๆ รุ่นพี่ก็เลยแนะนำ plugin ให้ลองใช้ดู

[Presentation Assistant](https://plugins.jetbrains.com/plugin/7345-presentation-assistant) จะแสดง shortcut ขึ้นบน IDE ทันทีที่เรากด ซึ่งจะช่วยให้
คนดูรู้ว่าเราใช้ shortcut อะไร แล้วเกิดอะไรขึ้นบ้าง มีประโยชน์สำหรับมือใหม่ที่ลองใช้ shortcut แทนการใช้ cursor  

![Presentation Assistant 1](/assets/2020-04-05-intellij-presentation-assistant-plugin-1.png)
  
![Presentation Assistant 2](/assets/2020-04-05-intellij-presentation-assistant-plugin-2.png)

>การฝึกใช้งาน IDE ให้ถนัดมือ ไม่ว่าจะเป็นในส่วนของ feature หรือ shortcut แจ่มๆ สามารถเพิ่ม productivity ให้กับเราเยอะมากๆ 
เพราะจะทำให้เราใช้ keyboard มากขึ้น ประหยัดเวลาในการเคลื่อนไหวเมื่อเทียบกับ cursor นั่นเอง (ถ้าไม่พิมพ์ช้าจนเกินไปอ่ะนะ ฮ่าๆๆๆ)  

พูดถึงเรื่อง shortcut แถม resource แจ่มๆ ใน IntelliJ ที่ช่วยทำให้เรารู้จัก shortcut มากขึ้น
- [Key Promoter X](https://plugins.jetbrains.com/plugin/9792-key-promoter-x) notification แสดง shortcut ที่ควรจะใช้แทน cursor
- [Default Keymap](https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf) สามารถดู shortcut ทั้งหมดได้ หรือ
generate ของตัวเองได้โดยไปที่ **Help > Keymap Reference**
