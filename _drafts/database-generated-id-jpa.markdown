---
layout: post
title:  "สิ่งที่น่ารู้เกี่ยวกับ ID ใน table ที่ database สร้างให้ผ่าน JPA"
date:   2022-09-17
tags: [database, jpa, java]
---
ช่วงนี้เรากำลังทำ project ที่มีเนื้องานจะต้อง refresh ข้อมูลใหม่ทุกวันใส่ลงไปใน database ในรูปแบบของ data dump เนื่องจากต้องต่อกับระบบ legacy ที่ไม่สามารถดึงข้อมูลตามแต่ละวันบางส่วนออกมาได้ แน่นอนว่าความท้าทายคือต้องทำงานกับข้อมูลจำนวนเยอะมากเป็นล้าน ๆ record จึงต้องปรับปรุงระบบให้สามารถเพิ่ม record ลงไปได้เร็วที่สุด ระบบงานที่ใช้พัฒนาบน Spring Boot framework ที่ใช้ JPA ดังนั้นเรามาเข้าใจกันหน่อยว่า JPA จะจัดการ ID ใน table ที่ database สร้างให้ (auto-generated ID) ได้อย่างไร แล้วมันมีผลต่อ performance ใน application อย่างไร

## รูปแบบที่ JPA จะสร้าง ID ให้

ใน JPA เราสามารถเลือกรูปแบบที่ JPA จะสร้าง ID ให้ผ่าน annotation `@GeneratedValue` ได้ โดยในขณะที่เขียนบทความนี้ จะมี 4 รูปแบบด้วยกัน

<script src="https://gist.github.com/raksit31667/2f154f8f6568e4e6ec03d6ca0fe7d592.js"></script>

1. ***IDENTITY***: สร้าง ID โดยอาศัยจาก column ที่เป็น primary key (auto-increment column เช่น serial จะได้ 1, 2, 3, ...) ซึ่งก่อนเพิ่ม record ลงไปใน table ผ่าน INSERT ตัว JPA จะขอ ID ใหม่ จาก database แล้ว return กลับมาให้ไปแปะใน record ใหม่
2. ***SEQUENCE***: สร้าง ID โดยอาศัยจากสิ่งที่เรียกว่า [sequence](https://www.ibm.com/docs/en/db2/11.5?topic=objects-sequences) แทน ซึ่งสิ่งที่พิเศษเหนือจาก auto-increment column คือ

    - ถ้าเรามี transaction หลาย ๆ อันที่เพิ่ม record พร้อมกัน จะไม่ได้ ID เหมือนกันกลับออกไป
    - เราสามารถใช้ sequence เดียวกันกับหลาย table ได้ ในกรณีไม่ต้องการให้ primary key ซ้ำกัน แต่ต้องระวังเรื่อง sequence หมดเร็วด้วยนะ (ถ้าเป็นตัวเลข ค่าสูงสุดคือ is `2^63-1`)

    <script src="https://gist.github.com/raksit31667/0385ffe1e172389f47d1eba005041def.js"></script>

3. ***TABLE***: คล้าย ๆ กับ *SEQUENCE* แต่จะใช้ table เพื่อเก็บ ค่า auto-increment

    <script src="https://gist.github.com/raksit31667/b4062175ffa80f478cc79941c854a068.js"></script>
    
4. ***AUTO***: ให้ persistence provider อย่างเช่น Hibernate เลือก 1 ใน 3 ข้อที่กล่าวมา [หลักการคร่าว ๆ](https://docs.jboss.org/hibernate/orm/current/userguide/html_single/Hibernate_User_Guide.html#identifiers-generators-auto) คือ
    - ถ้า column นั้นมี type เป็น UUID ก็จะใช้ UUID
    - ไม่ใช่ UUID (เช่น ตัวเลข) ก็จะใช้แบบ *SEQUENCE*
    - ในบาง database ที่ไม่รองรับ sequence (เช่น MySQL) ก็จะใช้ *TABLE* หรือ *IDENTITY* (ขึ้นอยู่กับ version ของ persistence provider)

จะสังเกตว่ารูปแบบ *SEQUENCE* เป็นตัวเลือกที่ดีในมุมมองของ performance ถ้า column เป็นในรูปแบบของตัวเลข เพราะ *TABLE* จะต้องดึงข้อมูลจากอีก table นึง ในขณะที่ *IDENTITY* จะต้องมี statement ในการส่ง ID ใหม่เพิ่มมา 1 อันต่อการเพิ่ม 1 record ลง table

## พูดถึงการทำ batch insert
หากเราพูดถึงการทำ batch insert เพื่อลดจำนวนครั้งที่จะต้องสั่ง database นั้น *IDENTITY* จะไม่รองรับ เพราะ JPA ต้องไปขอ ID ใหม่ทุกครั้ง และ database จะไม่สามารถการันตีลำดับของ record ที่เพิ่มเข้ามากับ ID ที่ถูกสร้างขึ้นมาใหม่ได้ ตรงกันข้ามกับ *SEQUENCE* ที่แยกออกจาก table ไปโดยไม่สนใจแล้วว่า record จะถูกเพิ่มเข้าไปใน table ได้ไหม ทำให้ JPA สามารถใช้ persistence provider จอง ID ไว้ได้เลย

โดยเราจะต้อง configure sequence ในส่วนของ increment เพิ่ม ก็จะทำให้ JPA ไปดึง sequence มาแค่ครั้งเดียวต่อจำนวน increment ส่งผลให้ performance จะออกมาดีขึ้น ตัวอย่างเช่น

<script src="https://gist.github.com/raksit31667/de8024d4bbaa9c4cba1c21678a2078fe.js"></script>

แต่ถ้าถ้าเราใช้ *SEQUENCE* ดั้งเดิมโดยไม่ configure อะไร (increment = 1) ผลที่ออกมาก็ไม่ได้ต่างจาก *IDENTITY* สักเท่าไร เพราะ JPA ก็ต้องไปดึง ID ใหม่จาก sequence ในทุก ๆ record ที่จะเพิ่มเข้าไปอยู่ดี  

<script src="https://gist.github.com/raksit31667/88fc02f314beeeaaeb8f479901b47cdd.js"></script>

รูปแบบ *SEQUENCE* จะมีข้อเสียคือถ้า application ถูก restart ระหว่าง batch insert อยู่ ก็จะทำให้ ID บางส่วนที่ยังเพิ่มไปไม่ถึงหายไปถาวร เพราะ sequence ได้เพิ่มไปแล้ว  

อีกข้อเสียนึงคือถ้ามีหลาย application ต่อ database เดียวกัน ทุก application ควรจะดึง ID จาก sequence เดียวกัน ไม่งั้นอาจจะเกิด conflict กันเพราะพยายามจะเพิ่ม record ที่มี primary key เดียวกันอยู่แล้วนั่นเอง

## References
- [The ultimate guide on DB-generated IDs in JPA Entities](https://www.jpa-buddy.com/blog/the-ultimate-guide-on-db-generated/)
- [Generate Identifiers Using JPA and Hibernate](https://thorben-janssen.com/jpa-generate-primary-keys)
