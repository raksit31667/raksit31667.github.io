---
layout: post
title: "ว่าด้วยเรื่อง versioning ของ GitHub Actions reusable workflow"
date: 2025-05-26
tags: []
---

## GitHub Actions reusable workflow คืออะไร
อธิบาย [GitHub Actions reusable workflow](https://docs.github.com/en/actions/sharing-automations/reusing-workflows) แบบ oversimplified คือ workflow ที่เขียนไว้ใน repo หนึ่ง แล้วสามารถให้ repo อื่นมาเรียกใช้ได้ เหมือนเป็น function หรือ template workflow นั่นแหละ เช่น เราอาจมี reusable workflow ชื่อ `unit-test.yaml` ที่อยู่ใน repo `devops-ci` แล้วให้ service A, B, C ใช้ workflow นี้ร่วมกันผ่าน syntax ประมาณนี้:

```yaml
uses: devops-ci/.github/workflows/unit-test.yaml@v2.6
```

จะเห็นว่ามี `@v2.6` อยู่ตรงท้าย ซึ่งก็คือ version ที่เราอยากใช้นั่นเอง (ใช้เป็น Git tag หรือไม่ก็ SHA ก็ได้)  

## ความซับซ้อนเพิ่มขึ้นเมื่อ workflow ถูก reuse มากขึ้น
พอเวลาผ่านไป มีการแก้ไขบ่อย ๆ workflow ถูกใช้หลายที่ ก็เริ่มมีปัญหา เช่น แก้ workflow แล้วทำให้ pipeline ของบาง service พัง เพราะไม่ได้ใช้ input ตามที่ workflow ใหม่ต้องการ เป็นต้น  

จากปัญหาที่เกิดขึ้น ทีมเลยเริ่มตั้งคำถามว่า

> "ถ้าเราจะทำ versioning สำหรับ reusable workflow จริงๆ แล้วเรามีทางเลือกอะไรบ้าง?"

สุดท้ายเราก็สรุปทางเลือกออกมาได้เป็น 3 แบบหลัก ๆ แต่ละแบบมีข้อดีข้อเสียต่างกัน ขึ้นอยู่กับ nature ของทีมและ service ที่ต้องดูแล

## 1. All in One Versioning
แบบแรกคือการใช้ version เดียวกันทั้ง repo ไม่ว่า workflow ไหนจะถูกแก้ ก็ต้อง bump version ทั้งหมดพร้อมกัน  

สมมุติตอนนี้เราใช้ version `2.6` อยู่ แล้วมีคนไปแก้แค่ `unit-test.yaml` เราจะต้อง bump tag ทั้ง repo เป็น `2.7` ซึ่งจะทำให้ workflow อื่น ๆ เช่น `update-kustomize.yaml` ก็กลายเป็น version `2.7` ทั้งที่จริง ๆ ไม่ได้เปลี่ยนอะไรเลย  

- ข้อดีคือจัดการ version ง่ายเพราะ manage Git tag ที่เดียว
- ข้อเสียคือดูยากว่า workflow ไหนเปลี่ยนอะไรไปเมื่อไร ทุกครั้งที่มีการเปลี่ยน ต้องให้ platform team bump tag จากนั้นก็ต้องไปบอกคนใช้ workflow ไปเปลี่ยน workflow version ที่ใช้ (หรือไม่เปลี่ยนก็ได้ แต่ถ้าไม่เปลี่ยน ก็ต้องหาทาง track ว่าอันไหนไม่ใช่ latest) นอกจากนี้ถ้ามี bug ใน version ก่อนหน้า ต้อง fetch tag เก่า กลับมาแก้แล้ว retag

## 2. Decoupled Versioning
แบบที่สองคือให้แต่ละ workflow มี version ของตัวเอง โดยใช้ prefix เป็นชื่อ workflow เช่น

```yaml
uses: devops-ci/.github/workflows/unit-test.yaml@unit-test-2.8
uses: devops-ci/.github/workflows/update-kustomize.yaml@update-kustomize-1.4
```

จะเห็นว่า workflow แต่ละตัวจัดการ version ของตัวเองของใครของมัน

- ข้อดีคือรู้ว่า version ไหนเปลี่ยน workflow ไหน เราแค่บอกคนใช้ workflow ให้ bump แค่ version ของ workflow ที่ต้องการ update ไม่ต้องไปไล่เปลี่ยนทั้งหมด
- ข้อเสียคือระบบ CI ที่ทำ versioning มีความซับซ้อนมากขึ้น เพราะต้องดูว่า file ไหนเปลี่ยน แล้วค่อย tag เฉพาะอันนั้น

## 3. ไม่ต้อง version เลย
ถ้าเราสามารถทำให้ workflow backward compatible ได้ทุกครั้ง (เช่น มี default value ให้ input ใหม่) แล้วไม่เคย introduce breaking change จริงๆ ก็อาจไม่จำเป็นต้องใช้ versioning ก็ได้

- ข้อดีคือไม่ต้อง manage tag หรือ version อะไรเลย คนใช้ไม่ต้องตาม update version ใหม่
- ข้อเสียคือทุกครั้งที่แก้ workflow ต้องแน่ใจว่าไม่พังของเก่า ถ้ามี breaking change จริงๆ ต้องใช้ feature flag ([boolean input](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/using-conditions-to-control-job-execution)) เพื่อให้ของเก่ายัง run ได้ นอกจากนั้นยังยากในการ debug ถ้าอยากรู้ว่า service ใช้ workflow version ไหน (แต่จริงๆ check ได้จาก `Setup job` step ใน workflow run ที่จะโชว์ commit ของ reusable workflow ที่ใช้ตอนนั้น)

```yaml
if: condition == 'true'
steps:
    - uses: devops-ci/.github/workflows/unit-test.yaml@master
```

## สุดท้าย
ถ้าทีมเราทำแล้ว share reusable workflow ให้ repo อื่นใช้ พอมีคนใช้เยอะขึ้นเรื่อย ๆ อย่าลืมคิดเรื่อง versioning ตั้งแต่เนิ่น ๆ เพราะ migration ทีหลังจะยุ่งมากกว่าหลายเท่า  

และไม่ว่าเราจะเลือกวิธีไหน ขอให้แน่ใจว่า

- มี documentation อธิบายวิธีใช้งานที่ชัดเจน
- มี process สำหรับ update workflow ที่ทุกคนเข้าใจ
- อย่าลืม automate เท่าที่ทำได้ โดยเฉพาะการ tag และการบอกว่ามี change ใหม่
