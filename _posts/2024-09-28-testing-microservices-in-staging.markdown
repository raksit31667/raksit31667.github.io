---
layout: post
title: "ว่าด้วยเรื่องของการทดสอบใน Staging environment"
date: 2024-09-28
tags: [testing, microservices, practice]
---

![Next Level](/assets/2024-09-28-next-level.png)
<https://www.monkeyuser.com/2020/next-level/>

เมื่อเดือนที่แล้วมี discussion เกิดขึ้นในบริษัทเกี่ยวกับเรื่องของการทดสอบใน Staging environment ซึ่งมันก็มีประเด็นที่น่าสนใจหลายอย่าง ก็เลยจดบันทึกไว้ซะหน่อย

## ปัญหาของการทดสอบใน Staging
ในอดีต การทดสอบในสภาพแวดล้อมแบบครบวงจรหรือที่เรียกว่า [Staging](https://en.wikipedia.org/wiki/Deployment_environment#:~:text=A%20stage%2C%20staging%20or%20pre%2Dproduction%20environment%20is%20an%20environment%20for%20testing%20that%20exactly%20resembles%20a%20production%20environment.) ถือเป็น best practice ในการทดสอบระบบก่อนที่จะปล่อยจริงขึ้น production ซึ่งการมี Staging นี้มีความสำคัญอย่างมากเพราะช่วยให้ทีมพัฒนามั่นใจได้ว่า ระบบจะสามารถทำงานได้อย่างถูกต้องเมื่อนำไปใช้จริงใน Production  

โดยบางองค์กรทีมพัฒนามักจะใช้ Staging ในการทดสอบรอบใหญ่ ๆ เช่น ทุก ๆ เดือน ไปถึงจนถึง ทุก ๆ 3 เดือน ก่อนที่จะส่งมอบให้ทีม operation หรือทีม tester เพื่อทำการตรวจสอบขั้นสุดท้าย  

แต่เมื่อเวลาผ่านไป การทำงานในลักษณะนี้เริ่มมีปัญหามากขึ้น โดยเฉพาะอย่างยิ่งเมื่อเราก้าวเข้าสู่ยุคของ [Continuous Delivery](https://en.wikipedia.org/wiki/Continuous_delivery) และแนวคิดของ [microservices](https://en.wikipedia.org/wiki/Microservices) การใช้ Staging ทำให้การส่งมอบ software ช้าลงเนื่องจาก

1. **ค่าใช้จ่ายสูงและดูแลยาก**: environment มักจะเปราะบางและมีค่าใช้จ่ายสูง ต้องออกแรงในการดูแลรักษาเพิ่มเติมคล้าย ๆ กับ production (ยกเว้นโจทย์ด้าน scalability)
2. **การทดสอบซ้ำซ้อน**: บ่อยครั้งที่การทดสอบใน Staging ซ้ำซ้อนกับการทดสอบแยกส่วนที่เราทำมาใน environment ก่อนหน้า ทำให้สิ้นเปลืองแรงและเวลาโดยไม่จำเป็น

การมี Staging สำหรับการทดสอบยังทำให้เกิดการนำ microservices หลาย ๆ ตัวมาทำการทดสอบใน Staging ร่วมกัน ทำให้เกิดคอขวดในกระบวนการ release และขัดแย้งกับหลักการพื้นฐานของ microservices ที่ควรจะสามารถ deploy ได้อย่างอิสระต่อกัน  

## ต้นเหตุที่แท้จริงคือ Staging หรือเปล่า
หากเรามองลงไปลึก ๆ แล้วองค์กรเหล่านั้นที่เจอปัญหาของการทดสอบใน Staging มันเป็นเพราะว่าใน microservices ของเรามันมีส่วนของ [monolith](https://en.wikipedia.org/wiki/Monolithic_application) ที่ยังแฝงตัวอยู่ ซึ่งไม่ผิดนะเพราะการเปลี่ยน architecture จาก monolith ไปเป็น microservices เนี่ยมันต้องใช้เวลา ซึ่งระหว่างเราก็จะต้องเจอจุดหนึ่งที่ architecture ของเราจะติดอยู่ครึ่ง ๆ กลาง ๆ เพื่อทดสอบว่า dependencies ที่ยังเหลืออยู่สามารถทำงานร่วมกันได้อย่างถูกต้อง หลายองค์กรก็เลี่ยงไม่ได้ที่ว่าต้องทดสอบใน Staging ซึ่งมันขัดแย้งกับแนวคิดการทำงานอิสระของ microservices โดยสิ้นเชิง

## แล้วจะทดสอบโดยไม่ต้องพึ่งพา Staging ได้อย่างไร

### 1. ทดสอบ microservices แบบแยกส่วน
การทดสอบ microservices แบบแยกส่วน (Independent Integration/Component Testing) ช่วยให้เราสามารถทดสอบแยก service กันได้โดยไม่ต้องรวมทั้งหมดใน Staging ซึ่งการทำเช่นนี้จะช่วยลดความซับซ้อนและทำให้ทีมมีความมั่นใจในการทดสอบมากขึ้น ตัวอย่างการทดสอบที่แนะนำได้แก่

- [Contract testing](https://www.somkiat.cc/contract-testing/) และ [Test doubles](https://en.wikipedia.org/wiki/Test_double) โดยจำลอง service อื่น ๆ ขึ้นมาโดยใช้ technology อย่าง [WireMock](https://wiremock.org/) หรือ [LocalStack](https://www.localstack.cloud/) ในการทดสอบการทำงานร่วมกันโดยไม่ต้องพึ่งพา environment จริง

### 2. สร้าง environment ชั่วคราวสำหรับการทดสอบ
แนวคิดนี้จะช่วยให้แต่ละทีมสามารถสร้างสภาพแวดล้อมที่เหมือน Production แบบชั่วคราว (On-demand) เพื่อทดสอบได้ แล้วจะดีขึ้นไปอีกหากใช้ [Infrastructure as Code (IaC)](https://en.wikipedia.org/wiki/Infrastructure_as_code) เพื่อให้การสร้างและลบ environment เป็นไปได้อย่างรวดเร็ว

### 3. การทดสอบใน Production
บางองค์กร เช่น [Uber](https://copyconstruct.medium.com/testing-in-production-the-safe-way-18ca102d0ef1) หรือ [Spotify](https://engineering.atspotify.com/2018/01/testing-of-microservices/) เลือกที่จะทดสอบใน Production โดยตรง โดยทำการแยก traffic ที่เป็นการทดสอบออกจาก traffic จริง หรือใช้วิธีการเปิด feature บางส่วนผ่าน [Feature toggle](https://en.wikipedia.org/wiki/Feature_toggle) ซึ่งจะช่วยให้การทดสอบไม่กระทบกับผู้ใช้งานจริง

### 4. กลับไปสู่ monolith
ในบางกรณีที่การแยกระบบไปเป็น microservices นั้นซับซ้อนเกินไป การย้อนกลับไปใช้ Mmnolith แต่ออกแบบให้แยกกันทำงานได้ในระดับ module ([Modular Monolith](https://www.milanjovanovic.tech/blog/what-is-a-modular-monolith)) อาจเป็นทางเลือกที่ดีกว่า สิ่งนี้ช่วยให้การทำงานร่วมกันของระบบต่าง ๆ ง่ายขึ้น และยังสามารถใช้ประโยชน์จาก Staging ได้อยู่

## สรุป

การมี Staging อาจเคยเป็นแนวทางที่ดีในอดีต แต่ในยุคปัจจุบันที่ทุกอย่างต้องการความรวดเร็ว การใช้ Staging ในลักษณะเดิมอาจจะไม่ตอบโจทย์อีกต่อไป การทดสอบแบบแยกส่วน การสร้าง environment เพื่อทดสอบชั่วคราว หรือแม้กระทั่งการทดสอบใน Production เป็นแนวทางที่หลายองค์กรเริ่มนำมาใช้เพื่อแก้ปัญหานี้ครับ

## Further readings
- [ThoughtWorks: Enterprise-wide Integration Test Environments](https://www.thoughtworks.com/radar/techniques/enterprise-wide-integration-test-environments)
- [Building Microservices - Sam Newman](https://learning.oreilly.com/library/view/building-microservices-2nd/9781492034018/ch01.html#idm45699546421792)
