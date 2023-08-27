---
layout: post
title: "จะใช้ data structure แบบไหนในการเก็บข้อมูลบน Redis"
date: 2023-08-27
tags: [redis, database]
---

ช่วงนี้ได้กลับมาทำระบบงานที่ต้องเชื่อมต่อกับ database อีกครั้งอย่าง Redis โดย project ก่อนหน้าที่ทำเมื่อ 3 ปีที่แล้วก็ใช้ แต่ด้วยความที่เพิ่งก้าวเข้าสู่สังเวียนจึงรู้แค่ว่าในเมื่อ Redis เป็น key-value database ดังนั้นมันจึงสามารถเก็บ data structure ได้แค่แบบเดียวคือ [String](https://redis.io/docs/data-types/strings/) ทั้งที่จริง ๆ แล้วตอนนี้ Redis เค้า[รองรับ data structure หลากหลาบรูปแบบ](https://redis.io/docs/data-types/) นอกจากนั้นยังมีความสามารถอื่น ๆ จาก pub-sub ด้วย  

![Redis data structure](/assets/2023-08-27-redis-data-structure-types.jpeg)

<https://keestalkstech.com/2019/04/building-a-high-performing-last-viewed-list-using-redis/>

ดังนั้นเมื่อเราดูจาก data structure ต่าง ๆ แล้วเราก็จะเห็นความแตกต่างในการนำไปใช้งานด้วยดังนี้

- [String](https://redis.io/docs/data-types/strings/) จะเหมาะกับการเก็บข้อมูลที่ไม่ซับซ้อนและไม่ต้อง update บ่อย ๆ เช่น จำนวน message ที่ยังไม่ได้อ่าน (unread messages) ในระบบ chat เป็นต้น
- [Hash table](https://redis.io/docs/data-types/hashes/) คือ list ของ key-value เปรียบเสมือน Dictionary ในภาษา Python ![Python Dictionary vs List](/assets/2023-08-27-python-dictionary-vs-list.jpeg) เมื่อเราต้องการดึงข้อมูลจาก Hash table ก็ต้องใช้ key เช่นเดียวกันแต่แทนที่จะได้ value เดียว ก็จะได้ list ของ key-value ที่เกี่ยวข้องกันออกมาแทน จะเหมาะสำหรับการดึงข้อมูลที่ 1 key สามารถโยงไปหา value ที่มีหลาย ๆ properties เช่น
  - เก็บข้อมูล user เช่น name, email address
  - เก็บข้อมูล product เช่น name, price, description
- [Lists](https://redis.io/docs/data-types/lists/) สำหรับเก็บข้อมูลที่ต้องเข้าด้วยรูปแบบ FIFO (first in, first out) หรือ LIFO (last in, first out) order เช่น message queue
- [Sets](https://redis.io/docs/data-types/sets/) สำหรับเก็บข้อมูลประเภทเดียวกันหลาย ๆ อันที่ไม่ซ้ำกัน เช่น IP address ของ user ที่เข้ามาดู website
- [Sorted sets](https://redis.io/docs/data-types/sorted-sets/) เหมาะกับข้อมูลที่ต้องเก็บแบบเรียงลำดับกัน (sorted order) เนื่องจาก Redis รองรับการเรียง key-value ในตัว เช่น ข้อมูล leaderboard ในเกม เป็นต้น

นอกจากนั้นแล้วเราต้องดูเรื่องของ cross-functional requirement ด้วย เช่น

- **Performance** เช่น การเก็บข้อมูลแบบ String ก็จะเร็วกว่า Sorted sets หรือการใช้งาน [indexing](https://redis.com/blog/indexing-with-redis/) ควบคู่ไปกับ Hash table
- **Scalability** เช่น หากหน้าตาของ data ของเรายังไม่แน่นอนว่าจะมีกี่ properties การใช้งาน Hash ย่อม scale ง่ายกว่า Lists เนื่องจาก Hash รองรับการเก็บหลาย properties

> ไม่ได้แตะ Redis มานานพอได้กลับมาลงมือทำจริงเลยได้พบว่ามันมีความสามารถเยอะมาก รองรับ use case ที่หลากหลาย ดังนั้นเราต้องใช้งานตาม requirement ที่เหมาะสมด้วย
  