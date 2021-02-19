---
layout: post
title:  "บันทึกการแบ่งปันเรื่อง Firebase Cloud Messaging ในบริษัท"
date:   2021-02-16
tags: [firebase, javascript, web-push, progressive-web-application]
---

เมื่อวันก่อนผมได้มีโอกาสแบ่งปันความรู้ให้กับเพื่อนร่วมทีมซึ่งจัดทุกๆ 2 อาทิตย์ โดยหัวข้อครั้งนี้คือ Firebase Cloud Messaging เนื่องจาก product ที่ดูแลอยู่นั้นใช้งานอยู่ ประกอบกับมีงานแก้ไขส่วน notification เข้ามาพอดี แต่ตอนทำอยู่เกิดติดปัญหาเป็น blocker ไม่สามารถทำต่อได้ เลยขอแบ่งปันความเจ็บปวดนี้เลยละกัน

## อธิบายระบบคร่าวๆ
Product ที่กำลังทำอยู่เป็น web application (อีกแล้ว ฮ่าๆๆ) มี tech stack ประมาณนี้
- Frontend ใช้ Angular และ firebase ในการ ส่ง firebase token ไปให้ backend และ subscribe notification ตาม topic
- Backend ใช้ Spring Boot สำหรับ register firebase token เข้า topic และส่ง notification ตาม topic

ทุกอย่างก็ทำงานได้ตามปกติ สิ่งที่แย่อยู่อย่างเดียวคือ code ครับ เนื่องจากระบบต้องจัดการกับ background notification และ event เมื่อ user มีการ click ไปที่ notification โดย code ส่วนนั้นอยู่ใน JavaScript file ที่ทดสอบไม่ได้

<script src="https://gist.github.com/raksit31667/335fa45fae8a323842df92b438e788bc.js"></script>

โดยเป้าหมายของงานนี้คือ **ย้ายส่วนของการจัดการ event ต่างๆ ออกมาไว้ใน Angular context**

## ว่าด้วยเรื่องของ Service worker
ระบบของเราเชื่อมกับ Firebase ผ่าน [Service worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) ตามที่แปะข้างบน ซึ่งคร่าวๆ มันคือ **JavaScript file ที่ทำงานแยกกับ browser หลัก** (คนละ thread กัน) โดยมีความสามารถหลากหลาย

- การทำงาน background process
- การส่ง push notification
- การ cache หรือ pre-fetch ข้อมูล

Firebase จะรู้จักเรา ผ่าน SDK (Software development kit) ใน [Firebase Console](https://console.firebase.google.com/) และเอาไปใส่ไว้ใน service worker

![Firebase SDK](/assets/2021-02-19-firebase-sdk.png)

จากนั้นเราก็ทำระบบ notification และจัดการ event ต่างๆ เป็นอันเสร็จ  

**ปล.** ในส่วนของ application อย่าลืม unregister ใน `onDestroy` นะครับ ไม่งั้น notification ตามเป็นเงา  

## ปัญหาที่เจอ
เนื่องจาก Service worker ไม่สามารถเข้า DOM (Document object model) ได้ตรงๆ ดังนั้นจะต้องทำผ่าน `postMessage()` ประมาณนี้

<script src="https://gist.github.com/raksit31667/8e862f0eebcd68654ba31b12a4efb4ed.js"></script>

ดังนั้นเราไม่สามารถจะย้าย code ในส่วนของ event ไปได้เลย

## Enter PWA
จาก discussion ใน [Angular issues ใน GitHub](https://github.com/angular/angular/issues/34352) หนึ่งในวิธีที่ได้ลองทำคือ การเปลี่ยน web application เป็น [PWA](https://web.dev/what-are-pwas/) (progressive web application) ซึ่งรวมข้อดีของ web application (รันได้ทุกที่ถ้ามี internet กับ web browser) กับ native application (interact กับ hardware และ software ได้เยอะกว่า จินตนาการถึง mobile application) ซึ่งทาง [Angular รองรับ service worker ผ่าน PWA ไว้แล้ว](https://angular.io/guide/service-worker-communications) โดย `@angular/service-worker` มี interface ที่เราจะใช้อยู่ 2 ตัว

- [SwUpdate](https://angular.io/api/service-worker/SwUpdate) สำหรับ check ว่ามีการ update service worker ไหม เพื่อจะได้ download version ใหม่ลงมา (ตรงนี้ทำให้ผมค้นพบปัญหาในระบบเพิ่มเพราะว่ายังไม่ได้ handle case นี้)
- [SwPush](https://angular.io/api/service-worker/SwPush) สำหรับ request subscription รับ notification และจัดการ notification click event (ครบเลย)

<script src="https://gist.github.com/raksit31667/7879e5760d6796dea717d7e55294af82.js"></script>

ในส่วนของการ request subscription เราจะใช้ [Web Push Protocol](https://developers.google.com/web/fundamentals/push-notifications/web-push-protocol) ซึ่งมีขั้นตอนดังนี้

1. Generate VAPID key (Voluntary Application Server Identity) ซึ่งจะได้คู่ของ public key และ private key มา โดยจะ generate ผ่าน [website](https://vapidkeys.com/) หรือทำผ่าน Firebase Console ก็ได้ โดยเข้าไปที่ `Project settings > Cloud Messaging > Web configuration > Web Push certificates` ตามรูปข้างล่าง

![Firebase VAPID keys](/assets/2021-02-19-firebase-webpush-vapid-keys.png)
Public key คือ `Key pair` และ private key กดดูจาก `Show private key`

2. Backend register WebPush โดย**ใช้ public และ private key**
3. Frontend ทำการ request subscription โดย**ใช้แค่ public key ลงไปเท่านั้น**
4. Frontend ส่ง subscription ให้ backend
5. Backend รับ subscription แล้ว store ไว้ใน persistence สักที (อาจจะเป็น Firestore หรือ NoSQL database ก็ได้)

จากข้อมูลตรงนี้ จะได้ implementation หน้าตาประมาณนี้ โดยที่เราสามารถย้าย logic ส่วนของการจัดการ event มาได้เลย

<script src="https://gist.github.com/raksit31667/3329dc5652676bec609c0f6f38dac4e0.js"></script>

<script src="https://gist.github.com/raksit31667/e1f1ac36a3494583715813a1623305dd.js"></script>

## ข้อจำกัดของ PWA
ตามที่ [official documentation](https://angular.io/guide/service-worker-getting-started#serving-with-http-server) บอกไว้ ดังนั้นเราจะเสียความสามารถ live reload เวลาเราแก้ไข file ไป จะต้องมา rebuild และ serve ใหม่ทุกครั้ง มันก็จะรบกวน development productivity ไปเยอะอยู่เหมือนกัน  

ในส่วนของ WebPush จะใช้ได้เฉพาะ web application เท่านั้น (ก็ตามชื่ออ่ะนะ) ดังนั้นถ้าระบบเราเป็น cross-platform หรือ support native iOS และ Android ก็ต้องมี dual maintenance ด้วย  

## สรุป
- ได้ความรู้เกี่ยวกับ Service worker และ PWA ไปพอประมาณ
- ยังไม่ได้เจอ best solution นะครับ ก็ต้องค้นหากันต่อ รวมถึงตามดู update จากทาง Angular ต่อไป
