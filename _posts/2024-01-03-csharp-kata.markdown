---
layout: post
title: "แบ่งปัน Code Kata สำหรับปูพื้นฐานภาษา C#"
date: 2024-01-03
tags: [c-sharp, programming, kata]
---

เมื่อปีที่ผ่านมาจนถึงตอนนี้ก็ใช้เวลาฝึกฝนและปูพื้นฐานเกี่ยวกับภาษา C# เพื่อเตรียมตัวสำหรับการเข้า project ใหม่ ซึ่งเราก็ได้ทำความเข้าใจเกี่ยวกับ intent, feature  ของภาษาที่น่าสนใจ วิธีการเรียนรู้ภาษาใหม่ของแต่ละคนก็แตกต่างกันไป โดยส่วนตัวเราเลือกใช้การทำ [Code Kata](https://apiumhub.com/tech-blog-barcelona/code-kata/) มาดูกัน

## Code Kata
Code Kata ก็คือการทำโจทย์ปัญหาหรือแบบฝึกหัดที่จะช่วยทั้งด้านฝึกฝน เคาะสนิม และเรียนรู้ทักษะการเขียน code ผ่านการฝึกฝนซ้ำ ๆ โดยเน้นไปที่การเรียนรู้มากกว่าทำโจทย์ให้เสร็จสมบูรณ์ 100% ซึ่ง Code Kata ก็มีหลากหลายรูปแบบ เช่น

- Problem solving ผ่าน platform อย่าง [LeetCode](https://leetcode.com/) และ [HackerRank](https://www.hackerrank.com/)
- Refactoring โดยมี constraints ต่าง ๆ เช่น focus ที่การทำตาม principles หรือ rules บางอย่าง
- Test-driven development
- Pair programming

Kata ที่เราใช้ในการฝึก C# คือ Refactoring และ Test-driven development สำหรับใครที่สนใจหรือกำลังปูพ้นฐานอยู่เหมือนกันก็ลองไป fork [GitHub repository](https://github.com/craftskill-repo/Backend-Workshop) นี้มาดูได้ครับ โดยเนื้อหาที่ครอบคลุมมีดังนี้

- Number
- String and Char
- Array
- Variables and Parameters
- Classes
- Inheritance
- Interfaces
- Object types
- Nested types
- Enums
- Generics
- Delegates
- Anonymous method
- Closure
- Events
- Try statements
- Disposable
- Enumeration
- Nullable types
- Implicit and Explicit Conversions
- Extension method
- Anonymous types
- LINQ (Language-Integrated Query)
- Operators
- Collections

## Feature ใหม่ที่(เพิ่ง)เคยเจอ
- ดึง default value ของแต่ละ type (`null` สำหรับ `object`, `0` สำหรับ numeric types, `false` สำหรับ boolean) ด้วย `default` keyword
- Pass variable ที่เป็น value type ไปพร้อมกับ reference ด้วย `ref` หรือ `out` keyword
- Pass parameter ที่มี length ได้ไม่จำกัดด้วย `params` keyword
- [Indexer](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/indexers/using-indexers) สำหรับการทำ indexing บน class หรือ struct คล้าย ๆ arrays เพื่อ encapsulate collection ของ objects และ access ผ่าน index แทน
- ถ้าจะให้ method สามารถ override โดย derived class ได้ ต้องระบุด้วย `virtual` keyword ถ้าไม่อยากให้ override ก็ไม่ต้องระบุหรือใช้ `sealed` keyword
- ใช้ `as` keyword เพื่อทำ safe cast กล่าวคือถ้า cast ไม่ได้ก็จะ return `null` แทนที่จะ throw Exception
- ใช้ `new` modifier บน method declaration เพื่อซ่อน method (คนละอย่างกับ `override`) ที่ inherited มาจาก base class
- ใช้ `struct` keyword ในการกำหนด definition ของ value types
- ใช้ `delegate` modifier ในการทำ [function pointer](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/reference-types#the-delegate-type) ส่วนใหญ่ไว้ใช้ทำ event handling กับ callback mechanisms
- `EventHandler` type สำหรับ handle event ในการเขียนแนว event-driven โดยสามารถ bind และ unbind events ด้วย `+=` และ `-=`
- ใช้ `yield` keyword ในการ iterate collection โดยไม่ต้องสร้าง collection ใหม่ใน memory
- ทำ [implicit conversion](https://www.c-sharpcorner.com/blogs/implicit-operator-in-c-sharp) ด้วย `public static implicit operator`
- เพิ่ม the functionality ของ types ที่มีอยู่แล้วโดยไม่ต้องไปแตะ type definition ด้วย [Extension methods](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods) (`this` modifier ใน method argument)

> ทั้งหมดนี้คือ feature ใหม่ที่เราไม่เคยเห็นในภาษาอื่นมาก่อน แต่อยากย้ำว่า [Code Kata](https://github.com/craftskill-repo/Backend-Workshop) ที่เราฝึกมันหยุดที่ปี 2019 นะครับ ถ้าอยากจะเรียนรู้ feature ตั้งแต่นั้นจนถึงใหม่ล่าสุดก็คงต้องหา Code Kata จากแหล่งอื่นมาประกอบด้วยครับ