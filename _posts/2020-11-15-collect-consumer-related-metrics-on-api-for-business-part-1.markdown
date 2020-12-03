---
layout: post
title:  "บันทึกการเก็บ metrics เกี่ยวกับ consumer ใน API เพื่อวัด business value (Part 1)"
date:   2020-11-15
tags: [spring, prometheus, monitoring]
---

## มาเข้าใจกันก่อนว่าทำไปทำไม

เรามีโจทย์ที่ทีมซึ่งมี business และ technical ต้องทำร่วมกันคือ เราจะวัดผลว่าระบบของเรามันมี business value อย่างไร ซึ่งถ้าระบบของเรามันเป็น customer-facing applications ก็ดีไป *แล้วถ้าไม่ใช่ละ จะวัดกันอย่างไร*  

ทีมจึงได้ข้อสรุปร่วมกันว่า เราจะวัดผลจากยอดการใช้งานละกัน เช่นระบบของเราหลังบ้านเป็น API เช่น วัดเอาว่า แต่ละ service แต่ละ feature ลงไปลึกถึงแต่ละ endpoint มีผู้ใช้งานกี่คน แต่ละคนเรียกใช้งานระบบกี่ครั้ง เป็นต้น  

ปัญหาคือ แล้วเราจะเก็บค่าจากไหน เนื่องจากระบบของเราไม่ได้เก็บไว้ว่ามี user คนไหนบ้าง เรา authenticate และ authorize ผ่าน OAuth authentication ดังนั้น JWT token จึงเป็นข้อมูลที่ทำให้รู้ข้อมูล user ซึ่งพบใน JWT claim ต่างๆ อย่างใน Azure Active Directory เราสามารถรู้ service principal ได้ผ่าน `appid` claim  

หนึ่งในไอเดียที่ทำร่วมกับทีมคือเราต้องเพิ่ม identifier หรือ tag ลงไปใน metrics ที่ service แสดง เพื่อจำแนกการใช้งานของ consumer  

```jsonc
{
  "aud": "...",
  "iss": "https://sts.windows.net/.../",
  "iat": 123456789,
  "nbf": 123456789,
  "exp": 123456789,
  "aio": "...",
  "appid": "...",
  "appidacr": "1",
  "idp": "https://sts.windows.net/.../",
  "oid": "...",
  "rh": "...",
  "roles": [
    "Write",
    "Read"
  ],
  "sub": "...",
  "tid": "...",
  "uti": "...",
  "ver": "1.0"
}
```

## การแก้ปัญหาแบบวิถีชาว Economy
ขึ้นชื่อว่า economy แน่นอน tool ที่เราเลือกใช้ก็ต้องมาจาก opensource โดยเราจะใช้ 

- Spring Web
- Spring Security
- Spring Actuator
- Micrometer with Prometheus

ซึ่งแต่ละ metric เค้าจะมี tag สำหรับจัดกลุ่ม เช่น HTTP method endpoint หรือ status ของข้อมูล  

```sh
http_server_requests_seconds_count{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/orders/{orderId}",} 1.0
```

อย่าง metrics นี้คือมีการใช้ HTTP request `GET /orders/{orderId}` ผลลัพธ์คือ HTTP `200 OK` ดังนั้นเราสามารถเพิ่ม tag เกี่ยวกับ consumer ลงไปได้ตามโค้ดนี้เลย

<script src="https://gist.github.com/raksit31667/2bcfc3b06e65ada30f7569f0897f5623.js"></script>

สิ่งที่เกิดขึ้นคือตอนที่จะ tag metrics ระบบจะไปทำการ decode JWT token เพื่อเอา claim ที่ชื่อว่า `appid` มาใส่เป็น value ของ tag `consumer` ถ้า request ที่ call มาไม่มี authentication หรือ JWT token ก็จะเข้า `catch` block ให้แปะ `consumer` ที่มีค่าเป็น blank ลงไป เมื่อลองทดสอบก็จะได้ค่ามาประมาณนี้  

```sh
http_server_requests_seconds_count{consumer="029a0ed2-bf62-49ff-8e39-1d80f909d9bd",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/orders/{orderId}",} 1.0
```

### แน่นอนว่าทำงานได้
แต่ข้อเสียคือระบบเราต้อง decode JWT token 2 ครั้ง (ครั้งแรกตอนทำ authentication) ดังนั้นเรามาลดการ decode JWT token ให้เหลือแค่ครั้งเดียวพอ โดยการเพิ่มสิ่งที่เรียกว่า [filter](https://spring.io/guides/topicals/spring-security-architecture) ลงไป ซึ่งจะมี **FilterChainProxy** ไว้กระจาย request ไปตาม **filter chain** ที่เรากำหนดไว้

สร้าง filter สำหรับการ decode JWT เพื่อเอา claim `appid` กับ `roles` แล้วเก็บลงไปใน `HttpServletRequest`

<script src="https://gist.github.com/raksit31667/5c174c2b236b71e9a1312e7fa482b0ff.js"></script>

แล้วก็เพิ่ม filter ลงไปก่อนเข้า default authentication / authorization filter

<script src="https://gist.github.com/raksit31667/9a5bea77f3aa57694b4ccb7193c57609.js"></script>

ในส่วนของ Prometheus tag ก็มาแก้ให้ไปดึง `appid` จาก `JwtUser` แทน

<script src="https://gist.github.com/raksit31667/35eaf9aa287aae79440a2da08ad9fd40.js"></script>

## Part ต่อไป
เนื่องจากระบบปัจจุบันใช้ [Datadog]({% post_url 2020-10-21-enable-datadog-logs-and-apm-in-java-k8s %}) เป็น monitoring solution จะมาลองแก้ปัญหาเดียวกันใน Datadog ดูครับ

> Sample code: <https://github.com/raksit31667/example-spring-order>