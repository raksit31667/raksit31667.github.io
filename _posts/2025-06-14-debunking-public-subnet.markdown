---
layout: post
title: "Workload บน public Subnet ไม่ได้แปลว่าใครจะเข้าถึงก็ได้นะ"
date: 2025-06-14
tags: [aws, cloud-computing, infrastructure, networking]
---

ถ้าใครเคยเอาระบบไป deploy บน cloud provider อย่าง AWS น่าจะเคยได้ยินคำว่า **public subnet** และ **private subnet** กันมาบ้าง และหลายคน (รวมถึงตัวเราในอดีต) มักเข้าใจว่า **"public subnet" แปลว่าเครื่องที่อยู่ในนั้นจะถูกเปิดให้คนภายนอกเข้าถึงได้เลย**

> แต่จริง ๆ แล้วไม่ใช่แบบนั้นเลยครับ

วันนี้เราจะมาแกะความเข้าใจผิดนี้ พร้อมอธิบายให้เห็นภาพด้วยตัวอย่างจริง ว่า public subnet คืออะไร มันทำอะไรได้ และมัน "เปิด" แค่ไหน

## TL;DR – Public/Private subnet คือเรื่องของ routing

ใน AWS คำว่า "public subnet" หรือ "private subnet" ไม่ได้เป็น label หรือ flag อะไรในระบบเลย มันแค่หมายถึง **เส้นทางการเดินของ network traffic ว่า subnet นั้นมี "การเปิดรับ/ส่ง traffic จาก internet" โดยตรงหรือเปล่า**

## Public subnet
- มี route ไปที่ **Internet Gateway** โดยตรง
- ถ้า instance ใน subnet นี้มี **public IP** และ**เปิด port ผ่าน security group** -> จะสามารถถูกเข้าถึงจาก internet ได้

### แล้ว Internet Gateway ทำอะไร
Internet Gateway (IGW) เป็น component/software ที่ทำหน้าที่เหมือนประตูหลักที่เชื่อม VPC ของเรา กับ internet ภายนอก ถ้า subnet ไหนมี route ไปที่ IGW หมายความว่า resources ข้างในสามารถ

- ออกไป internet ได้
- รับ request จาก internet ได้ (ถ้ามี public IP และ security group configuration)

### ตัวอย่าง
สมมติว่าเรามี EC2 อยู่ใน subnet ที่มีเส้นทาง

```
0.0.0.0/0 (ได้ทุก IP) -> igw-12345678
```

แล้วเราให้ public IP กับ EC2 นี้ และเปิด port `22` ใน security group เราก็จะ SSH เข้าเครื่องนี้จาก internet ได้เลย (เช่นจากเครื่อง local ของเราผ่าน Terminal)  

แต่ถ้าขาดข้อใดข้อหนึ่งไป เช่น ไม่มี public IP หรือ security group ปิดหมด ก็เข้าไม่ได้

## Private subnet
- ไม่มี route ไป IGW
- ต้องใช้ **NAT Gateway** เป็นทางอ้อมออกไป internet แบบ outbound-only (ขาออกอย่างเดียว)
- ไม่มีทางให้เข้าจาก internet ตรง ๆ ได้เลย

### แล้ว NAT Gateway ทำอะไร
NAT Gateway เอาไว้ให้ resources ที่อยู่ใน private subnet สามารถ "ออก internet" ได้โดยไม่ต้องเปิดให้ใครเข้ามาได้เลย เหมาะกับ worker node, serverless function, หรือ service ที่ต้อง ดึง image จาก Docker registry ติดตั้ง dependency จาก GitHub เข้าถึง S3, API ต่าง ๆ เป็นต้น

### ตัวอย่างของ AWS Elastic Kubernetes Service (EKS)
- วาง Application Load Balancer (ALB) ให้อยู่ใน public subnet -> มี IGW -> รับ traffic จาก user
- วาง Worker node ให้อยู่ใน private subnet -> ใช้ NAT Gateway ออกไป pull image จาก Docker registry
- วาง Pod ให้อยู่ใน private subnet ข้างในไม่เปิด public IP -> ใช้ NAT Gateway ออกไป internet หรือ รับ traffic ผ่าน ALB เท่านั้น

## เปรียบเทียบ IGW vs NAT Gateway แบบเข้าใจง่าย

| ด้าน                          | Internet Gateway (IGW)           | NAT Gateway                         |
| ----------------------------- | -------------------------------- | ----------------------------------- |
| การใช้งานหลัก                 | เปิดรับ/ส่ง traffic จาก internet | ให้ private subnet ออก internet ได้ |
| ทิศทาง                        | Inbound + Outbound               | Outbound only                       |
| Public IP จำเป็นไหม           | ✅ จำเป็น                         | ❌ ไม่จำเป็น                         |
| ถูกเข้าถึงจาก internet ได้ไหม | ✅ ได้ ถ้าเปิด security group     | ❌ ไม่ได้แน่นอน                      |
| ค่าใช้จ่าย                    | ฟรี                              | คิดเงินตามชั่วโมงและปริมาณข้อมูล    |

> ถ้าใครเคยกลัวคำว่า public subnet ว่ามันจะทำให้ระบบเรา "เปิดหมด" หวังว่า blog นี้จะช่วยให้เข้าใจโครงสร้าง AWS มากขึ้นครับ
