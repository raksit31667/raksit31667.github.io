---
layout: post
title:  "จัดการ error response ของ OAuth2 authentication บน Spring"
date:   2020-04-11
tags: [security, oauth, spring]
---
เมื่อ [blog ก่อนๆ]({% post_url 2020-03-18-owasp-api-security-part-1 %}) ได้ทำ OAuth2 authentication ให้กับระบบงาน พอลองเล่นกับพวก error พบว่าระบบ return response กลับไปไม่เหมือนกัน
<script src="https://gist.github.com/raksit31667/b7c487a5f27a2e537fba3d0c8f3a51d8.js"></script>

ผมคิดว่าเราควรจะต้องปรับปรุง API ของเราให้ return response ในรูปแบบที่คล้่ายๆ กัน และ HTTP status code (401, 403) สื่อถึง error ที่เกิดขึ้นจริงๆ (แต่ถ้าใครมาทางลัทธิส่ง HTTP status code 200 ต่างกันที่ error message ก็แล้วแต่)  

### ขอหยิบยกส่วนของ resource server configuration จาก blog ก่อนขึ้นมา
<script src="https://gist.github.com/raksit31667/d1d266bf42651706b59a816d420ff6fd.js"></script>

### สร้าง SecurityExceptionHandler ขึ้นมา
<script src="https://gist.github.com/raksit31667/c5e00eeedb08741aaf652fcecc7bade5.js"></script>
**คำอธิบาย**
ทำการ handle ทั้ง authentication และ authorization error โดยสร้าง ResponseEntity ของ Spring ขึ้นมา จากนั้นก็แปลงเป็น HttpServletResponse โดยใช้ Jackson เป็นตัว map Java Object เป็น JSON String

### เสร็จแล้วก็ไป configure resource server ให้ใช้ handler ตัวนี้
<script src="https://gist.github.com/raksit31667/02475853a4a93c6a22e40688cce8b142.js"></script>

### ทำการทดสอบด้วยการใช้ API
<script src="https://gist.github.com/raksit31667/45bf9bac064cbe68002cbdfd7d348477.js"></script>

 > ไปดูตัวอย่างโค้ด [https://github.com/raksit31667/example-spring-order](https://github.com/raksit31667/example-spring-order)