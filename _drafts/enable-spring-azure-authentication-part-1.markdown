---
layout: post
title:  "มาทำ API Security ใน Spring Boot ตาม OWASP API Security Project กัน (Part 1)"
date:   2020-03-18
tags: [spring, azure, security]
---
เนื่องจากมีโอกาสได้อ่าน [OWASP API Security Project](https://owasp.org/www-project-api-security/) ดังนั้นจึงมาปรับปรุง Security ของตัวเองซะหน่อย โดยจะเริ่มจากระบบงานพัฒนาด้วย Spring ที่ไม่เคยทำอะไรเกี่ยวกับ Security เลย  

ขอแบ่งเป็นตอนๆ ไปละกันเพราะตั้งใจว่าจะทำให้ครบ 10 ข้อเลย แต่น่าจะยาวเกินไปใน blog เดียว  

## เริ่มจาก API2:2019 Broken User Authentication
มักเกิดจากการทำ Authentication แบบผิดๆ ทำให้คนที่จะโจมตี API เราสามารถคาดเดาได้ง่าย เช่น
- Basic authentication (username / password) ที่ง่ายต่อการโดนเดา password ถูกแบบ brute force
- เอา Credentials ติดไปกับ URL
- ไม่มีการ validate token ที่เข้ามา ทั้ง signed algorithm และ expiring date

### วิธีการป้องกัน
- ใช้ Standard end-user authentication เช่น OAuth หรือ Multi-factor
- ตั้ง expiry date ของ access token ให้สั้นๆ เช่น 30 นาที หรือ 1 ชั่วโมง

### อธิบาย JWK, JWT, Issuer, tokenStore, Azure AD, authorization server, resource server
- JSON Web Token (JWT) หมายถึง ข้อมูลที่ระบุ identity ของ client ในรูปแบบของ JSON ซึ่งถูกเข้ารหัส (sign) เป็น token
- JSON Web Signature (JWS) หมายถึง signature ที่เกิดจากการ sign JWT ด้วย authorization server 
- JSON Web Key (JWK) หมายถึง ข้อมูลที่ใช้ในการ validate JWS ในรูปแบบของ JSON ซึ่งมันคือ public key ที่ได้รับมาจาก authorization server
- Authorization Server (Identity Provider) หมายถึง server ที่ทำการ sign JWT จาก request ของ client
- Resource Server หมายถึง server ที่ทำการ validate JWT โดยใช้ JWK ซึ่งได้รับมาจาก authorization server

เราจะในคำเหล่านี้มาร้อยกันเป็น flow ของ token-based authentication ที่สามารถอธิบายได้ตามรูปนี้เลย
[https://redthunder.blog/2017/06/08/jwts-jwks-kids-x5ts-oh-my/](https://redthunder.blog/2017/06/08/jwts-jwks-kids-x5ts-oh-my/)

ใน flow นี้ยังไม่ได้ครอบคลุมตัวอย่างที่เรากำลังจะทำทั้งหมดนะครับ มันยังมี component บางอย่างซ่อนอยู่ เช่น
- JWK Token Store หมายถึง ที่จัดเก็บ JWT ตั้งอยู่ใน resource server ที่ได้รับมาจาก client ใช้สำหรับ decode JWT และ verify JWS ด้วย JWK
- Token Issuer หมายถึง web หรือบริษัทที่เป็นเจ้าของ JWT ซึ่งในตัวอย่างเราจะใช้ Azure นั่นเอง

> ตัวย่อแม่งจะเยอะไปไหน...

ตัวอย่างระบบจะทำ OAuth2 authentication บน API ที่พัฒนาด้วย Spring Boot กัน โดยมี feature คร่าวๆ ดังนี้
- User สามารถ create Order ได้ (Write access)
- User สามารถ find Order จาก id และ query parameters ได้ (Read access)

### อธิบายลักษณะ Azure access token
ส่วนที่ 1 คือ token type และ algorithm ที่ใช้ sign
<script src="https://gist.github.com/raksit31667/1bc2211735f9ed91255fe1fbb88b8292.js"></script>
ส่วนที่ 2 คือ data
<script src="https://gist.github.com/raksit31667/d966c1dbf4d24aa6e3a738dd178ce526.js"></script>
ส่วนที่ 3 คือ การ verify signature ซึ่งขึ้นอยู่กับ algorithm ที่ใช้ sign

### ติดตั้ง Dependencies สำหรับการทำ OAuth2 authentication
- spring-security-oauth2-autoconfigure สำหรับการทำ token store
- java-jwt สำหรับการ decode JWT token
<script src="https://gist.github.com/raksit31667/89b00772e1a6aed5931c7d49bd660f31.js"></script>

### สร้าง JWT validator ขึ้นมา
<script src="https://gist.github.com/raksit31667/bfe4975f9013ad5eb2cc0286e8a2db2d.js"></script>
<script src="https://gist.github.com/raksit31667/e12e56019717fefb4557e9a281ff0aaf.js"></script>

### configure ให้ Global security method ใช้ @PreAuthorize ผ่าน hasApplicationRole ใน JWT validator
<script src="https://gist.github.com/raksit31667/e3fe0dafabae9347b3c9e8b9cc52e940.js"></script>

### configure resource server ให้ใช้ tokenStore ของ issuer และ resource id นี้
### configure resource server ให้เปิด authentication ใน method ที่มี @PreAuthorize
<script src="https://gist.github.com/raksit31667/d1d266bf42651706b59a816d420ff6fd.js"></script>

### configure OAuth2 security resource
<script src="https://gist.github.com/raksit31667/ac282138387a526725f66497dd39d8be.js"></script>

### เพิ่ม @PreAuthorize ใน Spring RestController method
<script src="https://gist.github.com/raksit31667/8666af06e9a93ca3cab23550d39d7cf2.js"></script>

### get access token มาจาก Azure ผ่าน Postman
<script src="https://gist.github.com/raksit31667/7a6f16fa99ffd89795440c72ba177178.js"></script>
