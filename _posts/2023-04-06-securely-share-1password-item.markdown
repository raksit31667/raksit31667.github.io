---
layout: post
title: "เพิ่งรู้ว่าเราสามารถ share 1Password item แบบปลอดภัยได้"
date: 2023-04-06
tags: [security, 1password]
---

ปกติเราใช้ 1Password เป็นเครื่องมือในการเก็บ credentials ต่าง ๆ แทนที่การจดไว้ใน notes สักที่แล้วก็ลืม ฮ่า ๆๆ ทีนี้มันก็ต้องมีเหตุการณ์ที่เราอยากจะ share credentials ให้กับคนอื่น เช่น Wi-Fi password หรือไม่ก็ Netflix passcode ให้แขกที่มาเยี่ยมบ้าน เป็นต้น ถ้ามันไม่ได้ยาวมากเราก็บอกได้เลยเพราะพอจะจำได้แหละ แต่ถ้ามันยาวมากทำยังไง  

วิธีแก้ก็ copy credentials จาก 1Password item แล้วก็แปะส่งให้ก็จบ ปัญหาคือถ้าทำโดยไม่ระวัง credentials ของเราก็อาจจะหลุดได้ กลายเป็นเปิดช่องโหว่ให้ผู้ไม่หวังดีมาโจมตีเรา ดังนั้นเรามาหาวิธีที่ปลอดภัยกว่านี้กัน ซึ่งก็ตามหัวข้อของ blog เลย คือ 1Password เค้ามี feature [Password secure sharing tool หรือ Psst](https://1password.com/features/secure-password-sharing/) โดยความสามารถก็คือเราสามารถสร้าง link เพื่อ share ให้กับใครก็ได้ หรือปล่อดภัยกว่าคือระบุเป็นคน ๆ ไปเลยผ่าน email address เพื่อให้ 1Password ส่ง email มาให้เค้ากรอก verification code ก่อนถึงจะดู credentials ได้ นอกจากนั้นยังสามารถตั้งเวลาหมดอายุของ link ได้ด้วย  

ปัญหาต่อมาคือถ้ามีคนใช้งาน 1Password มากกว่า 1 คน เช่น ในบริษัท แล้วเราจะรู้ได้ยังไงว่าใคร share หรือเข้ามาดู credentials ของเราบ้าง เพราะคนในอาจจะเผลอเอาไป share ต่อให้คนนอกก็ได้ ซึ่ง feature นี้เค้าก็มี [Activity Log](https://support.1password.com/activity-log/) เพื่อเป็น audit ในการตรวจสอบความเคลื่อนไหวนั่นเอง

<iframe width="560" height="315" src="https://www.youtube.com/embed/fgcDdxvyJPE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## References
- [Psst! Now you can securely share 1Password items with anyone](https://blog.1password.com/psst-item-sharing/)
