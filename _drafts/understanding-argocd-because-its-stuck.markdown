---
layout: post
title: "ทำความเข้าใจ ArgoCD มากขึ้นจากการเจอปัญหา sync/refresh แล้วไม่ไป"
date: 2026-01-25
tags: [argocd, gitops, kubernetes, redis]
---

หลายคนใช้ Argo CD ทุกวัน deploy แอปผ่าน GitOps แบบชิล ๆ เหมือนกับเรา แต่พอวันหนึ่ง sync ค้าง refresh แล้วไม่ไป เกิด timeout ตอน fetch repository จะรู้ได้ไงว่ามันพังตรงไหน ซึ่งเราไม่สามารถเริ่มหาคำตอบหรือหาเบาะแสได้หากเราไม่เข้าใจว่า Argo CD มันทำงานยังไง แล้วแต่ละส่วนมันแบ่งหน้าที่กันยังไง เราก็ใช้เหตุการณ์ที่เกิดขึ้นเป็นการจุดประกายในการเรียนรู้ไป

## เข้าใจ ArgoCD component
การมอง ArgoCD เป็น component จะช่วยให้เข้าใจว่า อะไรที่มันสามารถพังได้่บ้าง ถ้าพังแล้วจะลากอะไรพังตาม จาก doc ของ ArgoCD เราสามารถทำความเข้าใจได้ง่าย ๆ ดังนี้

![ArgoCD components](./assets/2026-01-25-argocd-components.webp)
<https://argo-cd.readthedocs.io/en/stable/developer-guide/architecture/components/>

1. UI Layer: ชั้นที่ user เจอโดยตรง เช่น web, CLI มีหน้าที่แสดงผลโดยคุยกับ API Server เท่านั้น
2. Application Layer: ชั้นที่เป็น API Server เป็นแค่ส่วนที่รับ request จาก UI / CLI และส่งงานต่อให้ controller หรือ repo-server ไม่ sync เอง ไม่อ่าน Git เอง
3. Core Layer: ประกอบไปด้วย Application Controller, ApplicationSet Controller, Repo Server เป็นหัวใจหลักของ ArgoCD
4. Infra Layer: ประกอบไปด้วย Redis, Kubernetes API, Git, Dex (Auth) เป็น source of truth ของ ArgoCD และจัดการ auth

มาเจาะลึก component ที่น่าสนใจกันเพิ่มอีกสักหน่อย

### Application Controller
หนึ่งในหัวใจหลักของ ArgoCD มีหน้าที่ด้วยกันดังนี้

- อ่าน Application, Project, Sync status, Health status จาก ​Redis
- เอา desired state จาก Repo Server
- เทียบกับ live state ใน Kubernetes ผ่าน Kubernetes API
- ตัดสินใจ sync / health / drift

เราจะเรียก process ตรงนี้ทั้งหมดว่า Reconcilation  

### Repo Server
ทำหน้าที่

- Clone Git
- Render Helm / Kustomize / manifests
- ส่ง desired state ให้ Controller

### Redis
Argo CD ใช้ Redis เพื่อ

- Cache Application, Kubernetes state
- Cache Git results
- Coordination ระหว่าง component
- เป็น work queue ให้กับ Application/ApplicationSet Controller เพราะ event ในการ sync ควรเป็น sequential

ในบาง setup สามารถตั้งให้ Redis deploy ในรูปแบบ high availability (HA) ซึ่งจะมีอย่างน้อย 3 replicas ในรูปแบบ `StatefulSet`

## Thought process เวลาเจอ ArgoCD ค้าง
กลับมาที่อาการ classic ที่หลายคนเจอ

- App ค้างที่ Running / Waiting to start
- กด Refresh แล้วไม่ขยับ
- Sync ใช้เวลานานผิดปกติ
- ไม่มี error ชัดเจน

เมื่อเรามองจาก flow ในการทำงานแล้วเราจะเห็นว่า ถ้า layer ใด layer หนึ่งช้า layer ด้านบนจะช้าตามไปด้วย ลองไล่ดูไปด้วยกัน

1. UI แค่แสดงผล ไม่ได้ทำงานหนัก ดังนั้น UI ค้าง = backend ค้าง อย่าเริ่ม debug ที่ frontend นาน
2. ในส่วนของ API server อาจจะเป็นต้นเหตุถ้า CLI timeout หรือ UI error บางหน้าโหลดไม่ขึ้น แต่โดยมากจะเป็นที่ API server คุยกับ Controller หรือ Repo Server ไม่ได้ ไปจนถึงรอ Redis ตอบช้า ดังนั้นมันมักเป็นตัวสะท้อนปัญหามากกว่าต้นเหตุ
3. Application Controller กรณีที่เป็นไปได้เช่น CPU สูง เพราะ App เยอะ หรือจำนวนงานที่ต้อง process เยอะ แต่ถ้า CPU ต่ำ ให้ไปดูว่า info log น้อยลงไปไหม หรือ work queue depth สูงขึ้นหรือเปล่า ถ้าใช่แปลว่า Controller มันรอ dependency อยู่
4. Repo Server มักจะเจอ error แบบ `GenerateManifest timeout` เหตุที่เป็นไปได้คือ Git ช้า / auth มีปัญหา repo มีขนาดใหญ่เกิน หรือว่าคุยกับ Redis ไม่ได้ ซึ่งล้วนแล้วแต่เป็น Infra Layer ทั้งนั้น
5. Redis ให้ดู CPU, memory, ops/sec โดยเฉพาะอย่างหลังถ้า ops/sec ลดลง แต่ไม่มี traffic spike มีโอกาสว่า Redis ไม่ตอบ มากกว่ารับงานไม่ไหว ในส่วนของ Redis HA ให้ดูเพิ่มเติมที่ [Sentinel container](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/) ถ้า Sentinel CPU สูงแค่บาง pod แล้วมี log `+sdown`, `+failover` แสดงว่า Redis ไม่ stable ในการ coordinate กับ Redis pod อื่น ๆ ในรูปแบบ master-slave
6. Kubernetes API ถ้ามี latency สูง Argo CD จะ reconcile ช้าลง
7. Git บางที่ clone บ่อย ๆ repo ใหญ่ ๆ อาจะติด rate limit หรือ network issue แต่ก็จะกระทบเฉพาะบาง app เท่านั้น

โดยสรุปแล้วแนวคิดในการไล่หาสาเหตุเมื่อ Argo CD เกิดอาการ sync ค้างหรือ refresh ไม่ไป ให้เน้นให้มองระบบเป็น flow ภาพรวมตั้งแต่ UI ไปจนถึง Kubernetes API และ Git สิ่งที่ขาดไม่ได้เลยคือ observability เพื่อดู metrics สำคัญ เช่น CPU usage, work queue depth, และ Redis ops/sec เพื่อแยกให้ออกว่าระบบมันค้างหรือแค่ยุ่งเฉย ๆ นั่นเอง
