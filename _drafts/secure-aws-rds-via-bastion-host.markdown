---
layout: post
title:  "เพิ่มความปลอดภัยในการเข้าถึง Amazon RDS ด้วย Bastion host"
date:   2021-12-04
tags: [aws, database, security]
---

ถ้าเราพูดถึงเรื่องความปลอดภัยในการใช้งาน database บน cloud สิ่งแรกๆ ที่ต้องคำนึงถึงคือ ทำอย่างไรที่จะอุดช่องโหว่ในการเข้าถึง database แบบไม่พึงประสงค์ เพราะถ้าไม่ปลอดภัย ก็น่าจะเป็นปัญหาใหญ่ต่อทั้งทีมพัฒนา และ business รวมไปถึงองค์กรด้วย  

## Database ของเราปลอดภัยจริงไหม

บางคนอาจจะบอกว่า เรามี credentials แล้วนะ เราตั้ง user permission แล้วนะ สื่งที่น่าสนใจคือถ้า credentials หลุดออกไป ระบบของเรายังปลอดภัยอยู่ไหม ลองตอบคำถามเหล่านี้ดู

1. Database server ของเราจะรับ connection จาก local client เท่านั้นหรือเปล่า (client ไม่ได้เป็น public access ใช่ไหม)
2. คนที่ได้ credentials ไป ไม่สามารถเข้าถึง local client ของเราได้ใช่ไหม
3. Application ที่เชื่อมต่อ database ปลอดภัยไหม
4. Credentials ที่หลุดออกไปไม่ได้ใช้ร่วมกันระบบส่วนอื่นๆ ใช่ไหม

ถ้าตอบว่าใช่ทั้งหมด ก็น่าจะอุ่นใจได้ระดับหนึ่งนะ ถ้าไม่ใช่ เราก็**แก้ไขปัญหา**ด้วยการเปลี่ยน credentials จะเป็น manual หรือ automate ก็ได้ ซึ่งถ้าเปลี่ยนทันก็โชคดีไป แต่จะดีกว่าไหมถ้าเรา**ป้องกันปัญหา**ที่มีโอกาสจะเกิดขึ้นตั้งแต่แรก

## Bastion host คืออะไร

![Architecture](/assets/2021-12-04-aws-rds-bastion-host-architecture.jpeg)
<https://marcincuber.medium.com/ssh-tunneling-to-access-aws-rds-using-bastion-host-and-iam-role-a0610104bb6c>

bastion host เป็นแนวคิดที่นำ server มาคั่นหน้าระบบงานจริงเพื่อจัดการเรื่อง security โดยเฉพาะ นึกภาพเป็นเป็นป้อมยามหน้าทางเข้าหมู่บ้าน ซึ่งของข้างใน bastion host ควรจะเรียบง่ายไม่ซับซ้อน อาจจะเป็น Linux virtual machine ก็ได้ แน่นอนว่ามีข้อเสียเหมือนกันคือเป็น one point-of-failure คือถ้า bastion host ถูก hack ระบบของเราก็สั่นคลอนทันที ดังนั้นเราจะต้องมา secure bastion host ด้วยเช่นเดียวกัน  

## ขั้นตอนการสร้าง Bastion host สำหรับ Amazon RDS
- สร้าง [Amazon RDS](https://aws.amazon.com/rds/features/) ที่ใช้ credentials จาก [Amazon Secrets Manager](https://aws.amazon.com/secrets-manager/features/)
- สร้าง bastion host ผ่าน [Amazon EC2](https://aws.amazon.com/ec2/features/)
- สร้าง security group สำหรับ bastion host ที่มี whitelist เป็น public IP address ของ client
- สร้าง security group สำหรับ Amazon RDS ที่มี whitelist เป็น private IP ของ bastion host
- เพิ่ม shell script ในการสร้าง Linux user เพื่อให้ client เชื่อมต่อ bastion host ด้วย SSH

### 1. สร้าง Amazon RDS ที่ใช้ credentials จาก Amazon Secrets Manager
ในตัวอย่างเราจะใช้ [Amazon Cloudformation](https://aws.amazon.com/cloudformation/features/) ในการสร้าง resource ต่างๆ  

<script src="https://gist.github.com/raksit31667/05c33a9e0defcaafb25f5aae28c4a76d.js"></script>

สร้าง master user โดยกำหนด username เป็น `postgres` และ password สุ่ม 16 หลักเอา จากนั้นเราก็เอามาเชื่อมกับ Amazon RDS for PostgreSQL ที่กำหนด port `5432`

### 2. สร้าง bastion host ผ่าน Amazon EC2
โดยก่อนอื่น เราจะต้องไปสร้าง [EC2 keypair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) เพราะเดี๋ยวเราต้องใช้ SSH ในการเข้าถึง bastion host โดย keypair จะไม่มีใน Cloudformation เพราะว่าผลลัพธ์จากสร้าง keypair คือเราจะได้ private key มาเก็บไว้ใน local machine ของเรา

<script src="https://gist.github.com/raksit31667/83b604cef90b0af9d4e8284e482773cd.js"></script>

สร้าง security group สำหรับ bastion host ที่มี whitelist เป็น public IP address ของเครื่อง local หรือ VPN ของบริษัท บน port `22` สำหรับ SSH (SSH จะใช้ port `22`) และอย่าลืมกำหนด output เพื่อนำ private IP ของ bastion host ไป whitelist ใน RDS เพื่อให้ bastion host เชื่อมต่อกับ RDS ได้นั่นเอง

<script src="https://gist.github.com/raksit31667/93f28fbb76af3f9f193bd10ee0699d91.js"></script>

### 3. เพิ่ม shell script ในการสร้าง Linux user
ในการเข้าถึง bastion host เราจะใช้ SSH ซึ่งจะช่วยให้

- Database server ของเราจะรับ connection จาก local client เท่านั้น
- คนที่ได้ credentials ไป ไม่สามารถเข้าถึง local client ของเราได้

โดย EC2 จะสามารถเพิ่ม Linux initial shell script ที่จะ run ก่อนเริ่มใช้งานผ่าน `UserData` ซึ่งใน shell script เราจะสร้าง Linux user เพื่อให้ client เชื่อมต่อ bastion host ด้วย SSH ดังนั้นเราจะต้องมี public-private SSH key กันก่อน ส่วนจะกำหนด SSH passphrase เพิ่มไหมก็แล้วแต่เราสะดวกเลย

```shell
$ ssh-keygen -t rsa
```

เราจะได้มา 2 file คือ private key (`example-db-bastion-host`) และ public key (`example-db-bastion-host-pub`) เราจะนำ public key ไปใส่ไว้ใน `UserData` shell script

<script src="https://gist.github.com/raksit31667/c17dcdbb32ebe859394e10666e2156b9.js"></script>

ตรงส่วน `Content-Type` เราต้องใส่ทั้งหมดเพื่อระบุ EC2 ว่าต้อง run script นี้ตอน start หลังจากนั้นเราก็มาสร้าง function ในการสร้าง user ที่มี permission สามารถเข้าถึง `.ssh` directory และ `.ssh/authorized_keys` file เพื่อเก็บ SSH public key ไว้ ทีนี้ในระบบเราอาจจะต้อง maintain user หลายๆ คน เราก็กำหนด array ของ user และ public key ไว้ แล้วก็วน loop array เพื่อสร้าง user หลายๆ คน

### มาทดสอบกัน
เราจะใช้ database client เจ้าไหนก็ได้ หรือเราจะใช้ command-line แต่ก็ต้องไปติดตั้งเองโดยการเขียน `UserData` script เพิ่ม เพื่อความง่าย เราใช้ [DBeaver](https://dbeaver.io/) เป็นอันจบงาน แต่มีข้อแม้อย่างหนึ่งคือ public IP จะเปลี่ยนแปลงไปตลอด ดังนั้นตอนเชื่อมให้ไปเอา public IP ใหม่จาก bastion host มาเสมอ

![DBeaver connection](/assets/2021-12-04-dbeaver-connection.png)

![DBeaver SSH connection](/assets/2021-12-04-dbeaver-ssh-connection.png)

> ลองนำ technique นี้ไปปรับปรุง security ของ database เรากันครับ



