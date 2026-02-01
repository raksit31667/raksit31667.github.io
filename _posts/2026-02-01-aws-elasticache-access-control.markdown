---
layout: post
title: "การทำ access control ใน AWS ElastiCache ฉบับปี 2026"
date: 2026-02-01
tags: [aws, elasticache]
---

ใน project ปัจจุบันที่เราทำอยู่มี requirement ใหม่มาจาก developer ในองค์กรว่าอยากได้ Redis เป็น distributed caching solution ของระบบ แต่พอ implement จริง ๆ ผ่าน AWS ElastiCache กลับพบว่า ค่า default ของ ElastiCache ไม่ require authentication เลย ซึ่งในด้าน security คือไม่ค่อยโอเคเท่าไร blog เลยเป็นการสรุปแนวคิด วิธีคิด และการตัดสินใจว่าเราควร authenticate ElastiCache ยังไงดี ความยากคือ ElastiCache เป็น service ที่ authentication model ต่างจาก AWS service อื่น
การเลือก mode จึงไม่ใช่แค่ "อันไหน secure สุด" แต่ต้องดู operational complexity ด้วย

## ทำความรู้จัก AWS ElastiCache กันก่อน

AWS ElastiCache คือ managed in-memory key-value data store ของ AWS รองรับ caching engine เดิมคือ Redis และ Memcached ตอนนี้มี Valkey เพิ่มเข้ามา การใช้งานก็ตามชื่อเลยคือสำหรับ caching data ที่เรียกบ่อยเพื่อลด load จาก database  

โดยเราสามารถเลือกรูปแบบการ deploy ได้ตั้งแต่ node-based (ต้องดูแลและกำหนด spec ของ node เอง, ได้ support ตรงจาก caching regine) ไปจนถึง serverless (AWS ดูแล scaling, patching, availability) และสามารถ integrate กับ AWS resource อย่าง VPC + Security Group ได้เลย

## Access control ใน ElastiCache

สำหรับ AWS services ทั่วไป เช่น S3, DynamoDB, SQS access control ผ่าน IAM เพียงแค่ workload สามารถ assume IAM role
role ที่มี permission ก็สามารถเข้าถึง service ได้เลย  

ในส่วนของ ElastiCache ก็จะต่างออกไป โดยจะประกอบไปด้วย

- User
- User Group
- Access string (กำหนดว่า user ทำอะไรกับ key ไหนได้)

### Option 1: Password mode

วิธีการก็คือสร้าง ElastiCache user แบบ password ที่เป็น static secret ที่เราดูแลเอง (ซึ่งเราสามารถเก็บไว้ใน secrets manager) ได้ ส่วน permission กำหนดผ่าน Access string เอา

![ElastiCache Password mode](/assets/2026-02-01-elasticache-password-mode.png)

<https://aws.amazon.com/blogs/database/manage-aws-elasticache-for-redis-access-with-role-based-access-control-aws-secrets-manager-and-iam/>

#### ข้อดี
- เรียบง่าย ตรงไปตรงมา
- Client library ส่วนใหญ่ support mode นี้โดยไม่ต้องแก้อะไรเพิ่มเติม

#### ข้อจำกัด
- มี long-lived secret ถ้ามี security requirement สูงก็ต้องการ  rotation strategy

### Option 2: IAM mode

![ElastiCache IAM mode](/assets/2026-02-01-elasticache-password-mode.png)

<https://aws.amazon.com/blogs/database/simplify-managing-access-to-amazon-elasticache-for-redis-clusters-with-iam/>

วิธีการคือเราจะสร้าง ElastiCache user ในรูปแบบของ IAM user แปลว่าไม่มี password ตอนที่จะ connect ElastiCache จึงต้องขอ temporary IAM token จาก Security Token Service (STS) ก่อน จะได้เอา token นั้นไปใช้เป็น password ตอน connect อีกทีนั่นเอง  

IAM policy ที่ต้องมี (ตัวอย่าง):

<script src="https://gist.github.com/raksit31667/e32611919748ddaeaa20ce88ada0182f.js"></script>

#### ข้อดี
- ไม่มี static password
- แยก concern เรื่อง authentication (IAM) ออกจาก authorsation (Access string) ชัดเจน

#### ข้อจำกัด
- ต้อง implement STS token flow เอง
- Token หมดอายุทุก 15 นาที อาจเกิดปัญหาหลุดมากกว่า mode แรก
- ยังไม่เป็น first-class citizen

**สรุปแล้วเราตัดสินใจเลือก Password mode** ด้วยเหตุผลหลัก ๆ คือ

- ไม่อยาก over-complicate code ส่วน connect กับ ElastiCache
- Surface area ของ bug / security issue น้อย แม้ใน worst case ที่ password หลุด attacker ยังต้องอยู่ใน VPC / Security เดียวกัน

## การ provision AWS ElastiCache
ใน requirement ของเราคือ ElastiCache จะเป็น caching store ให้กับ workload ที่ run อยู่ใน Elastic Kubernetes Service (EKS) ดังนั้นเราสามารถกำหนดให้ ElastiCache อยู่ VPC เดียวกับ EKS ได้เลยเพื่อให้ network secure อยู่ภายใน private VPC เรามาดูตัวอย่าง IaC ผ่าน Terraform กัน

<script src="https://gist.github.com/raksit31667/a38cbdec04fd530d57df795244aea60b.js"></script>

## การเชื่อมต่อกับ AWS ElastiCache ผ่าน application

เพื่อให้เห็นภาพชัด ลองดูตัวอย่างการ connect จากฝั่ง .NET ว่าทั้งสองแบบต่างกันยังไง ทั้งในแง่ code และ complexity  

สมมติว่าใช้ caching engine เป็น Valkey และใช้ library เป็น `StackExchange.Redis`

### Password mode

<script src="https://gist.github.com/raksit31667/86fa36d846536e865fbda91c0b41ba4d.js"></script>

### IAM mode

<script src="https://gist.github.com/raksit31667/424bd7b057710dd1f09f87377214578c.js"></script>

## การเชื่อมต่อกับ AWS ElastiCache ผ่าน AWS Console

ในกรณีที่ developer อยากจะ debug/inspect ElastiCache ด้วยตัวเอง การเชื่อมต่อผ่าน application ก็อาจจะไม่สะดวกเท่าไรนัก โดยเฉพาะหากเกิดปัญหาว่า application ไม่สามารถเชื่อมต่อ ElastiCache ได้ จึงต้องมีอีกวิธีที่เราจะใช้คือผ่าน [CloudShell](https://aws.amazon.com/cloudshell/) ซึ่งเป็น command-line interface สำหรับเข้าถึงและจัดการ AWS resource มี AWS CLI และ tools ที่เกี่ยวกับ AWS ติดมาให้แล้วโดยไม่ต้องติดตั้ง tool ใด ๆ บน local machine แต่ก็ยัง secure เพราะ access ถูกจำกัดด้วย IAM permission ของ AWS principal  

CloudShell จะมีด้วยกันอยู่ 2 แบบ

1. **Regional (default)**: region เปลี่ยนตาม region ที่เลือกบน AWS Console มี internet access โดยตรง เหมาะกับ AWS CLI ทั่วไป ไม่ต้อง connect เข้า private VPC resource
2. **VPC environment**: เชื่อมกับ VPC ที่เราเลือก โดย network behavior เหมือน EC2 ใน VPC นั้น อาจจะไม่มี internet access ขึ้นกับ VPC design  

ใน use case ของเรา

- ElastiCache อยู่ใน private subnet
- ถูกป้องกันด้วย Security Group

จึงจำเป็นต้องใช้ VPC environment CloudShell เท่านั้น  

การเชื่อมต่อ ElastiCache ผ่าน AWS Console มีขั้นตอนดังนี้

1. เปิด CloudShell
2. สร้าง VPC environment ถ้ายังไม่มี
3. ไปที่ ElastiCache copy Valkey connection command ![ElastiCache connect command](/assets/2026-02-01-elasticache-connect-command.jpg)
4. Paste ใน CloudShell เพื่อ connect เข้า ElastiCache แต่ยังไม่สามารถทำ action ใด ๆ ได้เพราะยังไม่ได้ login/authenticate
5. Login โดยใช้คำสั่ง `AUTH <username> <password>` ถ้าขึ้น `OK` ถือว่ามาถูกทางละ
6. ลอง debug ด้วยคำสั่งเช่น `SCAN 0`
7. เสร็จแล้ว `exit` ออกให้เรียบร้อย

CloudShell มีข้อจำกัดอยู่คือ

- 10 concurrent sessions / region / account
- 2 VPC environments ต่อ AWS principal

ดังนั้นถ้า ElastiCache ถูกใช้โดย user/principal หลายคนใน AWS Console ก็ช่วยกัน disconnect ทุกครั้งหลังใช้งานเสร็จ จะได้มีที่ไว้ให้คนอื่นใช้ต่อ

## แถม

ถึงแม้ว่าบน AWS Console มีปุ่ม "**Connect to cache**" เมื่อกดแล้วสามารถเชื่อมต่อกับ ElastiCache ได้ง่ายกว่าวิธีข้างบน แต่เนื่องจากว่าเมื่อกดแล้ว AWS จะ attach security group เพิ่มให้ CloudShell ใน VPC อัตโนมัติ ซึ่งมันอยู่นอก lifecycle ของ Terraform จึงเกิด Terraform state drift เราจึงเลือกสร้าง VPC CloudShell เองดีกว่า
