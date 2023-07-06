---
layout: post
title: "สร้าง cron job ใน Azure Container Apps ผ่าน Dapr"
date: 2023-04-12
tags: [azure, azure-container-apps, dapr]
---

![Dapr cron bindings](/assets/2023-04-12-dapr-cron-bindings.png)

<https://docs.dapr.io/getting-started/quickstarts/bindings-quickstart/>

จาก [blog ที่แล้ว]({% post_url 2023-03-30-azure-container-apps %})พูดถึงเรื่องของ [Azure Container Apps (ACA)](https://learn.microsoft.com/en-us/azure/container-apps/overview) หนึ่งในความสามารถที่มีมาให้คือการใช้ Dapr ที่ช่วยลดความซับซ้อนในการพัฒนา feature ต่าง ๆ ตามแนวคิดของ distributed architecture โดยที่หนึ่งในนั้นคือการสร้าง [cron job](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/) มาดูกันว่ามันจะต้องมีขั้นตอนยังไงบ้าง

## ทำความเข้าใจ cron ใน Dapr ก่อน
โดยปกติแล้ว Dapr container จะถูก deploy ในรูปแบบของ sidecar ไปกับ app container หลัก เราสามารถ configure cron ผ่านการทำ [bindings](https://docs.dapr.io/developing-applications/building-blocks/bindings/bindings-overview/) ที่มีชื่อว่า `bindings.cron` ไปที่ Dapr sidecar โดยมี input ที่จะต้องกำหนดดังนี้

```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: <NAME>
spec:
  type: bindings.cron
  version: v1
  metadata:
  - name: schedule
    value: <SCHEDULE>
```

- **Name**: ชื่อของ cron job
- **Version**: กำหนด version ของ bindings (ขณะที่เขียน blog นี้จะมีแค่ version `v1` เท่านั้น)
- **Schedule**: กำหนดรอบเวลาที่ cron job จะถูก trigger โดยจะเขียนตาม shorthand syntax อย่าง
  - @every 5s (seconds)
  - @every 5m (minutes)
  - @every 5h (hours)

หรือจะยึดตามมาตรฐานอย่าง [cron expression](https://en.wikipedia.org/wiki/Cron) ก็ได้  

เมื่อเรา setup เรียบร้อยแล้ว สิ่งที่ Dapr จะทำคือมันจะไปเรียก endpoint ที่ชื่อตรงกันกับ cron job เช่น ถ้า protocol เป็น HTTP แล้ว cron job ชื่อ `recipes` ก็จะไปเรียก HTTP `POST /recipes` เป็นต้น ดังนั้น endpoint ควรจะถูก secure ผ่าน [Dapr authentication](https://docs.dapr.io/operations/security/oauth/) หรือไม่ก็ต้องปิด traffic ให้อยู่แค่ใน ACA environment เดียวกันด้วย

<script src="https://gist.github.com/raksit31667/3cb53adb4050fa58c8ae620db7399dd6.js"></script>

## แล้วจะ configure ผ่าน ACA ยังไง
ในโลกของ ACA ส่วนของ Dapr configuration จะถูกซ่อนไว้ภายใน Azure resource 2 อย่างได้แก่

- **Dapr configuration** สำหรับกำหนดเกี่ยวกับ Dapr bindings ทุกประเภทไม่ได้จำกัดแค่ cron job จะอยู่ภายใต้แต่ละ ACA มี 3 attributes ด้วยกัน
  - **app_id** ไว้ผูกกับ bindings
  - **app_port** ไว้ระบุว่าจะให้ Dapr sidecar คุยกับ application ผ่าน port ไหน ซึ่งก็ควรจะเป็น port เดียวกันกับที่ configure ไว้ใน [ingress](https://learn.microsoft.com/en-us/azure/container-apps/ingress-overview)
  - **app_protocol** เลือกระหว่าง HTTP กับ gRPC

- **Dapr component** เป็นจุดที่เก็บ bindings configuration ต่าง ๆ (รวมถึง cron job ด้วย) จะอยู่ภายใต้แต่ละ **ACA environment** เนื่องจาก bindings นึงสามารถผูกได้กับหลาย ๆ ACA ได้นั่นเอง โดยมีหลาย attributes ด้วยกัน
  - **name** ระบุชื่อของ component โดยมันควรจะเป็นชื่อของ endpoint ที่เก็บ business logic สำหรับ cron ตามหัวข้อก่อน
  - **container_app_environment_id** Dapr component อยู่ใน ACA environment ไหน
  - **component_type** ในที่นี้ก็จะเป็น `bindings.cron`
  - **version** ในที่นี้ก็จะเป็น `v1`
  - **scopes** เป็น list ของ Dapr application ID ที่ผูกกับ bindings นี้
  - **metadata** ค่านี้ก็จะต่างกันไปตามแต่ละ bindings สำหรับ cron job นั้นก็จะมี `schedule` ที่ต้องกำหนดไว้

เมื่อนำมาประกอบกันแล้วสร้าง resource ดังกล่าวผ่านวิธีต่าง ๆ เช่น Infrastructure-as-a-Code อย่าง [Terraform](https://www.terraform.io/) ก็จะได้หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/6bae83dbc2447abbef8883f134cb5cfe.js"></script>

สิ่งที่ cron ใน Dapr ต่างจาก cron ใน Kubernetes คือเมื่อ cron run เสร็จแล้วตัว container จะยังคงอยู่ ไม่ได้ถูกทำลายทิ้งเมื่อทุก container ใน cron definition มี exit status code เป็น 0 เหมือนใน Kubernetes นั่นเอง

> น่าจะเห็นแล้วว่าการใช้งาน cron job ใน Dapr นั้นเป็นเพียงหนึ่งในตัวอย่างของความสามารถที่ Dapr ของ ACA มีให้ ดังนั้นเราสามารถนำวิธีการนี้ไปประยุกต์ใช้กับ bindings ประเภทอื่น ๆ ได้ตามความเหมาะสม
