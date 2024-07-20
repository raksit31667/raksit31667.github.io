---
layout: post
title: "คิดให้ดีก่อนที่จะใช้ theme ในการพัฒนา frontend web app"
date: 2024-07-20
tags: [frontend, vue, testing, unit-testing]
---

ในการพัฒนา software ในฝั่งของ frontend หนึ่งในสิ่งที่เป็นตัวชี้วัดคุณภาพ web application คือ user interface ที่ออกแบบมาเพื่อให้ user ใช้งานง่าย ทว่าการได้มาซึ่งสิ่งนี้จะต้องออกแรงเยอะมาก ไม่ใช่แค่ด้าน technical แต่ยังรวมถึงด้านคนและ process ที่เกี่ยวข้องเช่น การทำ user experience, research, prototyping, analytics เป็นต้น ซึ่งสวนทางกับ deadline ที่ในบางครั้งมันก็สั้นซะเหลือเกิน  

เนื่องด้วยสาเหตุดังกล่าวจึงมีแนวคิดของ theming ซึ่งก็คือ library หรือ framework ที่เตรียมของ มาให้โดยที่เราไม่ต้องเขียน HTML เพื่อสร้างมันขึ้นมาใหม่ตั้งแต่เริ่ม เช่น

- การกำหนดสี font และ spacing
- User interface ชิ้นเล็ก ๆ เช่น ปุ่ม card form หรือ menu เป็นต้น
- เครื่องมือและ API เพื่อใช้ในการปรับแต่ง style ต่าง ๆ ได้

Library หรือ framework ยอดนิยมก็อย่างเช่น [Material-UI](https://mui.com/), [Bootstrap](https://getbootstrap.com/) หรือ [Vuetify](https://vuetifyjs.com/en/) เป็นต้น มาดูตัวอย่าง code กันหน่อย

<script src="https://gist.github.com/raksit31667/70a709b22e74f43c812999a3af991583.js"></script>

<script src="https://gist.github.com/raksit31667/ff6facbebc1fb42ba20c7bc3f166a7f5.js"></script>

จะเห็นได้ว่าข้อดีหลัก ๆ ของการใช้งาน theme คือ

- ช่วยทุ่นแรงในการการันตีว่า user interface ใน web app จะไปในทิศทางเดียวกัน ช่วยตอบโจทย์ด้าน user experience ได้ง่ายขึ้น
- ลดเวลาที่ใช้ในการสร้าง application โดยไป focus ที่การใช้งานมากกว่าความสวยงามซึ่งปล่อยให้ theme เป็นคนจัดการ

แต่ในขณะเดียวกันมันก็มีข้อด้อยอยู่ หนึ่งในนั้นก็คือ**เรื่องของการทดสอบในระดับ unit/component testing** ตัวอย่างเช่นเราต้องการจะทดสอบว่าเมื่อกดปุ่มแล้วจะต้องมี modal ขึ้นมาพร้อมกับแสดงตัวหนังสือขึ้นมาได้อย่างถูกต้อง ก็จะได้ code ประมาณนี้

<script src="https://gist.github.com/raksit31667/028414096e888eb7dab9e84aca113349.js"></script>

<script src="https://gist.github.com/raksit31667/c03c20e7e9bef566e844d81efb6c128d.js"></script>

ปรากฎว่าพอ run test ดัน fail เพราะว่าหา text ไม่เจอ ซึ่งพอลอง run server ใน local แล้วกดปุ่มดู text กับ animation มันก็ขึ้นปกตินี่หว่า แสดงว่าการ render ใน test ไม่ถูกต้องละ  

สืบไปสืบมามันเกิดจาก statement เพื่อ check ว่า text นั้นแสดงถูกต้องไหมถูก execute ก่อนที่ animation ของ modal จะเล่นจบเพื่อไป update [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) ก็เลยทำให้มันหา text ไม่เจอ (เราเรียกสิ่งนี้ว่า race condition) ซึ่งมันอาจจะเกิดขึ้นหรือไม่ก็ขึ้นอยู่กับ theme เพราะ

- หากซ่อน component โดยใช้ CSS `display` property เป็น `none` การทดสอบก็ยังคงผ่านอยู่
- หากซ่อน component โดยไม่ render เลย การทดสอบจะไม่ผ่าน

เพื่อตัดปัญหาเรื่อง animation และหรือการซ่อน component เราก็เลยต้อง

- Stub มันเพื่อบอกว่าให้ render component นี้ขึ้นมาโดยไม่ต้องสนใจ animation ละ
- ให้ test ทำการรอให้ DOM update เสร็จก่อนแล้วค่อย run assert statement

Code ที่ออกก็จะได้สภาพประมาณนี้

<script src="https://gist.github.com/raksit31667/31ed5dd023e87965a198167efb44eac2.js"></script>

ซึ่งจะเห็นได้ว่าชุดการทดสอบมี code ที่เกี่ยวกับ theme เยอะขึ้น และผูกติดกับ implementation พอสมควร เมื่อจะ refactor ต้องออกแรงมากขึ้นเพราะต้องปรับแก้ชุดการทดสอบด้วย

## สรุป
ก็ตามหัวข้อนั่นแหละ อยากให้คิดและวิเคราะห์บริบทให้ดีก่อน (ไม่ได้ห้ามนะ เราก็ใช้ในบางโอกาส) ที่จะใช้ theme ในการพัฒนา frontend web app ถึงแม้ว่ามันจะมีประโยชน์ที่ช่วยทุ่นแรงและลดเวลาในการพัฒนาลง แต่ก็ต้องแลกกับการทดสอบในระดับ unit test ที่ยากขึ้น ทำให้ feedback ที่ได้กลับมามันช้าลงไปด้วย
