---
layout: post
title: "Kubernetes readiness probe กับ ALB health check ของมันต้องมีทั้งคู่ไหม"
date: 2025-08-03
tags: [kubernetes, aws, infrastructure, networking]
---

ในระบบที่เราดูแลอยู่มีการใช้ Kubernetes + AWS ALB (ผ่าน ALB Ingress Controller) ทีมเราก็ตั้งคำถามกันว่า

> ต้องใช้ทั้ง readiness probe กับ ALB health check พร้อมกันจริงเหรอ

เพราะดูมันทำหน้าที่คล้ายกันก็คือลด error rate ลงจากการ route traffic เข้าไปใน workload ที่ healthy เท่านั้น ดังนั้นถ้ามีแค่ ตัวใดตัวนึงมันก็จบแล้วนิ ซึ่งคำตอบคือถูกส่วนนึง แต่มันจะมี edge case บางอย่างซ่อนอยู่ ไปดูกัน

## ทำความรู้จัก Kubernetes readiness probe ก่อน
Readiness probe คือ mechanism ที่ Kubernetes ใช้ check ว่า **pod นั้นพร้อมรับ traffic แล้วหรือยัง**

* Run จากใน node (หรือใน container เองถ้าใช้ exec)
* ถ้า readiness fail -> Kubernetes network จะ **ไม่ส่ง traffic ให้ pod นั้นเลย**

<script src="https://gist.github.com/raksit31667/38c70faa9e58b60db2cb7a5600b2cfa0.js"></script>

| Field                 | ความหมาย                                                  |
| --------------------- | --------------------------------------------------------- |
| `httpGet.path`        | path ที่จะ check เช่น `/health`                             |
| `httpGet.port`        | port ที่ container เปิดอยู่ (ตรงกับ `containerPort`)      |
| `initialDelaySeconds` | รอเวลากี่วินาทีก่อน check ครั้งแรก (หลังจาก container start) |
| `periodSeconds`       | Check ทุก ๆ กี่วินาที                                       |
| `timeoutSeconds`      | รอ response นานแค่ไหนก่อนถือว่า timeout                   |
| `failureThreshold`    | ถ้า fail ต่อเนื่องกี่ครั้งถึงจะถือว่าไม่พร้อมรับ traffic            |

### แล้ว ALB health check คืออะไร
ในทางกลับกัน AWS ALB มี health check ของมันเอง มันจะยิง request มาที่ pod ผ่าน path ที่เรากำหนดไว้ (ใน ingress annotations)
ถ้า check แล้วไม่ผ่าน -> ALB จะ **ไม่ส่ง traffic จากข้างนอกเข้า pod ตัวนั้น**

ตัวอย่าง config:

```yaml
alb.ingress.kubernetes.io/healthcheck-path: /health
alb.ingress.kubernetes.io/healthcheck-port: "traffic-port"
```

### แล้วมันต่างกันยังไง?

| เรื่อง            | Readiness Probe (K8s)          | ALB Health Check (AWS)             |
| ----------------- | ------------------------------ | ---------------------------------- |
| Check จากที่ไหน     | ใน cluster / node              | จาก ALB (external)                 |
| Check เพื่ออะไร     | ตัดสินใจส่ง traffic ใน cluster | ตัดสินใจส่ง traffic จากภายนอก      |
| ถ้า check ไม่ผ่าน    | pod ยังอยู่ แต่ไม่รับ traffic  | ALB ไม่ส่ง traffic ให้ pod ตัวนั้น |

## แล้่วมันควรจะใช้ร่วมกันไหม
อย่างที่เกริ่นไปในต้น blog คือมันจะมี edge case อยู่ ลองตัวอย่าง case จริงที่เคยเจอจากการที่ตัวใดตัวนึงมัน fail

### Case 1: Readiness probe ผ่าน แต่ ALB เข้าไม่ได้
สิ่งที่เคยเจอคือ security group ของ pod/node configure ผิด ก็เลยกลายเป็นไม่เปิดให้ ALB เข้า จะเกิดเหตุการณ์ประมาณนี้
- Readiness probe ผ่าน -> Kubernetes รับ-ส่ง traffic จาก pod อื่น ๆ ได้อยู่
- ALB ยิง health check endpoint ไม่ได้ -> health check fail -> traffic ยังไม่เข้า pod

ช่วยให้เรารู้ว่าปัญหาไม่ได้อยู่ที่ app แต่เป็นเรื่อง infra เช่น SG, port, หรือ health check path ผิด

### Case 2: App ยังไม่พร้อมเพราะต้องรอ dependency ก่อน
สิ่งที่เคยเจอคือ แอพเพิ่ง start ขึ้นมา ยัง load dependency ไม่ครบ
- Readiness probe ยังไม่ผ่าน
- ALB fail -> traffic ไม่ยิงเข้ามา

ผลคือระบบไม่ส่ง traffic เข้ามาเลยทั้งภายในและภายนอก จนกว่า app จะพร้อมจริง ๆ

## สรุป: ใช้ทั้งคู่ไปเลยดีที่สุด
เพราะ Readiness probe กับ ALB health check มันทำงานคนละ layer

* Readiness probe = ถ้าผ่านถึงจะรับ **traffic เข้าภายใน cluster**
* ALB health check = ถ้าผ่านถึงจะรับ **traffic จากภายนอกเข้า**

| ใช้แค่ตัวเดียว          | ผลลัพธ์                                                  |
| ----------------------- | -------------------------------------------------------- |
| ใช้แค่ Readiness probe        | Traffic อาจจะไม่เข้าเพราะ network/security group/path ผิด แต่ไม่รู้ตัว  |
| ใช้แค่ ALB health check | Kubernetes ยังส่ง traffic มาจากใน cluster ทั้งที่ app ยังไม่พร้อม |
