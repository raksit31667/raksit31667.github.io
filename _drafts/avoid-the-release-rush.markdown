---
layout: post
title:  "เราต้องเตรียมอะไรบ้างในการ release ระบบ"
date:   2022-01-12
tags: [software-release, practice]
---

## การ release มันน่ากลัวจริงไหม
ในการ release ระบบขึ้น production มันไม่ได้สวยงามทุกครั้งเสมอไป มันก็จะมีบางครั้งที่เรา (คิดไปเอง) ว่าต้อง "รีบ" และ "เร่ง" นำขึ้นไป ก่อให้เกิดอาการตึงเครียด กลัว panic หน้ามืดคล้ายจะเป็นลม คำถามที่น่าสนใจคือ 

> เราเคยถามตัวเองไหมว่าทำไมเราถึงรู้สึกแบบนั้น

- เพราะเราขาดความมั่นใจว่า release ไปแล้ว ตัวระบบเองยัง work เหมือนเดิม
- เพราะเราขาดความมั่นใจว่า release ไปแล้ว dependency ยังเชื่อมต่อกับระบบเราได้
- เพราะเราขาดความมั่นใจว่า เราจะต้องรายงานเรื่องการ release ให้กับใครบ้าง
- เพราะเราขาดความมั่นใจว่า เราไม่สามารถรับมือกับเหตุการณ์ที่ไม่ได้เป็นไปตามแผนได้ทันท่วงที

จากบทความ [Avoid the release rush: a playbook for smooth production releases](https://www.thoughtworks.com/insights/blog/agile-project-management/release-rush-playbook-smooth-production-releases) ผู้เขียนได้แบ่งปันประสบการณ์การเตรียมพร้อมสำหรับการ release ไว้ ทั้งก่อนและหลัง release ซึ่งใจความสำคัญคือถ้าเรามีแผนหลักและแผนรองรับที่ดีพอ เราจะไม่ตกอยู่ในสถานการณ์ "รีบ" และ "เร่ง" อย่างที่เราอาจจะเคยเป็นกันมาก่อน ดังนั้นเราเลยนำมาสรุปบันทึกไว้หน่อย

## ก่อนการ release จะต้องมี
- Feature ที่จะส่งมอบพร้อมแล้ว
- ทำการทดสอบแบบ acceptance testing ผ่านแล้ว
- ตกลงกับ product owner ทั้งในเรื่องของกำหนดการ release และ feature ที่จะ release
- Approval จาก stakeholders ทั้งจากในฝั่ง security หรือ licensing หรือ IT
- ตรวจสอบฝั่ง upstream และ downstream system ในกรณีว่ามี feature ใหม่หรือไม่
- Feature toggles ที่จะต้องเปิด/ปิด พร้อมแล้ว
- การทำ [Bug bash](https://warun.in.th/580-bug-bash-%E0%B8%84%E0%B8%B7%E0%B8%AD%E0%B8%AD%E0%B8%B0%E0%B9%84%E0%B8%A3) (ถ้ามี)
- การทดสอบแบบ regression testing ผ่านแล้ว
- การเตรียม hotfix plan ในกรณีที่ release ไม่สำเร็จ (เช่น ต้อง rollback กลับไปเป็น version ก่อนหน้า เป็นต้น)
- การวัดคุณภาพในแง่ของ [NFR/CFR](https://en.wikipedia.org/wiki/List_of_system_quality_attributes) เช่น performance หรือ browser compatibility เป็นต้น
- สำหรับ native mobile application ต้องตรวจสอบเรื่อง Appstore/Play Store เพิ่ม
- Environment ที่จะ release พร้อมแล้ว
- Data ที่จะต้อง upload พร้อมแล้ว
- Third party licenses, renewals, contracts
- Documentation เช่น release notes, manual, known issues
- Release template รวมถึง timeline ว่ามีงานไหนที่จะต้องทำให้เสร็จก่อน release บ้าง (backtracking dates)
- จัดประชุม check-in เพื่อดู progress ของแต่ละงาน

## หลังการ release จะต้องมี
- ตรวจสอบว่า feature หลักทำงานได้
- Performance ตอนใช้งานระบบบนทุกอุปกรณ์ที่ support
- ถ้าเป็น SaaS หรือมีการ migration ใหญ่ จะต้องตรวจสอบเรื่องของ data เพิ่ม
- ตรวจสอบ logs เพื่อดูการ integrate ระหว่างระบบ upstream-downstream
- ระบบ monitoring ในส่วนของ performance ถ้าระบบมี load เยอะ

## ควรจะทำให้สิ่งเหล่านี้เป็น automatic ทั้งหมด
- Build pipeline
- Deployment
- การทดสอบแบบต่างๆ เช่น regression, sanity, performance
- ระบบแจ้งเตือนว่ามีการ upgrade ใหม่
- Data upload
- App publishing
- ระบบแจ้งเตือนให้ออก documentation ใหม่

## เรื่องของหน้าที่ความรับผิดชอบของการ release ใน project
แนะนำให้จัดการประชุมเรื่องพูดคุยกับทุกคนที่มีส่วนเกี่ยวข้องกับการ release ซึ่งจะได้ข้อสรุปดังนี้

- หน้าที่ความรับผิดชอบของแต่ละ team ซึ่งรวมถึง dependency ของเราด้วย
- Timeline ที่ชัดเจน
- [RAIDs](https://medium.com/wip-team/inception-%E0%B8%A1%E0%B8%B2%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%81%E0%B9%88%E0%B8%AD%E0%B8%99%E0%B9%80%E0%B8%A3%E0%B8%B4%E0%B9%88%E0%B8%A1%E0%B8%97%E0%B8%B3-product-%E0%B8%81%E0%B8%B1%E0%B8%99%E0%B8%94%E0%B8%B5%E0%B8%81%E0%B8%A7%E0%B9%88%E0%B8%B2-6628960e8bbc)

## ปิดท้ายด้วย tips & tricks
- เผื่อวันเวลาใน deadline ลงไปนิดหน่อย เผื่อบางอย่างไม่เป็นไปตามแผน
- ถ้าเราเห็นก่อนแล้วว่าการ release น่าจะเลย deadline ให้รีบแจ้ง stakeholder ของเรา
- ถ้ามี feature ไหนที่ยังไม่เสร็จ ให้พูดคุยกันเพื่อดูว่า feature นั้นมันสามารถตัดออกไปก่อน release ได้ไหม
- ถ้ามีงานที่ระบไว้บนหัวข้อ **ก่อนการ release** ไหนที่ยังไม่เสร็จ ให้พูดคุยเพื่อขอเลื่อนการ release ไปสักวัน-2 วัน ซึ่งต้องทำให้ทุกคนตระหนักว่าช้าหน่อนยังน่าจะดีกว่า release ไปแล้วมันมี bug

