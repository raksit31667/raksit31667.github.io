---
layout: post
title: "บันทึก tips ที่ช่วยให้การประมาณค่า cloud infrastructure ง่ายขึ้น"
date: 2024-03-10
tags: [infrastructure, cloud-computing]
---

อาทิตย์นี้ได้มีโอกาสในการเข้าไปประมาณ (estimate) ค่าใช้จ่ายในการวาง cloud infrastructure ใหม่ให้กับลูกค้า ซึ่งมีประโยชน์ในการคำนวนต้นทุนของ software ที่หลังจากนำไปรวมกับต้นทุนแฝงด้านคนและงานบริการแล้วจะต้องสอดคล้องกับ pricing model เพื่อให้ software สร้างกำไรให้กับลูกค้าได้ มาดูกันว่ามี tips อะไรแจ่ม ๆ บ้าง

## 1. เข้าใจ requirement ของ cloud
ก่อนที่จะเริ่ม estimate เราต้องรู้ requirement ว่า

- เราใช้ private หรือ public cloud
- Budget ของเรามีประมาณเท่าไร
- Component ของระบบมีอะไรบ้าง เช่น web app, database, networking, authentication, observability เป็นต้น
- ต้องมี license หรือ subscription อะไรบ้าง ค่าใช้จ่ายเท่าไร 
- ความคุ้มค่าของทีมในการ maintain resource เองเมื่อเทียบกับการ managed service
- Cloud provider เจ้าไหนมี service ที่ตอบโจทย์ระบบเรา รวมถึง ทั้ง functional และ cross-functional requirement
- ความคุ้มค่าของทีมในการวางแผนกรณีที่จะต้องย้าย cloud ไปอีกเจ้า 

ซึ่ง requirement เหล่่านี้จะช่วยในการพิจารณาเลือกใช้ cloud provider ได้อย่างเหมาะสม

## 2. เข้าใจลักษณะการทำงานของระบบ
หลังจากเลือก cloud provider ได้แล้วต่อมาคือประมาณการใช้งานของระบบโดยแต่ละ resource ก็มีวิธีคิดค่าใช้จ่ายตามการใช้งานที่แตกต่างกันไป แต่โดยรวมแล้วจะมีสิ่งที่คล้าย ๆ กัน เช่น

- Resource ที่ใช้ต้องตั้งอยู่ใน region ไหน
- Resource สามารถ share กับคนอื่นได้ไหม เพราะการใช้ resource ใน cloud [ไม่ได้หมายความว่าเราใช้อยู่คนเดียว](https://www.youtube.com/watch?v=LkLEggnQ4RM)
- ขนาดของ data ที่ใช้ประมวลผล (ทั้งแบบ compressed และไม่ compressed) เช่นดูผ่าน API request body, จำนวน record ใน local database กับ storage ที่กินไป เป็นต้น
- Component ในระบบเน้น CPU (data processing, video encoding) หรือ memory (databases, caching)
- โดยปกติแล้วอยากจะรับ request/sec ประมาณเท่าไร
- มี traffic ที่ peak ช่วงไหน เป็นระยะเวลาเท่าไร
- ในกรณีที่ resource ที่มีมากกว่า 1 อัน เช่น compute instance ให้คำนวนราคาโดยคิดเป็นต่อ 1 ตัว และแบ่งเลยว่า ขั้นต่ำ-ปกติ-สูงสุด จะต้องใช้ instanance ไม่เกินกี่อัน เพื่อให้เราสามารถเห็นภาพมากขึ้นถ้าต้องปรับจำนวนขึ้น-ลงในอนาคต
- ใช้ระบบในระยะสั้นหรือระยะยาว (เกิน 3 ปี) เพราะ resource บางตัวมี saving plan เพื่อให้เราซื้อแบบเหมาไปเลย 3 ปัีโดยจ่ายถูกกว่า pay-as-you-go 
- ใน 1-2 ปีข้างหน้า คาดว่าจะมีลูกค้่าเพิ่มขึ้นมากี่เท่า architecture ส่วนไหนจำเป็นต้องเปลี่ยนบ้าง
- [SLA และ uptime requirement](https://uptime.is/) เป็นอย่างไร เช่น การจัดการ redundancy และ disaster recovery plan สำหรับ 99.5% กับ 99.9% แตกต่างกันพอสมควร 
- หากระบบต้อง scale ต้องทำแบบ horizontal หรือ vertical (โดยปกติแล้ว horizontal จะถูกกว่าแต่ถ้า resource เป็น stateful ตอนรวมข้อมูลเข้ามาจะใช้ effort จัดการได้ยากขึ้น เช่น database)

ผลลัพธ์คือเราจะสามารถเลือก spec ของ resource ได้แม่นประมาณนึง

### ข้อสังเกต
- หลายข้อในนี้ตั้งใช้การคาดเดาเยอะ เพื่อให้เริ่มต้นได้ง่าย ให้ลองคิดกลับกันว่า "ระบบเราจะใช้ไม่มีทางเกินเท่าไร"

## 3. ใช้ calculator ของ cloud provider
ถ้าต้องการจะประหยัดแรงในการคำนวณ แนะนำให้ใช้ calculator ของ cloud provider เจ้าที่ต้องการเพราะเราสามารถกรอก requirement ใน form แล้วก็จะได้ราคาออกมาเลย นอกจากนั้นยังสามารถ export ออกมาดูเป็น format ที่นำไป present ได้ และสามารถประมาณค่าใช้จ่ายเป็นรายปีซึ่งเหมาะสำหรับองค์กรที่ต้องขอ budget สำหรับทั้งปี เช่น

- [AWS Pricing Calculator](https://calculator.aws/#/)
- [Azure Pricing Calculator](https://azure.microsoft.com/en-in/pricing/calculator/?cdn=disable)
- [GCP Calculator](https://cloud.google.com/products/calculator?hl=en)

![AWS Pricing Calculator](/assets/2024-03-10-aws-pricing-calculator.png)
<https://aws.amazon.com/blogs/aws/check-it-out-new-aws-pricing-calculator-for-ec2-and-ebs/>

## 4. Monitor ค่าใช้จ่ายอย่างสม่ำเสมอ
หลังจากเราใช้งาน cloud ไปสักระยะนึงแล้วกลับมาดูค่าใช้จ่ายจะพบว่ามันยากมาก ๆ นะที่จะ estimate ได้แบบเป๊ะ ๆ ตั้งแต่ครั้งแรก ขอแนะนำว่าให้ monitor ค่าใช้จ่ายแล้วปรับ tune ให้เหมาะสมไปเรื่อย ๆ น่าจะง่ายกว่า โดยมีขั้นตอนคร่าว ๆ ดังนี้

1. เลือก resource ที่เราต้องการจะ optimise อาจจะเริ่มต้นจากอันที่กินเงินเยอะที่สุด
2. เข้าไปดู monitoring ของ resource นั้น ๆ เช่น CPU, memory, storage, network เป็นต้น หากไม่มีให้ติดตั้งทันที
3. เลือกระยะเวลาที่ต้องการจะเก็บข้อมูล เป็นรายชั่วโมง-วัน-เดือน ซึ่งอันนี้ก็แล้วแต่ว่า resource เราคิดเงินยังไง
4. ระบุข้อมูลการใช้งานสูงสุด (maximum utilisation) ออกมา เช่น ดูว่าใช้ CPU, memory ในช่วง peak time ไปเท่าไรหรือกี่หน่วย
5. ทำการ normalise ค่าใช้จ่ายโดยสูตร cost / maximum utilisation ก็จะได้ออกมาเป็น ราคาต่อ 100% utilisation หรือ ราคาต่อหน่วย
6. ใช้ cloud provider calculator คำนวณราคาใหม่ โดยปรับ spec ให้เหมาะสมตามต้องการ และใส่ input ด้วย utilisation ปัจจุบัน หากเป็น % อย่าลืมปัญญัติไตรยางค์ก่อน
7. ทำการ normalise ค่าใช้จ่ายอีกครั้ง
8. เปรียบเทียบค่าที่ได้ 2 อันด้วยกัน แล้วสังเกตอาการผิดปกติที่เกิดขึ้นว่า provision ขาดหรือเกินความต้องการ
9. ปรับ tune spec ที่เลือกแล้ว monitor เพื่อดูว่าดีขึ้นไหม

### ยกตัวอย่าง
สมมติว่ามี compute resource อยู่ตัวนึง เราพบว่าเดือนนึง

- ค่าใช้จ่ายของ resource: 1000 บาท
- Peak CPU utilization: 90%
- Peak memory utilization: 600 MB

คำนวณ normalised cost จะออกมาเป็น

- CPU: 1000/90% = 1111.11 บาทต่อการใช้งานเต็ม 100%
- Memory: 1000/600 MB = 1.66 บาทต่อ MB

พอวิเคราะห์ดูแล้วจะพบว่า CPU ใช้ไป 90% นี่มีโอกาสสูงที่ resource จะ underprovision อาจจะเกิดปัญหา performance ได้ พอลองมาปรับ spec แล้วกดเครื่องคิดเลขดูได้ประมาณนี้

- ค่าใช้จ่ายของ resource: 1200 บาท
- Peak CPU utilization: 70%
- Peak memory utilization: 800 MB

คำนวณ normalised cost จะออกมาเป็น

- CPU: 1200/70% = 1714.28 บาทต่อการใช้งานเต็ม 100%
- Memory: 1200/800 MB = 1.5 บาทต่อ MB

พอวิเคราะห์ดูแล้วจะพบว่าถึงแม้ spec ใหม่จะแพงกว่า 200 บาท แต่ก็ลดความเสี่ยงของปัญหา performance ลงได้ และความคุ้มค่าในการใช้ memory ก็ดีกว่าแบบแรก

> เขียนไปเขียนมาเริ่มจะยาว ลองนำ tips เหล่านี้ไปใช้ดูครับ และอย่าลืม monitor ค่าใช้จ่ายอย่างสม่ำเสมอด้วย