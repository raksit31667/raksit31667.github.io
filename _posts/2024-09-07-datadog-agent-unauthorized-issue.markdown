---
layout: post
title: "บันทึกปัญหา Datadog Agent Unauthorized ในการดึงข้อมูล Kubernetes Cluster"
date: 2024-09-07
tags: [datadog, kubernetes]
---

ในช่วงไม่กี่วันที่ผ่านมา business ของบริษัทลูกค้าได้เริ่มเข้าสู่ช่วง sale ซึ่งทำให้มี traffic เข้ามาในระบบมากขึ้น ทีนี้เราต้องการตรวจสอบสถานะของ cluster ว่าเป็นอย่างไรบ้าง แต่สิ่งที่เกิดขึ้นคือข้อมูลของ cluster หายไปจาก Datadog เมื่อเราตรวจสอบเพิ่มเติมพบว่าข้อมูลของหลาย ๆ cluster ใน Datadog มีความผิดพลาด

![Datadog before resolving](/assets/2024-09-07-datadog-before-resolving.png)

จากการตรวจสอบ error logs ใน Datadog agent พบข้อความต่อไปนี้

```
error pulling from collector "kubelet": couldn't fetch "podlist": unexpected status code 401 on https://<NODE_IP>:10250/pods: Unauthorized
.
.
.

Cache processing of cluster-checks configuration provider failed: temporary failure in clusterAgentClient, will retry later: cluster agent authentication token length must be greater than 32, currently: 30
```

ในขณะที่ตรวจสอบ Datadog cluster agent พบข้อความแสดงข้อผิดพลาดเพิ่มเติมดังนี้

```
failed to resolve input: unable to list Kube resources:'policy/v1beta1, Resource=pods', ns:'default' name:'', err: pods.policy is forbidden: User "system:serviceaccount:default:datadog-cluster-agent" cannot list resource "pods" in API group "policy" in the namespace "..."
```

## การทำงานของ Datadog และการตั้งค่าใน Kubernetes
ก่อนที่เราจะเข้าไปแก้ไขปัญหา เราควรทำความเข้าใจเกี่ยวกับการทำงานของ Datadog ใน Kubernetes อย่างละเอียด โดย Datadog จะมีการทำงานผ่าน Node agent และ Cluster agent ที่มีการเชื่อมต่อกับ Kubernetes API (kubelet) เพื่อรับข้อมูลและตรวจสอบสถานะต่างๆ ของ cluster

![Datadog agents](/assets/2020-04-30/2020-04-30-datadog-agents.png)

### 1. Node Agent
Node agent เป็น component หลักของ Datadog ที่ทำหน้าที่ติดตามข้อมูลและ metrics ต่างๆ ที่เกี่ยวข้องกับแต่ละ node ใน Kubernetes เช่น การใช้ CPU, memory, สถานะของ container และอื่น ๆ  

Node agent จะทำงานโดยการเชื่อมต่อกับ Kubernetes API (kubelet) ซึ่งเป็น API ที่รันบนทุก node เพื่อดึงข้อมูลเกี่ยวกับ pod และ container ที่กำลังรันอยู่ แล้วต้องการใช้ authentication token เพื่อที่จะสามารถเข้าถึง API และดึงข้อมูลต่างๆ ได้

### 2. Cluster Agent
Cluster agent เป็น component ที่ทำหน้าที่จัดการและเชื่อมต่อระหว่าง Node agent หลาย ๆ ตัวใน Kubernetes Cluster agent จะช่วยลดภาระของ Kubernetes API โดยการดึงข้อมูลที่สำคัญเพียงครั้งเดียวแล้ว share ให้กับ Node agent ที่เกี่ยวข้อง  

การทำงานก็จะคล้ายกันกับ Node Agent โดยที่จะสื่อสารกับ Kubernetes API เพื่อดึงข้อมูลที่จำเป็น เช่น ข้อมูล cluster โดยรวม การกำหนดค่า network เป็นต้น แล้วก็ต้องการใช้ authentication token เช่นกัน

### 3. Kubernetes API (kubelet)

Kubernetes API (kubelet) เป็นส่วนสำคัญที่ทำหน้าที่รับและส่งข้อมูลระหว่าง Kubernetes control plane และ node ต่างๆ ใน cluster  

Kubelet จะดูแลการทำงานของ pod และ container บน node แต่ละ node รวมถึงการตรวจสอบสถานะและรายงานผลกลับไปยัง control plane  

Kubelet จะสื่อสารกับ Kubernetes API เพื่อรับคำสั่งจาก control plane และจัดการกับ pod บน node  รวมถึงการส่งข้อมูลกลับไปยัง API เพื่อการติดตามและตรวจสอบ

## การแก้ไขปัญหา
จาก error logs ที่เกิดขึ้น ทีมได้ทดลองทำการ update `DD_CLUSTER_AGENT_AUTH_TOKEN` ที่จากเดิมมี 30 bytes ให้เป็น 32 bytes แล้วทำการ restart ทั้ง Cluster agent และ Node agent ผลลัพธ์ที่ได้คือข้อมูลของ cluster และ metric ต่าง ๆ กลับมาแสดงผลเป็นปกติ  

![Datadog after resolving](/assets/2024-09-07-datadog-after-resolving.png)

เพื่อให้แน่ใจว่าปัญหาถูกแก้ไขเรียบร้อยแล้ว ทีมงานควรทำการตรวจสอบเพิ่มเติมใน error logs ของ Cluster agent เพื่อดูว่ามีข้อผิดพลาดใด ๆ ที่ยังคงอยู่หรือไม่ ปรากฎว่า error เดิมตามข้างบนก็หายไปหมดแล้ว แต่ดันเจอ error ใหม่ เช่น

```
Error from the agent http API server: http: TLS handshake error from <DATADOG_NODE_AGENT_IP>:<SERVICE_PORT>: EOF
```

การแสดงผลข้อมูลใน Datadog [Orchestrator Explorer](https://docs.datadoghq.com/infrastructure/containers/orchestrator_explorer/?tab=datadogoperator) ในส่วนของ Kubernetes Overview โดย สถานะ Pod ที่ถูกจัดหมวดหมู่โดย Nodes ยังไม่ถูกต้อง เนื่องจาก Pod ที่เห็นในทุก Node เป็นผลรวมของ Pod ทั้งหมด หากเราสามารถตั้งค่า host ได้อย่างถูกต้อง แต่ละ Node ควรแสดงผลตามการกรองที่ถูกต้อง

## สรุปสิ่งที่เราได้เรียนรู้
การจัดการกับปัญหาที่เกิดขึ้นใน Datadog โดยเฉพาะใน Kubernetes จำเป็นต้องมีความเข้าใจอย่างละเอียดถึงวิธีการทำงานของ agent ต่าง ๆ และวิธีการเชื่อมต่อกับ Kubernetes API การแก้ไขปัญหาที่เกิดขึ้นอาจต้อง update การตั้งค่าต่าง ๆ เช่น token และทำการรีสตาร์ท agent เพื่อให้ระบบกลับมาทำงานได้ตามปกติ

สิ่งสำคัญคือการตรวจสอบ error logs อย่างสม่ำเสมอและทำความเข้าใจปัญหาให้ถ่องแท้เพื่อป้องกันไม่ให้เกิดซ้ำในอนาคต