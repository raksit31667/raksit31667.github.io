---
layout: post
title:  "บันทึกการแบ่งปันเรื่อง Infrastructure-as-a-Code ผ่าน Terraform ในบริษัท"
date:   2021-05-31
tags: [infrastructure-as-a-code, terraform]
---

เมื่ออาทิตย์ที่แล้วได้มีโอกาสจัด session 2 วัน เกี่ยวกับ **Infrastructure-as-a-Code ผ่าน Terraform** ให้กับเพื่อนๆ พี่ๆ น้องๆ ในบริษัท ครั้งนี้จะนำ feedback จาก[ครั้งที่แล้ว]({% post_url 2020-08-09-introduction-to-version-control-sharing %}) มาปรับปรุงให้ดีขึ้น

## Session วันแรก
เนื้อหาที่ได้นำเสนอไปมีคร่าวๆ ประมาณนี้
- เป้าหมายของ DevOps 5 ข่้อ ได้แก่ Communication, Collaboration, Integration, **Automation**, Measurement
- ปัญหาของการจัดการ infrastructure กับระบบที่ซับซ้อน พร้อมตัวอย่าง
- Infrastructure-as-a-Code เข้ามาช่วยแก้ปัญหาได้อย่างไร
- Terraform ทำงานอย่างไร มี lifecycle **init-plan-validate-apply-destroy**
- Terraform state management
- Hands-on workshop ซึ่งครอบคลุมเรื่อง
  - AWS CLI + credentials + configuration
  - Provider definition
  - Resource definition
  - Terraform CLI
  - Terraform buit-in function เช่น `jsonencode` และ `filebase64sha256`
  - Resource dependency

## Session วันที่สอง
เป็น hands-on workshop ที่ทำต่อจากวันก่อนเลย จะเน้นไปในส่วนของการ refactoring ผ่าน concept ต่างๆ
  - Modules
  - Variables declaration and file (tfvars)
  - Outputs
  - Terraform remote state

## การเตรียม workshop ทั้ง 2 วัน
- เนื่องจากบริษัทใช้ AWS ดังนั้นโจทย์ที่ใช้ก็นำมาจาก [AWS tutorials](https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/module-3/) เหมือนกัน ซึ่งมี instruction ครบ เพียงแต่เราจะมาทำผ่าน Terraform เพื่อให้คนเรียนเห็นภาพการใช้งานแบบเปรียบเทียบกันได้เลย
- ใช้ AWS account ของตัวเองเพื่อคุม permission และ cost ที่ต้องการได้ เพราะบริษัทเค้ามี policy อ่ะนะ
- ก่อนเริ่ม session สร้าง AWS user และ replicate role ที่มี policy พอที่จะ provision resource ได้ จากนั้นส่ง access key ให้แต่ละคนไป configure
- ไม่ได้แนะนำ [AWS security best practices]({% post_url 2021-05-07-secure-aws-credentials-local-machine %}) ไปเพราะจัดได้อีก session นึง แต่ย้ำกับคนเรียนไปแล้วระดับนึง
- หลีกเลี่ยง built-in function ที่มี breaking change ใน version ใหม่ๆ เช่น `list`

## การปรับปรุงจาก session ครั้งก่อน
- [ ] สอนเร็วเกินไป (ถามแต่ไม่มีใครตอบ เดาว่าเร็วไปละกัน ฮ่าๆๆ)
- [x] มี Interaction กับคนเรียนมากกว่านี้หน่อย
- [x] ทำตามไม่ได้เนื่องจากใช้คำสั่งบางอย่างใน Linux (audience ส่วนใหญ่ใช้ Windows) เช่น `mkdir` หรือ `ls`

## ปัญหาที่เจอ
- มีคนไม่ได้เข้า workshop วันแรก แต่เข้าแค่วันที่สอง ทำให้เริ่มไม่ได้เพราะเราอิง code จากวันแรก เลยแก้โดยการ push code วันแรกขึ้น remote repository ก่อนจะเริ่ม workshop

## Repositories
- [teach-terraform-terragrunt-aws](https://github.com/raksit31667/teach-terraform-terragrunt-aws)
- [terraform-workshop-day-1](https://github.com/raksit31667/terraform-workshop-day-1)
- [terraform-workshop-day-2](https://github.com/raksit31667/terraform-workshop-day-2)
