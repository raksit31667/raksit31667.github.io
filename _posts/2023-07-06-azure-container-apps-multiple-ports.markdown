---
layout: post
title: "วิธี run containers บน Azure Container Apps แบบรองรับหลาย port"
date: 2023-07-06
tags: [azure, container, azure-container-apps, nginx]
---

## ปัญหาที่เกิดขึ้น

ใน project ที่ทำอยู่นั้นจะต้องนำ application ที่อยู่ในรูปแบบ container ไป run บน [Azure Container Apps (ACA)]({% post_url 2023-03-30-azure-container-apps %}) ซึ่งรองรับการ run หลาย ๆ container พร้อมกันใน application เดียวกัน ทีมเราจึงวางแผนที่จะ run application บนหลาย ๆ port ยกตัวอย่างเช่น HTTP stub server ยี่ห้อต่าง ๆ อย่าง [mountebank](http://www.mbtest.org/) หรือ [Smocker](https://smocker.dev/) ที่จะต้องมีอย่างน้อย 2 port ขึ้นไปได้แก่

1. Port ที่เอาไว้สร้าง/แก้/ลบข้อมูล (configure) ของ stub เช่น path, port, request, response (ต่อไปนี้จะขอเรียกว่า management port)
2. Port ที่ใช้งาน stub ตามที่กำหนดไว้ข้อแรก (ต่อไปนี้จะขอเรียกว่า stub port)

แผนดูสวยงามนะแต่ปัญหาคือว่า ณ ขณะที่เขียนบทความอยู่ทาง Microsoft ยังไม่รองรับการเปิดเกิน 1 port ตาม [GitHub issues](https://github.com/microsoft/azure-container-apps/issues/546) นี้เลย

ดังนั้นในระหว่างที่ต้องรอนี้เราต้องหาวิธีแก้ไปพลาง ๆ ก่อน ซึ่งวิธีที่เราใช้คือเอา reverse proxy เข้ามาช่วย

## แก้ด้วย reverse proxy
Reverse proxy คือตัว server นี่เชื่อมต่อกับ internet ด้านนอกที่ client จะส่ง request เข้ามา จากนั้นก็จะผ่าน request เข้าไปที่ server ปลายทางที่ไม่ได้เปิดออกสู่ internet ด้านนอกด้วยตัวเอง บางตัวนั้นมันสามารถอ่าน path หรือ header หรืิอ cookie ได้ ซึ่งเป็นสิ่งที่เราต้องการเนื่องจาก path ของ stub server นั้นมันเปลี่ยนไปตามที่เรา configure เลย  

ในบทความนี้เราจะใช้ [NGINX](https://www.nginx.com/) และ [mountebank](http://www.mbtest.org/) เป็นตัวอย่าง อย่างที่บอกไปหัวข้อที่แล้วว่าเรา run application บน container ด้วย Docker ดังนั้นพอเรามาเขียน Dockerfile ก็จะได้รูปร่างหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/247a2cdfd281f73f7eb25c7c570d8a2d.js"></script>

ในส่วนของ mountebank ก็ใช้ base image ตรง ๆ ได้เลย

<script src="https://gist.github.com/raksit31667/73bf4d2fcb48045d5aa6c49e6f1edf82.js"></script>

จะสังเกตว่าความต่างจาก NGINX base image คือแค่เราต้องแทน configuration ดั้งเดิมด้วยของใหม่ของเรา ซึ่งนี่คือจุดที่เราจะต้องมาทำต่อเพื่อให้ reverse proxy ของเราส่ง request ไปหา stub server ให้ถูก port นั่นเอง ก็จะได้หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/8ba51f4e07b7dd11f3b58d2b7119e8c1.js"></script>

**คำอธิบาย**
- เรา configure `worker_connections` แบบ global ผ่าน `events` block เพื่อรองรับ 4096 connection พร้อมกันได้ใน 1 process (จะมีหรือไม่มีก็ได้แล้วแต่ scale)
- ในส่วนของ configuration ที่เกี่ยวกับ reverse proxy โดยเฉพาะก็จะอยู่ใน `http` -> `server` block เป็นส่วนใหญ่
  - ให้ตัว NGINX เองเปิด port ไว้รับ request ที่ port `80` ที่ domain `localhost` เนื่องจากเรา deploy reverse proxy ไว้กับตัว stub server ใน ACA เดียวกัน เลยสามารถเชื่อมกันผ่าน `localhost` ได้เลย
  - ถ้า client อยากจะเชื่อมกับ stub server บน management port (ตัวอย่างคือ port `2525`) ก็ให้ส่งมาที่ path ที่ขึ้นต้นด้วย `/management` ทีนี้เราจะทำการ `rewrite` เพื่อดึง path ส่วนที่อยู่หลัง `/management` มาใช้ในการผ่าน request ไปที่ management port (ตัวอย่างเช่น ถ้า client จะส่ง request ไปที่ stub server ด้วย path `/imposters` ก็จะต้องใช้ path `/management/imposters` เพื่อส่งไปยัง NGINX แทนเพื่อที่ NGINX จะได้ส่ง request ต่อไปที่ `http://localhost:2525/imposters` นั่นเอง)
  -  ถ้า client อยากจะเชื่อมกับ stub server บน stub port ที่เลข port จะเป็น dynamic แต่ที่แน่ ๆ มันเป็นตัวเลขดังนั้นเราสามารถ configure NGINX ให้ใช้ path ที่ขั้นต้นด้วย `/stub` ตามด้วยตัวเลข port ของ stub นั้น ๆ โดย regular expression (regex) จะเป็น `/stub(\d+)(.*)` ในส่วนของ `~*` ก็คือเวลา check regex จะเป็น case-insensitive ถ้าอยากได้เป็น case-senstive ก็จะเป็น `~` แทน
  - ส่ง request ไปหา stub server ที่ `http://localhost:<stub_port>` โดยที่ `stub_port` นั้นก็คือส่วนของเลข port หลัง  `/stub` ตัวอย่างเช่นเรา configure stub ไว้ที่ port `1234` ก็จะต้องใช้ path ขึ้นต้นด้วย `/stub1234` เพื่อให้ NGINX ไปดึงเลข `1234` ผ่าน `$1` (วงเล็บที่ 1 ของ regex pattern)
  - ส่วนที่เหลือก็คือทำการ `rewrite` เพื่อดึง path ส่วนที่อยู่หลัง `/stub<stub_port>` มาใช้ในการผ่าน request ไปที่ stub port ผ่าน `$2` (ตัวอย่างเช่น ถ้า client จะส่ง request ไปที่ stub server ด้วย path `/customers/1a2b` ที่ port `1234` ก็จะต้องใช้ path `/stub1234/customers/1a2b` เพื่อส่งไปยัง NGINX แทนเพื่อที่ NGINX จะได้ส่ง request ต่อไปที่ `http://localhost:1234/customers/1a2b` นั่นเอง)
  - เนื่องจาก port มันเป็น dynamic ใน configuration ของเรา stub server เลยต้องใช้ตัวแปรชื่อ `mountebank_stub_url` แทน ปัญหาคือถ้าเป็นตัวแปร NGINX จะให้เรากำหนด DNS server เพื่อให้ resolver มาใช้ในการแปลง `localhost` ไปเป็น IP ของ Docker ดังนั้นเราจึงต้องใส่ `http` -> `resolver` block เป็น DNS server ของ Docker ซึ่งก็คือ `127.0.0.11` 

## ผลลัพธ์
เพื่อพิสูจน์ว่าใช้ได้จริงเราก็เอาไป deploy บน ACA แล้วก็ส่ง request เข้าไปผ่าน ACA ingress URL ดูผ่าน path `/management` ก็จะได้ประมาณนี้

<script src="https://gist.github.com/raksit31667/7f4019ba19991182b8dc85c98e2db0fc.js"></script>

> วิธีแก้นี้น่าจะพอใช้ไปได้พลาง ๆ แต่ทั้งนี้ทั้งนั้นถ้าทาง Microsoft เค้ารองรับให้ใช้ port หลาย ๆ อันได้ก็จะเปลี่ยนไปใช้ของเค้าดีกว่าเพราะ configuration แบบนี้ก็ซับซ้อนและต้องศึกษาการใช้งาน NGINX ในระดับนึงเลย

## References
- [Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)
- [Embedded DNS server in user-defined networks](https://docs.docker.com.zh.xy2401.com/v17.09/engine/userguide/networking/configure-dns/)