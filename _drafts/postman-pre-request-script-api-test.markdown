---
layout: post
title:  "ประยุกต์การใช้งาน Pre-request script ใน Postman สำหรับการทดสอบ API"
date:   2020-11-25
tags: [postman, testing]
---

ในระบบงานปัจจุบัน เรามีการทดสอบ API ผ่าน Postman อยู่แล้ว ซึ่งนอกจากต้องเตรียม request body หรือ query parameter หรือ header แล้ว ยังต้องเตรียม OAuth2 authentication ด้วย เราก็ต้องไปเรียก **authentication server** เพื่อเอา **access token** ไป request API

<script src="https://gist.github.com/raksit31667/552eb7cbddb5ae31e61176e36bdbeee4.js"></script>

![Postman authorization pane](/assets/2020-11-25-postman-authorization-pane.png)

ทีมเราขี้เกียจที่จะ copy access token มาแปะใน placeholder ทุกครั้ง เรากับ QA เลยลองใช้ [pre-request script](https://learning.postman.com/docs/writing-scripts/pre-request-scripts/) ใน Postman เพื่อ automate ขั้นตอนนี้  

สร้าง [Environment ใน Postman](https://learning.postman.com/docs/sending-requests/managing-environments/) แล้วเพิ่ม variable สำหรับการขอ access token ลงไป ตัวอย่างเช่น

![Postman authorization pane](/assets/2020-11-25-postman-manage-environments.png)

จากนั้นผมก็จะเพิ่ม pre-request script สำหรับการขอ access token และ set environment variable ชื่อ `access_token` ผ่านการใช้ function ของ **Postman API** จากรูปผมใช้ Microsoft Azure ซึ่ง script จะมาประมาณนี้

<script src="https://gist.github.com/raksit31667/400a912836d351d61d0a64bcc9d363f8.js"></script>

> ดู Postman JavaScript reference ได้ที่ <https://learning.postman.com/docs/writing-scripts/script-references/postman-sandbox-api-reference/>