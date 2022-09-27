---
layout: post
title:  "แนะนำเครื่องมือ CCMenu สำหรับดูสถานะ CICD server"
date:   2022-09-27
tags: [productivity, cicd]
---

ในการทำงานลักษณะ remote working ของทีมเรา สิ่งหนึ่งที่หายไปคือการมี monitoring dashboard เปิดไว้ให้ทุกคนในทีมเห็นลักษณะแบบนี้

![Office Dashboard TV](/assets/2022-09-27-office-dashboard-tv.jpeg)

[TV Dashboards: a complete guide](https://www.geckoboard.com/best-practice/tv-dashboards/)

หนึ่งใน dashboard ที่สำคัญคือสถานะของ continuous integration (CI) จาก server เพื่อที่ทีมจะได้รู้ว่าระบบล่าสุดมันมีข้อผิดพลาดตามขั้นตอนที่ได้ระบุไว้ไหม ซึ่งถ้ามีความผิดพลาด ทีมก็จะรู้ได้ไวและช่วยกันแก้ไข นอกจากที่เราจะได้ระบบพร้อมขึ้น production แล้วยังไม่ไป block การทำงานของคนอื่นในทีมอีกด้วย  

ปัญหาคือเมื่อไม่มี dashboard แล้วการที่ทีมจะรู้สถานะของ CI โดยเฉพาะเรามีหลาย ๆ อันก็ต้องออกแรงกันสักหน่อย เช่น สร้าง notification เข้า chat กลุ่มหรือไม่ก็เข้าไปดูกันใน dashboard เอาเอง ดังนั้นจึงมีเครื่องมือมาแนะนำคือ [CCMenu](http://ccmenu.org/) ซึ่งเราสามารถดูสถานะจาก Menu bar กันได้เลย นอกจากนั้นยังมี feature อื่น ๆ ที่น่าสนใจอย่างเช่น

- เลือกดูสถานะได้จากหลาย pipeline หลาย server
- พอกดเข้าไปที่ CI อันใดอันนึง มันจะเปิด browser ไปที่ server นั้นเลย ไม่ต้องเปิดรอหลาย tab/window
- ได้รับ notification โดยไม่ต้องตั้งค่าจาก CI เพิ่มเติม

![CCMenu](/assets/2022-09-27-ccmenu.png)

แต่ CCMenu มีข้อจำกัดอยู่คือ
- ใช้ได้แค่ใน macOS เท่านั้น สำหรับ Windows ต้องหาเครื่องมือที่ support [CCTray](https://cctray.org/v1/)
- ก่อนใช้จะต้องเพิ่ม server ลงไปก่อน ซึ่งวิธีก็จะต่างกันไปตาม CI นั้น ๆ CI และในขณะที่เขียนบทความ จะมีแค่บางตัวที่ support CCTray
  - [Jenkins](https://plugins.jenkins.io/cctray-xml/)
  - [TravisCI](https://docs.travis-ci.com/user/cc-menu/)
  - [Buildkite](https://buildkite.com/docs/integrations/cc-menu)

> ก็ลองเอาไปพิจารณาใช้กันดูครับ ของโคตรดี
