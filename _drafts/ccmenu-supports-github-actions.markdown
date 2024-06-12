---
layout: post
title: "CCMenu ตอนนี้รองรับ Github Actions workflow แล้วนะ"
date: 2024-06-12
tags: [productivity, cicd, github-actions, tools]
---

ก่อนหน้านี้เราได้ลองใช้เครื่องมือในการแสดงสถานะของ [GitHub Actions](https://github.com/features/actions) workflow ที่เขียนไว้ในบทความ [แนะนำเครื่องมือที่ใช้สร้าง dashboard view สำหรับ GitHub Actions]({% post_url 2024-05-12-github-actions-build-monitor-view %}) แล้วพบว่ามันก็ตอบโจทย์ ณ ตอนนั้นได้ดี แต่ถ้าไม่มี dashboard ไว้ดูเมื่อต้องทำงานแบบ remote โอกาสที่ทีมจะรู้ว่า workflow มัน fail และช่วยกันแก้ไขก็จะช้าลง ด้วยความที่เรารู้จัก CCMenu เมื่อเขียนบทความ [แนะนำเครื่องมือ CCMenu สำหรับดูสถานะ CICD server]({% post_url 2022-09-27-ccmenu-monitor-cicd-server %}) ที่เพิ่งออก [version 2](https://github.com/ccmenu/ccmenu2) มาหมาด ๆ ทำให้ตอนนี้เราหยิบมันกลับมาใช้กับ GitHub Actions ได้แล้ว

## ขั้นตอนการติดตั้ง
1. Download [pre-release](https://github.com/ccmenu/ccmenu2/releases) ในรูปแบบ zip file เนื่องจากตอนที่เขียนบทความนี้ CCMenu2 ยังไม่ได้ release ลง AppStore เหมือน [CCMenu](http://ccmenu.org/) อันก่อน
2. แตก zip file และติดตั้ง app
3. พอกดเข้ามาใน app ให้กดปุ่ม `+` ข้างบนแล้วเลือก `Add GitHub Actions workflow...` ประมาณนี้

    ![CCMenu 2](/assets/2024-06-12-ccmenu2.png)

4. ตรง `Authentication` กด `Sign in` แล้วให้ copy code รูปแบบ `XXXX-XXXX` ไว้ จากนั้นกด `Copy code and continue`
5. เอา code จากขั้นตอนที่แล้วไปแปะแล้วกด `Continue`
6. Grant access เข้า GitHub organization ตามต้องการ

    ![CCMenu 2 GitHub authorized](/assets/2024-06-12-ccmenu2-github-authorized.png)

7. กลับมาที่ CCMenu2 ตรง `Owner` ให้กรอก GitHub user หรือ organization ตามต้องการ
8. เลือก `Repository`, `Workflow` และ `Branch` ตามต้องการ
9. ปรับแก้ `Display name` ตามต้องการหรือจะใช้ default ก็ได้
10. กด `Apply` เป็นอันเสร็จ

![CCMenu 2 configured](/assets/2024-06-12-ccmenu2-configured.png)

สังเกตว่าบน menu bar จะเห็น status ของ GitHub Actions แล้ว เหมือนกับ version เดิมเลย

![CCMenu 2 menu bar](/assets/2024-06-12-ccmenu2-menu-bar.png)

## ข้อจำกัด
แต่ CCMenu 2 ก็ยังมีข้อจำกัดอยู่เหมือนเดิมคือ
- ใช้ได้แค่ใน macOS เท่านั้น สำหรับ Windows ต้องหาเครื่องมือที่ support [CCTray](https://cctray.org/v1/) แทน
- ขอ Full control สำหรับ private repositories ซึ่งดูเยอะเกินไปสำหรับแค่ monitor workflow
- ตอนนี้ต้อง configure workflow ได้ครั้งละอัน ถ้าทำครั้งเดียวแล้วได้หลายอันจะสะดวกสบายกว่านี้อีก
