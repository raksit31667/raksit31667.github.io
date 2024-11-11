---
layout: post
title: "วิธีการตั้งค่า source tag สำหรับ Datadog logging ใน Kubernetes"
date: 2024-11-11
tags: [datadog, kubernetes]
---

เมื่ออาทิตย์ที่แล้ว application developer กำลังทำการตรวจสอบผลการทดสอบ แต่พบปัญหาว่าไม่มีการแสดงผลของ log บนหน้า APM (Application Performance Monitoring) ของ Datadog ทำให้ยากต่อการวิเคราะห์ว่าผลการทดสอบเกิดปัญหาจากอะไร และมีสาเหตุอะไรที่ทำให้ log หายไปจาก trace เมื่อทาง developer แจ้งมาหา platform team อย่างเราก็ต้องเร่งแก้ไขให้เอา log มาแสดงผลให้เร็วที่สุด ความโชคดีคือมันเกิดขึ้นบน Dev environment (service ถูก deploy บน Kubernetes cluster) ที่สร้างขึ้นมาใหม่สำหรับทำการทดสอบโดยเฉพาะ (เคยบ่นในแล้วใน blog [ว่าด้วยเรื่องของการทดสอบใน Staging environment]({% post_url 2024-09-28-testing-microservices-in-staging %}))  

![Datadog APM missing logs](/assets/2024-11-10-datadog-apm-missing-logs.png)

สาเหตุคาดว่าเกิดจากการที่ log ไม่ได้ถูกส่งผ่านเข้ามาในกระบวนการ correlation pipeline ของ Datadog แต่ก่อนจะไปเจาะลึกถึงวิธีแก้ต้องขออธิบายถึง *Log Pipeline* ใน Datadog ก่อน

## Datadog Log Pipeline

*Log Pipeline* คือกระบวนการที่ช่วยจัดการและประมวลผล log ก่อนที่ log จะถูกเก็บเข้า Datadog หรือแสดงในหน้าต่าง ๆ ของ Datadog โดย log pipeline จะทำหน้าที่กรอง เปลี่ยนรูปแบบ และ filter ข้อมูลที่สำคัญออกจาก log รวมถึงการเชื่อมโยง log กับ trace เพื่อให้การวิเคราะห์มีความชัดเจนมากยิ่งขึ้น โดย log pipeline ประกอบด้วยขั้นตอนต่าง ๆ เช่น

### 1. **การสร้าง Pipeline**
   ผู้ใช้สามารถสร้าง log pipeline ใหม่สำหรับการจัดการ log ที่มาจาก origin ต่าง ๆ (เช่น environment หรือ infrastructure component เป็นต้น) โดยแยกตาม origin ที่มาจะช่วยให้จัดการและประมวลผล log ที่ต้องการได้ง่ายขึ้น และลด log ที่ไม่เกี่ยวข้องหรือไม่จำเป็นออกไป

### 2. **การใช้ Filters**
   **Filter** คือส่วนที่ใช้ในการกรอง log ภายใน pipeline โดยการตั้งเงื่อนไขเพื่อเลือก log ที่ต้องการประมวลผล ตัวอย่างเช่น การตั้งค่าให้ pipeline ประมวลผลเฉพาะ log ที่มี `source` หรือ `service` tag ตรงกับเงื่อนไขที่กำหนด ตัวกรองนี้จะช่วยลดปริมาณ log ที่ไม่เกี่ยวข้อง และช่วยลดค่าใช้จ่ายในการจัดเก็บ log

### 3. **การใช้ Processors**
   Processor คือส่วนที่ใช้ในการปรับแต่งหรือเพิ่มข้อมูลใน log ที่ผ่าน filter มาแล้วซึ่ง แต่ละประเภทมีหน้าที่แตกต่างกันไป เช่น

   - **Groking**: ใช้เพื่อแยกและนำข้อมูลออกจาก log เช่น การแยก IP, URL หรือค่าเฉพาะที่สนใจ
   - **Remapper**: ใช้ในการเปลี่ยนค่า fields ใน log เช่น กำหนดระดับความสำคัญของ log (เช่น error, warning, info) ซึ่งช่วยในการจัดลำดับความสำคัญของ log
   - **Trace Id Remapper**: ใช้ในการเชื่อมโยง log กับ trace ที่มาจาก APM (Application Performance Monitoring) การเชื่อมโยงนี้สามารถทำได้โดยการ remap ค่า `dd.trace_id` ใน log ให้ตรงกับ trace ที่เกิดขึ้น เช่น การตั้งค่า Trace Id Remapper ให้ใช้ field ต่างๆ เช่น `dd.trace_id`, `dd_trace_id`, หรือ `properties.dd.trace_id` เป็นตัวแทนของ trace ID ที่อยู่ใน log
   - **Tagging**: เพิ่ม tag ให้กับ log เพื่อให้สามารถกรอง log ได้ตาม tag ที่สนใจ เช่นการเพิ่ม environment tag เพื่อบ่งบอกว่า log นี้มาจาก dev หรือ prod environment

### 4. **การส่งออก (Exporting) และการจัดเก็บ (Archiving)**
   หลังจาก log ผ่าน pipeline และ process เสร็จแล้ว Datadog มีตัวเลือกให้ส่งออก log ไปยังที่จัดเก็บภายนอกหรือระบบอื่น เช่น Amazon S3 หรือ Google Cloud Storage เพื่อการเก็บข้อมูลระยะยาว หรือนำ log ไปวิเคราะห์เพิ่มเติมด้วยเครื่องมืออื่น ๆ

## กลับมาที่ปัญหา
ทีม platform เราสร้าง Log pipeline โดยหนึ่งในขั้นตอนที่ใช้คือ 
- **Trace Id Remapper** เพื่อกำหนด `dd.trace_id`, `dd_trace_id`, `Properties.dd.trace_id`, `properties.dd_trace_id`, `Properties.dd_trace_id` เป็น trace ID ที่ใช้ใน log ดังนั้นการที่ log จะเชื่อมกับ trace ได้

    ![Datadog trace Id mapper](/assets/2024-11-10-datadog-trace-id-mapper.png)    

- เราจะต้องใช้ **Filters** ที่กำหนด source และ service tags ประมาณนี้

```plaintext
source:(SOURCE_1 or SOURCE_2 or .. or SOURCE_N) service:(SERVICE_1 or SERVICE_2 or .. or SERVICE_N)
```

ประเด็นคือค่า source ของ Datadog ถูกตั้งค่าโดยอัตโนมัติจากชื่อ repository ของ Docker image ยกตัวอย่างเช่น Docker container image ของเราเก็บอยู่ใน ECR ชื่อว่า `account` ทำให้ค่า source เป็น `account` ซึ่งไม่มีปัญหาอะไรเมื่อใช้งานใน environment ปกติ  

แต่ใน Dev environment ของเรา เราได้ใช้ repository ใหม่ชื่อ `account-dev` ดังนั้นค่า source จึงกลายเป็น `account-dev` ซึ่งไม่ได้อยู่ใน filter ที่กำหนดไว้ ทำให้ log ไม่สามารถเชื่อมกับ trace ได้ และหายไปจากระบบ APM ของ Datadog นั่นเอง

## วิธีแก้ไขปัญหา
เราสามารถแก้ปัญหานี้ได้โดยการตั้งค่า source tag ใหม่ หรือแก้ไขกฎ filter เพื่อรวม source ใหม่ แต่การเปลี่ยนค่า filter ในครั้งนี้อาจจะไม่เข้ากับการตั้งค่าที่เราใช้กับ environment อื่น ๆ ได้  

วิธีแก้ไขที่เราเลือกใช้คือการกำหนดค่า source ให้กับ Datadog เป็น `account` โดยการเพิ่ม annotation ใน Kubernetes deployment manifest เฉพาะ Dev environment เท่านั้น

ตัวอย่างการตั้งค่าใน manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    metadata:
      annotations:
        ad.datadoghq.com/<CONTAINER_NAME>.logs: |
          [{"service": "<SERVICE_GOES_HERE>", "source": "<SOURCE_GOES_HERE>"}]
    spec:
      containers:
        - name: <CONTAINER_NAME>
```

การเพิ่ม annotation แบบนี้จะช่วยให้ log ใน Dev environment ใช้ค่า source เป็น `account` เหมือนกับ environment อื่น ๆ ทำให้ log สามารถเชื่อมกับ trace ได้ตามปกติ 

![Datadog APM with logs](/assets/2024-11-10-datadog-apm-with-logs.png)

## References
- [Datadog Kubernetes and Integrations](https://docs.datadoghq.com/containers/kubernetes/integrations/?tab=annotations#set-up-your-integration)
- [Datadog Log Pipelines](https://docs.datadoghq.com/logs/log_configuration/pipelines/?tab=source)
- [วิธีการตั้งค่า source สำหรับ Datadog log ใน Docker Container](https://stackoverflow.com/questions/72577156/how-can-i-override-source-in-datadog-when-running-docker-containers)
