---
layout: post
title:  "Deploy Angular application บน Local Kubernetes โดยใช้ Helm"
date:   2021-04-06
tags: [angular, kubernetes, kind, cicd]
---

ช่วงนี้มีงานยกเครื่อง path to production ใหม่บนระบบหน้าบ้านที่พัฒนาบน Angular 10 เนื่องจากปัญหาที่เจอบนระบบปัจจุบันไม่ตอบโจทย์การส่งมอบ product  

## As-is
- ระบบปัจจุบันมี pipeline ที่เอื้อต่อแนวคิดของ CICD ซึ่งแบ่งเป็น 2 ส่วนหลักๆ คือ
  - **Continuous integration (CI)** เมื่อแต่ละคนนำสิ่งที่ตัวเองสร้างมารวมกัน (integrate) เราจะมั่นใจได้ไงว่า มันยังทำงานได้อย่างถูกต้อง
  - **Continuous deployment (CD)** เมื่อทำการ deploy ระบบงาน เราจะมั่นใจได้ไงว่ามันยังทำงานได้อย่างถูกต้อง

- ในขั้นตอน CI ก็มีการทดสอบพวก unit test หรือ integration test หรือ static code analysis ทุกอย่างต้องผ่านทั้งหมด 

- Configuration ถูกแยกออกจาก source code เมื่อแก้ configuration ก็ไม่ตัอง build ใหม่ตั้งแต่เริ่ม
  
- ระบบมีการกำหนด environment มากมาย เช่น DEV SIT UAT เพื่อสร้างมั่นใจและลดโอกาสที่ bug จะเกิดขึ้นบน production นอกจากนั้นยังเอื้อต่อการทดสอบอื่นๆ โดยไม่กระทบการส่งมอบงานโดยตรง เช่น regression test หรือ performance test

![Traditional CICD pipeline](/assets/2021-04-08-traditional-cicd-pipeline.png)
<https://blog.oursky.com/2019/08/19/how-to-build-cicd-pipeline/>
  
### ทุกอย่างก็ดูดีนะ
แต่ปัญหาที่พบเจอระหว่างเข้ามาทำ product นี้คือ
- **Build once, deploy once** ถึงแม้จะมีหลาย environment แต่ก่อนจะ deploy ทุกครั้งจะต้องมีการ build ใหม่เสมอ แน่นอนว่าขั้นตอนทุกอย่างยังเหมือนเดิม
- **Branching** แต่ละ environment ผูกกับแต่ละ Git branch ทำให้ branching strategy รวมถึง conflict management ซับซ้อนมากขึ้น

## To-be
ดังนั้นสิ่งที่เราสามารถปรับปรุงได้คือ
- **Build once, deploy everywhere** มีการ build เพียงครั้งเดียวเพื่อให้ได้ artifact มา deploy ตาม environment ที่ต้องการ ทั้งยังการันตีได้ด้วยว่า deploy ด้วย artifact เหมือนกัน ก็จะทำงานได่้คล้ายๆ กันที่สุด ที่ต่างก็จะเป็นแค่ configuration เท่านั้น ทั้งนี้ทั้งนั้นก็ต้องมั่นใจด้วยว่า backing services ที่ใช้ (เช่น database, message queue, caching system, SMTP service) ต้องคล้ายกันที่สุดด้วยนะ

## เริ่มลงมือ
เครื่องมือที่ใช้คร่าวๆ มีประมาณนี้
- GitHub Actions
- act
- Docker
- Kind
- Helm

flow ใหม่คร่าวๆ ของเราคือ
1. ทำการ run build pipeline เมื่อมีการเปลี่ยนแปลง โดยยังคงขั้นตอนการทดสอบอะไรไว้เหมือนเดิม
2. Build artifact จาก source code เป็น Docker image จากนั้นเก็บไว้ใน Docker registry
3. (ถ้าจำเป็น) Update configuration และ Kubernetes resource ผ่าน Helm template files, Chart และ values file
4. ทำการ run deployment pipeline โดยมีขั้นตอนไป upsert Helm repo ใน Kubenetes namespace ที่กำหนดไว้

![K8S CICD pipeline](/assets/2021-04-08-k8s-cicd-pipeline.png)
<https://developpaper.com/k8s-and-cicd-using-helm-to-deploy-and-apply-to-kubernetes/>




