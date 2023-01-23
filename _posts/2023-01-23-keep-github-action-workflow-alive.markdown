---
layout: post
title: "แนะนำเครื่องมือป้องกัน GitHub Action Workflow หยุดทำงานหลัง 60 วัน"
date: 2023-01-23
tags: [github, github-action]
---

ตั้งแต่ปีที่ผ่านมาเราเริ่มใช้เครื่องมือ [WakaTime]({% post_url 2020-02-22-coding-activity-with-wakatime %}) เป็นตัวเก็บสถิติ จากนั้นเราสามารถนำสถิติที่เก็บได้ไปแสดงผลบน GitHub ผ่านเครื่องมือ [waka-box](https://github.com/matchai/waka-box) ประมาณนี้

![waka-box](/assets/2023-01-23-waka-box.png)

โดยเครื่องมือที่ว่านี้การทำงานคือทุก ๆ วันเครื่องมือจะสร้าง job มายิง [API ไปหา WakaTime](https://wakatime.com/developers) เพื่อดึงข้อมูลสถิติมาแสดงผล ซึ่งเราจะต้องติดตั้ง job ผ่าน [GitHub Action Workflow](https://docs.github.com/en/actions/using-workflows/about-workflows) และผูกกับ API key ที่เราได้มาจากการสมัคร WakaTime  

เกริ่นมาตั้งนาน ปัญหาที่เกิดขึ้นคือข้อจำกัดของ GitHub Action Workflow คือ  

> ถ้าไม่มี "ความเคลื่อนไหว" ใด ๆ ใน repository ของ job **ภายใน 60 วัน** ตัว job จะหยุดทำงานโดยอัตโนมัติ

ผลที่เกิดขึ้นก็คือสถิติของเราจะไม่ถูก update บนหน้า GitHub profile จนกว่าเราจะเข้าไปเปิดให้ job มันทำงานต่อ **"ความเคลื่อนไหว"** ที่กล่าวมาคือ commit ใน repository นั่นเอง แต่ว่าใน waka-box เราไม่ได้อยากจะแก้ไข code แต่อย่างใดเว้นเสียจากการ upgrade dependencies เท่านั้น  

เพื่อที่จะป้องกันไม่ให้ GitHub Action Workflow หยุดทำงานหลัง 60 วัน เราเลยเลือกใช้ GitHub Action ที่ชื่อว่า [Keepalive Workflow](https://github.com/marketplace/actions/keepalive-workflow) โดยหลักการทำงานคือทุก ๆ 50 วันหลังจาก commit ล่าสุด (สามารถปรับเปลี่ยนได้) มันจะใช้ bot มาทำ commit แบบ dummy ขึ้นมา เพื่อให้ ใน repository ของ job มี **"ความเคลื่อนไหว"** ส่งผลให้ไม่ถูกหยุดทำงานโดยอัตโนมัตินั่นเอง (อ้างอิงจากตัว [keepalive-workflow](https://github.com/gautamkrishnar/keepalive-workflow/blob/461917b9000283f953590c4f8387b2d065d5fda6/library.js#L13))  

## วิธีการติดตั้ง

1. เพิ่ม [environment variable](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository) ที่มี key ชื่อว่า `GH_TOKEN` โดยมี value คือ [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) ที่มี scope คือ `repo` จุดประสงค์เพื่อให้ bot ทำ commit บน repository ของ job โดยอัตโนมัติ สำหรับ waka-box นั้นก่อนใช้งานจะต้องมี `GH_TOKEN` อยู่แล้วเพื่อให้ bot แสดงสถิติบนหน้า GitHub profile ของเรา
2. ทำการ update GitHub Action Workflow file ของเรา โดยปกติจะอยู่ใน `path/to/your/repo/.github/workflows/schedule.yml` ตามนี้

<script src="https://gist.github.com/raksit31667/7c981f7f8cea50a91d2478513be54c2b.js"></script>

เพียงเท่านี้ก็เป็นอันเสร็จ หลังจากนี้อีก 50 วันก็จะมี commit จาก [bot](https://github.com/gkr-bot) ขึ้นมาละ



