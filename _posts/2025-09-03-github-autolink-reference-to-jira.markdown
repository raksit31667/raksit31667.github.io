---
layout: post
title: "Autolink GitHub ไปหา Jira แบบง่าย ๆ"
date: 2025-09-03
tags: [github, jira, automation]
---

เวลาเราใช้ GitHub ทำงานเป็นทีม เรื่องการ refer Issue หรือ PR ก็คือกลายเป็นของธรรมดาไปแล้ว แต่บางทีทีมเราก็ไม่ได้ใช้ GitHub Issues อย่างเดียว หลายทีมก็ใช้ [Jira](https://www.atlassian.com/software/jira) เป็นตัวหลักในการ track งาน ที่เหมาะสำหรับ project management กว่า  

ทีนี้ปัญหาคือ เวลาจะ refer Jira issue key (เช่น `JIRA-123`) ลงไปใน GitHub PR หรือ commit message มันจะกลายเป็น plain text ธรรมดา ๆ ไม่ได้ link ไปไหน ต้อง copy Jira URL มาแปะเองให้ยาว ๆ ดูไม่ค่อยสะดวก. 

GitHub มี feature ที่ช่วยแก้เรื่องนี้พอดี เรียกว่า [Autolink references](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/configuring-autolinks-to-reference-external-resources)

## Autolinks คืออะไร
Autolink ก็คือการบอก GitHub ว่า "ถ้าเจอ prefix ที่กำหนด ให้แปลงเป็น link ไป external system"
ตัวอย่างเช่น ถ้าเราใช้ Jira แล้วอยากให้ `JIRA-123` กลายเป็น link ไปหา issue บน Jira จริง ๆ ก็ทำได้เลย. 

ตอนแรก GitHub เปิดให้ใช้ได้แต่แบบตัวเลขล้วน เช่น `TICKET-123` แต่ตอนนี้รองรับ **alphanumeric** แล้ว แปลว่า Jira issue key ที่เป็นตัวอักษร+เลข (`JIRA-123a`) ก็ใช้ได้  

การตั้งค่าก็ไม่ยาก แค่กำหนด 2 อย่าง

* **Reference prefix** เช่น `JIRA-`
* **Target URL** เช่น `https://jira.example.com/browse/JIRA-<num>`

จากนั้นเวลาเขียน PR message ว่า `JIRA-123` มันจะ auto กลายเป็น link ไป Jira เลย

## วิธีตั้งค่า Autolink บน GitHub
1. เข้าไปที่หน้า **Settings** ของ repo
2. ในเมนูด้านซ้าย เลือก **Autolink references**
3. กดปุ่ม **Add autolink reference**
4. ใส่ prefix และ URL ตามที่ต้องการ
5. กด Save

![GitHub autolink reference](/assets/2025-09-03-github-autolink-reference.png)

เสร็จแล้วลองพิมพ์ Jira key ใน PR description เช่น `JIRA-123` จะกลายเป็น link ไป Jira โดยอัตโนมัติ

## ข้อจำกัดนิดหน่อย
การตั้งค่า Autolink ทำได้เฉพาะระดับ repository เท่านั้น ยังไม่มีแบบตั้งครั้งเดียวใช้ได้ทั้ง organization หมายความว่าถ้าทีมมี repo เยอะ ต้องไปนั่งตั้งทีละ repo ก็เสียเวลาอยู่  

เราลองลดเวลาลงด้วยการใช้ GitHub CLI script เพื่อยิง API ตั้งค่า Autolink ให้ repo ได้เร็วขึ้น

```sh
repo="<org>/<repo>" \
sh -c '\
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/$repo/autolinks \
  -f key_prefix="JIRA-" \
  -f url_template="https://jira.example.com/browse/JIRA-<num>" \
'
```

จากนั้นก็แค่เปลี่ยนค่า `repo` แล้ว run ซ้ำหรือเขียน for-loop สำหรับแต่ละ repo ก็จบ ไม่ต้องมานั่งกดหน้าเว็บเอง

## สรุป
Autolink reference ของ GitHub ช่วยให้ทีมที่ใช้ Jira ทำงานสะดวกขึ้น แค่เขียน Jira key ใน PR หรือ commit message มันก็ link ไปที่ issue บน Jira อัตโนมัติเลย ไม่ต้องคอย copy วาง URL อีกต่อไป
