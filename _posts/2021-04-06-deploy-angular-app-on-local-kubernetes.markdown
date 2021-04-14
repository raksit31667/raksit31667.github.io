---
layout: post
title:  "Deploy Angular application บน Local Kubernetes"
date:   2021-04-06
tags: [angular, kubernetes, cicd]
---

ช่วงนี้มีงานยกเครื่อง path to production ใหม่บนระบบหน้าบ้านที่พัฒนาบน Angular 10 เนื่องจากปัญหาที่เจอบนระบบปัจจุบันไม่ตอบโจทย์การส่งมอบ product  

## As-is
- ระบบปัจจุบันมี pipeline ที่เอื้อต่อแนวคิดของ CICD ซึ่งแบ่งเป็น 2 ส่วนหลักๆ คือ
  - **Continuous integration (CI)** เมื่อแต่ละคนนำสิ่งที่ตัวเองสร้างมารวมกัน (integrate) เราจะมั่นใจได้ไงว่า มันยังทำงานได้อย่างถูกต้อง
  - **Continuous deployment (CD)** เมื่อทำการ deploy ระบบงาน เราจะมั่นใจได้ไงว่ามันยังทำงานได้อย่างถูกต้อง

- ในขั้นตอน CI ก็มีการทดสอบพวก unit test หรือ integration test หรือ static code analysis ทุกอย่างต้องผ่านทั้งหมด 
  
- ระบบมีการกำหนด environment มากมาย เช่น DEV SIT UAT เพื่อสร้างมั่นใจและลดโอกาสที่ bug จะเกิดขึ้นบน production นอกจากนั้นยังเอื้อต่อการทดสอบอื่นๆ โดยไม่กระทบการส่งมอบงานโดยตรง เช่น regression test หรือ performance test

![Traditional CICD pipeline](/assets/2021-04-08-traditional-cicd-pipeline.png)
<https://blog.oursky.com/2019/08/19/how-to-build-cicd-pipeline/>
  
### ทุกอย่างก็ดูดีนะ
แต่ปัญหาที่พบเจอระหว่างเข้ามาทำ product นี้คือ
- **Build once, deploy once** ถึงแม้จะมีหลาย environment แต่ก่อนจะ deploy ทุกครั้งจะต้องมีการ build ใหม่เสมอ แน่นอนว่าขั้นตอนทุกอย่างยังเหมือนเดิม
- **Branching** แต่ละ environment ผูกกับแต่ละ Git branch ทำให้ branching strategy รวมถึง conflict management ซับซ้อนมากขึ้น
- **Configuration** อยู่ติดกับ source ถ้ามีการเปลี่ยนแปลงต้อง build ใหม่ตั้งแต่ต้น

## To-be
ดังนั้นสิ่งที่เราสามารถปรับปรุงได้คือ
- **Build once, deploy everywhere** มีการ build เพียงครั้งเดียวเพื่อให้ได้ artifact มา deploy ตาม environment ที่ต้องการ ทั้งยังการันตีได้ด้วยว่า deploy ด้วย artifact เหมือนกัน ก็จะทำงานได่้คล้ายๆ กันที่สุด ที่ต่างก็จะเป็นแค่ configuration เท่านั้น ทั้งนี้ทั้งนั้นก็ต้องมั่นใจด้วยว่า backing services ที่ใช้ (เช่น database, message queue, caching system, SMTP service) ต้องคล้ายกันที่สุดด้วยนะ
- **Configuration ถูกแยกออกจาก source code** เมื่อแก้ configuration ก็ไม่ตัอง build ใหม่ตั้งแต่เริ่ม

## เริ่มลงมือ
เครื่องมือที่ใช้คร่าวๆ มีประมาณนี้
- GitHub Actions เป็น CI ของเรา
- Docker ไว้ build และ run application บน container ละก็ใช้ Docker Hub registry เพื่อ host image
- Kind สำหรับสร้าง Kubernetes cluster บน local ผ่าน Docker daemon ของเราเอง
- Helm เป็น package manager ช่วยให้การ deploy Kubernetes resource ง่ายขึ้น

flow ใหม่คร่าวๆ ของเราคือ
1. ทำการ run build pipeline เมื่อมีการเปลี่ยนแปลง โดยยังคงขั้นตอนการทดสอบอะไรไว้เหมือนเดิม
2. Build artifact จาก source code เป็น Docker image จากนั้นเก็บไว้ใน Docker registry
3. (ถ้าจำเป็น) Update configuration และ Kubernetes resource ผ่าน Helm template files, Chart และ values file
4. ทำการ run deployment pipeline โดยมีขั้นตอนไป upsert Helm repo ใน Kubenetes namespace ที่กำหนดไว้

![K8S CICD pipeline](/assets/2021-04-08-k8s-cicd-pipeline.png)
<https://developpaper.com/k8s-and-cicd-using-helm-to-deploy-and-apply-to-kubernetes/>

### เตรียม application
ในส่วนของ application เราแค่แยก configuration ออกมาจาก source code ซึ่งปกติแล้ว Angular จะมี environment variable ซึ่งเรียกใช้แบบ global ได้เลย แต่เดิมจะเก็บไว้ใน `environment.ts` แต่ก็สามารถ customize ได้ ผ่าน build target ใน `angular.json` ดังนั้นตอน build เราก็แค่ระบุ build target ลงไป

```ts
ng build --configuration=<your-build-target-or-environment>
```

สำหรับแนวทางใหม่ แบ่งการทำงานเป็น 2 ส่วนใหญ่ๆ

### Build artifact
- เราจะใช้ NGINX เป็น Layer 7 reverse proxy ดังนั้นมันสามารถอ่าน path หรือ header หรืิอ cookie ได้ และใช้เป็น HTTP server ในการ serve static file ที่ได้จากการ build ออกมาเป็น HTML, JS, CSS และ asset files

<script src="https://gist.github.com/raksit31667/35c873450036d5085677012469b264ed.js"></script>

- จาก configuration ข้างบน จะเห็นว่าเรา serve static file จาก path `/usr/share/nginx/html` ดังนั้นตอนเรา build Docker image เราก็จะ replace default static file ที่ NGINX ให้มาด้วย build artifact ของเรา ซึ่งมี `index.html` ที่ผูก script file ไว้แล้ว แน่นอนว่าการ build กับ serve ต้องแยกกัน ซึ่งเราสามารถใช้ [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) ได้

<script src="https://gist.github.com/raksit31667/d4e1296098277ce818e31733968eac2d.js"></script>


### Configuration
- Load configuration file ผ่าน static JSON file แทน แล้วใครจะใช้ configuration ก็ให้ inject เข้ามาเป็น dependency แทน

<script src="https://gist.github.com/raksit31667/74680a000123f7ceb4eeff5a62cc1913.js"></script>

- แน่นอนว่าจังหวะที่ดีที่สุดในการ inject configuration คือตอน start application สิ่งที่เราต้องทำคือ inject การ load configuration file เข้ามาผ่าน [APP_INITIALIZER](https://angular.io/api/core/APP_INITIALIZER)

<script src="https://gist.github.com/raksit31667/f6c01124db17d7222187970c83d710ab.js"></script>

<script src="https://gist.github.com/raksit31667/ab43ba40887d5c84c9239cec456cfc9c.js"></script>

- เก็บ configuration ของแต่ละ environment ไว้ใน Kubernetes ConfigMap

<script src="https://gist.github.com/raksit31667/d9d4adf4be606073f8a5d40a2b0335cd.js"></script>

- ตอนเรา deploy ก็ mount ConfigMap เข้าไปใน directory ที่ configuration file อยู่

<script src="https://gist.github.com/raksit31667/2cb2773d67d36863460fcc86142dd08e.js"></script>

> ไปดูตัวอย่างโค้ด [https://github.com/raksit31667/example-angular-order](https://github.com/raksit31667/example-angular-order)

## References
- [Continuously Deploying Angular to Azure App Service with Azure DevOps](https://dev.to/thisdotmedia/continuously-deploying-angular-to-azure-app-service-with-azure-devops-4hf2)



