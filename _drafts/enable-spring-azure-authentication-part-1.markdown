---
layout: post
title:  "มาทำ API Security ใน Spring Boot ตาม OWASP PI Security Project กัน (Part 1)"
date:   2020-03-14
tags: [spring, azure, security]
---
เนื่องจากมีโอกาสได้อ่าน [OWASP API Security Project](https://owasp.org/www-project-api-security/) ดังนั้นจึงมาปรับปรุง Security ของตัวเองซะหน่อย โดยจะเริ่มจากระบบงานพัฒนาด้วย Spring ที่ไม่เคยทำอะไรเกี่ยวกับ Security เลย  

ขอแบ่งเป็นตอนๆ ไปละกันเพราะใจว่าจะทำให้ครบ 10 ข้อเลย แต่น่าจะยาวเกิน  

## เริ่มจาก API2:2019 Broken User Authentication
มักเกิดจากการทำ Authentication แบบผิดๆ ทำให้คนที่จะโจมตี API เราสามารถคาดเดาได้ง่าย เช่น
- Basic authentication (username / password) ที่ง่ายต่อการโดนเดา password ถูกแบบ brute force
- เอา Credentials ติดไปกับ URL
- ไม่มีการ validate token ที่เข้ามา ทั้ง Signed algorithm และ expiring date

วิธีการป้องกัน
- ใช้ Standard end-user authentication เช่น OAuth หรือ Multi-factor
- ตั้ง expiry date ของ access token ให้สั้นๆ เช่น 30 นาที หรือ 1 ชั่วโมง

ตัวอย่างระบบจะทำ OAuth2 authentication บน API ที่พัฒนาด้วย Spring Boot กัน โดยมี feature คร่าวๆ ดังนี้
- User สามารถ create Order ได้ (Write access)
- User สามารถ find Order จาก id และ query parameters ได้ (Read access)


## อธิบาย JWK, JWT, Issuer, tokenStore, Azure AD, authorization server, resource server

## อธิบายลักษณะ Azure access token

## สร้าง JWT validator ขึ้นมา

## configure ให้ Global security method ใช้ @PreAuthorize ผ่าน hasApplicationRole ใน JWT validator

## configure resource server ให้ใช้ tokenStore ของ issuer และ resource id นี้

## configure resource server ให้เปิด authentication ใน method ที่มี @PreAuthorize