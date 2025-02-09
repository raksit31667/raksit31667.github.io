---
layout: post
title: "GitHub Actions ใช้ค่า secret ตอนไหนกันแน่"
date: 2025-02-09
tags: [github-actions]
---

เรื่องมันมีอยู่ว่าในระบบ CI/CD pipeline ที่ใช้ในปัจจุบันมัน fail ใน step ที่ checkout repository ลงมา 

```json
{"message":"Bad credentials","documentation_url":"https://developer.github.com/v3"}
```

ซึ่งสืบไปสืบมาก็ดูเหมือนว่าปัญหาจะอยู่ที่ GitHub PAT ที่ใช้ใน step ของ workflow ที่ run ค้างไว้นานเพราะรอ approval

<script src="https://gist.github.com/raksit31667/e4f6622fc241963394c15e59db23bd12.js"></script>

นั่นก็ทำให้ถึงมันมึนงงเพราะเราเพิ่ง update GitHub PAT ใหม่ลงไปใน GitHub Actions secret ด้วย  

คำถามที่เกิดขึ้นในหัวของเรา ณ ตอนนั้นคือ

> "GitHub Actions ดึงค่า secret มาใช้ตอนไหน"
> "ถ้าเราเปลี่ยนค่า secret ระหว่างที่ workflow กำลัง run อยู่ ค่าใหม่จะถูกนำไปใช้ไหม"

จึงขอลองทำการทดลองเสียหน่อย โดยทั้งสมมติฐานว่า  
> GitHub Actions จะ load ค่า secret **ตั้งแต่ตอนที่ workflow เริ่ม run** ไม่ใช่ตอนที่ step ทำงาน และ approval stage (ที่ใช้ environment) ก็ไม่มีผลต่อเรื่องนี้  

## สร้าง workflow สำหรับทดสอบ  
เราใช้ workflow ที่ต้องรอ approval ก่อนจะทำงาน โดยใน workflow จะ  

1. บันทึกค่า secret ก่อนรอ (เพื่อดูค่าตอนเริ่มต้น)  
2. Sleep 1 นาที ให้มีเวลาปรับค่า secret  
3. บันทึกค่า secret อีกครั้งหลังจากรอ  
4. Upload ค่าทั้งสองเป็น Artifact ให้เรา download มาตรวจสอบ  

<script src="https://gist.github.com/raksit31667/049ed1100873919c3ea0775a887c88f2.js"></script>

## วิธีทดสอบ  
1. ตั้งค่า secret (`TEST_SECRET`) ใน GitHub repository
2. Run workflow ด้วยมือ (`workflow_dispatch`)
3. ก่อนกด approve เข้าไปเปลี่ยนค่า secret ใหม่  
4. Approve workflow ให้มันทำงานต่อ
5. Download artifact ที่ชื่อ `secret-values`
6. Check ค่าใน file `secret_before.txt` และ `secret_after.txt`  

## ผลลัพธ์ที่ได้ (ถ้าสมมติฐานถูกต้อง) 
ค่า secret **ก่อนและหลังเหมือนกันเป๊ะ** เพราะ GitHub Actions โหลดค่าตั้งแต่ workflow เริ่ม ไม่ใช่ตอนที่ step ทำงานนั่นเอง แม้ว่าเราจะมี approval stage ก็ตาม secret ก็จะยังคงเป็นค่าตอนแรกที่ Workflow เริ่ม  

## Reference
- [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions?utm_source=chatgpt.com#:~:text=Organization%20and%20repository%20secrets%20are%20read%20when%20a%20workflow%20run%20is%20queued%2C%20and%20environment%20secrets%20are%20read%20when%20a%20job%20referencing%20the%20environment%20starts.)
