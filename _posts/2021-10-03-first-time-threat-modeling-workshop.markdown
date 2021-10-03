---
layout: post
title:  "แบ่งปันประสบการณ์ครั้งแรกกับการทำ threat modeling workshop"
date:   2021-10-03
tags: [threat-modeling, security]
---

เมื่ออาทิตย์ที่แล้วได้มีโอกาสเข้า workshop ที่บริษัทจัดทุกเดือนเกี่ยวกับ software architecture โดยในรอบนี้เป็น theme เกี่ยวกับ threat modeling แน่นอนว่าเป็นครั้งแรก และมี hands-on workshop ด้วย ดังนั้นเลยนำมาสรุปไว้นิดหน่อย

## พูดถึง Threat modeling
Threat modeling เป็นแนวคิดในการทำความเข้าใจเกี่ยวกับต้นเหตุและเตรียมแนวทางการแก้ไขจากความเสี่ยงที่อาจจะเกิดขึ้นได้ในระบบของเรา แทนที่จะเป็นการทำ checklist ว่าเราทำอะไรไปแล้วบ้าง เป็นเพราะว่าส่วนใหญ่แล้วความสูญเสียที่เกิดขึ้นจากการโดนโจมตีมาจาก "ความรู้เท่าไม่ถึงการณ์" ถึงความเสี่ยงนั้นๆ นั่นเอง  

> แต่เราไม่ได้เป็น security expert นะ

ไม่จำเป็นว่าเราต้องเป็น security expert เท่านั้นถึงจะทำได้ แล้วเราก็ไปศึกษาเพิ่มจาก expert ไม่ว่าจะเป็น security architect หรือ risk management team ผ่านการทำ workshop ด้วยกัน ซึ่งพวกเขาก็จะได้ประโยชน์จากมุมมองที่ต่างกันทั้งในด้าน tech และ non-tech เราจะพูดถึงจุดอ่อนของระบบเช่น authorization หรือ การเก็บข้อมูลส่วนบุคคล (Personally Identifiable Information หรือ PII) ซึ่งสามารถเห็นได้จาก visualization ของระบบในรูปแบบต่างๆ เช่น data-flow, system architecture diagram  

ดังนั้นการทำ threat modeling จึงเป็นการร่วมมือกันของทุกๆ คนที่มีส่วนเกี่ยวข้อง โดยเฉพาะทีมพัฒนาที่จะเห็นหลายๆ คนในทีมพูดถึงความเสี่ยงเดียวกัน (นั่นหมายความว่ามันสำคัญใช่ไหม) และ project management จะได้ระวังไว้ว่า business value อะไรที่มีผลต่อความเสี่ยงในการโดนโจมตีบ้าง เพราะถ้ามันเกิดขึ้น แน่นอนว่าทีมก็จะเสีย business value ไปด้วย  

เรามักจะเคยได้ยินการพัฒนา software แบบ incremental ที่จะค่อยๆ ส่งมอบงานที่มี business value แบบเล็กๆ แต่ถี่ๆ ผ่านกันมาบ้าง เช่นเดียวกันกับ threat modeling ที่เราสามารถทำล้อไปกับการพัฒนาได้เลย เพื่อที่ทีมพัฒนาจะได้จัดลำดับความสำคัญของการเตรียมป้องกันจากความเสี่ยงได้อย่างทันท่วงที

![Agile threat modeling](/assets/2021-10-03-agile-threat-modeling.png)

### เรากำลังป้องกันอะไร
เริ่ม workshop จากทำความเข้าใจระบบก่อนว่ามันสร้างมาเพื่ออะไร มี asset อะไรที่ต้องป้องกันบ้าง เก็บข้อมูลอะไรไว้ตรงไหนบ้าง ให้เราตั้ง security objectives เพื่อให้ทุกคนมองภาพเดียวกันว่า เป้าหมายของการป้องกันครั้งนี้คืออะไร ยกตัวอย่างเช่น ระบบจอง vaccine ให้คนทั้งประเทศไทย เป้าหมายก็อาจจะเป็น

- ข้อมูลการจอง vaccine ถูกเก็บไว้และไม่ถูกแก้ไขโดยไม่ชอบ
- ข้อมูลจะต้องไม่มีการรั่วไหลออกไป
- ระบบการจองจะต้องไม่ล่มง่ายๆ เมื่อทุกคนในประเทศไทย 70 ล้านคนเข้ามาจองพร้อมกัน (แต่อาจจะช้าหน่อย ฮ่าๆๆ)

![Example system diagram](/assets/2021-10-03-example-system-diagram.png)

### ระบบมีความเสี่ยงจากอะไรบ้าง
มาถึงจุดที่สำคัญที่สุดคือเราต้องระบุคือผู้โจมตี ซึ่งอาจจะเป็น hacker หรือ คนในกันเองก็ได้ ทีนี้เราเพิ่งเริ่มทำ เราจะรู้ได้ไงว่ามันมีความเสี่ยงอะไรบ้าง ให้มานึกทั้งหมดนี่ลำบากแน่ๆ เราสามารถเริ่มจากการใช้ [STRIDE framework](https://en.wikipedia.org/wiki/STRIDE_(security)) ในการระบุความเสี่ยงที่เกิดขึ้น จากนั้นให้เราดูว่า S, T, R, I, D, E ตามข้างล่างนี้ มัน match กับ [CIA triad](https://www.f5.com/labs/articles/education/what-is-the-cia-triad) ซึ่งประกอบไปด้วย

- **Confidentiality:** asset สามารถเข้าถึงได้จากคนที่ควรจะเข้าถึงเท่านั้น
- **Integrity:** asset สามารถเปลี่ยนได้จากจากคนที่ควรจะเปลี่ยนเท่านั้น
- **Availability:** ทุกคนหรือระบบที่มีสิทธิ์สามารถเข้าถึง asset ได้ตลอด

![The CIA Triad](/assets/2021-10-03-the-cia-triad.png)

- **Spoofed identity:** ปลอมตัวเป็นคนอื่นๆ เข้าไปใช้งานระบบ ซึ่งจะเกี่ยวข้องกับการจัดการ authentication ที่ไม่ดี เช่น
  - ไม่มี authentication
  - UI ไม่ซ่อนการ input credentials เช่น password field
  - การให้ user สร้าง password ที่เดาง่ายๆ เช่น 1234 abcd
  - การให้ user ทำ brute force ในการ authenticate เข้า เช่น เดา password ได้ไม่จำกัดครั้ง
  - ไม่มี multi-factor authentication
  - ลืมล้าง access หลังจากที่มีคนออกจากระบบ เช่น พนักงานใหม่ได้ access จากคอมพนักงานเก่าที่ลาออกไป
  - เขียน code ทำ authentication authorization เอง (?)

- **Tampering with input:** การโจมตีจากข้อมูลที่ส่งเข้าไปในระบบ เช่น
  - SQL injection
  - Cross site scripting
  - Cross site request forgery
  - File upload ไม่กัน malware
  - การ validate input ผ่านแค่ด้าน client-side เท่านั้น

- **Repudiation of action:** ระบบมีการเก็บหลักฐานของ user ในการทำ action กับระบบหรือไม่ เช่น
  - มีการ log เวลาเข้าถึงข้อมูลส่วนตัว หรือ การลบ account หรือ admin access หรือ authentication/validation error
  - ถ้ามีการ log แล้วเก็บ log ไว้ที่ไหน เก็บไว้กี่วัน ไม่ใช่ว่า restart instance แล้วหายหมดไรงี้
  - มีการจำกัดสิทธิ์ให้เข้าถึง log ไหม
  - มีการแจ้งถึงเรื่อง privacy & policy ในการใช้งานระบบไหม ถ้าไม่มีแล้วจับ user ที่ทำได้ ก็ลอยตัวเลยนะ
  - ทีมมีแผนแก้ไขหรือแผนสำรองเมื่อเกิดปัญหาไหม เช่น user ทั้งหมดถูกลบออกจากระบบ
  
- **Information disclosure:** ระบบมีการป้องกันไม่ให้เข้าถึงข้อมูลที่ user ไม่ควรเข้าถึงหรือไม่ เช่น
  - มีการ check ว่ามี secret หลุดขึ้นไปใน version control system หรือเปล่า
  - เก็บ secret ไว้เป็น plain text (คงไม่มีใครทำหรอกนะ)
  - มีการ encrypt ข้อมูลที่เก็บไว้ หรือก่อนส่งข้ามระบบหรือไม่
  - มีการใช้ protocol ที่ update ใหม่หรือไม่
  - มี sensitive data ใน log
  - การจัดการ error handling ไม่ดี

- **Denial of service:** ระบบมีการป้องกันไม่ให้ระบบล่มจากเหตุการณ์ผิดปกติหรือไม่ เช่น
  - ป้องกันการโดน flood โดยการส่ง request เข้ามาพร้อมๆ กันเยอะๆ เช่น DDoS
  - มี rate limiting หรือไม่
  - มีการ block traffic จาก source ที่ flood request มาไหม
  - การไม่ใช้ CDN ในการเก็บ static files (ทุกวันนี้ CDN เองยังล่ม ฮ่าๆๆ)

- **Elevation of privilege:** การโจมตีด้วยการใช้ role ที่สูงเกินกว่าจะเป็น ซึ่งจะเกี่ยวข้องกับการจัดการ authorisation ที่ไม่ดี
  - การเพิ่ม permission จากระบบส่วนที่ไม่เกี่ยวข้อง แต่ดันมีผลกับระบบอื่น
  - ลืมปิด developer mode
  - ไม่มีการ check authorisation เวลาเข้าถึงข้อมูล sensitive

![Example system diagram after threat modeling](/assets/2021-10-03-threat-modeling-with-diagram.png)

### แล้วเราจะป้องกันความเสี่ยงเหล่านี้อย่างไร
แนะนำว่าให้เราเลือกตัว top มาสัก 3 อัน ระบุวิธีการแก้ไขลงไป เพื่อที่จะนำไปจัดลำดับความสำคัญต่อไป อย่าลืมว่าทุกๆ ช่วงเวลานึง ให้เรากลับมา review ว่าทำไปแล้วหรือยัง แล้วมันป้องกันได้ไหม จากนั้นเราก็ทำ threat modeling ในรอบต่อไปเรื่อยๆ

![Threat modeling table](/assets/2021-10-03-threat-modeling-table.png)

> เป็น workshop ที่ทำให้เราตระหนักถึง security ได้ดีเลยว่ามันเป็นเรื่องของทุกคนที่เกี่ยวข้องจริงๆ แล้วทุกวันนี้เราจัดการเรื่อง security ในระบบของเราอย่างไรเอ่ย

## References
- [Threat modeling toolkit by Thoughtworks](https://thoughtworksinc.github.io/sensible-security-conversations/materials/Sensible_Agile_Threat_Modelling_Cards.pdf)