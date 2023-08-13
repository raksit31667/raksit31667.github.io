---
layout: post
title: "สรุปสิ่งที่น่าสนใจจากงาน AWS Cloud Day Thailand (ส่วน Developer Lounge)"
date: 2023-08-08
tags: [conference, aws]
---

เมื่อวันก่อนได้มีโอกาสเข้าไปร่วมงาน [AWS Cloud Day Thailand](https://aws.amazon.com/events/cloud-day-thailand/) ที่เป็นการรวมกันของฝั่ง business และ technical ในการใช้งาน Amazon Web Services (AWS) เพื่อสร้างนวัตกรรมใหม่ ๆ ในงานก็จะมีกิจกรรมและการแบ่งปันประสบการณ์ในการใช้งาน AWS โดยส่วนใหญ่ก็จะเน้นเรื่องที่เป็น trend อยู่ในขณะนี้อย่าง Serverless, Machine learning (ML), Generative artificial intelligence (AI) นอกจากนี้ก็จะมี booth ต่าง ๆ ตามความสนใจของเรา เช่น game, startup, เรียนรู้ฝึกการใช้งาน AWS หรือ software development เป็นต้น  

## Session ช่วงเช้า
โดยใน session ช่วงเช้าก็จะมีการพูดถึง use case ของบริษัทในแถบ South East Asia ที่นำ AWS ไปใช้งานจริง เช่น

- SCG นำ AWS IoT ไปใช้ทำ smart home (ปล. ทาง CEO บอกว่า IoT จะแซง application development ในอนาคต รีบเข้าไปศึกษาก่อนจะได้เปรียบ)
- เงินเทอร์โบ นำ AWS ไปทำ analytics สำหรับดูความเสี่ยงในการปล่อยสินเชื่อแบบ data-driven
- 2C2P นำ AWS ไปใช้ในด้าน payment, security, data analytics และ observability

ต่อมาก็เป็น session ในการปล่อยของ AWS ใหม่ ๆ โดยในปีนี้ทาง AWS ก็ได้นำ services ที่มีอยู่แล้วไปพัฒนาให้รองรับ Serverless มากขึ้น เช่น Amazon Aurora (มาในรุ่น Serverless v2) และตระกูล Analytics ต่าง ๆ นอกจากนี้ยังดันเรื่อง services ที่เกี่ยวกับ AI และ ML เต็มตัว โดยเค้ามี service ใหม่ที่รองรับการทำ Generative AI โดยเฉพาะอย่าง Amazon Bedrock (ยังเป็น preview mode อยู่นะ)  

นอกนั้นก็เป็นการ showcase ของ partner ของ AWS อย่างเช่น AWS Prime Day, Amazon Go, runway, Canva, autodesk เป็นต้น

## Session ช่วงบ่าย
หลังจากพักกินข้าวแล้วก็ต่อกับช่วงบ่ายโดยคนก็จะแยกกันไปตาม booth ต่าง ๆ ไม่ก็เข้าห้องประชุมฟัง session ต่อ โดยเราจะปักหลักอยู่ที่ Developer Lounge ที่หัวข้อถูกจริตเราที่สุดละ ฮ่า ๆๆ โดยมีหัวข้อน่าสนใจมากมาย เราเลยสรุปเท่าที่เราได้เข้าตามนี้

### Chalk Talk: Building modern applications? Let's talk about serverless
ใน session นี้จะเน้นไปที่การใช้ AWS ในการสร้างระบบงานขึ้นมาโดยยังคงเน้นไปในด้าน serverless อย่างเช่น Simple Queue Service (SQS),  Simple Notification Service (SNS), EventBridge และ Lambda เป็นต้น และมีการยกตัวอย่างระบบงานสมมติขึ้นมาแล้วช่วยกันออกแบบโดยใช้ AWS services ต่าง ๆ  

<รูประบบ AWS ถ่ายรูปคนในงานแล้ว recognition นับเอา>

โดยเราสามารถเข้าไปศึกษาและดูตัวอย่างของระบบ serverless เพิ่มเติมได้ผ่าน <https://serverlessland.com>

### Practical cost-saving automation for AWS accounts
ผู้พูดได้เล่าถึงประสบการณ์ในการจัดการค่าใช้จ่ายใน AWS ซึ่งเป็นหนึ่งในความเจ็บปวดที่คนหรือองค์กรที่ใช้ AWS ต้องเคยพบเคยเจอ โดย resource ที่กินค่าใช้จ่ายเยอะที่สุดได้แก่ EC2 (EC2 vs EC2 serverless), ECS และ EKS (EC2 vs Fargate) และกลุ่ม database (SQL vs NoSQL) ซึ่งค่าใช้จ่ายจากทุก resource ที่กล่าวมานั้นมาจากหลายสาเหตุด้วยกัน ได้แก่

- Overprovisioning: สร้าง resource ที่มีขนาดใหญ่หรือเยอะเกินที่จะใช้จริง
- Un-tag resources: มี resource ที่อยากจะลบเพราะไม่ได้ใช้แล้วแต่ลบไม่ได้เพราะไม่รู้ว่าเป็นของใคร
- Idle resources: มี resource ที่มีเจ้าของแต่ใช้แค่บางเวลาเท่านั้น เช่น ตอนเวลาทำงาน แต่หลังเลิกงานก็ปล่อยทิ้งไว้ข้ามคืน ไปจนถึง เสาร์-อาทิตย์

แนวทางการลดค่าใช้จ่ายสามารถทำได้หลายทาง เช่น
- Economies of scale: ยิ่งใช้งานเป็นจำนวนเยอะ ๆ ค่าใช้จ่ายต่อหน่วยการใช้งานก็จะยิ่งถูกลง
- Architecture: ปรับระบบงานและเลือกใช้ technology ที่เหมาะสมกับ scale ของงาน
- Operation: การจัดการ resource ซึ่งอันนี้คือแนวทางที่เราจะเน้นในหัวข้อนี้


ผู้พูดได้เสนอวิธีแก้ปัญหาคือการจัดการ resource ผ่าน AWS ด้วยแนวปฏิบัติดังนี้

1. สร้าง maintenance window บน AWS Systems Manager (solve un-tag, idle) 
2. สร้าง automation documents บน AWS Systems Manager (solve un-tag, idle)
3. ใช้ run command บน AWS Systems Manager
4. ตรวจสอบและปรับการใช้งาน EC2 ผ่าน AWS Compute Optimizer (solve overprovisioning)
5. เปิดใช้งาน AWS time-based schedule ที่ AWS Auto Scaling สำหรับ EC2/EKS
6. เปิดใช้งาน Application Schedule Action สำหรับ Fargate

### Implementing DevOps to deploy and run web applications on AWS
ผู้พูดได้แนะนำให้รู้จักกับ JavaScript library สำหรับสร้าง static website อย่าง [NuxtJS](https://nuxt.com/) ที่พัฒนาต่อยอดจาก [Vue.js](https://vuejs.org/) อีกที โดยเราสามารถสร้างและแน่นอนว่าเราสามารถ deploy static website ด้วย AWS มีขั้นตอนประมาณนี้  

```
Create app -> Build -> generate static content -> upload to S3 -> set entrypoint
Simple pipeline: Git -> pickup and release to S3 Dev artifact -> deploy to S3 Dev -> release S3 Prod
GitHub Actions - DinD (docker:24.0.2-git)
```

โดยปกติแล้ว entrypoint ของ S3 จะเป็น HTTP ซึ่งไม่ปลอดภัย เราสามารถใช้ AWS ในการทำให้ระบบงานของเราเป็น production grade โดยใช้ services ต่าง ๆ ดังนี้

- ใช้ AWS Cert Manager ในการสร้าง HTTPS certification
- เก็บ certification ไว้ใน AWS Cloudfront เพื่อส่งให้ server
- จด domain ผ่าน AWS Route 53 แล้วชี้ไปที่ AWS CloudFront
- ด้าน security เราก็จำกัด การเข้าถึง AWS S3 เป็น private access หรือถ้าจำเป็นต้องใช้ public access จริง ๆ ก็ให้ใช้ท่าตั้งค่า `BucketPolicy` ด้วย aws:Referer
- ตั้งค่า retention ใน AWS S3 เพื่อลบ artifact ที่ไม่ได้ใช้แล้วออกไป

เข้าไปดูตัวอย่าง code ได้ที่ <https://github.com/jumpbox-academy/cloud-day>

### Unveiling Saga Pattern: A beginner’s exploration into microservices orchestration
ใน session นี้จะเป็นการแบ่งปันเรื่องของ Saga Pattern โดยเมื่อเราพูดถึงระบบงานที่มี database ในการเก็บข้อมูล จะต้องมีคุณสมบัติ 4 ข้อ ACID

- Atomicity: ความคล้ายคลึงกับอะตอมในฟิสิกส์ แปลว่าการทำงานจะถูกดำเนินการในรูปแบบอย่างเต็มที่หรือไม่เลย ถ้ามีการบกพร่องหรือข้อผิดพลาดเกิดขึ้นกลางทาง การทำงานทั้งหมดในรายการ (transaction) จะถูกยกเลิก และไม่มีการเปลี่ยนแปลงใดๆ ที่จะถูกเก็บไว้ในระบบฐานข้อมูล

- Consistency: หลังจากที่การดำเนินการ transaction เสร็จสมบูรณ์ ฐานข้อมูลจะต้องเข้าสู่สถานะที่สอดคล้องกับเงื่อนไขหรือกฎระเบียบที่กำหนด นั่นคือ การที่ข้อมูลจะไม่ถูกทำให้เข้าสู่สถานะไม่สอดคล้องหรือแสดงผลที่ไม่ถูกต้อง

- Isolation: การดำเนินการของ transaction แต่ละรายการจะต้องเป็นอิสระจากการกระทำของ transaction อื่น ๆ ที่เกิดขึ้นในเวลาเดียวกัน นั่นคือ การที่การดำเนินการของ transaction หนึ่งจะไม่ส่งผลกระทบต่อการดำเนินการของ transaction อื่น

- Durability: หลังจากที่การดำเนินการ transaction เสร็จสมบูรณ์ การเปลี่ยนแปลงที่ถูกนำเข้ามาจะถูกเก็บไว้ในระบบฐานข้อมูลโดยถาวร แม้ว่าระบบจะเกิดความขัดข้องหรือต่อสู้กับปัญหาการเสียหายต่อไป

ซึ่งแนวทางการสร้างระบบงานตามคุณสมบัตินี้ก็ขึ้นอยู่กับการออกแบบ architecture ด้วย หากเป็นลักษณะแบบ monolith เช่น Monolith system that reads Order, Customer, Inventory, Accounting table การใช้งาน database transaction ก็จะตอบโจทย์นี้ได้  

แต่เนื่องจาก monolith มีข้อจำกัดเพื่อระบบมีความซับซ้อนขึ้น การ scale ก็จะทำได้ยากขึ้น, ปรับแก้ได้ยากชึ้น เมื่อเกิดปัญหาขึ้นที่จุดใดจุดหนึ่งก็มีโอกาสสูงที่ระบบจะพังทั้งหมด จึงมีแนวคิดเรื่องของ microservices ขึ้นมาแก้ปัญหาดังกล่าว แต่ก็แลกกับการจัดการที่ซับซ้อนขึ้น เช่นการ deploy, การ monitor, การจัดการ infrastructure และแน่นอนว่ารวมถึงคุณสมบัติ ACID ด้วย เช่น

- we lose Atomicity and Isolation in ACID
- Logic ในการร้อยเรียง operation ของระบบจะอยู่ตรงไหน?
- ACID in Distributed systems - Order, Customer, Inventory, Accounting services

โดยส่วนใหญ่มักจะเกิดขึ้นในระบบงานที่ใช้เวลานานกว่าจะจบ business operation นึงอย่าง Food delivery  

Saga pattern ตอบโจทย์เรื่อง atomicity ว่าในการทำ operation ต่อ ๆ กัน ถ้ามี operation ใด ๆ อันหนึ่งมัน fail ระบบของเราจะย้อน operation เหล่านั้นกลับยังไง โดยวิธีการ Saga pattern ทำคือจะให้เราสร้าง transaction อีกรูปแบบนึงแยกออกมาต่างหากเพื่อทำการหักล้างสิ่งที่เกิดขึ้นจาก transaction แบบปกติ (เรียกว่า Compensated transaction) เช่น ในระบบ food delivery หาก operation ในการจัดการอาหารมีปัญหาอย่างร้านดันปิดไปหลังจากกดสั่ง order ไปแล้ว ตัว compensated transaction ก็จะประกอบด้วย operation ที่ต้องยกเลิก order ของเราและคืนเงินที่โอนไป การออกแบบ compensated transaction ก็จะขึ้นอยู่กับลักษณะของ operation ด้วย เช่น

- บาง operation เกิดขึ้นแล้วไม่สามารถย้อนกลับได้
- บาง operation เกิดขึ้นแล้วสามารถย้อนกลับได้แต่ไม่สามารถทำแบบอัตโนมัติได้ ต้องมีคนเข้ามาช่วย
- บาง operation เกิดขึ้นแล้วสามารถย้อนกลับไปที่ operation ปกติได้ใหม่อีกที

ข้อสำคัญที่สุดของ operation คือไม่ว่า operation ข้อมูลเดิมจะเกิดขึ้นกี่ครั้งซ้ำ ๆ กันกี่ครั้งก็ตาม ผลลัพธ์ก็จะต้องได้เท่าเดิม (เรียกว่า idempotent) เพื่อที่จะทำให้ operation สามารถทำซ้ำ (retry) ในกรณีที่เกิดปัญหาได้

ทีนี้ Saga pattern ก็ยังไม่ตอบโจทย์เรื่อง isolation เพราะปัญหาที่เจอใน database transaction ก็จะมาเจอใน Saga pattern เช่น dirty reads, lost updates, non-repeatable reads ซึ่งเราก็ต้องใช้ท่าอื่น ๆ มาช่วย เช่น

- Semantic locks (set a flag ORDER_PENDING)
- Commutative updates (ทำให้ operation มันสลับกันได้ order ไม่มีผล)
- Pessimisitic view (reorder)
- Reread value: Rereading the record and verify it's unchanged

Logic ในการร้อยเรียง flow ของระบบจะอยู่ตรงไหน?
- Cheoreography ไม่มีคนคุม workflow ทุกคนรู้หน้าที่ว่าจะต้องทำอะไรเมื่อได้รับ event มา (ข้อดี implement ง่าย ข้อเสียคือถ้า workflow มันซับซ้อนจะยากขึ้น เช่น fork-join รอ 2 event ที่มาไม่พร้อมกันมารวมกันเมื่อจะได้ทำงานถูก, cyclic dependencies)
- Orchrestrator มีคนคุม workflow เป็น state machine เพื่อ delegate งานไปให้ worker (ข้อดีคือเหมาะกับ workflow ซับซ้อน ข้อเสีย implement ยาก และ single point of failure)

วิธีการแก้ปัญหานอกจาก Saga pattern ก็มี two-phase commit ในทางทฤษฎีคือมันดูดีนะ แต่ทางปฏิบัติจากประสบการณ์ของหลาย ๆ องค์กรคือไม่ค่อย work เพราะในระหว่างที่เวลาระบบแต่ละตัวมันรอให้พร้อม แล้วมันรับ load อื่นไม่ได้ ทำให้เสีย availability ไป  

ปัญหาอื่น ๆ ที่จะพบเจอใน Saga pattern คือ States & Event หายไป ซึ่งโจทย์นี้ก็ต้องนำ Outbox pattern มาช่วยแก้  

ปิดท้ายด้วยแนะนำ framework และเครื่องมือที่ช่วยทำ Saga pattern ให้ง่ายขึ้น อย่าง AWS StepFunction และ Netflix Conductor เป็นต้น

### Software craftsmanship
ผู้พูดเล่าเรื่องของความรักและความเป็นมืออาชีพในการพัฒนา software ว่าจริง ๆ แล้ว ทีมพัฒนาต่างหากที่มีอำนาจสูงสุดในการตัดสินใจ ดังนั้นทีมไม่ควรปลุกปีศาจ complexity และ technical debt ขึ้นมาแต่ไม่รู้ว่าจะควบคุมมันอย่างไร หากมีปัญหาเกิดขึ้นจากทีมนี้และถูกปล่อยหลุดออกมา อาจจะเป็นอันตรายและสามารถก่อให้เกิดความเสียหายได้  

ทีนี้วิธีการควบคุมปีศาจเหล่านี้คือการฝึกฝนและลงมือทำจริง เราควรจะต้องฝึกฝนบ้างเพื่อเวลาลงงานจริงจะพลาดน้อยที่สุด เปรียบเทียบเหมือนกับทีม football 2 ทีม

- ทีมที่ 1 อาทิตย์นึงลงสนามแข่งทุกวัน เลยซ้อม 0 วัน
- ทีมที่ 2 อาทิตย์นึงลงสนามแข่ง 1 วัน แต่ซ้อม 6 วัน

แต่ในโลกของการพัฒนา software เวลาลงงานจริงมันเยอะกว่าเวลาซ้อมอยู่แล้ว (สมมติทำงานวันละ 8 ชั่วโมง) อย่างน้อยให้เราปันเวลา 2-3 ชั่วโมงมาซ้อมบ้าง แต่ที่สำคัญกว่าจำนวนวันคือการฝึกฝนอย่างมีคุณภาพด้วย ผู้พูดได้แนะนำ <https://exercism.org/> เป็น website สำหรับการฝึกฝนและเรียนรู้การเขียน program จากโจทย์เดียวกันด้วยหลากหลาย programming language ทำให้เราได้เห็นแนวทางการแก้ปัญหาด้วยวิธีการที่ต่างกันไป นอกจากนั้นแล้วเราสามารถฝึกด้วยการเข้ากิจกรรมต่าง ๆ เช่น coding dojo, code retreat, การร่วมเขียนโปรแกรมใน open source เป็นต้น  

อีกสิ่งหนึ่งที่ผู้พูดฝากไว้คืออย่าปล่อยให้ใครก็ไม่รู้มาดันเราออกจากการเป็น developer ที่เก่ง ๆ ไปเป็น manager ที่ห่วย ๆ เพราะประเทศไทยขาด developer แก่ ๆ ที่มีคุณภาพ  

ปิดท้ายด้วยแนวคิด Software Craftsmanship จาก <http://manifesto.softwarecraftsmanship.org/>

<รูป manifesto>

<https://www.somkiat.cc/software-craftsmanship/>
