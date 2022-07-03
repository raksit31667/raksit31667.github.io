---
layout: post
title:  "ว่าด้วยเรื่องของ API response สำหรับข้อมูลที่เป็น optional"
date:   2022-07-03
tags: [rest, api]
---

เมื่ออาทิตย์ก่อนมีงานที่ต้องเพิ่ม key ใหม่ลงไปใน API endpoint response ซึ่ง key ใหม่จะมีค่าบ้างไม่มีค่าบ้างขึ้นอยู่กับข้อมูล (optional) ระหว่าง design เกิดประเด็นที่น่าสนใจขึ้นมาว่า

> เราจะ return response สำหรับข้อมูลที่เป็น optional ในรูปแบบไหนดี

โดยหลัก ๆ ที่นึกได้ ณ ตอนนั้นจะมี 2 ทางเลือก โดยสมมติว่า `email` เป็น optional

## 1. Return key ที่มี value เป็น null

```json
{
    "firstName": "John",
    "lastName": "Doe",
    "email": null
}
```

## 2. ไม่ return key ออกไปเลย

```json
{
    "firstName": "John",
    "lastName": "Doe"
}
```

เราจะมาวิเคราะห์กันว่าเราจะเลือกวิธีไหนกันดี

## เรื่องของ domain modeling
ถ้า API response เรามี optional value ลักษณะแบบนี้เยอะ ๆ นั่นอาจเป็นสัญญาณว่า API resource ที่เรา return นั้นออกแบบมาให้ใช้งานได้หลากหลาย use case มากจนเกินไป ดูเหมือนจะใช้ง่าย แต่ในระยะยาวจะส่งผลให้ API consumer เกิดความซับซ้อนเนื่องจากจะต้องเขียน business logic เพื่อมาตรวจสอบ optional value หลาย ๆ อัน ยกตัวอย่างเช่น  

จะออกแบบ API สำหรับ ครู-นักเรียน (teacher-student) แต่ปรากฎว่าดันเก็บข้อมูลไว้ใน table เดียวกันชื่อว่า user ก็เลยใช้ resource เดียวกันชื่อว่า `/users` เลยได้หน้าตาออกมาประมาณนี้

```jsonc
// GET /users/{userId}
{
    "firstName": "John",
    "lastName": "Doe",
    "subject": "Math", // null สำหรับ student
    "enrollmentDate": "2022-07-13" // null สำหรับ teacher
}
```

ทำให้ API consumer จะต้องเพิ่มเงื่อนไขว่า

```js
if (subject != null) {
    // do business logic about teacher
}
else if (enrollmentDate != null) {
    // do business logic about student
}
else {
    // throw an exception
}
```

- ถึงแม้หน้าตาของข้อมูลจะมีความคล้ายกัน แต่มันก็ไม่ได้หมายความว่ามันจะเป็นสิ่งเดียวกัน (domain เดียวกัน)
- ถึงแม้เราจะเก็บข้อมูลไว้ที่เดียวกัน แต่มันก็ไม่ได้หมายความว่าเราจะต้องใช้ endpoint หรือ ใช้ response เดียวกัน

ดังนั้นเราสามารถออกแบบ domain model ใหม่ให้แยกเป็น teacher และ student ออกจากกัน จะได้

```jsonc
// GET /teachers/{teacherId}
{
    "firstName": "John",
    "lastName": "Doe",
    "subject": "Math"
}
```

```jsonc
// GET /students/{studentId}
{
    "firstName": "John",
    "lastName": "Doe",
    "enrollmentDate": "2022-07-13"
}
```

> ถ้า domain modeling ได้ถูกปรับปรุงแก้ไขแล้ว บางทีก็ไม่จำเป็นที่จะต้องมาพูดถึงเรื่อง optional value เลย

ในบางครั้งก็เป็นเรื่องยากที่จะออกแบบ domain modeling เช่นมี optional value ที่ขึ้นอยู่กับแต่ละประเทศในโลก การที่จะมาออกแบบ API endpoint ให้รองรับแต่ละประเทศเป็น 100 กว่าอัน ทำได้ยากและซับซ้อนมาก วิธีแก้ก็อาจจะต้องลงเอยด้วยการสร้าง API endpoint ให้ใช้งานได้ทุกประเทศ แต่ต้องนำ field มายัดไว้ใน object ที่ประกอบด้วย key-value แบบนี้

```jsonc
// GET /users/{userId}
{
    "user": [
        {
            "key": "optional1",
            "value": "..."
        },
        {
            "key": "optional2",
            "value": null
        }
    ]
}
```

แน่นอนว่าหลีกเลี่ยงไม่ได้ที่ API consumer จะต้องรู้ว่าจะเลือก key ไหนที่ตัวเองสนใจ

## เรื่องของ backward compatibility
หนึ่งในสิ่งที่ต้องพิจารณาในเรื่องของการดูแลรักษา API คือ backward compatibility หมายความว่าเมื่อมีการ upgrade API version ควรจะทำโดยที่ API consumer ใน version เก่ายังใช้งานได้ วิธีการคือเราต้องออกแบบ API ให้ลดความเสี่ยงในการที่จะกิดผลกระทบต่อ API consumer ใน version เก่าโดยตรง หรือที่เรียกกันว่า breaking change  

การที่เราไม่ส่ง key ที่เป็น optional ลงไป ทำให้ API consumer ต้องตรวจสอบก่อนว่ามี key นี้ไหมก่อนที่จะไปใช้ค่า เนื่องจากข้อจำกัดในบางภาษา เช่น

```jsonc
// GET /teachers/{teacherId}
{
    "firstName": "John",
    "lastName": "Doe"
    // subject is optional, don't return a key
}
```

```js
const teacher: Teacher = teacherApiClient.findById(...)

console.log(teacher.subject.toUpperCase()) // TypeError: Cannot read properties of undefined (reading 'toUpperCase')

if (teacher.subject != undefined && teacher.subject != null) {
    console.log(teacher.subject.toUpperCase())
}
else {
    // do something else...
}
```

ถ้าเราส่ง key ของ optional value พร้อมค่า `null` เงื่อนไขก็จะเรียบง่ายขึ้น

```js
if (teacher.subject != null) {
    console.log(teacher.subject.toUpperCase())
}
else {
    // do something else...
}
```

อีกทางเลือกหนึ่งนอกจากการตั้งค่าเป็น `null` คือใช้ default value แทน เช่น

- สำหรับ `String` ใช้ Empty value (`""`)
- สำหรับ `Integer` ใช้ `0`
- สำหรับ `Boolean` ใช้ `false`
- สำหรับ `Array` ใช้ Empty value `[]`

```js
console.log(teacher.subject.toUpperCase()) // ""
```

ข้อเสียก็คืออาจจะเกิดความสับสนกับ API consumer ว่า default value หมายถึงว่า มีค่าเป็น default value จริง ๆ หรือ ไม่มีค่าเลยเป็น default value กันแน่ ซึ่ง `null` จะตอบโจทย์ตรงดีได้ดีกว่า **ทั้งนี้ทั้งนั้นการส่ง optional key ไปก็ย่อมจัดการได้ง่ายกว่าไม่ส่ง key ไปเลย**

## เรื่องของ breaking change
ถ้ามีเหตุการณ์จำเป็นจริง ๆ ที่จะต้อง break backward compatibility แบบหลีกเลี่ยงไม่ได้ เราสามารถทำได้หลายวิธี เช่น API versioning (new endpoint หรือ header version ก็ได้) เราควรจะใช้โอกาสนี้ในการจัดการ technical debt จาก optional value ที่เกิดขึ้น อย่างเช่น ทบทวนการออกแบบ domain modeling ของเรา เป็นต้น ข้อควรระวังคือ อย่า manage API หลาย version ที่ต่างกันเพียงเล็กน้อยมากจนเกินไป ไม่เช่นนั้นจะเกิดค่าใช้จ่ายใยการดูแลรักษามากขึ้นตามไป เราควรจะต้องดูแล API เป็นเหมือน product ที่จะอยู่กับเราไปในระยะยาวมากกว่า

## สรุป

> โดยสรุปแล้ว ในความคิดเห็นของเราคือ ควรจะ return optional key โดยมีค่าเป็น `null` หรือ default value ไป ถ้าไม่มี optional key มากจนเกินไปจนมีผลต่อ response size, bandwidth, และความซับซ้อนในฝั่งของ API consumer

สิ่งสุดท้ายที่อยากฝากคือ เพื่อลดการพูดคุยจนเกิดเหตุการณ์ [Bikeshredding](https://exceptionnotfound.net/bikeshedding-the-daily-software-anti-pattern/) ทีมพัฒนาควรจะหา [guidelines](https://opensource.zalando.com/restful-api-guidelines/) ซึ่งอาจจะมีอยู่แล้วหาได้ทั่วไป เพื่อใช้เป็นมาตรฐานของการออกแบบ จากนั้นเริ่มพูดคุยกันจากจุดนั้น ๆ ไป