---
layout: post
title:  "เราควรจะใช้ feature flag-driven-development ตอนไหน"
date:   2022-01-08
tags: [feature-flag, feature-toggle, branching, split.io]
---

ขึ้นปีใหม่นี้ ทีมต้องการที่จะย่นระยะเวลาในการส่งมอบคุณค่าทาง business ให้กับลูกค้าโดยการส่งมอบทีละเล็กทีละน้อย หลีกเลี่ยงไม่ได้เลยที่จะต้องมีการเปลี่ยนแปลง เนื่องจากแนวทางการทำงานจากเดิมที่เป็น mini-waterfall จะต้องเปลี่ยนอะไรบ้างในเมื่อจบทุก sprint จะมีการ release เข้ามา

- เรื่องของความเร็วในการทดสอบ
- เรื่องของ scope of work ใน product backlog
- เรื่องของการทำ analysis เช่น experiment หรือ research
- เรื่องของการทำ Git branching

โดยบทความนี้จะมาเน้นในเรื่องของ branching กัน แล้ว feature flag-driven-development จะมาช่วยแก้ปัญหา (หรือสร้างปัญหาเพิ่ม ฮ่าๆๆ) ได้อย่างไร

## การทำ Git branching ในปัจจุบัน
เป้าหมายของการทำ branching ต้องการที่จะแบ่งส่วนงานให้ developer แยกกันทำไปได้พร้อมๆ กันพร้อมกับให้มาประกอบรวมกันเมื่อต้องการ หลักๆ จะมี 2 แบบคือ 

1. trunk-based development
2. feature branches 

ซึ่งจะแตกต่างจากกันตรงที่

- feature branch จะมี CICD (continuous integration/continuous delivery) แยกกันไปกันตามแต่ละ branch ในขณะที่ trunk based-development จะ merge change ไปที่ trunk (เช่น `master` หรือ `main` branch) บ่อยๆ ที่มี CICD อยู่
- feature branch ช่วยให้ developer ที่ทำในแต่ละ feature ไม่ไป block กันและกันทำให้งานเดินไปได้เร็วขึ้น แต่ข้อเสียคือมีโอกาสสูงที่จะทำให้เกิด branch ที่มีอายุ (log-lived branch) เวลาจะ merge ขึ้นมาจะเกิด conflict มากมาย รวมทั้งจะเกิดปัญหาถ้าเราไม่ได้ระวังว่า feature ของเราจะไปกระทบของคนอื่นหรือไม่

จากข้อดี-ข้อเสียที่ว่ามา ทีมเราเลือกใช้เป็นแบบ trunk-based development เนื่องจากทีมเราเน้นเรื่องของ fast feedback หมายความว่าเราอยากรู้ว่า "เมื่อ code มารวมกัน มันจะมีผลกระทบต่อกันและกันไหม" ได้เร็วที่สุด  

สืบเนื่องจากเวลาเราต้องส่งมอบถี่ขึ้น แน่นอนว่าจะต้องมี code ของ feature ที่ยังไม่เสร็จขึ้นไปกับ trunk ด้วย ปัญหาของ trunk-based development เกิดสิครับ เพราะเรายังไม่อยากส่งมอบงานที่ยังไม่เสร็จ เราจะแก้ปัญหานี้อย่างไร

## ทำความรู้จักกับ feature flag-driven-development
feature flag-driven-development ก็คือแนวทางการทำงานที่เราสามารถจัดการและเลือกที่จะ เปิด หรือ ปิด feature อะไรบ้างจาก component อะไรที่จะให้ลูกค้าใช้งานบ้าง มีขั้นตอนดังนี้

1. เพิ่ม feature flag สำหรับ feature ใหม่ หรือ feature ที่ต้องการเปลี่ยน
2. เขียน code สำหรับพัฒนา feature พร้อมกับ condition ในการ toggle feature

```
if (feature_flag_on = true) {
    [do feature]
} else {
    [do something else]
}
```

3. ทำการ deploy และ release และวัดผล
4. เลือก feature ที่ต้องการจะเปิด-ปิด จากผลข้อ 3
5. วนกลับไปข้อ 1

![Feature flag-driven-development](/assets/2022-01-08-feature-flag-driven-development.png)
<https://www.split.io/guides/feature-flags/>

ประโยชน์ที่ได้คือเราสามารถป้องกันการส่งมอบงานที่ยังไม่เสร็จได้ในระดับหนึ่ง นอกจากนั้นเราสามารถเก็บ feedback จากลูกค้าได้เร็วด้วย มีเครื่องมือให้เลือกต่อยอดได้หลากหลายแบบ เช่น เปิด feature ให้กับผู้ใช้งานบางกลุ่ม (A/B Testing)  

สำหรับทีมของเราเลือกใช้เป็นเครื่องมือชื่อว่า [Split](https://www.split.io/)

## การประยุกต์ใช้กับ trunk-based development
จากประโยชน์ที่ว่าเราสามารถป้องกันการส่งมอบงานที่ยังไม่เสร็จได้ ดังนั้นมันจะมีขั้นตอนคร่าวๆ ดังนี้คือ

1. เพิ่ม feature flag สำหรับ feature ใหม่ หรือลบ feature flag ที่ไม่ต้องการ โดยแต่ละ feature จะต้องมี flag สำหรับ development และ production environment
2. เขียน code สำหรับพัฒนา feature พร้อมกับ condition ในการ toggle feature
3. ทำการ deploy ขึ้น development environment พร้อมกับ toggle feature flag เป็น on ไว้
4. ถ้า feature ยังไม่พร้อมส่งมอบแต่มีการ deploy ขึ้น production environment เราต้อง toggle feature flag เป็น off ไว้ก่อน
5. ถ้า feature พร้อมแล้วเราก็ toggle feature flag เป็น on ไว้
6. วนกลับไปข้อ 1  

![Trunk-based development with feature flags](/assets/2022-01-08-trunk-based-feature-flag.png)
<https://www.split.io/solutions/trunk-based-dev/>

> การทำ feature flag-driven-development ไปคู่กับ trunk-based development มีประโยชน์สูงสุดเมื่อระบบของเรา มีการทดสอบที่ดีและเร็ว รวมถึงการจัดการ scope ของ feature ที่ดี ไม่ใหญ่จนกลายเป็น big bang release

