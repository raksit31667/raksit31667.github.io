---
layout: post
title:  "แบ่งปันประสบการณ์การเข้า workshop เกี่ยวกับ Disabilities"
date:   2022-12-11
tags: [accessibility]
---

![Disabilities workshop](/assets/2022-12-11-disabilities-workshop.jpeg)

เมื่ออาทิตย์ก่อนได้มีโอกาสไปเข้า workshop เกี่ยวกับคนพิการ ซึ่งองค์กรที่มาพูดคือ [Vulcan Coalition](https://readthecloud.co/vulcan-coalition/) ซึ่งเป็นบริษัทที่ร่วมมือกับองค์กรที่ต้องการใช้ Artificial intelligence (AI) มาแก้ปัญหา business เพื่อหาคนพิการมาช่วยป้อนข้อมูลด้วยรูปแบบ data labeling เช่น ภาพและเสียง คนพิการทางสายตามีแนวโน้มที่สามารถฟังได้ดีกว่า คนพิการทางการได้ยินก็มีแนวโน้มที่สามารถมองเห็นได้ดีกว่า เพราะสมองต้องใช้ประสาทส่วนอื่นแทน นอกจากทำให้องค์กรได้ข้อมูลที่แม่นยำมากขึ้น มีแนวโน้มที่ตัดสินใจทางด้าน business ทีดีขึ้นแล้ว ยังช่วยให้คนพิการมีงานทำ ถ้าใช้ศักยภาพของเขาได้อย่างเหมาะสม ก็ไม่มีความต่างอะไรจากคนทั่วไป โดยระบบที่ Vulcan สร้างไว้คร่าว ๆ ก็มี

- ระบบ guideline ให้คนพิการฝึกฝนการป้อนข้อมูลเข้า model
- Log centralization เก็บ input จากคนพิการเพื่อป้อนข้อมูลเข้า model
- Social platform สำหรับ update ข่าวสาร
- Learning management system (LMS) ที่สร้างโดยคนพิการ สำหรับคนพิการ

## Blind developer
ใน session มีการบรรยายจาก speaker ที่เป็น Developer ที่พิการทางสายตา ผู้พูดเล่าให้ฟังว่าการที่จะเป็น Developer ก็เริ่มจากการใช้งาน computer ให้ได้ก่อน โดยเข้าไป screen reader ที่จะทำงานในรูปแบบ (HTML)text-to-speech ใน่สวนของการพิมพ์ก็ต้องฝึกการพิมพ์สัมผัสเอา

<iframe width="560" height="315" src="https://www.youtube.com/embed/dEbl5jvLKGQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

หลีกเลี่ยงไม่ได้สำหรับการเรียน programming ในฐานะ Developer ที่ฝึกฝนหรือตาม technology ให้ทัน แต่ผู้พูดเล่าว่าการหาเรียนจากแหล่งทั่วไป (web, book) บางครั้งก็เป็เรื่องท้าทายเนื่องจากบางที่แปะ code มาเป็นรูป (!!!) ทำให้เครื่องมือ screen reader อ่านไม่ออก จึงต้องหาแหล่งอื่นที่รองรับ screen reader ด้วย  

การใช้เครื่องมือพัฒนาก็เป็น text editor ทั่ว ๆ ไป แต่จะเพิ่มการเน้นใช้เครื่องมือ Command-line interface (CLI) ไว้ก่อน เนื่องจากเครื่องมือบางตัวรองรับ User Interface (UI) การใช้ screen reader บางครั้งก็ไม่เอื้อเท่ากับ CLI นอกจากนั้นก็จะเน้นใช้งาน hotkeys เพื่อจะได้ลดการกด UI ให้เหลือเท่าที่จำเป็นพอ

> จาก session นี้ทำได้เรียนรู้ว่าการที่เครื่องมือหลายตัวถึงมีการรองรับทั้ง UI และ CLI ด้วย มันไม่ได้ช่วยเอื้อแค่คนชอบ/ไม่ชอบ CLI อย่างเดียว แต่ยังช่วยคนด้าน accessbility สำหรับคนพิการที่เข้าไม่ถึง UI ด้วย

## เรียนภาษา Braille และทำนามบัตร

![Braille alphabet](/assets/2022-12-11-braille-alphabet.jpeg)

<https://stock.adobe.com/th/images/braille-alphabet/50182595>

- Braille 1 ช่อง มี 6 จุด
- จำ A-J นอกนั้นจำได้หมด เพราะที่เหลือจะเติมไปในตำแหน่งที่ 3 (ซ้ายล่าง)
- W แตกต่างเพราะไม่มีในภาษาฝรั่งเศส
- ถ้ามีอักษรนำเลข (#) แสดงว่าที่เหลือเป็นตัวเลขทั้งหมด
- ความหมายของตำแหน่งที่ 6 (ขวาล่าง) ใน Cell แรกทำให้เรารู้ว่าตัวถัดไปเป็น Uppercase

ปิดท้ายด้วยการทำนามบัตรที่มีอักษร Braille ที่มีชื่อของเราอยู่ในนั้น แล้วก็พูดคุยสังสรรค์เล่นดนตรี (คนพิการสายตาก็มาแจม guitar ด้วย 🎸) จบด้วยความอบอุ่นและแรงผลักดันที่ทำให้เรามีกำลังใจในการใช้ชีวิตต่อไป

![Business card with Braille](/assets/2022-12-11-business-card-with-braille.jpeg)
