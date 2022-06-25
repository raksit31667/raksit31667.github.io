---
layout: post
title:  "แนวทางการสร้างเครื่องมือเพื่อ automate งาน"
date:   2022-06-24
tags: [automation]
---

![Automation](/assets/2022-06-26-automation.jpg)

Photo by <a href="https://unsplash.com/@lennykuhne?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Lenny Kuhne</a> on <a href="https://unsplash.com/s/photos/automation?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>  

อาทิตย์ก่อนมี discussion ที่น่าสนใจจากกลุ่ม Software Development ของที่บริษัท เลยจดบันทึกไว้สักหน่อย  

เมื่อเราพูดถึงงานที่เราต้องมาทำ automation โดยมากก็จะเป็นงานที่ทีมพัฒนา software จะต้องทำบ่อย ๆ ซ้ำ ๆ ไม่ว่าจะเป็น

- ทำการ run ชุดการทดสอบในแต่ละระดับ
- Build source code ให้เป็น artifact
- Deploy artifact ขึ้นระบบงาน

งานบางส่วนสามารถนำมาร้อยเรียงกันเป็นขั้นเป็นตอนได้ในรูปแบบของ pipeline เพื่อทำให้เส้นทางในการส่งมอบงานให้ผู้ใช้เป็นไปได้อย่างรวดเร็ว และป้องกันความผิดพลาดที่เกิดจากการทำแบบ อัตโนมือ (human-error prone) ซึ่งในการที่จะนำมาร้อยเรียงกันได้ ก็คงหนีไม่พ้นการ coding อยู่แล้ว เรามาดูกันว่ามีวิธีที่ทีมพัฒนาสามารถสร้าง automation ได้อย่างไร

## 1. Strict declarative tools
เครื่องมือในกลุ่มนี้จะใช้ภาษาหรือกฎเฉพาะตัว โดยถูกสร้างมาเพื่อทำงานใดงานหนึ่งเท่านั้น เช่น

- **Maven**: สำหรับทำ package management และ build automation กำหนดเงื่อนไข บน XML file
- **Terraform**: สำหรับทำ Infrastructure-as-a-Code กำหนด resource, configuration ด้วย Hashicorp Configuration Language
- **Helm**: สำหรับทำ package management สำหรับ Kubernetes application กำหนด resource ต่าง ๆ ด้วย YAML file

เนื่องจากสร้างมาสำหรับทำงานใดงานหนึ่งโดยเฉพาะ ถ้าเราต้องการจะ customize ในระดับนึง จะทำได้ยากกว่าเครื่องมือประเภทอื่น เพราะ syntax จะ strict มาก (declarative language)

## 2. Declarative with flexible scripting language
เครื่องมือในกลุ่มนี้จะคล้ายกันกับกลุ่มที่ 1 แต่จะมีความยืดหยุ่นในการ customize ได้มากกว่า เช่น

- **Gradle**: สำหรับทำ package management และ build automation กำหนดเงื่อนไขด้วยภาษา Groovy หรือ Kotlin
- **gulp.js**: สำหรับทำ automate task เช่น แปลง CSS file โดยกำหนด task ด้วยภาษา JavaScript

ภาษาที่ใช้ส่วนใหญ่ในการ customize จะอยู่ในกลุ่ม imperative language และมี plugin เสริมที่สามารถ download มาใช้ได้ ซึ่งจะมีข้อจำกัดตรงที่ว่าเราไม่สามารถ customize ตัว plugin ได้มากมายไปเกินกว่าที่คนสร้างกำหนดไว้ ถ้าต้องลงเอยด้วยการเขียนเอง ก็จะมีค่าใช้จ่ายในการดูแลรักษาสูงขึ้น

## 3. Declarative with Shell
เครื่องมือในกลุ่มนี้จะใช้ Shell ในการ customize เช่น

- **Make**: สำหรับทำ automate task และ workflow ในระดับ low-level เช่น เมื่อมีการ update file ใด ๆ กำหนด flow ด้วย `Makefile`

ข้อดีคือจะมีความยืดหยุ่นสูงมาก สามารถใช้ได้กับ project ที่มีหลาย ๆ ภาษาพร้อมกัน โดยไม่ต้องสลับ context ของแต่ละภาษาไป ๆ มา ๆ ข้อควรระวังคือทีมพัฒนาจะมี learning curve ในการทำความเข้าใจ workflow (เช่น `Makefile`) และ task ที่เขียนด้วย shell script ที่โดยทั่วไปแล้วไม่ได้อยู่ในภาษามนุษย์เท่าไร

## 4. Shell call-out
เครื่องมือในกลุ่มนี้จะคล้ายกันกับกลุ่มที่ 3 แต่จะลด learning curve ในการทำความเข้าใจ workflow ด้วยการใช้เครื่องมือตัวอื่น ๆ แทน เช่น

- **npm** และ **yarn**: เป็น package management สำหรับ JavaScript project สามารถเรียก shell script ได้

แม้ว่าจะลด learning curve ในการทำความเข้าใจ workflow แต่ในส่วนของ task ที่เขียนด้วย shell script ก็ยังคงยู่

## 5. Containers-based tools
เครื่องมือในกลุ่มนี้จะใช้แนวคิดเรื่อง containerization มาประยุกต์ เช่น

- **docker-compose** และ **batect**: กำหนด CLI command, environment variable และ workflow ผ่าน YAML file

ข้อดีคือไม่จำเป็นต้องติดตั้ง dependencies ที่ใช้ในการ run เครื่องมือเหมือนกลุ่มที่ 1-2 ในขณะเดียวกัน task ที่เขียนก็ไม่จำเป็นต้องอยู่ในรูปแบบของ shell เหมือนกลุ่มที่ 3-4 แต่มีข้อจำกัดคือ ระบบที่ใช้ run เครื่องมือกลุ่มนี้จะต้องรองรับ containerization เช่น Docker เป็นต้น

## แล้วควรใช้รูปแบบไหนดีล่ะ
เป็นอีกหนึ่งคำถามที่ต้องตอบว่า *"It depends"* อีกเช่นเคย เนื่องจากมีหลายปัจจัย เช่น

- เราทำงานกับ Project ที่ใช้มากกว่า 1 ภาษาหรือไม่
- เราทำงานกับ Project ที่ระบบงานรองรับ containerization ไหม
- งานที่จะ automate สามารถทดแทนด้วย plugin ได้ไหม หรือต้อง customize เอง
- ทีมพัฒนามีความคุ้นเคยกับภาษาใดบ้าง

> แล้วทีมของเราใช้เครื่องมือกลุ่มไหน เพราะอะไร