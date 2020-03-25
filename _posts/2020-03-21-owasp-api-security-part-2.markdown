---
layout: post
title:  "มาทำ API Security ใน Spring Boot ตาม OWASP API Security Project กัน (Part 2)"
date:   2020-03-21
tags: [spring, integration-testing, owasp, security]
---
blog นี้จะมาต่อจาก [Part 1]({% post_url 2020-03-18-owasp-api-security-part-1 %}) ในส่วนของการทดสอบ authentication  

ซึ่งตัวอย่างนี้ผมจะใช้ `RestAssured` ในส่วนของ test script หลัก ส่วน `Spring Security OAuth2 AutoConfigure` และ `java-jwt` สำหรับการเตรียม environment
<script src="https://gist.github.com/raksit31667/cd506ad38cb823d39e14c5d730e9c0e2.js"></script>

## เริ่มจากการ override ResourceServerConfiguration กันก่อน
เพราะเราจะไม่ใช้ `jwkTokenStore` จาก Azure จริงๆ ดังนั้นเราจะต้อง override bean `jwkTokenStore` เป็น in-memory `tokenStore` แทน
<script src="https://gist.github.com/raksit31667/d9466ff7b89a3f671d209d480e5ae9ad.js"></script>
**เพิ่มเติม**
- ต้อง set priority ของ configuration นี้มาเป็นอันดับ 1 ถึงจะสามารถ override `ResourceServerConfiguration` ได้ ไม่งั้น priority มันจะทับกันและจะเกิด error นี้
  
```
Injection of autowired dependencies failed; nested exception is java.lang.IllegalStateException: @Order on WebSecurityConfigurers must be unique. Order of 3 was already used on org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfiguration@f8c1177, so it cannot be used on org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfiguration@173371c7 too.
```

## สร้าง Base class สำหรับการทดสอบ
มีการ setup `RestAssured` และ generate JWT เอง เพื่อใช้ send request และ store ใน `tokenStore` ดังนั้น access token จะตรงกันเสมอ
<script src="https://gist.github.com/raksit31667/38d4f1b2a75243e4cae074a1d9fda447.js"></script>
**เพิ่มเติม**
- จากเรื่อง Azure AD access token claims ใน part 1 เราจะ focus ที่ `roles` claim สำหรับการกำหนด application role (Read หรือ Write)
- กำหนด grant type ให้เป็น `client_credentials` เนื่องจากเรา access resource ของตัวเอง ไม่ใช่ on-behalf of user (อ่านเพิ่มเติมได้ที่นี่ [https://tools.ietf.org/html/rfc6749#section-4.4](https://tools.ietf.org/html/rfc6749#section-4.4)) 

## จากนั้นก็เริ่มเขียน test
อย่าลืม inherit `IntegrationTest` นะครับ
<script src="https://gist.github.com/raksit31667/0ead76645bf3987eef273288aa0c7cce.js"></script>

> ไปดูตัวอย่างโค้ด [https://github.com/raksit31667/example-spring-order](https://github.com/raksit31667/example-spring-order)
