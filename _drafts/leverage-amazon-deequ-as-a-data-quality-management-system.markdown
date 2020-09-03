---
layout: post
title:  "ทำความรู้จัก Amazon Deequ กับการจัดการ Data quality"
date:   2020-09-02
tags: [big-data, data-quality, deequ]
---

# ว่าด้วยเรื่องของ Business requirement กันก่อน
ปัจจุบันย้ายมาทำงานในส่วนของ big data ซึ่งรับข้อมูลการสั่งซื้อการลูกค้ามาทำ data cleansing เพื่อเตรียมข้อมูลให้ทีมในบริษัทพร้อมสำหรับทำ analytics ต่อไป ดังนั้นทีมต้องมั่นใจว่า

- ไม่มีข้อมูลที่เป็น non-null หายไป เพราะอาจจะทำให้เกิด error ในฝั่ง analytics ถ้าเค้าไม่ได้ดักไว้
- ข้อมูลจะต้องถูกต้องสมบูรณ์ เนื่องจากข้อมูลที่ผิดอาจจะทำให้ analytics วิเคราะห์ผิด ส่งผลให้ business ตัดสินใจผิดไปด้วย

ดังนั้นถ้ามีข้อมูลผิดไหลเข้ามา ระบบจะ reject ข้อมูลเหล่านั้นออกไป พร้อมกับส่ง notification ไปเตือนลูกค้าว่ามีข้อมูลไหนผิดบ้าง  

เมื่อกลับมามองที่ระบบปัจจุบันที่ทำกับทีม พบว่ามีข้อเสียดังนี้
- มี API ที่ทำ structural validation (เช่น null check, numeral check, uniqueness check) คั่นหน้าก่อนทำ semantic validation ผ่าน Apache Spark (เช่น ต้องทำ calculation บางอย่าง) ทำให้ developer ต้อง maintain logic 2 ที่ และลูกค้าต้อง handle error 2 ที่ (จาก API และ notification system)
- หากในอนาคตลูกค้าส่งมาเป็น flat file หรือ CSV แทน ต้องสร้าง service หรือ adapter มาแปลงไฟล์เหล่านั้นให้เป็น API spec ก่อน แล้วก็ไป call API อีกทีเพื่อให้ผ่าน structural validation

ทีมเราจึงวางแผนที่จะย้าย structural validation ให้ไปอยู่กับ semantic validation ก็จะสามารถแก้ปัญหาข้างต้นได้ แต่ก็เป็นงานช้างสำหรับทีมเพราะ structural validation มันเยอะเหลือเกิน การที่ต้องมานั่งเขียน code check null ใน DataFrame ทีละ column นี่แค่คิดก็เหนื่อยละครับ  

## แล้ว Amazon Deequ ช่วยอะไรได้
จากปัญหาดังกล่าว ทำให้เราไปหา tool ที่ช่วยทำให้การทำ data quality มันง่ายขึ้น เลยไปพบกับ [Amazon Deequ](https://aws.amazon.com/blogs/big-data/test-data-quality-at-scale-with-deequ/) 
ซึ่งตอนแรกใช้กันภายในบริษัท Amazon เองเพื่อใช้กับ dataset ขนาดใหญ่

> You generally write unit tests for your code, but do you also test your data?

สิ่งที่ Deequ library เอื้อให้กับทีมเราได้คือ

![Deequ overview components](/assets/2020-09-02-amazon-deequ-overview-components.png)

- built on top of Apache Spark อีกที ดังนั้นแค่ติดตั้งใน package management สบายๆ
- ทำการ verify data ผ่าน constraint ที่เราเลือกจาก Deequ หรือจะ custom เองก็ได้ จากนั้นจะ generate report ที่มี result อยู่
- สามารถเก็บ metrics ของ data ที่เราสนใจได้ เพื่อดู trend ของ data เช่น value distribution เป็นต้น
- สามารถ suggest constraint ที่ควรจะมีได้ (อันนี้ยังไม่ได้ลองใช้นะครับ)

## มาดูตัวอย่าง code กัน
