---
layout: post
title:  "แนะนำ endoflife.date สำหรับการตรวจสอบ software version"
date:   2021-12-08
tags: [security]
---

## การใช้งาน software ตกรุ่น
เราจะพูดถึง software ที่อยู่ในสถานะ end-of-life (ตกรุ่น) ว่าเป็น software ที่ผู้ดูแลหยุดรองรับ สนับสนุน แก้ไข เนื่องจากผู้ดูแลไปพัฒนา software version ใหม่แทน สิ่งที่เกิดขึ้นคือเมื่อเวลาผ่านไป software เหล่านั้นจะมีช่องโหว่ด้านความปลอดภัยเพราะเมื่อหยุดแก้ไข ก็ไม่ได้ป้องกันช่องโหว่ใหม่ๆ นั่นเอง ทำให้ความเสี่ยงที่ระบบของเราจะถูกโจมตีมีมากขึ้น ส่งผลเสียต่อ business และมีค่าใช้จ่ายต่างๆ ตามมา  

แนวทางการแก้ปัญหาก็มีหลายแบบ เช่น การทำ application/container security scan, static/dynamic code analysis, penetration test หรือง่ายที่สุดคือดูผ่าน notification หรือ warning message จาก application คำถามคือ **เราจะมีวิธีรู้ก่อนล่วงหน้าได้หรือไม่**

## endoflife.date
[endoflife.date](https://endoflife.date/) เป็น website ที่รวบรวมข้อมูล software version ที่ใช้งานกันอย่างแพร่หลาย ทั้ง open-source และ commercial โดยข้อมูลจะประกอบไปด้วย

- Version
- Release number ปัจจุบัน
- วันที่ Release
- วันที่จะหยุด ออก feature ใหม่
- วันที่จะหยุด support ด้าน feature และ security

### ตัวอย่าง end-of-life ของ Kubernetes
![endoflife Kubernetes](/assets/2021-12-08-endoflife-kubernetes.png)

เราสามารถ contribute หรือติดตามการ update version ได้ใน [GitHub](https://github.com/endoflife-date/endoflife.date)

> [endoflife.date](https://endoflife.date/) เป็นเครื่องมือที่ช่วยเตรียมแผนการ upgrade software version ของเรา เพื่อที่จะทำให้เราได้รับ feedback จากระบบเมื่อเกิดปัญหาจากการ upgrade และลดช่องโหว่ที่จะเกิดความเสี่ยงทางด้านความปลอดภัยลงด้วย
