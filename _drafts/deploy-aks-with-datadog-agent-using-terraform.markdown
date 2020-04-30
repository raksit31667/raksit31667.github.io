---
layout: post
title:  "Deploy AKS cluster พร้อมกับ Datadog agent ผ่าน Terraform"
date:   2020-04-24
tags: [azure, aks, datadog, terraform]
---
blog นี้จะมา deploy Azure Kubernetes Service (AKS) บน Azure cloud ซึ่งจะใช้ Datadog เป็น logging / monitoring โดยหลักการคร่าวๆ ของ Datadog คือ เราติดตั้ง agent เพื่อให้ส่ง log และ metrics ต่างๆ ให้กับ Datadog (push model) ซึ่งจะต่างจาก Prometheus ที่จะมี server ไปเก็บ metrics มาจาก service discovery (Pull model)  

![Datadog agents](2020-04-30-datadog-agents.png)
[https://www.datadoghq.com/blog/monitoring-kubernetes-with-datadog/]
เราจะต้อง deploy 2 agents ได้แก่

- Node agent สำหรับเก็บ metrics จากแต่ละ node ได้ มาในรูปของ DaemonSet ดังนั้นการันตีว่าจะถูก deploy ในทุกๆ node
- Cluster agent ถูก deploy ใน cluster node ใด node นึง ซึ่งจะเก็บของมาจาก Node agent อีกที

### สิ่งที่จะใช้ในบทความนี้
- Datadog subscription พร้อมกับ API key และ Application key
- Azure DevOps ที่มี permission เพียงพอ
- Terraform
- Azure Blob storage account

**คำเตือน** บทความนี้จะไม่ลงพื้นฐาน Terraform หรือ Azure นะครับ เพื่อความกระชับ

### 1. สร้าง Azure DevOps pipeline
เราจะติดตั้ง extension บน Azure DevOps [ผ่าน Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) เพื่อสร้าง service connection โดยจะช่วย
- Setup service principal ที่ใช้ในการเพิ่ม แก้ไข หรือลบ resource บน Terraform ได้โดยที่ไม่ต้อง configure `client_id` หรือ `client_secret` ใน source code ผ่าน variable เลย
- Setup storage account สำหรับเก็บ `tfstate` file สำหรับใช้ในการ plan ใน build ครั้งถัดๆ ไป โดยที่ไม่ต้อง configure `backend` เลย
- ติดตั้ง Terraform CLI มาพร้อมกับ command ในรูปแบบ declarative เข้าใจง่ายกว่า bash script ที่เขียนเองอย่างแน่นอน

**รูป azure เพิ่ม task**

เลือก Task เป็น Terraform จาก extension และใส่ข้อมูลลงไป add แล้วจะได้ code มาประมาณนี้

**code**

จากนั้นเพิ่ม `backend` ใน Terraform แต่ปล่อยเป็น block เปล่าไว้ extension มันจัดการให้

**code**

ลองรัน pipeline ก็จะผ่าน  

### 2. เพิ่ม Terraform step init-validate-plan
อิงตาม Terraform life cycle กันเลย เก็บ plan ไว้เป็น file ด้วย

**code**

สร้าง Azure resource group ซึ่งจะเก็บ AKS ของเรา ไว้เช็คดูว่า steps มันรันผ่านไหม

**code**

### 3. เพิ่ม step ในการเก็บ Terraform file ไว้
เพราะว่า stage ถัดๆ ไปจะไม่เก็บ file ที่ generate จาก stage ที่แล้ว และการจะเอา apply ไปไว้ใน stage เดียวกับ init-validate-plan ก็ไม่ดีอีก เพราะบางทีเราไม่อยาก apply ทันที อยากให้มี approve ก่อน

**code**

### 4. เพิ่ม approval stage และ Terraform apply จาก file ที่เราเก็บไว้ในขั้นตอนที่แล้ว

**รูป approval**

**code**

Error: Failed to instantiate provider "azurerm" to obtain schema: fork/exec /home/vsts/work/1/s/.terraform/plugins/linux_amd64/terraform-provider-azurerm_v2.7.0_x5: permission denied  

เราต้อง grant permission ให้ Azure DevOps agent ใน permission ในการอ่าน terraform file ด้วย

### 5. สร้าง AKS บน resource group จากขั้นตอนที่ 2

**code**

### 6. เพิ่ม stage สร้าง Terraform tfvars file สำหรับ assign variable ลงไป
service principal สำหรับ AKS กับ datadog api key app key

**code**

### 7. สร้าง Kubernetes namespace สำหรับ Datadog cluster agent 

**code**

### 8. ติดตั้ง Datadog agents โดยใช้ Helm

**code**
