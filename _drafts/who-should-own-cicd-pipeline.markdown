---
layout: post
title: "ใครควรเป็นคนดูแลและรับผิดชอบ CI/CD Pipeline"
date: 2024-12-27
tags: [cicd, platform]
---

![Pipeline](/assets/2024-12-27-pipeline.jpg)

Photo by <a href="https://unsplash.com/@hiro_ishii?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Hiro Ishii</a> on <a href="https://unsplash.com/photos/a-close-up-of-a-metal-structure-against-a-blue-sky-i7BW-QvcuRU?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
      
หลังจากที่ได้เข้าไปทำ project ในฐานะ Platform Engineer มา 2 project ก็เกิดคำถามกับตนเองว่า แล้วใครควรเป็นคนดูแลและรับผิดชอบ CI/CD Pipeline ดีกว่า ระหว่าง Developer และ Platform Engineer แบบไหนดีกว่ากัน    

> คำตอบที่ดีที่สุดคือ "มันควรเป็นหน้าที่ร่วมกัน"

## ประเด็นที่ 1 - หน้าที่และความรับผิดชอบที่ต่างกัน
หากเราพูดถึงว่า "การเป็นคนดูแลและรับผิดชอบ pipeline" โดยส่วนมากแล้วจะมีหน้าที่ดังนี้

- กำหนดวิธีการและออกแบบขั้นตอนต่าง ๆ ในการทำงานของ pipeline รวมถึงเครื่องมือที่ใช้ให้เหมาะสมกับลักษณะงานของทีม
- ดูแลให้ pipeline ทำงานได้อย่างราบรื่น ไม่มีปัญหาหรือข้อผิดพลาด
- ตรวจสอบและแก้ไขปัญหาที่เกิดขึ้นใน pipeline เมื่อเกิดข้อผิดพลาด
- การจัดการความเสี่ยงและความปลอดภัยในการใช้งาน pipeline

จะเห็นว่าคนที่จะมาดูแลความรับผิดชอบนั้นมันก็ขึ้นอยู่กับว่ามันไปตกที่บทบาทของ Developer และหรือ Platform Engineer ซึ่งก็จะแตกต่างกันไปในแต่ละองค์กร มันก็เลยไม่มีกลุ่มตายตัวว่าจะต้องเป็นใคร แต่มันอยู่ที่บทบาทที่ตกลงกันมากกว่า

## ประเด็นที่ 2 - ความรู้และทักษะในการจัดการกับความซับซ้อนของ Pipeline
ความซับซ้อนของ pipeline นั้นมันเกิดจาก 2 ส่วนใหญ่ ๆ ด้วยกันได้แก่

1. Tooling สำหรับตั้งค่า pipeline ตามความต้องการของ project หรือ style การทำงานของทีม
2. Infrastructure ที่อยู่เบื้องหลัง pipeline เช่น agent, plugin, credentials, permission ไปจนถึง integration กับ deployment platform สำหรับ deploy application

ถ้าทีม Developer มีความเชี่ยวชาญในการตั้งค่า pipeline และสามารถแก้ไขปัญหาเองได้ Platform Engineer ก็สามารถออกแบบ pipeline ให้ยืดหยุ่นในการปรับ pipeline ตาม workflow ของทีมได้ ซึ่งมันก็จะช่วยให้ทีมส่งมอบงานได้เร็วและง่ายขึ้น  

แต่ข้อเสียคืออาจไม่มีเวลาเพียงพอในการดูแล pipeline เมื่อ focus หลักอยู่ที่ feature นอกจากนั้นยังมีความเสี่ยงในการ over-customise ซึ่งอาจนำไปสู่ปัญหาใหญ่ที่ไม่อาจคาดคิดได้ ตรงส่วนนี้ Platform Engineer จะต้องมีการตั้งกฏหรือระบบตรวจสอบ (guardrail) เพื่อให้แน่ใจว่า Developer ไม่ทำการ over-customise เช่น ไม่สามารถ deploy application โดยไม่ผ่านขั้นตอนที่จำเป็นก่อน เป็นต้น  

ในทางกลับกันบางองค์กรที่เน้นเรื่องของมาตรฐานเป็นหลัก ไม่มีความแตกต่างในกระบวนการทำงานของแต่ละทีมหรือถ้ามีก็น้อยมากกก และความรู้ด้าน infrastructure และ tooling ของ Developer นั้นจำกัดจำเขี่ยจริง ๆ การให้ Platform Engineer ดูแลรับผิดชอบเป็นหลักก็ไม่เลว  

ข้อดีหลัก ๆ เลยคือทีม Platform สามารถออกแบบ pipeline ให้มีมาตรฐานได้ด้วยการตั้งค่า guardrails และปรับแต่งการทำงานของ pipeline ในระดับที่เหมาะสม นอกจากนั้นก็ลดการปวดหัวของ Developer ไม่ต้องมานั่งตั้งค่า pipeline หรือเรียนรู้เทคโนโลยีที่เกี่ยวข้อง Developer จะได้โฟกัสที่การพัฒนา feature และการเขียน code อย่างเต็มที่  

ในกรณีนี้ Platform Engineer อาจสร้าง abstraction ในรูปแบบของ reusable workflows ที่มีการกำหนดค่ามาตรฐานไว้ให้แล้ว ซึ่ง Developer สามารถนำไปใช้ได้ทันที อย่างเช่น การรวมขั้นตอนการ build, test, และ deploy ไว้ใน pipeline เดียวกัน เพื่อลดความซับซ้อน แต่ข้อเสียก็คือ Developer อาจรู้สึกถูกจำกัดในการปรับแต่ง pipeline ตามที่ต้องการ เพราะมันอาจจะไม่ยืดหยุ่นเท่าที่ควร นอกจากนี้ Platform Engineer ต้องดูแล abstraction ไม่ให้มัน leak จนดูแลรักษาไม่ไหวเมื่อหลากหลายทีมจำเป็นต้อง customise เพิ่มเติม ซึ่งหากเกิดขึ้นก็จะเป็น[งานที่หยาบมาก ๆ](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/)

## คำตอบที่ดีที่สุดคือ... การทำงานร่วมกัน
จาก 2 ประเด็นข้างต้น การเลือกข้างระหว่าง Developer กับ Platform Engineer อาจสร้างการพัฒนา pipeline ที่ดีได้ แต่การทำงานร่วมกันจะสามารถสร้างการพัฒนา pipeline ที่ดีที่สุด เพราะมันถูกพัฒนาจากความรู้ ความเชี่ยวชาญ engineering practice และความคิดเห็นจากทั้งสองฝ่าย  
ช่วงเวลาที่ทั้งสองฝั่งควรทำงานร่วมกันมากที่สุดคือตอนเริ่มสร้าง Platform ขึ้นมา Platform Engineer ต้องคัดเลือก Developer ทีมแรกที่จะทำงานด้วยให้ดี เพราะมันจะ shape workflow ที่เรียบง่ายพอที่ Developer ถัด ๆ ไปจะสามารถปรับแต่งตามความต้องการได้ด้วยตนเอง

### ตัวอย่างการทำงานร่วมกัน
- Platform Engineer
  - ดูแล workflow ที่เรียบง่ายให้ Developer เข้าใจง่าย สามารถนำไปใช้ได้ง่าย
  - ดูแลโครงสร้างหลักของ pipeline โดยอิงจาก cross-cutting concerns ที่ได้ไปคุยร่วมกันมากับ Developer เช่น infrastructure ที่อยู่เบื้องหลัง pipeline รวมไปถึง security
  - ตรวจสอบและแก้ไขปัญหาที่เกิดขึ้นใน pipeline เมื่อเกิดข้อผิดพลาดที่เกี่ยวข้องกับโครงสร้างหลัก
- Developer
  - ดูแลพัฒนา pipeline โดยสามารถใช้ workflow ที่สร้างโดย Platform Engineer ปรับแต่ง workflow ให้เหมาะสมกับความต้องการของทีม
  - ตรวจสอบและแก้ไขปัญหาที่เกิดขึ้นใน pipeline เมื่อเกิดข้อผิดพลาด หากสันนิษฐานว่าต้นเหตุอยู่ที่โครงสร้างหลักให้ติดต่อ Platform Engineer
