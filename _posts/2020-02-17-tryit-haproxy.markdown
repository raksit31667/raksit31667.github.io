---
layout: post
title:  "ลองเล่น Load Balancing ง่ายๆ ด้วย HAProxy"
date:   2020-02-17
tags: [haproxy, load-balancer]
---
## Load balancing คืออะไร
Load balancing คือการส่ง request จาก client ไปยังตัวกลาง (Load balancer) ที่ทำหน้าที่กระจายไปยัง server ต่างๆ ตาม criteria ที่เรากำหนดไว้ ดังนั้นจะไม่มีการ communicate กับระหว่าง client-server โดยตรง ข้อดีของมันคือ
- **Availability** ถ้า server ตัวนึงล่มไป เราก็จะส่ง request ไปหา server ตัวอื่นที่ยังอยู่
- **Performance** เนื่องจาก server ตัวนึงมีโอกาสที่ไม่ต้องรับ load จากทุกๆ request

มีวิธีการกระจาย request รูปแบบที่ต่างกันไป ตาม algorithm ที่ Load balancer มีหรือเรา config ไว้ เช่น
- **Round robin** แต่ละ server ผลัดกันรับ request ตามลำดับ ถ้ารับหมดแล้วก็วนรอบใหม่
- **Least connections** ส่ง request ไปยัง server ที่มี connection น้อยที่สุด
- **Random** สุ่มแม่ง ฮ่าๆๆๆ
แต่ละวิธีก็จะมีการรองรับในกรณีที่ขนาดของ server ไม่เท่ากันด้วย เพื่อเกลี่ย request ให้ server อย่างเหมาะสม (Weighted)  

## รูปแบบของ Load balancing
มี 2 แบบคือ **Layer 4** กับ **Layer 7** แสดงตาม 7 Layers of OSI ดังนี้  

![7 Layers of OSI Model](/assets/2020-02-17-seven-layers-of-OSI-model.png)
[https://viettechgroup.vn/tcp-ip-vs-osi-whats-the-difference-between-the-two-models.nvp](https://viettechgroup.vn/tcp-ip-vs-osi-whats-the-difference-between-the-two-models.nvp)

## ในส่วนของ Layer 4 จะทำ load balancing ผ่าน IP address และ port
โดยตัว load balancer จะใช้ Network address translation (NAT) ในการจับคู่ client กับ server ผ่าน TCP connection เดียว (จินตนาการเหมือนเราเข้า browser เข้าไปที่ www.github.com request จะไปหา router ก่อน จากนั้น router ค่อยส่งไปหา server อีกที) หากใช้ HAProxy จะได้ configuration ตามนี้

<script src="https://gist.github.com/raksit31667/69a6bca929b3592c4df86abc6b101acb.js"></script>

#### คำอธิบาย
load balancer นี้อยู่ในโหมด tcp (layer 4) โดยเข้าผ่าน port 8888 เชื่อมกับ server 2 ตัวคือ localhost:4444 กับ localhost:5555  

## ในส่วนของ Layer 7 จะทำ load balancing ผ่าน data เช่น path
load balancer สามารถทำอะไรกับ client request ที่ถูก decrypt ไปแล้วก็ได้ เช่น add header หรืออื่นๆ เพื่อใช้ในการทำ balancing แต่ก็ต้องแลกมากับการต้องเปิด 2 TCP connection (ระหว่าง client -> load balancer และ load balancer -> server) เพราะว่า TLS ต้องถูก terminate ก่อนในขา client -> load balancer เพื่อ decrypt data นั่นเอง ตรงนี้ก็แล้วแต่เราละว่าจะ encrypt ในขา load balancer -> server อีกทีไหม ตัวอย่าง  

<script src="https://gist.github.com/raksit31667/7b4b1f3ae6e036e5602514fab03f3f6b.js"></script>

#### คำอธิบาย
load balancer นี้อยู่ในโหมด http (layer 7) โดยเข้าผ่าน port 9999 เชื่อมกับ app 2 อันคือ app1 (มี localhost:4444 กับ localhost:5555) และ app2 (มี localhost:7777 กับ localhost:8888) ถ้าเข้า localhost:9999/app1 request จะไปที่ server อันใดอันนึงของ app1 เข้า localhost:9999/app2 request จะไปที่ server อันใดอันนึงของ app2

## แล้วข้อดีข้อเสียล่ะ
สรุปได้ตามตารางนี้  

|           Topic           | Layer 4 | Layer 7 |
|:-------------------------:|:-------:|:-------:|
| ความฉลาดในการทำ balancing |  โง่กว่า  | ฉลาดกว่า |
|         ความปลอดภัย        |  มากกว่า |  น้อยกว่า |
|  การใช้งานกับ microservices |   ไม่ได้  |    ได้   |
|          ความเร็ว          |  เร็วกว่า |  ช้ากว่า  |
|       การทำ caching       |   ไม่ได้  |    ได้   |

***Layer 4*** เร็วและปลอดภัยกว่าเพราะไม่ต้อง decrypt data มาดูจาก request แต่ก็ไม่สามารถใช้กับระบบ microservices ได้เพราะไม่สามารถส่ง request ไป ยัง service ที่ต้องการได้  

***Layer 7*** ฉลาดกว่า เหมาะกับระบบ microservices เนื่องจากสามารถโยงไปที่ service ที่ต้องการได้ แต่ไม่ค่อยปลอดภัยเพราะถ้า attacker เจาะ load balancer ได้ ก็จะได้ decrypted data ไป ส่วนเรื่องความเร็วสามารถแก้ได้ด้วย caching

> ไปดูตัวอย่างโค้ด [https://github.com/raksit31667/tryit-haproxy](https://github.com/raksit31667/tryit-haproxy)


