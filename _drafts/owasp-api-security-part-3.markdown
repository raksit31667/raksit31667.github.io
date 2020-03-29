---
layout: post
title:  "มาทำ API Security ใน Spring Boot ตาม OWASP API Security Project กัน (Part 3)"
date:   2020-03-29
tags: [spring, azure, owasp, security]
---
## API5:2019 Broken Function Level Authorization
เกิดจาก API ที่ไม่แยกการทำ authorization ระหว่าง user ปกติและ admin เช่น
- User สามารถทำ operation `createOrder` ได้เท่านั้น
- Admin สามารถทำ operation `createOrder` และ `deleteOrder` ได้

ทำให้คนที่โจมตี API ของเราสามารถ `deleteOrder` ได้โดยที่ตนเองเป็นแค่ user ปกติ หรือเข้าถึง resources ของคนอื่นได้

### วิธีการป้องกัน
[อ้างอิงจากการทำ authentication ใน Part 1]({% post_url 2020-03-18-owasp-api-security-part-1 %}) เหตุการณ์นี้จะเกิดขึ้นถ้าไม่มี `JwtEvaluator` เพื่อเช็ค role ก่อน ดังนั้นจากตัวอย่างเราจะต้องป้องกัน operation `deleteOrder` ให้ access ได้แค่ admin เท่านั้น เราสามารถกำหนด role ใน application ของเราได้ 2 แบบ

#### แบบที่ 1 กำหนดตาม User privilege
คร่าวๆ จะได้มา 2 roles คือ `USER` กับ `ADMIN` ซึ่งสามารถ access endpoint `POST /orders` ได้ทั้งคู่ มีเพียงแค่ `ADMIN` เท่านั้นที่ access endpoint `DELETE /orders/{orderId}` เราจะได้ implementation หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/cd94ed6df2715adc9768dc8b9c27e002.js"></script>

มีข้อเสียคือ ถ้าในอนาคตมีการเพิ่ม role ใหม่เป็น
- User สามารถทำ operation `createOrder` ได้
- Superuser สามารถทำ operation `createOrder` และ `updateOrder` ได้
- Admin สามารถทำ operation `createOrder` `updateOrder` และ `deleteOrder` ได้

<script src="https://gist.github.com/raksit31667/6d67034ccac453b87932087904019f0d.js"></script>
คนที่เข้ามาดู​ code ของเรา ก็จะเห็นได้เลยว่า role ไหนทำอะไรได้บ้าง

#### แบบที่ 2 กำหนดตาม Operation
จำนวนของ role ทั้งหมดใน application เราจะมีจำนวนอย่างน้อยมากกว่าหรือเท่ากับจำนวนของ operation ทั้งหมด เช่น
- CREATE สามารถทำ operation `createOrder` ได้เท่านั้น
- UPDATE สามารถทำ operation `updateOrder` ได้เท่านั้น
- DELETE สามารถทำ operation `deleteOrder` ได้เท่านั้น

แบบนี้จะมีความยืดหยุ่นมากกว่าแบบแรกในการปรับแก้ role เนื่องจากไม่ขึ้นอยู่กับ user แต่เป็น operation แทน ทำให้จากตัวอย่างการเพิ่ม role ด้านบน เราจะได้ `role` claim ใน Azure access token ดังนี้

#### User
```json
{
    "roles": [ "CREATE" ]
}
```

#### Superuser
```json
{
    "roles": [ "CREATE", "UPDATE" ]
}
```

#### Admin
```json
{
    "roles": [ "CREATE", "UPDATE", "DELETE" ]
}
```

ส่วน implementation จะได้หน้าตาประมาณนี้
<script src="https://gist.github.com/raksit31667/0d3f3225276d55372d43ebcc55e6667d.js"></script>