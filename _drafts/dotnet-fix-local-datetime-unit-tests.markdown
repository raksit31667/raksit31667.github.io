---
layout: post
title: "วิธีแก้ไขปัญหา Unit Test ที่เกี่ยวกับ DateTime ใน .NET ให้รองรับ Locale ไทย"
date: 2024-11-09
tags: [c-sharp, dotnet, testing]
---

เมื่ออาทิตย์ก่อน application developer เจอปัญหา run unit test ไม่ผ่านใน .NET project แต่ว่า run ผ่านบนเครื่อง CI (it doesn't work on my machine LOL) โดยเฉพาะกับ test case ที่เกี่ยวข้อง `DateTime` ซึ่ง ค่าปีที่จะมีค่าเพิ่มขึ้นมา 543 ปี

### ตัวอย่างปัญหา

มาลองดูตัวอย่างการทดสอบที่เกี่ยวกับ `DateTime` ใน XUnit กันก่อน เช่น

<script src="https://gist.github.com/raksit31667/d5adc33026f6e910b7561a1865fa785a.js"></script>

เมื่อเรารันเทสต์ข้างต้นบนเครื่องที่ Locale เป็นไทย ค่าปีของ `actual` จะผิดไป 543 ปี

```
Assert.Equal() Failure
Expected: 2023-01-01T00:00:00.0000000
Actual:   1480-01-01T00:00:00.0000000
```

อาการแบบนี้มักจะเกิดจากเครื่องของเราตั้งค่า Locale เป็นภาษาไทย ซึ่งใช้ปีพุทธศักราชที่มากกว่าปีคริสต์ศักราช อยู่ 543 ปีนั่นเอง  

### วิธีแก้ไข
เพื่อให้แน่ใจว่า unit test ของเราใช้เวลาในรูปแบบสากล (หรือแบบ UTC) ที่ไม่มีผลกระทบจาก Locale หรือ ปีพุทธซักราช วิธีง่าย ๆ ที่ใช้แก้ปัญหานี้ได้คือเพิ่มการตั้งค่า `<InvariantGlobalization>` ในไฟล์ `.csproj` ของ project ที่ใช้ run unit test โดยตั้งค่าให้เป็น `true` เพื่อให้ .NET ไม่สนใจ Locale ของเครื่อง และใช้การตั้งค่ากลาง (Invariant Culture) แทน

<script src="https://gist.github.com/raksit31667/0c04deac882b1de1b58bd8508b0b8d46.js"></script>

จากนั้น ลอง run test อีกครั้ง จะพบว่า test ผ่านแล้ว เพราะการตั้งค่านี้ทำให้ `DateTime` ถูกจัดการโดยไม่มีการแปลงปีเป็นพุทธศักราช

นั่นหมายความว่าไม่ว่า test จะถูก run ที่ CI server ในต่างประเทศหรือเครื่องส่วนตัวในไทย `DateTime` จะถูกแสดงผลและเปรียบเทียบตามมาตรฐานเดียวกัน  

มีอีกวิธีนึงคือใช้ `CultureInfo.InvariantCulture` ร่วมด้วยใน code ที่มีการแปลงเป็น `DateTime`

<script src="https://gist.github.com/raksit31667/cc179c8697b45a33a731ccbc8fe1a53d.js"></script>

การใช้ `CultureInfo.InvariantCulture` จะช่วยให้มั่นใจได้ว่า code จะทำงานได้ถูกต้องโดยไม่มีการเปลี่ยนแปลงตาม Locale ของเครื่องนั่นเอง

> หวังว่าวิธีแก้นี้จะช่วยให้ test ของเรามีความสม่ำเสมอไม่ว่าเราจะ run ที่ไหน
