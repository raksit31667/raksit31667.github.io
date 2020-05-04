---
layout: post
title:  "จดวิธี trigger Azure DevOps pipeline ผ่านอีก pipeline นึง"
date:   2020-05-04
tags: [azure-devops, cicd]
---
ได้โจทย์มาคือต้อง build ระบบงานบน `dev -> qa -> uat` ซึ่งมี stage ในการ test ในระดับที่ต่างๆ กันไปให้ผ่านก่อน จึงจะสามารถ deploy บน `production` ได้ โดยที่ non-production จะใช้ code ชุดเดียวกันกับ production เลย  
  
สำหรับ Azure DevOps มีวิธีการง่ายๆ คือ เข้าไปที่ production pipeline `Edit -> Triggers` แล้วก็ configure ตามภาพเลย

![Trigger configuration](/assets/2020-05-04-azure-devops-trigger-configuration.png)

เราเลือกใช้ `Build completion` พร้อมกำหนด pipeline ที่จะมา trigger pipeline นี้ (ในตัวอย่างใช้ non-production pipeline)  

โดยปกติแล้ว Continuous Integration มันจะถูก enable ไว้เสมอ ในกรณีนี้เราต้อง disable เพื่อไม่ให้ non-production pipeline ไป trigger production pipeline ตอนที่เรา **push code** ขึ้นไปบน repository เท่านั้น  

สังเกตว่าใน production pipeline จะขึ้นว่าเป็น Build completion และจะ trigger หลังจากที่ non-production pipeline build สำเร็จเท่านั้น  

![Trigger result](/assets/2020-05-04-azure-devops-trigger-result.png)