---
layout: post
title: "แนวทางการทำงานร่วมกันของ Platform team และ consumer ของพวกเขา"
date: 2023-07-10
tags: [platform, technique]
---

หลังจากจบ project เรื่อง platform ไปแล้วก็มีโอกาสได้ไปฟังเรื่องราวของการพัฒนา platform ที่อื่น ๆ บ้างพบว่าแต่ละทีมเขาก็มีวิธีการทำงานร่วมกันของ platform team และ consumer แตกต่างกันไป คำถามในหัวเราคือแล้วแบบไหนควรใช้ตอนไหนล่ะ มีข้อดี-ข้อเสียอย่างไร มาดูกัน

## Ticket system
เมื่อ platform ต้องการให้ consumer ใช้งาน feature ใหม่หรือทำการ upgrade platform ก็ให้ platform team ส่งคำขอมาในรูปแบบ artifact ที่จับต้องและตรวจสอบได้ เช่น Product Item Backlog (PBI), support request, support ticket อาจจะทำผ่านเครื่องมือ project management ต่าง ๆ ก็ได้มาให้ consumer แล้วก็ให้ consumer เค้าไปทำการแก้ไขใน code ของเขาเองโดยอาศัยจาก documentation หรือ wiki ก็ได้ 

![Ticket system 1](/assets/2023-07-10/2023-07-10-ticket-system-1.png)

ในทางกลับกันถ้า consumer ต้องการใช้งาน feature ใหม่หรือทำการ upgrade platform ก็ให้ consumer ส่งคำขอมาให้ platform team แล้วก็ให้ platform เค้าไปทำตามคำขอของ consumer ไป  

![Ticket system 2](/assets/2023-07-10/2023-07-10-ticket-system-2.png)

- **ข้อดี**: สามารถ scale ไปใช้กับ consumer หลาย ๆ ทีมได้ง่ายไม่ต้องออกแรงมากมาย นอกจากนั้น platform team ก็ไม่จำเป็นต้องเข้าไปดูหรือทำความเข้าใจ code ของ consumer ด้วย
- **ข้อเสีย**: อาจจะใช้เวลานานกว่า consumer จะทำตามเนื่องจากเขาก็ต้องมีงาน product ทั่วไปที่ต้องทำอยู่แล้ว เรื่อง platform ก็จะถูกลดความสำคัญลงไป เช่นเดียวกับ platform team จะทำตามเพราะ consumer ต้องรอให้ ticket นั้นถูกหยิบขึ้นมาเหมือนกัน

## Collaboration mode
เมื่อ platform ต้องการให้ consumer ใช้งาน feature ใหม่หรือทำการ upgrade platform ก็ส่งคนใน platform team ไปช่วยเพิ่มหรือแก้ไข code ของ consumer ไม่ว่าจะมาในรูปแบบเข้าไป pair development เลยก็ดีหรือว่าจะเป็น pull request ก็ได้เหมือนกัน

![Collaboration mode](/assets/2023-07-10/2023-07-10-collaboration-mode.png)

- **ข้อดี**: ใช้เวลาน้่อยเนื่องจากคนใน platform team เข้าไปลงมือทำเอง (ในกรณี pull request ก็แล้วแต่ว่า consumer เค้าจะมา review ตอนไหนด้วย)
- **ข้อเสีย**: scale ไปใช้กับ consumer หลาย ๆ ทีมได้ยากขึ้น platform team ก็ต้องเข้าไปดูหรือทำความเข้าใจ code ของ consumer ด้วยส่งผลต่อความเป็นเจ้าข้าวเจ้าของ code ส่วนนั้นด้วย

## X-as-a-Service
เมื่อ platform ต้องการให้ consumer ใช้งาน feature ใหม่หรือทำการ upgrade platform ก็จะเตรียม service เอาไว้เพื่อให้ consumer นำไปใช้ต่อ

- **ข้อดี**: สามารถ scale ไปใช้กับ consumer หลาย ๆ ทีมได้ นอกจากนั้น platform team ก็ไม่จำเป็นต้องเข้าไปดูหรือทำความเข้าใจ code ของ consumer
- **ข้อเสีย**: ความยากง่ายในการใช้ service ก็แล้วแต่ platform team ที่จะออกแบบละ ถ้าออกแบบไม่ scale กับ consumer แล้วแทนที่จะแก้ปัญหา consumer กลับกลายเป็นไปสร้างปัญหาให้เขาซะงั้น

ทีนี้เรามาเจาะลึกว่าเราสามารถใช้ท่าไหนในการออกแบบหรือสร้าง service ให้ consumer ได้บ้าง

### Reusable modules
เริ่มจาก platform team สร้าง module เช่น library หรือ SDK รวมถึงเอกสารในการใช้งานที่สามารถรองรับการใช้งานกับ consumer หลาย ๆ แบบได้ เช่น สามารถ configure บางส่วนเองได้ จากนั้นเวลา consumer ต้องการใช้งาน module ก็สามารถหยิบไปใช้ใน code ของ consumer เองได้เลย

![Reusable modules](/assets/2023-07-10/2023-07-10-reusable-modules.png)

- **ข้อดี**: สามารถปรับแก้ให้รองรับกับการใช้งานของ consumer หลาย ๆ กรณีได้ง่าย เพราะ consumer สามารถทำเองได้ด้วยตนเอง
- **ข้อเสีย**: consumer ต้องเข้าใจในการใช้งาน module และถ้าต้องการจะปรับแก้ก็จะต้องเรียนรู้ technical เพิ่มเติมไปอีก

### Configuration/parameters
เริ่มจาก platform team เตรียม platform และรูปแบบของ configuration และ parameter รวมถึงเอกสารในการใช้งานที่สามารถรองรับการใช้งานกับ consumer หลาย ๆ แบบได้ จากนั้นเวลา consumer ต้องการใช้งานก็ configure โดยใช้ parameter ตามที่ได้ระบุไว้

![Platform config](/assets/2023-07-10/2023-07-10-platform-config.png)

- **ข้อดี**: consumer ทำความเข้าใจในการใช้งานแค่ส่วน configuration เท่านั้น
- **ข้อเสีย**: มีโอกาสที่ code ในตัว platform จะซับซ้อนตาม configuration และการทำ versioning ก็จะซับซ้อนมากขึ้น

### APIs
เริ่มจาก platform team เตรียม platform และ API ซึ่งมาในรูปแบบของภาษาอย่าง JSON หรือ YAML (ตัวอย่างเช่น [score](https://score.dev/blog/score-one-yaml-to-rule-them-all) หรือ Kubernetes) รวมถึงเอกสารในการใช้งานที่สามารถรองรับการใช้งานกับ consumer หลาย ๆ แบบได้ จากนั้นเวลา consumer ต้องการใช้งานก็ใช้งาน API ตามที่ได้ระบุไว้

![Platform APIs](/assets/2023-07-10/2023-07-10-platform-apis.png)

- **ข้อดี**: consumer ทำความเข้าใจในการใช้งาน API เท่านั้น สามารถใช้งาน API ต่าง ๆ ที่ community มีให้อยู่แล้ว
- **ข้อเสีย**: การออกแบบให้รองรับกรณีในการใช้งานจำกัดอยู่ที่ API ที่ให้มา ถ้าจะปรับแก้ให้ใช้งานนอกเหนือ API จะทำได้ยาก

> ไม่ว่าจะใช้ท่าไหนในการทำงานร่วมกัน หนึ่งในสิ่งที่สำคัญที่สุดที่ทำให้ platform ประสบความสำเร็จคือ "เราต้องฟังเสียงของ consumer เสมอ" แล้วพัฒนา platform ให้เติบโตไปทางที่สอดคล้องกันเพื่อให้องค์กรได้รับประโยชน์จากการใช้งาน platform ในระยะยาวไปนั่นเอง