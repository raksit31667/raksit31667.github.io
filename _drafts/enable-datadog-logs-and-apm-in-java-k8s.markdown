---
layout: post
title:  "มาเปิด Logs กับ APM ของ Datadog ใน Java application ที่ deploy บน Kubernetes"
date:   2020-10-21
tags: [datadog]
---

![Datadog agents](/assets/2020-04-30/2020-04-30-datadog-agents.png)

หลังจากที่ไปทำ product ใหม่แล้วต้องทำระบบ monitoring ผ่าน Datadog เป็นครั้งที่สอง พบว่าบันทึกไปถึงแค่[การติดตั้ง Datadog agent ภายใน cluster เท่านั้น](./../_posts/2020-04-30-deploy-aks-with-datadog-agent-using-terraform.markdown) กลับมาดูอีกทีเลยหาไม่เจอ จึงขอบันทึกการเปิด metrics logging และ tracing ไว้กันลืม

### สิ่งที่จะใช้ในบทความนี้
- Java application (ในตัวอย่างจะใช้ Spring อีกแล้ว ฮ่าๆๆ)
- Datadog subscription พร้อมกับ API key และ Application key
- Kubernetes ที่ provision ไว้แล้ว
- [Helm](https://helm.sh/)
- CICD pipeline (ในตัวอย่างจะใช้เป็น Azure DevOps จะใช้เป็นตัวอื่นหรือจะทำแบบ manual แล้วแต่สะดวกครับ)

**คำเตือน** บทความนี้จะไม่ลงพื้นฐาน Helm หรือ Datadog นะครับ เพื่อความกระชับ

## 1. ติดตั้ง Datadog Java agent ลงไปใน Docker container ของเรา
ทำการ download agent มาเพิ่มเข้าไปใน Java class ที่ถูก compile แล้ว ตามแนวคิด [Java Instrumentation API](https://docs.oracle.com/javase/7/docs/api/java/lang/instrument/Instrumentation.html)

<script src="https://gist.github.com/raksit31667/3a670fa5f48a031d946a1f24db0483e7.js"></script>

## 2. Expose metrics ออกไป
เราจะใช้ [Micrometer Prometheus](https://micrometer.io/docs/registry/prometheus) สำหรับ expose JVM metrics ง่ายๆ โดยเราจะให้ Datadog Java agent ไปดึง metrics ผ่าน `service-name:8080/actuator/health`

<script src="https://gist.github.com/raksit31667/20db7e62f11d6fa1886b95637145411d.js"></script>

<script src="https://gist.github.com/raksit31667/205e8386933311919a585a1bcd2600e8.js"></script>

พอเรา start application ขึ้นมา และเข้าไปที่ <http://localhost:8080/actuator/prometheus> ก็จะมี metrics ขึ้นมาละ

![Actuator Prometheus](../assets/2020-10-21-actuator-prometheus.png)

## 3. Configure logs ใน application ให้อยู่ในรูปของ JSON format
เราจะใช้ `logstash-logback-encoder` ในการ encode logs ในรูป JSON เพื่อให้ Datadog ingest ไปได้ จากนั้นเราก็จะสร้างไฟล์ `logback-spring.xml` ไว้ใน classpath เพื่อ configure หน้าตาของ JSON keys ต่างๆ เช่น `status` `level` `trace_id` เพื่อให้เราสามารถ filter logs ได้ง่ายขึ้นเมื่อค้นหาผ่าน Datadog

<script src="https://gist.github.com/raksit31667/62210504a3607980c632d71807c73ca4.js"></script>

<script src="https://gist.github.com/raksit31667/5fd1df7148408d324ad900f49bc2f792.js"></script>

**ข้อสังเกต** เราควรแยก log format สำหรับ local และ non-local ไว้ด้วย เนื่องจากใน local การดู logs ผ่าน console หรือ terminal ในรูปแบบ inline สำหรับผมมันดูง่ายกว่า

## 4. Configure Kubernetes Deployment สำหรับ Datadog
ปิดท้ายด้วยการเพิ่ม annotations และ environment ให้ Java agent ไปเก็บข้อมูลมา โดยที่ผมจะให้ agent ไปเก็บ metrics ทุกอย่างผ่าน `http://%%host%%:8080/actuator/prometheus` ตามที่ทำไว้ข้อ 2 รวมถึงเปิด logs และ tracing ผ่าน environment variable ชื่อ `DD_LOGS_INJECTION` และ `DD_TRACE_ANALYTICS_ENABLED` ในส่วนของ `DD_AGENT_HOST` เนื่องจากเราลง agent ไว้กับตัว Java container แล้ว เราก็เชื่อมกับ container IP ได้เลย จบด้วย `DD_SERVICE_NAME` เอาไว้ filter ใน Datadog เพื่อหา metrics ของเรา

<script src="https://gist.github.com/raksit31667/ca3af4325ac41a9f97310db12680df60.js"></script>


> References: <https://docs.datadoghq.com/agent/docker/prometheus/?tab=standard>


