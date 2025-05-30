---
layout: post
title: "ลองใช้ External Secrets Operator เพื่อดึง secrets จาก AWS มาใช้ใน app ที่ิอยู่บน EKS"
date: 2025-05-12
tags: [external-secrets, kubernetes, aws]
---

## เล่าถึงปัญหาก่แน
ใน project นึงของเราที่ดูแลระบบ internal developer platform เรามี deployment ของ app ที่รันอยู่ใน EKS (Kubernetes ของ AWS) และใช้ secrets จาก AWS Secrets Manager สำหรับเช่น API Key, DB Password ฯลฯ โดยใช้ shared library ใน .NET เพื่อดึง secrets มาเก็บไว้ใน memory cache (TTL 60 นาที)  

แต่พอมี developer ไป update secrets ที่ AWS เราก็ต้องมานั่ง `kubectl rollout restart` service เองทุกครั้ง ซึ่งมันไม่ work เลยถ้าจะต้องมีหลาย ๆ service  

โจทย์ใหม่ที่ทีมเราต้องการในการจัดการกับ secrets คือ
1. Application สามารถ update ค่าตาม secret ที่เปลี่ยนได้
2. Application สามารถดึง secret โดยไม่ต้องไปดึงผ่าน AWS Secrets Manager โดยตรงทุกครั้ง
3. Developer สามารถเข้าไป update secret ได้อย่างง่ายและปลอดภัย

## ตัวเลือกที่พิจารณา
จากโจทย์ข้างต้น เราได้พิจารณาตัวเลือกต่าง ๆ ดังนี้

### Update ผ่าน Kubernetes Secrets โดยตรง
คือใช้ `kubectl edit secret ...` หรือ apply YAML ใหม่ลงไป

- ข้อดีคือใช้งานง่าย ไม่ต้องติดตั้งอะไรเพิ่ม application สามารถ mount secrets เป็น file หรือ env ได้เลย
- ข้อเสียคือไม่ตอบโจทย์บางข้อ เช่น ต้องจัดการ secret sync เอง และทีมเราต้องจัดการ developer access และความรู้ในการจัดการ Kubernetes secrets (เช่นเรื่องของ base64 encode รวมถึง auditing เป็นต้น)

### ใช้ Sealed Secrets
[Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) เป็น CLI tool เพื่อ encrypt secret ก่อน commit ลง git → แล้ว deploy ไป Kubernetes ให้ Sealed Secrets Controller ทำการ decrypt

- ข้อดีคือสามารถเก็บ secrets ไว้ใน Git ได้อย่างปลอดภัย ทำ auditing ได้ง่ายจาก version control ที่ Git มีให้ ถ้าใช้ GitOps tool ก็ยิ่งง่ายเข้าไปใหญ่ นอกจากนั้นเราไม่ต้องให้ developer เข้าถึง Secrets Manager หรือ cluster โดยตรง
- ข้อเสียคือจะมีความซับซ้อนในการจัดการ key pair สำหรับการ seal/unseal secret และไม่ตอบโจทย์ "auto update" เพราะ sealed secret ต้อง deploy ใหม่ทุกครั้งที่เปลี่ยน นอกจากนั้น developer ต้องใช้ CLI tool เพิ่ม ซึ่งก็คือ `kubeseal`

### ใช้ External Secrets Operator (ESO)
[External Secrets Operator](https://external-secrets.io/latest/) คือ Kubernetes controller ที่ช่วย sync ข้อมูลจาก AWS Secrets Manager (หรือ secret provider อื่นๆ) มาเก็บเป็น Kubernetes Secrets ให้เราอัตโนมัติ

- ข้อดีคือ application สามารถ mount secrets เป็น file หรือ env ได้เลย Kubernetes Secrets update ค่าตาม Secrets Manager ได้
- ข้อเสียคือมีความซับซ้อนเพิ่มเติมในการติดตั้ง operator เพิ่มใน cluster จัดการ IAM permission เพื่อให้สิทธิ์ cluster อ่านค่าจาก Secrets Manager นอกจากนั้น developer ต้องเรียนรู้วิธีการเขียน `ExternalSecret` เพิ่มเติม

ESO มี component หลัก ๆ อยู่ประมาณนี้:

![ESO Diagram](/assets/2025-05-12-eso-diagrams-component-overview.png)
<https://external-secrets.io/latest/api/components/>

#### 1. SecretStore / ClusterSecretStore
เป็นตัวบอกว่าเราจะไปดึง secret จาก external source อะไร ที่ไหน และใช้ credential แบบไหน

- `SecretStore` = ใช้ใน namespace เดียวกับ app
- `ClusterSecretStore` = ใช้ข้าม namespace ได้ (เหมาะกับการ reuse/shared seceet)

#### 2. ExternalSecret / ClusterExternalSecret
เป็นตัวกำหนด Kubernetes `Secret` ที่จะถูกสร้างใหม่และ sync จาก `SecretStore` / `ClusterSecretStore` อีกที

- ระบุว่าจะสร้าง secret ชื่ออะไรใน cluster
- จะดึง key ไหนจาก AWS Secrets Manager มาใช้
- จะ mapping secret key ยังไงบ้าง
- `ExternalSecret` = ใช้ใน namespace เดียวกับ app
- `ClusterExternalSecret` = สร้าง Kubernetes `Secret` แบบเดียวกันในหลาย ๆ namespace ได้ (เหมาะกับการ reuse/shared seceet)

#### 3. ESO Controller
เบื้องหลังจะมี controller ที่ run อยู่ใน cluster คอยทำงานตาม CRD พวกที่เราสร้างข้างบน

- ดูว่าเรามี `ExternalSecret` อะไรบ้าง
- ไปดึง secret จาก source ตามที่ระบุ
- สร้างหรือ update Kubernetes `Secret` ให้อัตโนมัติ

### วิธีติดตั้ง External Secrets Operator ด้วย Terraform
ตัวอย่างใน blog เราใช้ `ClusterSecretStore` เพราะอยากให้หลาย namespace ใช้ร่วมกันได้

<script src="https://gist.github.com/raksit31667/5504e5cfdd6e89e1dbe67bf84496e79e.js"></script>

สร้าง ClusterSecretStore ที่ใช้ AWS Secrets Manager

<script src="https://gist.github.com/raksit31667/87439bf603566f802ee6a07a71928246.js"></script>

แค่เราสร้าง `ExternalSecret` object โดยบอกว่าอยากได้ secret key ไหนจาก AWS มาเก็บเป็น Kubernetes `Secret` แล้ว ESO จะดูแลให้เลย เช่น

<script src="https://gist.github.com/raksit31667/8774642f9bf6e3ee5fabc838210e9f84.js"></script>

อันนี้จะไปดึง `prod/weather/apiKey` จาก AWS Secrets Manager มาเก็บเป็น Kubernetes Secret ชื่อ `weather-api-secrets`  

จากนั้นผูก IAM Role กับ ServiceAccount `external-secrets-sa` ด้วย [IAM roles for service accounts (IRSA)](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) ตามแนวทางของ AWS EKS เป็นอันเสร็จ

### แล้ว app รู้ได้ไงว่า Secret เปลี่ยน
ถึง ESO จะ sync ให้ Kubernetes `Secret` เปลี่ยนอัตโนมัติ แต่ Deployment ของเราจะไม่รู้เลยว่า secret file ที่ mount อยู่มันเปลี่ยนแล้ว ทำให้ app ยังคงใช้ค่าเดิมอยู่ จนกว่าเราจะ restart เอง ถ้าลืมหรือไม่รู้ app อาจทำงานผิดเพราะใช้ secret เก่าอยู่

**ตรงนี้แหละที่ "Reloader" เข้ามาช่วย** [Reloader](https://github.com/stakater/Reloader) เป็น Kubernetes controller ที่คอย ดูว่า `Secret` หรือ `ConfigMap` ไหนมีการเปลี่ยนแปลง แล้วจะ trigger การ rolling restart ของ `Deployment`, `StatefulSet` หรือ `DaemonSet` ให้แบบอัตโนมัติ

#### ติดตั้ง Reloader ด้วย Terraform

ในเมื่อเราใช้ Terraform จัดการ infra อยู่แล้ว เราก็ติดตั้ง Reloader ผ่าน Helm ได้เลย

<script src="https://gist.github.com/raksit31667/ff75e89b6c002516d2be18db1ecb1278.js"></script>

แล้วใน Deployment ของเรา แค่เพิ่ม annotation นี้

```yaml
metadata:
  annotations:
    reloader.stakater.com/auto: "true"
```

เท่านี้ Reloader จะคอยสังเกต Kubernetes `Secret` ที่ mount อยู่ใน deployment ถ้ามีการเปลี่ยนแปลง มันจะทำ rolling restart ให้อัตโนมัติ

### สรุปภาพรวม solution

1. ใช้ ESO ดึง secrets จาก AWS Secrets Manager → Kubernetes Secret
2. ใช้ Reloader คอยดูว่า Secret เปลี่ยนหรือไม่ → ถ้าเปลี่ยนก็ trigger rollout
3. Application ไม่ต้องใส่ AWS SDK ไม่ต้องทำ cache เอง และไม่ต้อง restart manual

ดูตัวอย่าง code ได้ใน <https://github.com/raksit31667/learn-external-secrets>
