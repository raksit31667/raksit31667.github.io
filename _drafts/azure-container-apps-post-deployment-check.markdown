---
layout: post
title:  "บันทึกการทำ post-deployment check บน Azure Container Apps"
date:   2023-05-09
tags: [azure, azure-container-apps]
---

ช่วงนี้ใน project จะเริ่มทำการพัฒนา CI/CD pipeline สำหรับ developer ทั้งองค์กรเพื่อ deploy application ขึ้น cloud อย่าง [Microsoft Azure](https://azure.microsoft.com/en-us) หนึ่งในจุดหมายของการ deploy คือ [Azure Container Apps (ACA)](https://learn.microsoft.com/en-us/azure/container-apps/overview) เราได้พูดถึงพื้นฐานของ ACA ใน[บทความก่อนหน้าแล้ว]({% post_url 2023-03-30-azure-container-apps %}) แวะไปอ่านก่อนเพื่อที่จะได้อ่านบทความนี้อย่างเข้าใจเต็มที่

## ปัญหาที่พบเจอ
ในระบบงานปัจจุบันใช้ [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) เป็น Infrastructure-as-a-Code ในการ deploy application ผ่าน ACA ด้วย Azure CLI

<script src="https://gist.github.com/raksit31667/bd16da2bff06295bafb28707c3db7cd7.js"></script>

เมื่อคำสั่ง run ผ่านแล้วเราจะได้ผลลัพธ์หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/0379a1ba69624602eebf4ae0df531ec8.js"></script>

แต่ในบางครั้งเราก็จะพบว่ามันก็จะเกิดกรณีที่ fail ขึ้นจากหลากหลายสาเหตุด้วยกัน เช่น

- Configure [Ingress](https://learn.microsoft.com/en-us/azure/container-apps/ingress-overview) ไม่ถูกต้องเพราะเลือก target port ไม่ตรงกับ port ที่ application เปิดไว้
- Configure Docker image ไม่ถูกต้องทำให้ ACA ไม่สามารถไป pull ออกมาจาก Docker registry ได้
- [Health probe](https://learn.microsoft.com/en-us/azure/container-apps/health-probes) (liveness, readiness, startup) ดัน fail เกิน threshold ที่กำหนดไว้
- การเรียกใช้ root access เพื่อ run คำสั่งใน container
- เกิด error ที่ไม่ได้ handle ไว้ทำให้ application exit ด้วย status code ที่ไม่ใช่ 0

ซึ่งในกรณีส่วนใหญ่ก็จะทำให้ผลลัพธ์ของการ run คำสั่งข้างบน fail ส่งผลให้ `properties.provisioningState` เป็น `Failed` นั่นเอง แต่ก็จะมีบางกรณีที่คำสั่งข้างบนผ่าน แต่ก็เข้าไปดูใน ACA revision management ปรากฎว่า revision ใหม่ที่เอาขึ้นไปดันมี `properties.provisioningState` เป็น `Failed` หรือค้างอยู่ที่ `Provisioning` ซะงั้น  

นั่นหมายความว่าเราควรจะต้องตรวจสอบเพิ่มว่า revision ใหม่ที่เอาขึ้นไปมี `properties.provisioningState` เป็น `Provisioned` ถึงจะยืนยันได้ว่าการ deploy นั้นเสร็จสมบูรณ์แล้ว ไม่งั้นมันจะเกิด [CrashLoopBackOff](https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/) ส่งผลให้ container ใน ACA ถูก scale down จนเป็น 0 เกิด downtime ขึ้นในระบบตามมา

## วิธีแก้ปัญหา
ใน Azure CLI เราสามารถเรียกดูสถานะของ revision ได้ผ่านคำสั่ง [az containerapp revision list](https://learn.microsoft.com/en-us/cli/azure/containerapp/revision?view=azure-cli-latest#az-containerapp-revision-list)

```shell
$ az config set extension.use_dynamic_install=yes_without_prompt # Install extension ให้อัตโนมัติ

$ az containerapp revision list -n "<your-aca-name>" -g "<your-resource-group>"
```

จะได้ผลลัพธ์ออกมาหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/6e1057b5bccbb92c8ae8c9302078258d.js"></script>

โดยที่สถานะที่เราต้องการจะอยู่ใน `properties.provisioningState` ทีนี้เราสามารถใช้ `--query` option ในการหยิบ key จาก response ที่เป็น JSON ได้เลย แล้วก็ตั้ง output เป็น tab-separated value (tsv) เอา

```shell
$ az containerapp revision list -n "<your-aca-name>" -g "<your-resource-group>" --query ".properties.provisioningState" -o tsv
```

จะได้ผลลัพธ์ออกมาหน้าตาประมาณนี้

```
Provisioned
```

ดังนั้นเราสามารถเขียน script เพื่อ run คำสั่งไป check สถานะจนกว่าจะเป็น `Provisioned` หรือ `Failed` ได้

<script src="https://gist.github.com/raksit31667/1507f52b26824ce06fd063ac268870da.js"></script>

แต่ปัญหาที่ตามมาก็คือคำสั่งนี้มันไม่รองรับกรณีที่มีหลาย revision ถึงแม้ revision mode จะเป็น `Single` ก็ตาม เพราะว่า revision เก่าจะยังไม่ถูกลบจนกว่า revision ใหม่จะมีสถานะ เป็น `Provisioned` ทำให้ผลลัพธ์มันออกมาเกิน 1 ค่า แล้วเราจะแก้ยังไงต่อ

```
Provisioned
Failed
```

สิ่งที่เราต้องทำคือเราต้องไปหยิบ revision ล่าสุดมาให้ได้ เพื่อให้ผลลัพธ์มันออกมาได้ 1 ค่าเท่านั้น เผอิญว่าตอนระบบเรา build Docker image จะใส่ tag เป็น build number ไว้ ทำให้เราสามารถ filter เอาเฉพาะ revision ที่มี Docker image tag ตรงกับ build number ได้โดยการแก้ไข `--query` option เป็น

<script src="https://gist.github.com/raksit31667/042fc30cb68ba0b4f24896df124b280a.js"></script>

ซึ่ง syntax จะล้อตาม [JMESPath query](https://jmespath.org/) ในกรณีเราเลือกใช้ `contains` function ในการ filter image tag เอา แน่นอนว่าเราจะได้ผลลัพธ์ 1 ค่าเพราะ build number จะไม่ซ้ำกันในคนละ build อยู่แล้ว ที่เหลือก็แค่ดึงสถานะออกมาผ่าน `properties.provisioningState` key เป็นอันเสร็จสิ้น

## References
- [Container Apps and Failed Revisions](https://azureossd.github.io/2022/08/01/Container-Apps-and-failed-revisions-Copy/)
