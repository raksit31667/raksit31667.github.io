---
layout: post
title: "วิธีการติดตั้งและแก้ปัญหาการใช้งาน CrowdStrike Falcon Sensor บน Kubernetes"
date: 2025-05-31
tags: [crowdstrike, security, kubernetes]
---

หลาย ๆ คนน่าจะรู้จัก CrowdStrike กัน ([ในเรื่องที่อาจจะไม่ค่อยดีสักเท่าไร](https://en.wikipedia.org/wiki/2024_CrowdStrike-related_IT_outages) ฮ่า ๆๆ) เขามี product อย่าง Falcon Sensor เป็น solution นด้านความปลอดภัยที่บริษัทใหญ่ ๆ หลายเจ้าเลือกใช้กับ Kubernetes โดยเฉพาะสำหรับการป้องกันและตรวจจับ security issue ในระดับ container และ node  

Blog นี้จะบอกวิธีการติดตั้งและ upgrade Falcon Sensor และแก้ไขปัญหาใน Kubernetes

## Falcon Sensor คืออะไร?
[CrowdStrike Falcon Sensor](https://www.crowdstrike.com/en-us/products/trials/try-falcon/) เป็น agent ที่ติดตั้งบน endpoint เช่น VM หรือ container เพื่อ monitor ชอ่งโหว่ด้าน security แบบ real-time ([เขาเคลมว่าใช้ AI และ threat intelligence](https://www.crowdstrike.com/en-us/platform/charlotte-ai/) เพื่อวิเคราะห์และตอบสนองต่อภัยคุกคามอย่างรวดเร็ว) ใน Kubernetes เราสามารถติดตั้ง Falcon Sensor ผ่าน Helm Chart หรือ DaemonSet เพื่อป้องกันทั้ง node และ container workload

## วิธีติดตั้ง / upgrade Falcon Sensor บน Kubernetes

### 1. Pull และ upload Falcon Sensor image ไปยัง Docker registry

CrowdStrike มี script bash ที่ชื่อว่า [falcon-container-sensor-pull.sh](https://github.com/CrowdStrike/falcon-scripts/tree/main/bash/containers/falcon-container-sensor-pull) สำหรับดึง image ล่าสุดจาก CrowdStrike registry และอัปโหลดไปยัง Docker registry ของเรา script นี้ช่วยให้การจัดการ image เป็นเรื่องง่าย

ตัวอย่าง GitHub Actions workflow เพื่อ automate process นี้กับ AWS Elastic Container Registry (ECR):

<script src="https://gist.github.com/raksit31667/bd2630d5c86a477c825c77d620f09d4d.js"></script>

Script นี้จะดึง image ล่าสุดของ Falcon Sensor และ upload ไปยัง ECR พร้อม tag เป็น `latest` โดยจะต้องมี input คือ `FALCON_CLIENT_ID` และ `FALCON_CLIENT_SECRET` ซึ่งเป็นข้อมูลรับรองที่ใช้สำหรับการเชื่อมต่อกับ CrowdStrike API ผ่าน OAuth2 ([ดูวิธีสร้าง](https://fluency.readme.io/docs/crowdstrike-falcon))

### 2. ติดตั้ง / upgrade Falcon Sensor ผ่าน Helm Chart

หากเคยติดตั้ง Falcon Sensor ด้วย Helm Chart มาก่อน การ upgrade สามารถทำได้ง่ายๆ ดังนี้:

```bash
aws eks update-kubeconfig --region <region> --name CLUSTER_NAME
kubectl config use-context arn:aws:eks:<region>:0123456789:cluster/CLUSTER_NAME
helm repo add crowdstrike https://crowdstrike.github.io/falcon-helm && helm repo update
```

สร้าง file `values.yaml` ด้วยค่าใหม่:

```yaml
falcon:
  cid: <FALCON_CID>
  tags: "<cluster-name>,..."
node:
  image:
    repository: <Docker registry>
    tag: <Falcon Sensor image tag>
```

จากนั้น run คำสั่ง:

```bash
helm upgrade --install falcon-helm crowdstrike/falcon-sensor \
    -n <namespace> --create-namespace \
    -f values.yaml
```

ในที่นี้ `FALCON_CID` คือรหัสประจำตัวลูกค้าที่ใช้ในการระบุบัญชีของเราในระบบ CrowdStrike สามารถเข้าไปดูค่าตามวิธีนี้ได้เลย [How to Obtain the CrowdStrike Customer Identification](https://www.dell.com/support/kbdoc/en-th/000129349/how-to-obtain-the-crowdstrike-cid)

การ upgrade นี้จะติดตั้ง Falcon Sensor version ใหม่บนทุก node ใน cluster ของเรา

### 3. ทดสอบการตรวจจับด้วย Detection Container

CrowdStrike มี [detection container](https://github.com/CrowdStrike/detection-container/) สำหรับทดสอบการตรวจจับของ Falcon Sensor สามารถ deploy ได้จาก GitHub repository:

```bash
kubectl apply -f https://raw.githubusercontent.com/CrowdStrike/detection-container/refs/heads/main/detections.example.yaml
```

หลังจาก deploy แล้ว เราก็ควรเห็นการแจ้งเตือนใหม่ใน CrowdStrike Falcon Dashboard ภายในไม่กี่นาที

## การแก้ไขปัญหา Falcon Sensor บน EKS

หาก Falcon Sensor ไม่ทำงานตามที่คาดไว้ หรือไม่สามารถตรวจจับ container ที่เป็นอันตรายได้ ลองทำตามขั้นตอนต่อไปนี้:

### 1. ตรวจสอบสถานะของ Falcon Sensor Pods

ใช้คำสั่งเพื่อดูสถานะและ log ของ DaemonSet และ pods

```bash
kubectl get daemonset falcon-sensor -n <namespace>
kubectl get pods -n <namespace> -l app=falcon-sensor
kubectl logs <pod-name> -n <namespace>
```

### 2. ตรวจสอบ Kernel Compatibility

หาก Falcon Sensor อยู่ใน Reduced Functionality Mode (RFM) อาจเกิดจาก kernel ที่ไม่รองรับ (ซึ่งสามารถเกิดได้หลัง upgrade เนื่องจาก Falcon Sensor script มันจะดึงมาแต่ version ล่าสุดเท่านั้น) ตรวจสอบด้วยคำสั่งนี้ใน container ของ Falcon Sensor

```bash
falcon-kernel-check
```

หากผลลัพธ์แสดงว่า `Host OS ... is not supported by Sensor version 00000.` แสดงว่า sensor ไม่สามารถทำงานได้เต็มที่ หากไม่รองรับ เราอาจต้อง upgrade sensor หรือเปลี่ยน kernel ให้เป็น version ที่รองรับ
