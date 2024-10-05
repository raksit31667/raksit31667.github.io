---
layout: post
title: "บันทึกการจัดระเบียบ AWS IAM permission ภายในองค์กร"
date: 2024-09-25
tags: [aws, cloud-computing]
---

ช่วงที่ผ่านมาได้มีโอกาสไปทำชิ้นงานในการสังขยนาการใช้งาน [AWS Identity and Access Management (IAM)](https://aws.amazon.com/th/iam/) ขึ้นมาใหม่ เพื่อช่วยเสริม requirement ด้าน security ของ product ให้ดีขึ้น  

## ว่าด้วยเรื่องของปัญหาที่อยากจะต้องแก้
เริ่มจากว่า developer ใช้ IAM ในการกำหนด permission ในการเข้าถึง AWS resource ต่าง ๆ เพื่อดูแล infrastructure ของระบบงาน ซึ่งท่าในการเพิ่ม permission เข้าไปในแต่ละ IAM user มันไม่ได้เป็นระเบียบสักเท่าไรเลย ยกตัวอย่างเช่น

- IAM user ของแต่ละคนที่ควรจะมีสิทธิ์เท่ากันดันมี IAM permission ไม่เหมือนกัน
- IAM user ของแต่ละคนต้องใช้ IAM role/policy หลาย ๆ ตัวในการเข้าถึง AWS resource
- IAM user บางคนมี admin policy ที่สามารถเข้าถึงได้ทุก resource ใน account

ผลจากการที่การจัดการ IAM ไม่เป็นระเบียบคือ

1. มีความเสี่ยงด้าน security เพราะหาก IAM user credentials หลุดรั่วออกไป คนไม่หวังดีสามารถสร้างความเสียหายกับ AWS account ได้ ตั้งแต่ลบ resource ทิ้งไปจนถึงดูดข้อมูลที่เป็นความลับของบริษัท
2. Developer experience ของทีมไม่ดีเนื่องจากจะ manage AWS resource หลาย ๆ ตัวก็ต้องสลับ role ไป ๆ มา ๆ
3. การ onboarding-offboarding คนเข้าในทีมลำบาก เพราะไม่แน่ใจว่าคน ๆ นึงจะต้องมี IAM permission อะไรบ้าง

จากปัญหาที่เกิดขึ้น โจทย์ที่ทีมต้องแก้คือ

1. ทำยังไงให้ IAM user มี IAM permission เท่าที่จำเป็นจะต้องมีเท่านั้น
2. ทำยังไงให้ IAM user ทุกคนที่ควรจะมีสิทธิ์เท่ากันมี IAM permission เท่ากัน
3. ทำยังไงให้ developer สามารถ manage AWS resource หลาย ๆ ตัวโดยใช้แค่ไม่กี่ role

## ขั้นตอนการแก้ปัญหา
จากปัญหาที่เกิดขึ้น ทีมได้วางแผนและลงมือแก้ปัญหาดังนี้

1. รวบรวม IAM permission ของ developer แต่ละคน เอาหมดทั้ง AWS-managed และ inline (JSON) และที่ได้มาจาก IAM group (อย่างหลังสุดก็คือต้องรู้ว่า developer แต่ละคนอยู่ในกลุ่มไหนบ้าง)
2. ระบุ use case ต่าง ๆ ของทีมในการเข้าถึง AWS resource เช่น การ manage ส่วน application ส่วน storage หรือจะแบ่งเป็น service A, B, C ก็ได้ แล้วเจาะจงลงไปว่าแต่ละ use case ใช้ AWS resource อะไรบ้าง ตรงนี้จะสำคัญมากเพราะในอนาคตเราสามารถ assign IAM permission ให้ developer แต่ละคนที่ใช้งานกันคนละ use case ได้
3. จัดกลุ่ม IAM permission ที่ได้รวบรวมมาตาม use case โดยตัดอันที่ซ้ำกันออกไป ยิ่งเป็นอันที่เจาะจงไปที่ resource ที่จะใช้จริง ๆ ยิ่งดี
4. สร้าง IAM role สำหรับแต่ละ use case และ assign IAM policy ที่มี permission เท่าที่จำเป็น
5. สร้าง IAM user group ของทีมขึ้นมาแล้วเพิ่ม IAM user เข้าไป จากนั้นเพิ่ม IAM policy ให้ทุกคนในกลุ่มสามารถ assume IAM role ที่สร้างขึ้นมาใหม่ได้
6. สำหรับ IAM role ที่มี permission สูง ๆ อย่าง admin ถ้าจะให้ดีควรจะเพิ่ม [trust relationship](https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/) ให้ใช้ Multi-Factor Authentication (MFA) ในการ assume ตัว role นั้น ๆ เองด้วย

หลังจากที่ได้ลองทำแล้วก็พบว่าเราสามารถแก้ปัญหาได้ทั้ง 3 ข้อ

1. ทุกคนที่ควรจะมีสิทธิ์เท่ากันก็จะอยู่ใน IAM user group เดียวกัน
2. ตอน onboarding-offboarding คนเข้าในทีมก็แค่เอา IAM user เข้า-ออกทีม
3. Developer experience ดีขึ้นเพราะ assume แต่ role เดียวสามารถทำทุกอย่างตาม use case ได้หมด

## เกิดปัญหาใหม่ขึ้นมา

ทุกอย่างเหมือนจะดี แต่เรากลับสร้างปัญหาใหม่ขึ้นมาคือ

> IAM user นอกกลุ่มยังสามารถ assume IAM role ใหม่ของเราได้

นั่นหมายความว่าเรายังไม่สามารถควบคุมให้ IAM user เฉพาะกลุ่มของเราเท่านั้นที่สามารถ assume IAM role เหล่านั้นได้  

วิธีแก้ง่าย ๆ ที่เราคิดคือไป set trust relationship ใน IAM role ให้อนุญาตแค่ IAM user group นั้น assume role ได้

<script src="https://gist.github.com/raksit31667/7fff02e570f202965be2455b2e1ba4c1.js"></script>

ปรากฏว่า run แล้วดัน error! สืบไปสืบมาคือพบว่าเราไม่สามารถใช้ IAM group ใน trust relationship ได้เพราะ AWS IAM ไม่รองรับ group เป็น principal ใน trust relationship/policy ไม่เหมือนกับ IAM user, role หรือ service

- IAM group มันถูกสร้างมาแค่เป็น abstraction เพื่อให้จัดการ IAM user หลาย ๆ ตัวได้ง่ายขึ้นเท่านั้น ตัวมันเองไม่ได้มี identity หรือ credentials (access key) ใด ๆ ดังนั้นตัว group จึงไม่สามารถ authenticate เข้าไปใน AWS services ได้ นั่นก็รวมถึงการ assume role เพื่อให้ได้ [AWS Security Token Service (STS)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html) ตามแบบที่เรา design ไว้ด้วย
- หาก AWS IAM อนุญาตให้ group assume role ได้ AWS จะไม่สามารถ track ได้เลยว่า user คนไหนในกลุ่มที่ทำ action อะไรไปบ้าง หากเกิดปัญหาอะไรขึ้นมาจะไม่สามารถตามรอยอะไรได้เลย

## แก้ปัญหาใหม่อีกที
ถึงแม้ว่า group จะไม่สามารถ assume role ได้ตามที่กล่าวมา แต่เรายังสามารถกำหนดได้ว่า IAM user ไหนที่สามารถ assume IAM role นั้น ๆ ได้ผ่านการ set trust relationship ประมาณนี้

<script src="https://gist.github.com/raksit31667/58f2d5121b5de2708a64042750ec73ba.js"></script>

ดังนั้นตอน onboarding-offboarding เราก็ต้องมาแก้ trust relationship เพื่อเอา IAM user เข้า-ออก ออกแรงเพิ่มนิดหน่อยแต่ก็ปลอดภัยมากขึ้นด้วย
