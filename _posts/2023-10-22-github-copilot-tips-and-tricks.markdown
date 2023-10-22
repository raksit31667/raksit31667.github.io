---
layout: post
title: "ก้าวแรกสู่สังเวียน GitHub Copilot"
date: 2023-10-22
tags: [github-copilot, generative-ai, tools]
---

เมื่ออาทิตย์ที่แล้วมีโอกาสได้ไปเข้ากิจกรรมของบริษัทเกี่ยวกับ [GitHub Copilot](https://github.com/features/copilot) ซึ่งก็มีการทดลองใช้งานและแบ่งปัน tips เล็ก ๆ น้อย ๆ ในการใช้งานจริง ก็เลยใช้บทความนี้ในการจดบันทึกไว้ว่ามีอะไรที่น่าสนใจกันบ้าง

## GitHub Copilot คืออะไร
GitHub Copilot คือผู้ช่วยเราเขียน code พัฒนาโดย Microsoft และ OpenAI โดยเบื้องหลังจะใช้ machine learning ในการ generate code ตาม context ของงานที่เรากำลังทำอยู่ เปรียบเสมือน StackOverflow ที่ปรับ context เข้ากับเราแล้ว นักพัฒนาอย่างเรา ๆ ก็แค่ติดตั้ง Copilot บน IDE และเชื่อม license เข้ากับ GitHub account ของเรา จากนั้นเขียน prompt ที่เป็นลักษณะของ comment, function, variable name, test description ลงไปใน code สิ่งที่ได้คือ code snippet ที่ถูก generate ออกมา

![GitHub Copilot](/assets/2023-10-22-github-copilot.webp)  
[GitHub Copilot: Your friendly neighborhood AI pair programmer!](https://paravatha.medium.com/github-copilot-your-friendly-neighborhood-ai-pair-programmer-158daf60ff54)

โดยความที่ Copilot ทำการ train data เบื้องต้นจาก GitHub public repositories ทั้งหมดแล้ว ทำให้ code ที่ออกมานั้นมีความแม่นยำ สามารถ compile ได้ในระดับที่ดี (แต่ก็มีบางกรณีที่ compile ไม่ได้บ้าง) แล้วใช้งานได้กับทุก codebase ไม่ใช่แค่ต้องเป็น code ที่จะถูก host ใน GitHub อย่างเดียว  

นอกจากนั้นแล้วในอนาคตอันใกล้ก็จะมี [Copilot X](https://github.com/features/preview/copilot-x) ที่เป็น chat feature ช่วยหา error หรือช่วยส่วนงานอื่น ๆ ที่เกี่ยวกับ code และยังมี [Copilot แบบ command-line](https://githubnext.com/projects/copilot-cli) ที่ช่วย generate Shell commands อีกด้วยนะ น่าสนใจมาก!

## ความสามารถของ Copilot
- สามารถ generate code ที่ถูกต้องได้ถึงแม้ว่า code ปัจจุบันจะมี bug!
- สามารถอธิบาย code ส่วนที่เรา highlight ไว้ได้ เช่น dependencies ใน `package.json` เหมาะสำหรับเป็นตัวช่วยในการเรียนภาษาหรือ dependencies ใหม่ ๆ

![Copilot explanation](/assets/2023-10-22-copilot-explanation.png)

- สามารถ generate พวก non-programming language ได้ เช่น API documentation, YAML, emoji, markdown เป็นต้น
- สามารถ generate test suite จาก code snippet ที่เราเลือกไว้ได้ (chat)
- สามารถ generate test data ที่สมจริงในระดับนึงได้
- สามารถแก้ไข compile error, syntax error ได้ (chat)

## สิ่งที่ Copilot ไม่สามารถทำได้หรือยังทำได้ไม่ดี
- Copilot เหมาะสำหรับส่วนงานที่ทำซ้ำ ๆ ตรงไปตรงมาไม่ซับซ้อน ถ้าอยากให้ผลลัพธ์ออกมาแม่นยำ context ตรง เราอาจจะต้องออกแรงเขียนเองไปก่อน
- Copilot chat feature มีแค่ใน VSCode แต่ไม่มีใน IDEA?
- Copilot ไม่สามารถทำ import-export function หรือ class ได้

## ปิดท้ายด้วยข้อควรระวังในการใช้งาน
- อย่าเสียเวลาในการปรับ prompt หรือ suggestion จาก Copilot มากจนเกินไป ถ้ามันไม่ดีก็ลงมือเขียนเองซะ
- ระวังการ generate code หลายบรรทัดมากจนเกินไปเพราะเราต้อง review นานขึ้่น
- อย่าเชื่อใจ Copilot มากจนเกินไปเพราะ code ที่ออกมาก็ยังมีโอกาสที่จะมี bug อยู่
- มองว่า Copilot suggestion เป็นแค่ทางเลือกหนึ่ง อย่าปิดกั้นตนเองกับทางเลือกอื่น ๆ ที่อาจจะยังมี
- หากนำไปใช้ในงานจริงในบริษัทควรปรึกษาทีมกฎหมายหรือ security เกี่ยวกับ data privacy เพราะ code ของเราอาจจะถูก 3rd party (GitHub แล้วแน่ ๆ ละหนึ่ง) นำไปใช้ในทางอื่น ๆ

> โดยรวมแล้ว GitHub Copilot เป็นเครื่องมือที่ช่วยทุ่นแรงเราในการ coding เหมาะสำหรับส่วนงานที่ทำซ้ำ ๆ ตรงไปตรงมาไม่ซับซ้อน ยิ่งถ้า code ที่มีอยู่แล้วดี ผลลัพธ์ที่ได้ก็จะดีขึ้นตามไปด้วย แต่ถ้าผลลัพธ์ตรงกันข้าม ก็อย่าได้เสียเวลาจมไปกับการปรับแก้ prompt ครับ ลงมือเขียนเองกันไปเลย