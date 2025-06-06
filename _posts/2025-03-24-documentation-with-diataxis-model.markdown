---
layout: post
title: "มาเขียนเอกสารด้วย Diátaxis model กัน"
date: 2025-03-24
tags: [documentation]
---

![Diátaxis model](/assets/2025-03-24-diátaxis-model.webp)
<https://diataxis.fr/>

ในการพัฒนา software การเขียนเอกสารเป็นเรื่องที่หลายคนมองข้าม มักจะถูกทำแบบลวก ๆ ไม่ค่อยจะ update หรือหนักที่สุดคือมันจัดไม่เป็นระเบียบ ไม่รู้ส่าเอกสารที่เคยเขียนอยู่ที่ไหนจนเป็นปัญหาใหญ่ แต่มันไม่ควรเป็นแบบนั้น เพราะเอกสารที่ดีช่วยให้ทุกคนทำงานง่ายขึ้นแทนที่จะเป็นภาระ!

หนึ่งในวิธีที่ช่วยให้การเขียนเอกสารเป็นระเบียบและใช้งานได้จริงก็คือ [Diátaxis](https://diataxis.fr/) ซึ่งเป็นโครงสร้างที่ช่วยจัดประเภทเอกสารออกเป็น 4 ส่วนหลัก ๆ ได้แก่ **Tutorials, How-to Guides, Reference Guides และ Explanation** วิธีนี้ช่วยให้เอกสารมีความชัดเจนขึ้น และช่วยให้ทั้งผู้เขียนและผู้อ่านเข้าใจเนื้อหาได้ง่ายขึ้น เนื่องจากเราจะต้องเข้าใจจุดประสงค์ว่าเราเขียนเอกสารนั้น ๆ ขึ้นมาเพื่ออะไร เนื้อหาจะอยู่ในรูปแบบไหน ความละเอียดของเนื้อหาประมาณไหน เป็นต้น

## ทำไมต้องใช้ Diátaxis

Diátaxis model นี้ไม่ได้เป็นเพียงแค่ทฤษฎีลอย ๆ ขึ้นมา แต่[ได้รับการพิสูจน์แล้วว่าสามารถใช้งานได้จริง](https://docs.divio.com/documentation-system/adoption/)ในหลาย software project ทั้งเล็กและใหญ่ การที่เรามีแนวทางชัดเจนในการจัดเอกสารทำให้

- **ง่ายต่อการเขียนและดูแลรักษา**: เพราะรู้ว่าเนื้อหาแต่ละประเภทควรอยู่ตรงไหน
- **ช่วยให้ผู้อ่านค้นหาข้อมูลได้เร็วขึ้น**: เนื่องจากมีโครงสร้างที่ชัดเจน
- **ป้องกันการสับสนของเนื้อหา**: เพราะแต่ละประเภทมีเป้าหมายที่แตกต่างกัน

มาดูกันว่าเอกสารแต่ละประเภทใน Diátaxis มีหน้าที่อะไร และใช้งานอย่างไรบ้าง

### 1. Tutorials (บทเรียนแบบจับมือทำ)

แนวคิดของเอกสาร Tutorials คือ**เน้นการเรียนรู้เป็นหลัก (Learning-oriented)** เหมาะสำหรับมือใหม่สุด ๆ เพราะจะพาไปทีละขั้นตอน เป้าหมายคือให้คนอ่านสามารถทำอะไรบางอย่างสำเร็จได้ เช่น *"วิธีติดตั้งและเริ่มใช้ application ของเรา"* หรือ *"สร้าง webpage แรกของคุณด้วย HTML"*

**วิธีเขียน Tutorials ให้ดี:**
- เขียนให้เป็นลำดับขั้นตอนที่เข้าใจง่าย
- ใช้ตัวอย่างที่ทำตามได้จริง ตรวจสอบให้แน่ใจว่าสามารถทำซ้ำได้โดยไม่มีข้อผิดพลาด
- หลีกเลี่ยงคำอธิบายที่ซับซ้อนเกินไป
- ทำให้ผู้อ่านเห็นผลลัพธ์ได้เร็ว

### 2. How-to Guides (คู่มือวิธีทำ)

แนวคิดของเอกสาร How-to Guides คือ**เน้นการแก้ปัญหา (Goal-oriented)** มันจึงเหมาะสำหรับคนที่พอมีพื้นฐานแล้ว ต้องการคำตอบแบบชัดเจนไว ๆ เช่น *"จะเพิ่มปุ่ม Login บน web ได้ยังไง"* หรือ *"วิธีตั้งค่า Docker ให้ใช้งานกับ PostgreSQL"*

**วิธีเขียน How-to Guides ให้ดี:**
- เน้นไปที่วิธีการแก้ปัญหาที่ชัดเจน
- เขียนเป็นลำดับขั้นตอนสั้น ๆ และกระชับ
- ไม่ต้องอธิบายพื้นฐานที่คนอ่านควรจะรู้แล้ว
- ใช้ตัวอย่างที่ใช้งานได้จริง

### 3. References (ข้อมูลอ้างอิง)

แนวคิดของเอกสาร References คือ**เน้นการให้ข้อมูล (Information-oriented)** สำหรับคนที่ต้องการรายละเอียดเกี่ยวกับสิ่งใด ๆ เช่น API, architecture ต่าง ๆ โดยไม่มีการสอนหรืออธิบายแนวคิดเพิ่มเติม บอกแค่่ว่าอะไรคืออะไร ใช้งานยังไง เช่น "XXX ใช้งานยังไง?"

**วิธีเขียน Reference Guides ให้ดี:**
- ใช้ภาษาที่เป็นกลางและตรงไปตรงมา
- มีตัวอย่างการใช้งานที่ชัดเจน
- หลีกเลี่ยงการอธิบายแนวคิดหรือกระบวนการ ให้ focus ไปที่ "นี่คืออะไร" และ "ใช้งานยังไง"

### 4. Explanation (บทความอธิบาย)

แนวคิดของเอกสาร Explanation คือ **เน้นความเข้าใจเชิงลึก (Understanding-oriented)** อธิบายแนวคิดเบื้องหลัง วิธีการทำงานของระบบ หรือเหตุผลว่าทำไมบางอย่างถึงเป็นแบบนั้น เช่น *"ทำไมต้องใช้ MVC ในการออกแบบ web application?"*

**วิธีเขียน Explanation ให้ดี:**
- ให้บริบทและเหตุผลที่อยู่เบื้องหลังแนวคิดต่าง ๆ
- อธิบายแนวคิดเชิงลึกที่อาจไม่สามารถจับต้องได้โดยตรง
- เปรียบเทียบและให้ข้อคิดเห็นเกี่ยวกับแนวทางที่แตกต่างกัน
- หลีกเลี่ยงการสอนเป็นขั้นตอน หรือให้ข้อมูลอ้างอิงโดยตรง

## สรุป

| Tutorials | How-to Guides | Reference | Explanation |
|-----------|--------------|-----------|-------------|
| สอนเริ่มต้น | แก้ปัญหาเฉพาะจุด | ให้ข้อมูลเชิงเทคนิค | อธิบายแนวคิดลึก ๆ |
| เหมือนครูพาเรียน | เหมือนสูตรอาหาร | เหมือนพจนานุกรม | เหมือนบทความวิชาการ |
| ต้องทำตาม | ต้องการคำตอบเร็ว ๆ | ต้องรู้ข้อมูลชัด ๆ | ต้องการเข้าใจภาพรวม |

การแยกเอกสารออกเป็น 4 หมวดหมู่นี้ช่วยให้ทั้งผู้ใช้และนักพัฒนาทำงานได้สะดวกขึ้น ผู้ใช้สามารถหาข้อมูลที่ต้องการได้ง่ายขึ้น และผู้เขียนเองก็สามารถเขียนและดูแลเอกสารได้อย่างเป็นระบบมากขึ้น โดยไม่ต้องเสียเวลาสับสนว่าควรใส่ข้อมูลไว้ที่ไหน

> ลองเอาไปใช้ดู แล้วจะพบว่าเอกสารดี ๆ ก็สร้างประสบการณ์ที่ดีให้กับผู้อ่านได้!
