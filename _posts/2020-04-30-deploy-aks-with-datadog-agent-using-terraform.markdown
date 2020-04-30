---
layout: post
title:  "Deploy AKS cluster พร้อมกับ Datadog agent ผ่าน Terraform"
date:   2020-04-30
tags: [azure, aks, datadog, terraform]
---
blog นี้จะมา deploy Azure Kubernetes Service (AKS) บน Azure cloud ซึ่งจะใช้ Datadog เป็น logging / monitoring โดยหลักการคร่าวๆ ของ Datadog คือ เราติดตั้ง agent เพื่อให้ส่ง log และ metrics ต่างๆ ให้กับ Datadog (push model) ซึ่งจะต่างจาก Prometheus ที่จะมี server ไปเก็บ metrics มาจาก service discovery (Pull model)  

![Datadog agents](/assets/2020-04-30/2020-04-30-datadog-agents.png)
<https://www.datadoghq.com/blog/monitoring-kubernetes-with-datadog/>  

เราจะต้อง deploy 2 agents ได้แก่

- Node agent สำหรับเก็บ metrics จากแต่ละ node ได้ มาในรูปของ DaemonSet ดังนั้นการันตีว่าจะถูก deploy ในทุกๆ node
- Cluster agent ถูก deploy ใน cluster node ใด node นึง ซึ่งจะเก็บของมาจาก Node agent อีกที

### สิ่งที่จะใช้ในบทความนี้
- Datadog subscription พร้อมกับ API key และ Application key
- Azure DevOps ที่มี permission เพียงพอ
- Terraform
- Azure Blob storage account สำหรับเก็บ `tfstate`

> Source code: <https://github.com/raksit31667/tryit-aks-datadog>

**คำเตือน** บทความนี้จะไม่ลงพื้นฐาน Terraform หรือ Azure นะครับ เพื่อความกระชับ

### 1. สร้าง Azure DevOps pipeline
เราจะติดตั้ง extension บน Azure DevOps [ผ่าน Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) เพื่อสร้าง service connection โดยจะช่วย
- Setup service principal ที่ใช้ในการเพิ่ม แก้ไข หรือลบ resource บน Terraform ได้โดยที่ไม่ต้อง configure `client_id` หรือ `client_secret` ใน source code ผ่าน variable เลย
- Setup storage account สำหรับเก็บ `tfstate` file สำหรับใช้ในการ plan ใน build ครั้งถัดๆ ไป โดยที่ไม่ต้อง configure `backend` เลย
- ติดตั้ง Terraform CLI มาพร้อมกับ command ในรูปแบบ declarative เข้าใจง่ายกว่า bash script ที่เขียนเองอย่างแน่นอน

![Terraform extension task 1](/assets/2020-04-30/2020-04-30-terraform-extension-task-1.png)
![Terraform extension task 2](/assets/2020-04-30/2020-04-30-terraform-extension-task-2.png)

เลือก Task เป็น Terraform จาก extension และใส่ข้อมูลลงไป add แล้วจะได้ code มาประมาณนี้  

<script src="https://gist.github.com/raksit31667/03181cee6c25d28bc663c1641f179df5.js"></script>

จากนั้นเพิ่ม `backend` ใน Terraform แต่ปล่อยเป็น block เปล่าไว้ extension มันจัดการให้  

<script src="https://gist.github.com/raksit31667/b305b8f8beab89a596698387f2697fe8.js"></script>

### 2. เพิ่ม Terraform step init-validate-plan
อิงตาม Terraform life cycle กันเลย เก็บ plan ไว้เป็น file ด้วย  

<script src="https://gist.github.com/raksit31667/cf696eb7ad762b9aafea2f767c9bdd75.js"></script>

สร้าง Azure resource group ซึ่งจะเก็บ AKS ของเรา ไว้เช็คดูว่า steps มันรันผ่านไหม  

<script src="https://gist.github.com/raksit31667/0240344740d93388268dd0612c62e7bb.js"></script>

![Init-validate-plan](/assets/2020-04-30/2020-04-30-init-validate-plan.png)

### 3. เพิ่ม step ในการเก็บ Terraform file ไว้
เพราะว่า stage ถัดๆ ไปจะไม่เก็บ file ที่ generate จาก stage ที่แล้ว และการจะเอา apply ไปไว้ใน stage เดียวกับ init-validate-plan ก็ไม่ดีอีก เพราะบางทีเราไม่อยาก apply ทันที อยากให้มี approve ก่อน  

![Terraform archive task](/assets/2020-04-30/2020-04-30-add-terraform-archive-task.png)

กดเพิ่ม task จะได้ code หน้าตาประมาณนี้
<script src="https://gist.github.com/raksit31667/3ec25243a6edf3dc39738268bb4dc24c.js"></script>

เข้าไปเช็ค **Artifacts** ใน pipeline จะพบว่ามี terraform file เก็บไว้ทั้งหมดเลย  

![Terraform archive artifact](/assets/2020-04-30/2020-04-30-terraform-archive-artifact.png)

### 4. เพิ่ม approval stage และ Terraform apply จาก file ที่เราเก็บไว้ในขั้นตอนที่แล้ว
เริ่มจากสร้าง **Environment > Approvals and checks** ตามรูปเลย   

![Add approval step 1](/assets/2020-04-30/2020-04-30-azure-devops-add-approval-1.png)  

![Add approval step 2](/assets/2020-04-30/2020-04-30-azure-devops-add-approval-2.png)

จากนั้นเพิ่ม code สำหรับ approval และ `terraform apply` หน้าตาประมาณนี้
<script src="https://gist.github.com/raksit31667/35c9704863bed99cf08573d47667c955.js"></script>

พอรันแล้วพบว่าเกิด error ดังนี้
```
Error: Failed to instantiate provider "azurerm" to obtain schema: fork/exec /home/vsts/work/1/s/.terraform/plugins/linux_amd64/terraform-provider-azurerm_v2.7.0_x5: permission denied  
```

ดังนั้นเราต้อง grant read permission ให้ Azure DevOps agent ในการอ่าน terraform file ด้วย  

![Add bash task](/assets/2020-04-30/2020-04-30-add-bash-task-grant-read-permission.png)

<script src="https://gist.github.com/raksit31667/51c5f40e2fd735158e173489f94e88c5.js"></script>

พอรันถึง Approval ก็สามารถทำ one-clik approval หรือ reject ผ่าน pipeline ได้เลย  

![Pending for approval](/assets/2020-04-30/2020-04-30-azure-devops-pending-approval.png)

พอรัน apply ผ่านแล้ว เข้าไปดู Blob storage account จะพบว่ามี file tfstate เก็บไว้สำหรับ build ครั้งถัดไปแล้ว  

![tfstate blob storage account](/assets/2020-04-30/2020-04-30-tfstate-blob-storage-account.png)

### 5. สร้าง AKS บน resource group จากขั้นตอนที่ 2
เราต้องการ Kubernetes config จาก output AKS เพื่อสร้าง Kubernetes namespace สำหรับ deploy Datadog agent  

<script src="https://gist.github.com/raksit31667/0fe793dfbe47dac775aeb2c164953012.js"></script>

โดยปกติ Azure resource จะเพิ่ม tag `ENV: DEV` มาโดยอัตโนมัติ ถ้าไม่ได้ customize มัน ทีนี้พอเรารัน pipeline มันก็นึกว่าเราเปลี่ยน tag จาก `DEV ~> null` เพื่อป้องกันเหตุการณ์นี้ ผมเลยเพิ่ม tag `ENV: TEST` ไป  

เสร็จแล้วจะยังรันไม่ได้ เพราะ AKS ต้องการ service principal  

### 6. เพิ่ม stage สร้าง Terraform tfvars file สำหรับ assign variable ลงไป
สร้าง `Variables` ใน Azure DevOps pipeline สำหรับ AKS เพิ่ม 2 ตัวคือ
- Service principal `client_id`
- Service principal `client_secret`

![Azure DevOps variables](/assets/2020-04-30/2020-04-30-azure-devops-pipeline-variables.png)

จากนั้นเราจะสร้าง `tfvars` file จาก `Variables` 2 อันนี้ ใช้ในการ pass variable เข้า Terraform  

<script src="https://gist.github.com/raksit31667/65667c5927b208e6f3eaa2deef941651.js"></script>

อย่าลืม publish `tfvars` file สำหรับใช้ใน apply stage ด้วย  

เข้าไปดู Artifacts หน้าตาประมาณนี้  

![Azure DevOps artifacts](/assets/2020-04-30/2020-04-30-azure-devops-final-artifacts.png)

### 7. ติดตั้ง Datadog agents โดยใช้ Helm
สร้าง Kubernetes namespace สำหรับ Datadog cluster agent ด้วย  

<script src="https://gist.github.com/raksit31667/8eeb0c4084b431da38948acd506608e4.js"></script>

ผม override configuration ของ `values.yaml` โดยเปิด feature ต่างๆ เช่น
- Log ingestion for Docker containers
- APM (tracing)
- `podLabelsAsTags` สำหรับ search หา metrics ผ่าน key `app: your-service-name` ได้เลย
- `DD_CHECKS_TAG_CARDINALITY` เป็น `orchestrator` เพื่อให้ Datadog เก็บ metrics เก็บ metrics ของ Kubernetes pods
สามารถอ้างอิงจาก [Datadog helm chart](https://github.com/helm/charts/blob/master/stable/datadog/values.yaml) ได้เลย  

สร้าง `Variables` ใน Azure DevOps pipeline สำหรับ AKS เพิ่ม 2 ตัวคือ
- Datadog `API_KEY`
- Datadog `APP_KEY`  

<script src="https://gist.github.com/raksit31667/bf30cf41b9765fd6536d55d144e36fbe.js"></script>

### มาถึงตรงนี้ ก็น่าจะเห็นภาพสำหรับการทำ Infrastructure-as-a-Code กันบ้างแล้ว
![Azure DevOps pipeline completed stages](/assets/2020-04-30/2020-04-30-azure-devops-final-stages.png)
![Datadog metrics explorer](/assets/2020-04-30/2020-04-30-datadog-metric-explorer.png)

