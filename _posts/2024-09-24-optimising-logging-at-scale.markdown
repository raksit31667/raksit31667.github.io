---
layout: post
title: "บันทึกสิ่งที่ได้เรียนรู้จากการ optimise logging ของ Adevinta"
date: 2024-09-24
tags: [logging]
---

เมื่อเดือนที่แล้วได้มีโอกาสอ่านบทความของบริษัท Adevinta เรื่อง [The 300 Bytes That Saved Millions: Optimising Logging at Scale](https://adevinta.com/techblog/the-300-bytes-that-saved-millions-optimising-logging-at-scale/) 
ว่าด้วยเรื่องของการลดต้นทุนการเก็บ log ซึ่งก็เกิดขึ้นจากการปรับปรุงเล็ก ๆ น้อย ๆ แต่กลับสร้างผลกระทบทางบวกมหาศาล

## การใช้งาน logging pipeline
ในการเก็บ log ทางบริษัทใช้ [AWS OpenSearch](https://aws.amazon.com/opensearch-service/) 
รองรับการเก็บ log ได้ถึง 54TB แต่ค่าใช้จ่ายรายเดือนสูงถึงกว่า €7500 
ดังนั้นจึงมองหาวิธีที่มีประสิทธิภาพและคุ้มค่ามากขึ้นในการเก็บ log จนได้มาพบกับ [Vector.dev](https://vector.dev/) 
ซึ่งเป็น data pipeline ความเร็วสูงที่ช่วยให้เราจัดการข้อมูลได้ดียิ่งขึ้น  

## การทำ programmable transformations 
หนึ่งในความสามารถเด่นของ Vector คือการทำ programmable transformations 
ซึ่งช่วยให้สามารถปรับเปลี่ยนข้อมูล log ได้ตามที่ต้องการ ต่อมาทีมพัฒนาก็ได้ทำ transformation ต่าง ๆ เพื่อลดต้นทุนดังนี้

1. ลบ whitespace ที่ไม่จำเป็น
2. เปลี่ยนรูปแบบ `requestId` จาก [UUIDv4](https://en.wikipedia.org/wiki/Universally_unique_identifier) มาเป็น [nanoids](https://github.com/jaevor/go-nanoid)
3. เปลี่ยน attribute `log_file` ที่มี value `/opt/${app}/logs` เป็น attribute `app` แทน
4. เปลี่ยน attribute `hostname` ที่มี value `ip-00-00-00-00.<region>.compute.internal` เป็น attribute `ip` ที่มี value `00.00.00.00` แทน
5. ลบข้อมูลที่ซ้ำซ้อนจากการเก็บ timestamp ซ้ำกันถึงสองครั้ง และข้อมูล JWT token 
6. เปลี่ยนการเก็บ request init time ของ Java services เวลาจาก nanosecond เป็น millisecond

## ผลลัพธ์ที่ได้จากการเปลี่ยนแปลง
การเปลี่ยนแปลงเล็ก ๆ เหล่านี้ส่งผลอย่างมากต่อการประหยัดพื้นที่เก็บ log โดยมีการลดขนาดข้อมูลที่เก็บได้ดังนี้

- **ลบ whitespace ที่ไม่จำเป็น**: 3.5GB ต่อวัน
- **เปลี่ยนรูปแบบ requestId**: 28GB ต่อวัน
- **เปลี่ยนจาก log_file เป็น app**: 71GB ต่อวัน
- **ลบ timestamp ที่ซ้ำซ้อน**: 40GB ต่อวัน
- **เปลี่ยน hostname เป็น IP**: 60GB ต่อวัน
- **ลบข้อมูล JWT ซ้ำซ้อน**: 25GB ถึง 190GB ต่อวัน
- **ปรับ request init time ใน Java services**: 1GB ต่อวัน

> หลังจากที่ปรับเปลี่ยนทั้งหมดนี้ Adevinta สามารถลดต้นทุนการเก็บ log บน AWS OpenSearch ได้ถึง 35% หรือมากกว่า €30K ต่อปี 
> เป็นการพิสูจน์ว่าการเปลี่ยนแปลงเล็ก ๆ ก็สามารถส่งผลอย่างมากได้ หากนำไปใช้ในระดับที่เหมาะสม
