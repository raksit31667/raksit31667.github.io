---
layout: post
title: "แนวทางในการเพิ่ม subnet ใน Terraform AWS EKS module"
date: 2026-01-24
tags: [terraform, aws, networking, kubernetes]
---

ใน project ที่เรากำลังทำอยู่ ต้อง deploy ระบบงานขึ้น [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) ระหว่างที่กำลัง upgrade EKS cluster ตัวหนึ่ง ก็มี error นี้ขึ้นมา

```
InsufficientFreeAddresses: One or more of the subnets associated with your cluster does not have enough available IP addresses for Amazon EKS to perform cluster management operations.
```

ง่าย ๆ เลยคือ Subnet ที่ EKS ใช้อยู่ IP ไม่พอแล้ว ซึ่งอาการมันออกตอน upgrade เพราะว่าตอน upgrade EKS ต้องการ IP เพิ่มเพื่อ

- สร้างและ upgrade control plane components ซึ่งต้อง spin ตัวใหม่มาคู่ตัวเก่าชั่วคราว
- สร้าง ENI ใหม่ (ENI คือ component ที่ AWS ใช้เชื่อม EC2 หรือ Node ใน EKS เข้ากับ Subnet ของ VPC (Virtual Private Cloud))
- Replace node เก่าเนื่องจาก upgrade EKS version ควรทำทั้ง control plane และ node ให้เป็น version เดียวกัน ซึ่งจะมีจังหวะที่ node / pod เพิ่มขึ้นชั่วคราว

หมายความว่าถ้า subnet ไม่มี IP ว่างเพื่อทำสิ่งต่าง ๆ ตามข้างบน -> upgrade ไม่ได้นั่นเอง

## มาดูการ setup ปัจจุบันกันก่อน
Cluster นี้ provision ด้วย Terraform โดยใช้ [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) และ [terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) module
เพื่อความง่ายในการ setup เพราะถ้าไม่มี module ตัว Terraform code ค่อนข้างเยอะและซับซ้อน ในขณะเดียวกันการ setup ของเรามันหมายความว่าเราออกแบบให้ VPC มี subnet ที่ fixed size ตั้งแต่แรก
ตอนแรกดูเหมือนเหลือเยอะ แต่พอเวลาผ่านไป

- Node เพิ่ม
- Pod เพิ่ม
- ENI เพิ่ม

IP ก็หมดโดยไม่รู้ตัว

<script src="https://gist.github.com/raksit31667/2e6a8a453fcac4b05746279888d0a75e.js"></script>

<script src="https://gist.github.com/raksit31667/b7ea381df505076343d110480b4eab40.js"></script>

## IP ไม่พอ ก็เพิ่ม subnet เข้าไปสิ

วิธีคิดง่าย ๆ ตอนแรกคือ ก็เพิ่ม CIDR เข้าไปใน `var.private_subnets` สิ เดี๋ยว VPC module สร้าง subnet ใหม่ให้  

แต่พอ apply Terraform ดันจะ recreate EKS cluster สังเกตจาก output นี้

<script src="https://gist.github.com/raksit31667/e3c1932620f8ac94dadb8b7f09cf6c27.js"></script>

จาก output แปลได้ว่า **EKS cluster จะถูก destroy + create ใหม่ทั้งก้อน**

## ทำความเข้าใจ module

จาก Terraform module ของเรา ตอนที่กำหนด subnets

```
subnet_ids = module.vpc.private_subnets
```

Terraform module เลยตีความว่า `subnet_ids` = subnet ของทั้ง control plane และ node group  

พอ subnet list เปลี่ยน -> control plane subnet เปลี่ยน -> EKS cluster replace

ใน doc เขียนไว้ว่า

```
If control_plane_subnet_ids is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets
```

พอเราเข้าไปดู `control_plane_subnet_ids` ใน doc เขาบอกว่า

```
Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane
```

ถ้าอยากเพิ่ม subnet สำหรับ node โดย ไม่แตะ control plane ต้องใช้ตัวนี้  

## ลงมือเพิ่ม subnets

แต่ว่าเราเพิ่มตรง ๆ เข้าไปใน VPC module ที่มีอยู่แล้วไม่ได้ ต้องสร้าง resource `aws_subnet` เพิ่มใหม่

<script src="https://gist.github.com/raksit31667/ec1fa27e3bed5aae51d9f47293806ef9.js"></script>

ทีนี้เราก็เพิ่ม subnets ลงไปใน EKS module ด้วย `control_plane_subnet_ids` ได้แล้ว

<script src="https://gist.github.com/raksit31667/3b265c87777d732f34725558ddedcd3c.js"></script>

## อีกทางหนึ่งที่ใช้ได้ (ถ้า Terraform ขยับยาก)

1. สร้าง subnet ใหม่ผ่าน AWS Console
2. Import subnet เข้า Terraform state
  ```
  terraform import \
  'module.eks.module.vpc.aws_subnet.private[<last index>]' \
  subnet-<new-subnet-id>
  ```
3. เพิ่ม CIDR เข้า var.private_subnets

## เสริมในกรณีที่ระบบมี VPC endpoint
ถ้าใน VPC มี Interface VPC Endpoint อยู่แล้ว การเพิ่ม subnet อาจทำให้มันพังได้ เหตุผลจาก [AWS doc](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html#vpce-interface-limitations)

```
You can select one subnet per Availability Zone. You can't select multiple subnets from the same Availability Zone.
```

แปลว่า 1 AZ จะทำได้แค่ต่อ 1 subnet กับ 1 VPC endpoint ถ้าเพิ่ม subnet ใน AZ เดิม endpoint ต้องถูกแก้ / recreate ด้วย ตรงนี้ต้อง plan ดี ๆ ก่อนขยาย subnet
