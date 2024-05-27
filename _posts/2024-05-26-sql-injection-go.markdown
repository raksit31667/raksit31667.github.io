---
layout: post
title: "ตอบคำถามเรื่องของการป้องกัน SQL injection บนระบบภาษา Go"
date: 2024-05-26
tags: [go, database, postgresql, security]
---

บทความนี้ก็ยังอยู่กับการได้รับโอกาส[ไปแบ่งปันประสบการณ์](https://medium.com/@msrisawatvichai/go-intensive-workshop-5b62d3f3116b) ว่าด้วยเรื่องของ software engineering practice ผ่านการพัฒนาระบบด้วยภาษา Go แต่จะเป็นการตอบคำถามคนเรียนเกี่ยวกับการใช้ SQL ในการ query จาก database ด้วย Go package [database/sql](https://pkg.go.dev/database/sql) ซึ่งใน session ถามมา-ตอบไป เราคิด(ไปเอง)ว่าตอบได้ถูกแล้ว แต่ยังมันเนียนกว่านี้ได้อีก ก็เลยเอามาบันทึกไว้เผื่อโอกาสหน้าละกัน

## ปัญหาของการใส่ user input ลงไปตรง ๆ
จาก code ตัวอย่างนี้คือการ query ข้อมูล user จาก database โดยรับ id มาจาก parameter แล้ว return JSON ของ `User` struct กลับไป ซึ่งในที่นี้เราใช้ [Echo](https://echo.labstack.com/) เป็น HTTP framework 

<script src="https://gist.github.com/raksit31667/8b698a62e4a7b684b94631ad872ccde1.js"></script>

สิ่งที่สังเกตเห็นได้คือมีการนำ input จาก user request (ในที่นี้คือ id) มาต่อกับ SQL statement ตรง ๆ ซึ่งถ้าใส่ parameter เป็นตัวเลขปกติแบบนี้ก็ไม่ได้มีปัญหาอะไร 

```
GET http://localhost:1323/users/1
```

เพราะว่า query ที่สั่ง database จะเป็นหน้าตาประมาณนี้

```sql
SELECT id, name, email FROM "user" WHERE id = 1;
```

ผลลัพธ์ก็จะได้หน้าตาประมาณนี้

```json
{
    "id": 1,
    "name": "raksit",
    "email": "raksit.m@ku.th"
}
```

แต่ถ้าใส่ parameter เป็น `1; DROP TABLE "user"` หนังชีวิตจะเกิดขึ้นทันที

```
GET http://localhost:1323/users/1; DROP TABLE "user"
```

เพราะว่า query ที่สั่ง database จะเป็นหน้าตาประมาณนี้

```sql
SELECT id, name, email FROM "user" WHERE id = 1; DROP TABLE "user";
```

ผลลัพธ์ก็จะได้หน้าตาเหมือนเดิมในการ query ครั้งแรก

```json
{
    "id": 1,
    "name": "raksit",
    "email": "raksit.m@ku.th"
}
```

แต่การ query ครั้งถัด ๆ ไปจะได้ผลลัพธ์ว่า table user ของเราไม่มีแล้ว เพราะถูก drop ทิ้งไปนั่นเอง

```
"pq: relation \"user\" does not exist"
```

สำคัญกว่าคือข้อมูลที่มีอยู่ใน table ก็หายหมดเกลี้ยง ถ้าเป็นระบบบน production บอกได้เลยว่า "งานเข้า"

## วิธีป้องกัน SQL injection
วิธีป้องกันคือใช้ [parameterized queries](https://go.dev/doc/database/querying) SQL injection โดย Go package `database/sql` จะส่ง SQL statement แยกไปกับ parameter ทำให้ parameter นั้นไม่กลายเป็น code ที่จะถูก execute ได้ จากตัวอย่างใน code ของเรา ก็ให้เปลี่ยนไปใช้ parameterized queries ก็จะได้หน้าตาประมาณนี้ 

<script src="https://gist.github.com/raksit31667/4a70e92fea3ae6c740a07da3ddc0bbf0.js"></script>

โดยใน query เราแค่ต้องระบุจุดที่จะใส่ parameter ในรูปแบบ `?`, `$1`, `$2` (อันนี้แล้วแต่ database ที่เราใช้เลย) ซึ่งก็จะเหมือนกับท่าการทำ SQL [prepared statement](https://en.wikipedia.org/wiki/Prepared_statement) เช่นถ้าส่ง parameter `id` ที่มีค่า `1` เข้าไปก็จะได้ประมาณนี้

```sql
PREPARE stmt (INT) AS
SELECT id, name, email FROM spender WHERE id = $1;

EXECUTE stmt(1);

DEALLOCATE stmt;
```

## ผลลัพธ์
หลังจากปรับแก้ code ลองใส่ parameter เป็น `1; DROP TABLE "user"` ดู

```
GET http://localhost:1323/users/1; DROP TABLE "user"
```

Query ที่สั่ง database จะเป็นหน้าตาประมาณนี้

```sql
PREPARE stmt (INT) AS
SELECT id, name, email FROM spender WHERE id = $1;

EXECUTE stmt('1; DROP TABLE "user"');

DEALLOCATE stmt;
```

ผลลัพธ์ก็จะได้ error ออกมา แต่เป็น SQL syntax error แทน

```
"pq: invalid input syntax for type integer: \"1; DROP TABLE \"user\"\""
```

เพราะว่าตอนเรา prepare statement เราต้องใส่ parameter ที่มี type เป็น int ลงไปนั่นเอง  

ทีนี้ลองเปลี่ยน SQL statement ตรง `WHERE` clause จาก `id` ให้เป็น `name`

<script src="https://gist.github.com/raksit31667/820a1471ffb62c107b071539efafab8f.js"></script>

จากนั้น restart แล้วก็ลองยิง API endpoint โดยคราวหน้าจะเปลี่ยนเป็น parameter เป็น `earth; DROP TABLE "user"` (ก่อนหน้านี้ทำการ insert user ที่มี `name` ว่า `earth` ลงไปแล้ว)

```
GET http://localhost:1323/users/earth; DROP TABLE "user"
```

Query ที่สั่ง database จะเป็นหน้าตาประมาณนี้

```sql
PREPARE stmt (VARCHAR) AS
SELECT id, name, email FROM spender WHERE name = $1;

EXECUTE stmt('earth; DROP TABLE "user"');

DEALLOCATE stmt;
```

ผลลัพธ์คือได้ HTTP `404 Not Found` มาแทน เพราะว่าไม่มี user record ที่มี `name` =  `earth; DROP TABLE "user"`

ทีนี้ลองยิง endpoint ด้วย parameter ที่ถูกต้อง

```
GET http://localhost:1323/users/earth
```

ผลลัพธ์ก็คือได้ record ที่ถูกต้องประมาณนี้

```json
{
  "id": 2,
  "name": "earth",
  "email": "rak-sit@hotmail.com"
}
```

ที่เหลือก็ทำการเพิ่ม request validation ตั้งแต่ขารับเพื่อไม่ให้เกิด workload ที่ database มากเกินความจำเป็น และ return custom error เพื่อซ่อน SQL error ไม่ให้ consumer เห็น

## สรุป
จะเห็นว่าหากเราทำการ query จาก database โดยรับ parameter จาก consumer ให้ใช้ parameterized queries เสมอ ซึ่งเบื้องหลังจะเป็น prepared statement แบบในตัวอย่างหรือจะเป็น [stored procedure](https://en.wikipedia.org/wiki/Stored_procedure) ก็แล้วแต่จะเลือกให้เหมาะสมกับ use case ของเราครับ
