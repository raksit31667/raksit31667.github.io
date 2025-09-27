---
layout: post
title: "แนะนำ git sparse-checkout สำหรับ version control ใน monorepo"
date: 2025-09-18
tags: [git]
---

กำลังทำงานกับ [monorepo](https://en.wikipedia.org/wiki/Monorepo]) ใหญ่ ๆ อยู่ หลายคนคงเจอปัญหาเหมือนกันคือ repo มันใหญ่มากจน clone มาลงเครื่องแล้วอืด เปิด file ก็เยอะเกินไป ทั้งที่จริง ๆ แล้วเราอาจจะอยากแก้หรือดูแค่บาง folder เท่านั้นเอง ตรงนี้แหละที่ [git sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) เข้ามาช่วยได้

### git sparse-checkout คืออะไร

มันคือ feature ของ Git ที่ให้เราเลือก checkout มาเฉพาะบาง file หรือบาง folder ที่สนใจ ไม่ต้องโหลดทั้ง repo มาลงเครื่อง ข้อดีคือกินเนื้อที่น้อยลง ทำงานกับ file ได้เร็วขึ้น และไม่ต้องวุ่นวายกับ code ส่วนที่ไม่เกี่ยวกับงานเรา

### ทำงานยังไง

1. เปิดใช้งาน sparse checkout โดยใช้คำสั่ง

   ```bash
   git sparse-checkout init --cone
   ```

   ตรงนี้ `--cone` จะทำให้ pattern ที่ใช้เลือก folder มันง่ายขึ้น

2. เลือก folder ที่จะใช้

   ```bash
   git sparse-checkout set your/directory
   ```

   คำสั่งนี้จะบอก Git ว่าเอาเฉพาะ folder `your/directory` มาให้เรา ส่วน folder อื่น ๆ จะไม่ถูกดึงลงมาใน working directory

3. ถ้าวันไหนอยากกลับมา checkout ได้ทั้ง repo ก็ทำได้ง่าย ๆ

   ```bash
   git sparse-checkout disable
   ```

### ประโยชน์ที่เห็นชัด ๆ

* **ใช้เนื้อที่น้อยลง** ไม่ต้อง checkout ทั้ง repo
* **ทำงานเร็วขึ้น** ทั้ง `git status`, `git diff` หรือ `git checkout`
* **Focus งานได้ตรงจุด** โดยเฉพาะเวลาทำงานกับ monorepo ที่มีหลาย service หรือหลาย platform

สรุปคือถ้าใครทำงานกับ monorepo ใหญ่ ๆ หรือ repo ที่ file เยอะ ลองใช้ `git sparse-checkout` ดูครับ
