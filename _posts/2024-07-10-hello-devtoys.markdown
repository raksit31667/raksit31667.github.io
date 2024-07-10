---
layout: post
title: "สวัสดี DevToys เครื่องมือสารพัดประโยชน์สำหรับ developer"
date: 2024-07-10
tags: [devtoys, productivity, tools]
---

![DevToys](/assets/2024-07-10-devtoys.png)

> "A Swiss Army knife for developers." - DevToys

มันจะมีงานของชาว developer ไม่ว่าจะสาย frontend, backend, infra, data, IoT, security ที่มีเหมือนกันก็อย่างเช่น

- Format JSON, YAML
- Encode/Decode เช่น base64, JWT
- Regular expressions
- Escape/Unescape string
- Convert ค่าต่าง ๆ เช่น date (epoch seconds) หรือ JSON

ปัญหาคือหลายคน (รวมถึงเราก่อนหน้านี้) เลือกที่จะใช้เครื่องมือผ่าน web browser ซึ่งถ้ามันไม่เป็นความลับไปก็โอเคอยู่ แต่ถ้าเป็นของลูกค้าก็มีความเสี่ยงที่เครื่องมือเหล่านี้จะเอา input เราไปทำอะไรไม่ดีต่อ security ของระบบก็ได้  

เมื่ออาทิตย์ก่อนเพิ่งรู้จัก application ที่สามารถทำสิ่งต่าง ๆ เหล่านี้ได้ชื่อว่า [DevToys](https://github.com/DevToys-app/DevToys) ซึ่งมี feature หลัก ๆ ดังนี้

- มีเครื่องมือต่าง ๆ ที่ contribute จาก open-source community รวมถึงสามารถ[ต่อเติมให้เป็นของเราเอง](https://devtoys.app/doc/articles/extension-development/getting-started/create-an-extension.html?tabs=rider)ก็ได้ โดยให้เขียน code เป็นภาษา C#
- แนะนำเครื่องมือที่น่าจะต้องใช้จาก content ใน clipboard ของเรา เพราะเราต้อง copy ข้อมูลเข้ามาก่อนใช้
- ใช้งานผ่าน command-line interface (CLI) ได้ด้วยคำสั่ง `devtoys.cli` (ต้องลงแยกจาก GUI app)

วีธีการติดตั้งก็ดูตาม [official website](https://devtoys.app/download) ได้เลยครับ ส่วนตัวลองใช้แล้วเครื่องมือที่ให้มาก็ตอบโจทย์งานปัจจุบันที่ทำอยู่ ถ้ามี use case ใหม่ ๆ ที่ DevToys ครอบคลุม มันก็น่าจะสารพัดประโยชน์มากขึ้นไปอีก
