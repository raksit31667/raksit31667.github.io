---
layout: post
title: "ความเชื่อมโยงกันของ Kubernetes Deployment, HPA, PDB resource"
date: 2025-08-09
tags: [kubernetes]
---

หลายคนที่เริ่มนำระบบงานไป deploy หรือดูแลระบบที่อยู่ใน Kubernetes อาจจะเข้าใจว่าแต่ละ resource ทำงานแยกจากกันไปเลย แต่จริง ๆ แล้วมันมีกรณีที่ทำงานเชื่อมโยงกัน และถ้าเราไม่เข้าใจพฤติกรรมของมัน เราอาจจะเจอ deployment ที่ rollout ไม่เสร็จ autoscaling แกว่ง หรือแม้แต่ downtime แบบงง ๆ ก็เลยเขียน blog นี้ขึ้นมาว่าของพวกนี้มันเกี่ยวข้องกันยังไง และต้องระวังตรงไหนบ้าง

## 1. Deployment Strategy แบบ Rolling Update
เวลาเรากด `kubectl rollout restart` หรือ deploy pod ใหม่ ระบบจะทำ rolling update แบบค่อย ๆ สร้าง pod ใหม่เข้ามาทีละนิด เมื่อ pod ใหม่พร้อมรับ traffic แล้วค่อย terminate pod เก่าออก

สิ่งที่ควรรู้คือมี 2 ค่าหลัก:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 25%
    maxUnavailable: 25%
```

* `maxSurge`: สร้าง pod ใหม่เพิ่มได้เกินจากจำนวนที่กำหนดกี่ pod หรือกี่ percent
* `maxUnavailable`: ยอมให้มี pod ที่ไม่พร้อมใช้ (unavailable) ได้กี่ pod หรือกี่ percent ระหว่าง rollout

หมายความว่าถ้าเราตั้ง `maxUnavailable` ต่ำเกินไป แต่กว่า pod ของเราจะพร้อมรับ traffic (readiness) ก็ช้ามาก rollout จะช้าหรือค้าง เพราะของใหม่ยังไม่พร้อมแต่ของเก่าก็ลบไม่ได้

## 2. CPU / Memory Request & Limit
การกำหนด CPU และ memory เป็นส่วนนึงของ Deployment เพราะมันเกี่ยวกับการจอง resource และ ป้องกันการใช้ resource เกินจนไปรบกวนระบบส่วนอื่น ๆ จนลามไปถึงทุก ๆ ส่วน 

* `request` = resource ที่ขอจองไว้ตอนที่ scheduler กำลังจะ schedule pod เข้า node
* `limit` = ของที่ใช้ได้สูงสุด ถ้าเกินจะถูก throttle (CPU) หรือ OOMKill (memory)

สิ่งที่หลายคนเจอ (รวมถึงตัวเราด้วย):

* ตั้ง CPU request เยอะเกิน -> HPA คิดว่าใช้ CPU ไม่ถึง -> เปลือง CPU (over-provision)
* ตั้ง memory limit ต่ำเกิน -> app run ได้แป๊บเดียวก็โดน OOMKill (out of memory) -> pod ตายระหว่าง rollout

## 3. HPA Behavior & Stabilization

HorizontalPodAutoscaler (HPA) ใช้ค่า CPU หรือ memory utilisation เพื่อตัดสินใจว่า scale up/down ดีไหม โดย HPA คิดจากสัดส่วนของ utilisation กับ request 

- ถ้า request เยอะ แต่ app ใช้จริงนิดเดียว -> HPA คิดว่า utilisation ต่ำ -> เปลือง resource
- ถ้า request น้อย แต่ app ใช้จริงเยอะ -> HPA คิดว่า utilisation สูง -> เริ่มทำการ scale up

```yaml
behavior:
  scaleUp:
    stabilizationWindowSeconds: 60
    policies:
      - type: Percent
        value: 100
        periodSeconds: 15
    selectPolicy: Max
```

* `stabilizationWindowSeconds` จะช่วยหน่วงการ scale เพื่อรอให้ utilisation มันขึ้น/ลงให้สม่ำเสมอก่อน ไม่ใช่พอ spike แป๊บเดียวก็ scale เลย
* `policies` ช่วยจำกัดจำนวน pod ในการ scale — จะได้ไม่ scale up/down เยอะจนเกินไป

## 4. PodDisruptionBudget (PDB)

PDB คือตัวคุมว่า จะ disrupt pod ได้มากสุดกี่ตัว เวลามี rolling update, node maintenance หรือ autoscaling

```yaml
pdb:
  minAvailable: 1
```

* ถ้าเราบอกว่า `minAvailable: 1` -> อย่างน้อยต้องมี 1 pod ที่พร้อมเสมอ
* ถ้ามี disruption แล้วเหลือน้อยกว่านั้น -> Kubernetes จะไม่ยอมให้ลบ pod

มันจะมีกรณีที่เกี่ยวข้องกับ Deployment rolling update คือถ้า `maxUnavailable` ของ rolling update กับ `minAvailable` ของ PDB conflict กันจะทำให้ rolling update ค้างได้ (เช่น `maxUnavailable` = 2 แต่ PDB บอก `minAvailable` = 1)

## แล้ว resource ทั้งหมดนี้มันเชื่อมโยงกันยังไง

ลองนึกภาพ deploy ตามนี้

1. **Deployment เริ่มปล่อย pod ใหม่** ตาม `maxSurge` / `maxUnavailable`
2. **Readiness probe ยังไม่ผ่าน** -> Pod ใหม่ยังไม่ ready
3. Deployment จะพยายามลบ pod เก่าออก -> แต่ถ้า **PDB ไม่ให้ลบเกินกว่านี้** -> rolling update ค้าง
4. ถ้า HPA run อยู่ -> ดู CPU load แล้วอาจ scale เพิ่ม
5. แต่ถ้าเรา **ตั้ง CPU request เยอะไป** -> HPA คิดว่าโหลดต่ำ (เพราะคิดเป็น % of request) -> ไม่ scale เพิ่ม
6. สุดท้าย rolling update ติด HPA ไม่ช่วย PDB ก็ไม่ให้ลบ -> **deploy ไม่เสร็จ**

มันแปลว่าของพวกนี้ไม่ได้แยกกันอยู่เลย การทำความเข้าใจแต่ละ resource ก็สำคัญ การเข้าใจว่ามันมีผลกระทบต่อกันยังไงก็สำคัญเช่นเดียวกัน 

| ของที่เกี่ยว             | เรื่องที่ต้องระวัง                                                                |
| ------------------------ | --------------------------------------------------------------------------------- |
| Rolling update           | readiness probe ต้องไม่ strict เกินไป strategy ต้องไม่ conflict กับ PDB |
| Resource requests/limits | CPU/memory request มากเกินไป -> ทำให้ HPA ไม่ scale                                       |
| HPA behavior             | stabilization window ป้องกัน flapping แต่ก็อาจ delay การ scale เมื่อต้องการ            |
| PDB                      | ถ้าตั้งผิด -> rolling update หยุดนิ่งทันที                                  |

ถ้าเราเข้าใจวิธีที่มันทำงานร่วมกัน เราจะสามารถปรับ config ให้ rollout เร็วขึ้น, autoscale ลื่นขึ้น และป้องกัน downtime ได้อย่างมั่นใจตามความต้องการของ business
