---
layout: post
title: "วิธีแก้ปัญหา Terraform EKS destroy ที่มี add-ons แล้ว timeout"
date: 2025-03-10
tags: [infrastructure-as-a-code, terraform, aws]
---

ถ้าใครเคยใช้ **Terraform** กับ **AWS EKS** ผ่าน module [`terraform-aws-modules/eks/aws`](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) แล้วเจอปัญหาตอน `terraform destroy` ที่อยู่ดีๆ ก็ timeout แถมขึ้น error ประมาณนี้:  

```text
│ Error: deleting EC2 VPC (vpc-XXXX): operation error EC2: DeleteVpc, https response error StatusCode: 400, RequestID: XXXXX-XXXX-XXXX-XXXX-XXXXXX, api error DependencyViolation: The vpc 'vpc-XXXX' has dependencies and cannot be deleted.
```

ปัญหานี้เกิดจาก dependency ที่ไม่ถูกลบออกจาก AWS อย่างถูกต้อง blog นี้เราจะมาเจาะลึกกันว่าทำไม Terraform ถึงลบ dependency ออกไม่ได้ต้องแก้ยังไงถึงจะ destroy ได้สำเร็จ

## Component หลักใน Terraform EKS module

<script src="https://gist.github.com/raksit31667/7b002bc9302635b807a00b884bf5c467.js"></script>

ใน Terraform ของเราจะมีการใช้ `module.eks` และ `module.eks_blueprints_addons` เพื่อสร้าง **AWS EKS Cluster** และ deploy [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/how-it-works/) ซึ่งเป็น add-ons ที่ช่วย update (สร้าง-แก้-ลบ) AWS Load Balancer (ทั้ง ALB และ NLB) ให้อัตโนมัติจากการ update Kubernetes resource ในรูปแบบ [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) หรือ [Service แบบ LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) นอกจากนั้น AWS Load Balancer Controller จะสร้าง AWS resource อื่น ๆ อย่าง [Frontend และ Backend Security Group](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/security_groups/) เพื่อใช้กับ Ingress ด้วย

![How ALB controller works](/assets/2025-03-10-alb-controller-how-it-works.png)

<https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/how-it-works/>

## ปัญหาที่เกิดขึ้นจากการ Destroy
ตอนที่เรา run `terraform destroy` จาก Terraform code ชุดนี้ มันจะลบ **Ingress** และ **Load Balancer Controller** พร้อมกัน แต่ AWS Load Balancer Controller ทำงานแบบ async มันทำให้ AWS resource ที่ Load Balancer Controller (เช่น Security Group) เคยสร้างไว้ยังค้างอยู่ เพราะว่า **resource เหล่านั้นถูกสร้างนอก Terraform (ก็คือไม่ได้เก็บ state ของ resource เหล่านั้นไว้)** เมื่อ Terraform พยายามลบ VPC ออกก็จะเจอ error ว่ายังมี dependency กับ AWS resource ที่กล่าวไปข้างต้น

## วิธีแก้ปัญหา  
จากปัญหาข้างต้น วิธีแก้ปัญหาก็คือเราจะต้องลบ addons ที่ไปสร้าง resource นอก Terraform และ module ที่เกี่ยวข้องออกจาก EKS cluster ก่อนนั่นเอง อย่างในโจทย์นี้คือลำดับการลบก็จะเป็นหน้าตาประมาณนี้

```sh
terraform destroy -target="module.eks_blueprints_addons" -auto-approve
terraform destroy -target="module.eks" -auto-approve
terraform destroy -auto-approve
```

หรือจะเข้าไปแก้ไข Terraform เพื่อทำการลบ resource ก่อนเลย แล้วค่อย run `terraform destroy` อีกที

<script src="https://gist.github.com/raksit31667/ac341f7a47ed309c306f6f8de646e6b3.js"></script>

## References
- [Amazon EKS Cluster w/ Istio](https://aws-ia.github.io/terraform-aws-eks-blueprints/patterns/istio/#destroy)
