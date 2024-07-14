---
layout: post
title: "ว่าด้วยเรื่องของแนวทางในการออกแบบ SaaS ผ่าน multi-tenant architecture"
date: 2024-07-14
tags: [software-as-a-service, architecture, multi-tenancy, kubernetes]
---

![Kubernetes multi-tenancy](/assets/2024-07-14-kubernetes-multi-tenancy.png)
<https://www.youtube.com/watch?v=iBO9pLwOasE>

เมื่อช่วงต้นปีที่ผ่านมาได้มีโอกาสออกแบบระบบ [Software-as-a-Service (SaaS)](https://en.wikipedia.org/wiki/Software_as_a_service) ให้องค์กรที่กลุ่มลูกค้าคือบริษัทย่อย ๆ อีกที (B2B) ซึ่งองค์กรมี pain point ที่ค่าใช้จ่ายในการดูแล infrastructure ของลูกค้าแต่จะเจ้าสูง พอเข้าไปดูแล้วก็พบว่า

- ก่อนหน้านี้ลูกค้าแต่ละเจ้าขององค์กรนี้มี infrastructure แยกเฉพาะไปเลย เจาะลึกลงไปแต่ละเจ้าก็พบว่าใช้ resource (CPU, memory) ไม่ถึง 10% ในช่วงเวลาปกติ แต่อาจจะมีโดดขึ้นมา 50%-70% เดือนละครั้งจากการ batch load ข้อมูลเข้าที่กินเวลาประมาณ 15 นาที
- องค์กรได้บทเรียนก็เลยสร้างระบบใหม่สำหรับลูกค้าใหม่ต่อจากนี้ (ลูกค้าเจ้าเดิมก็ใช้แบบเดิมไปก่อนเนื่องจากสาเหตุด้าน people-process-tech) โดยปรับ architecture ให้เป็น [multi-tenant architecture](https://en.wikipedia.org/wiki/Multitenancy) กล่าวคือเป็น architecture ที่ instance 1 ตัวสามารถ serve request ให้ลูกค้า (ในที่นี้คือ tenant) ได้มากกว่า 1 เจ้า เมื่อมี tenant ใหม่ onboard เข้ามา traffic ก็จะวิ่งเข้ามาที่ instance เดียวกันโดยไม่ต้อง provision instance ชุดใหม่อีกแล้ว ซึ่งก็ทำให้ค่าใช้จ่ายลดลงไปได้เยอะเมื่อเทียบกับ architecture เก่า
- Business model ใหม่มีการกำหนด tier (S-M-L) เพื่อควบคุมการใช้งาน รวมไปถึงจำนวน feature และ priority ของการ support เมื่อเกิดปัญหา
- มี cross-functional requirement ที่ใหญ่ที่สุดคือ availability ที่ตั้งไว้สูงมาก

จากการค้นพบที่ว่าทำให้ทีมมานั่งคุยกันว่า architecture ทั้ง 2 แบบนั้นมีข้อดี-ข้อเสียอย่างไรซึ่งก็พบว่ามันคือ**การ trade-off ระหว่าง ความเป็นอิสระจากกัน (isolation) กับ การใช้งาน resource (resource utilization) ที่ดีขึ้น**ดังนี้

## Architecture เก่า (Silo model)
![Silo model](/assets/2024-07-14-silo-model.png)

- เมื่อระบบของ tenant นึงเกิดปัญหา เช่น ล่มหรือกิน resource เยอะ จะกระทบกับแค่ tenant นั้นเท่านั้น เจ้าอื่นไม่เกี่ยว
- Track ค่าใช้จ่ายที่เกิดขึ้นกับแต่ละ tenant ได้ง่าย
- การสร้างและกำหนด security policy และ access control ทำได้อย่างเรียบง่าย
- ยิ่งจำนวนของ tenant มากขึ้น ค่าใช้จ่ายในการ operate ยิ่งสูง เช่น หากมีการ upgrade OS ของ instance ต้องทำทีละ tenant
- ค่าใช้จ่ายสูงเนื่องจากมี resource ที่ไม่ถูกใช้อยู่แต่ไม่สามารถดึงออกมาให้ลูกค้าเจ้าอื่นใช้ได้
- การ onboarding มีแนวโน้มที่จะใช้เวลานานเนื่องจากต้อง provision infrastructure ใหม่ทั้งชุด

## Architecture ใหม่ (Pool model)
![Pool model](/assets/2024-07-14-pool-model.png)

- การ onboarding มีแนวโน้มที่จะใช้เวลาน้อยกว่าเนื่องจากสามารถใช้ infrastructure เดิมได้
- ค่าใช้จ่ายในการ operate ต่ำกว่าแบบ silo เพราะไม่ต้องมา operate ทีละ tenant แล้ว
- ค่าใช้จ่ายถูกลงเนื่องจากเราสามารถจัดสรรปันส่วน resource ตามการใช้งานของแต่ละ tenant ได้
- เมื่อระบบของ tenant นึงเกิดปัญหา เช่น ล่มหรือกิน resource เยอะ จะกระทบกับ tenant เจ้าอื่น ๆ ด้วย (noisy neighbor)
- Track ค่าใช้จ่ายที่เกิดขึ้นกับแต่ละ tenant ซับซ้อนมากขึ้นเนื่องจาก resource ใช้ร่วมกัน
- การสร้างและกำหนด security policy และ access control มีความซับซ้อนมากขึ้น
- มีความซับซ้อนเพิ่มในการจัดการจำนวน database connection ไม่ให้เกิน limit

## Bridge model (tier-based)
![Bridge model](/assets/2024-07-14-bridge-model-tier-based.png)
เป็นการนำของเก่า (silo) มา operate รวมกันกับของใหม่ (pool) แลกกับงาน operation ที่ซับซ้อนมาก ๆ

> ประเด็นที่น่าสนใจคือ "เราจะตอบโจทย์ด้าน isolation กับ resource utilization โดยไม่เอนเอียงไปด้านใดด้านนึงมากเกินไปได้อย่างไร"

ซึ่งคำตอบก็คือ**เราต้องออกแบบเริ่มต้นจาก pool model แลกกับการจัดการความซับซ้อนในการจัดการ tenant นั่นเอง แล้วถ้าจำเป็นค่อยโยกไปเป็น bridge model ทีหลังได้** ซึ่งวิธีการก็จะแตกต่างกันไปตาม technology ที่เลือกใช้ เช่น หากเราเลือก deployment platform เป็น Kubernetes เพื่อตอบโจทย์ด้าน availability (Kubernetes มี mechanism ที่ช่วยเรื่องนี้ เช่น [replication](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/), [probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/) หรือการแยก master node ออกจาก worker node เป็นต้น) เราจะต้องจัดการ tenant ในแง่ต่าง ๆ อาทิเช่น

## Pod security
- การป้องกันไม่ให้ tenant มี access ในการเข้าถึง configuration เกี่ยวกับ kernel, networking, VM ผ่าน [sysctl](https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/), [mounts](https://kubernetes.io/docs/concepts/storage/volumes/) และ port
- การป้องกันไม่ให้ tenant โจมตีระบบโดยใช้ท่า [privilege escalation](https://en.wikipedia.org/wiki/Privilege_escalation) ผ่านเครื่องมือ seccomp, security enhanced linux (SELinux), AppArmor (อ่านเพิ่มได้ที่ [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/))
- การสร้าง custom policy ผ่านเครื่องมืออย่าง [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) [Kyverno](https://kyverno.io/) หรือ [jsPolicy](https://www.jspolicy.com/)

## Networking
- การกำหนด network policy (ใน AWS เรียกว่า security group) ให้่ระบบ communicate หากันภายใน tenant (namespace) เดียวกันเท่านั้น ยกเว้น DNS port (53) เพื่อให้ระบบยังคงเข้าถึงผ่าน DNS service ได้อยู่

## Node management
- Assign node หรือสร้าง node pool สำหรับเฉพาะ tenant นั้น ๆ เพื่อป้องกันไม่ให้ workload จาก tenant อื่นเข้ามากวน (noisy neighbor)
- ใช้ solution ที่ช่วย manage การ scale node โดยลดการปวดหัวในการ manage node เช่น [serverless](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html) หรือ [nodeless Kubernetes](https://www.elotl.co/)

## Fair resource usage
- กำหนด limit ของจำนวน object เช่น pod, service, node port, load balancer
- กำหนด limit ของ hardware resource ทั้ง CPU และ memory
- ใช้ 1 namespace ต่อ 1 tenant เพื่อแยก configuration ตามที่กล่าวมาทั้งหมด แต่มีข้อจำกัดอยู่ที่ไม่สามารถกำหนดให้ access เข้า resource ที่ใช้กันทั้ง cluster ได้ ซึ่ง [vCluster](https://www.vcluster.com/) โฆษณาว่าสามารถมาแก้ตรงจุดนี้ได้โดยการสร้าง virtual control plane แยกกันตาม tenant ไปเลย

> การออกแบบระบบ SaaS เพื่อตอบโจทย์ด้าน isolation กับ resource utilization ที่นำเสนอในบทความนี้มันครอบคลุมด้าน technology เท่านั้น ยังมีด้าน people และ process ที่ต้องพิจารณาตามความเหมาะสมของแต่ละองค์กรอีกด้วย
