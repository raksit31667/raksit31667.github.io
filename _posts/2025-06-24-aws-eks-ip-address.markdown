---
layout: post
title: "ว่าด้วยเรื่องของ IP address ใน Amazon EKS"
date: 2025-06-24
tags: [aws, networking, kubernetes]
---

หากเคยใช้งาน Amazon EKS ในระดับ production grade มาสักพัก อาจเคยเจอกับปัญหาที่น่าปวดหัวอย่างเช่น **InsufficientFreeAddresses** ซึ่งหมายถึง Subnet ใน VPC ไม่มี IP Address เหลือพอให้ EKS ใช้งาน

> InsufficientFreeAddresses: One or more of the subnets associated with your cluster does not have enough available IP addresses for Amazon EKS to perform cluster management operations.

ปัญหานี้อาจเกิดขึ้นระหว่างการ upgrade EKS, node maintenance หรือแม้กระทั่งการ scale node  

บทความนี้จะพาไปทำความเข้าใจ

- พื้นฐานของ **ENI**, **VPC**, และ **CNI Plugin**
- ทำไม EKS ถึงใช้ IP เยอะกว่าที่คิด

## ENI (Elastic Network Interface) คืออะไร

ENI คือ component ที่ AWS ใช้เชื่อม EC2 หรือ Node ใน EKS เข้ากับ Subnet ของ VPC (Virtual Private Cloud) นึกภาพ ENI เป็นสาย LAN เสมือนที่เสียบเข้ากับเครื่องเพื่อให้สามารถเชื่อม EC2 ต่อกับระบบภายใน AWS ได้

แต่ละ ENI มี

- **1 Primary IP** สำหรับใช้งานกับ EC2 instance หรือ Node
- **หลาย Secondary IP** ที่สามารถใช้ assign ให้ Kubernetes pod ได้

| Comonent | หน้าที่                                     |
| ---------- | ------------------------------------------- |
| **VPC**    | เครือข่ายหลักใน AWS                         |
| **Subnet** | พื้นที่ย่อยของ VPC ที่แบ่ง IP               |
| **ENI**    | เชื่อม Node เข้ากับ Subnet |
| **Pod**    | ใช้ 1 IP จาก Secondary IP ของ ENI           |

## VPC CNI Plugin คืออะไร

ใน Kubernetes ปกติ ถ้าเรารัน cluster เอง (เช่นบนเครื่องจริงหรือ VM) เราจะใช้สิ่งที่เรียกว่า CNI (Container Network Interface) ในการเชื่อมต่อ network ให้กับ pod ซึ่งก็มีให้เลือกหลายเจ้า เช่น Calico, Flannel, Weave เป็นต้น

แต่ใน Amazon EKS จะ ใช้ VPC CNI Plugin ที่ AWS พัฒนาเอง ซึ่งมีลักษณะเฉพาะตัวและเชื่อมโยงโดยตรงกับ VPC ทำให้ Pod สามารถสื่อสารกับ resource อื่นใน VPC ได้โดยตรง เช่น RDS, Lambda, หรือ Load Balancer เป็นต้น

### หน้าที่ของ VPC CNI Plugin

- สร้าง ENI ให้ Node และ Pod เวลาที่ต้องการ IP เพิ่ม
- Assign IP Address จริงจาก Subnet ให้กับทุก Pod ซึ่งก็คือ IP ที่เป็น Secondary IP จาก ENI ของ Node ที่มันอยู่
- ลบ ENI ที่มันสร้างขึ้น เมื่อมั่นใจว่าไม่มี Resource ไหนใช้งานแล้ว 

เพื่อให้เห็นภาพมากขึ้น มาดูกันทีละขั้นตอนว่าเกิดอะไรขึ้นเบื้องหลังเมื่อมีการสร้าง Pod ใหม่ใน cluster

1. Pod ถูก Schedule ลงไปบน Node
2. VPC CNI Plugin จะตรวจสอบ ENI ที่ผูกกับ Node ว่ายังมี Secondary IP ว่างอยู่หรือไม่
3. ถ้ามี IP ว่าง
    - CNI จะ assign 1 Secondary IP จาก ENI ให้กับ Pod นั้น
    - Pod จะได้ IP จริงที่อยู่ใน Subnet ของ VPC
4. ถ้าไม่มี IP ว่าง
   - CNI อาจพยายาม แนบ ENI เพิ่มให้กับ Node (ถ้า Instance type รองรับ ENI หลายตัว)
   - จากนั้นขอ IP เพิ่มจาก Subnet เดิมเพื่อใช้งานกับ Pod ใหม่ ซึ่งอาจจะใช้เวลาเพิ่ม (latency สูง)
   - หรือการสร้าง Pod จะล้มเหลว เพราะไม่มี IP ให้ใช้งาน

![How VPC CNI Plugin Works](/assets/2025-06-24-how-vpc-cni-works.png)
<https://docs.aws.amazon.com/eks/latest/best-practices/vpc-cni.html>

## ย้อนกลับไปที่ปัญหา
ปัญหา **InsufficientFreeAddresses** จะเกิดเมื่อ

- Cluster มี Node เยอะ แต่ Subnet เล็ก
- มี ENI ที่ยังผูกอยู่กับ Node เก่าที่ Terminate ไปแล้ว แต่ยังจอง IP อยู่ ซึ่งเกิดจากการทำงานของ VPC CNI Plugin ที่ไม่สมบูรณ์
- ระบบพยายามแนบ ENI ใหม่แต่ Subnet ไม่มี IP เหลือ

การเข้าใจว่า VPC CNI Plugin ทำงานร่วมกับ ENI เพื่อจองและ assign IP ให้กับ Pod จะช่วยให้เรามีมุมมองที่แม่นยำขึ้นเวลาเกิดปัญหา เช่น Pod สร้างไม่ขึ้น, Scale ไม่ได้ นำไปสู่วิธีการแก้ปัญหาได้หลายแบบ เช่น

1. ป้องกันไม่ให้เกิดแต่แรกด้วยการวางแผน IP allocation + subnet sizing + ENI ที่ดี
2. ตรวจสอบ ENI ที่ไม่ถูกใช้งาน ใน VPC Console หรือ AWS CLI (`aws ec2 describe-network-interfaces`)
3. ใช้ Subnet ที่มี CIDR ใหญ่พอ เช่น `/23` หรือ `/22` หากมี Node เยอะ
4. เปิดใช้งาน [Prefix Delegation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-prefix-eni.html) เพื่อให้ ENI ได้ IP Block /28 แทนที่จะจองทีละ IP (อันนี้ยังไม่ได้ลองเล่นเลยไม่รู้รายละเอียดมากเท่าไร)
5. เพื่อตรวจสอบการใช้งาน IP ผ่าน VPC CNI Plugin

### ยกตัวอย่างการคำนวณ IP ที่ควรมีใน Subnet

สมมติว่า

- ใช้ EC2 ประเภท `m7i.xlarge` -> 1 ENI มี ~15 IP (1 Primary + 14 Secondary)
- ใช้ Node 4 ตัวในแต่ละ AZ
- มี 2 AZ -> 2 Subnet

ดังนั้นในแต่ละ Subnet ต้องมี IP อย่างน้อย

```
4 Node × (1 Primary + 14 Pod) = 60 IP
```

หากมี ENI 2 ตัว (30 IP) + Node ปัจจุบัน (60 IP) → รวม 90 IP
ถ้า Subnet เป็น `/25` (แค่ 128 IP) → มีโอกาสเต็มได้ง่ายมาก

## สรุป
ในการ maintain Amazon EKS ใน production grade อย่ามองข้ามเรื่อง IP Planning และการตรวจสอบ ENI เพราะบางครั้งสิ่งที่ "ไม่เห็น" อาจเป็นต้นเหตุของปัญหาที่ใหญ่ที่สุด
