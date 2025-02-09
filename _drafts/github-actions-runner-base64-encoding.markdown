---
layout: post
title: "บันทึกแก้ปัญหา GitHub Actions Runner ไม่รับงานบน EKS"
date: 2025-02-09
tags: [github-actions, kubernetes]
---

ช่วงที่ผ่านมามีเหตุการณ์ที่ผู้ใช้ platform พยายาม run workflow บน [GitHub Actions](https://github.com/features/actions) แต่ดูเหมือนว่า **runner ไม่รับงานมาทำ** ทำให้ต้องสืบหาต้นตอของปัญหากัน  

## ปัญหาคืออะไร
Platform ของเราดูแล [self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) ของ GitHub Actions ที่ run อยู่บน [Amazon EKS](https://aws.amazon.com/eks/) ซึ่งเป็นจุดแรกที่เราต้องตรวจสอบเมื่อเกิดปัญหา พบว่า runner ที่ถูกจัดการโดย `actions-runner-controller` ไม่สามารถอัปเดต registration token ได้ ทำให้มันไม่สามารถรับงานจาก GitHub Actions ได้  

```
Updating registration token failed    {"type": "Warning", "object": {"kind":"Runner","namespace":"actions-runner","name":"runner-abcd-1234","uid":"..."}, "reason": "FailedUpdateRegistrationToken"}
Failed to get new registration token    {"runner": "runner-abcd-1234", "error": "failed to create registration token: Post \"https://api.github.com/orgs/$YOUR_ORG_HERE/actions/runners/registration-token\": net/http: invalid header field value for \"Authorization\""}
```

จาก error message เห็นได้ชัดว่ามีปัญหาเกี่ยวกับ **authentication token** ที่ใช้ในการเชื่อมต่อกับ GitHub  

## ต้นเหตุของปัญหาคืออะไร
GitHub Actions Runner ที่รันแบบ self-hosted ต้องใช้ [Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) เพื่อให้ GitHub ส่ง workflow jobs มาที่ runner ผ่าน API และ authentication token ทีนี้เมื่อ runner เริ่มทำงาน มันจะต้อง

1. Register ตัวเองกับ GitHub
2. รับงานมา run workflow
3. ส่งผลลัพธ์กลับไปที่ GitHub

โดยในกรณีของ Kubernetes มันก็จะมีตัว `actions-runner-controller` ซึ่งเป็น Kubernetes controller ที่ช่วยจัดการ runner จะอ่านค่าจาก Secret นี้ทุกครั้งที่ต้องการจัดการ container ของ runner นั่นเอง โดยเราจะเก็บ PAT ไว้ใน Kubernetes Secret เพื่อให้ controller ดึงไปใช้งานได้อย่างปลอดภัย  

กลับมาที่สถานการณ์ปัจจุบัน เมื่อวันก่อนเราเพิ่ง update GitHub PAT ใหม่ลงไปใน Kubernetes Secret ด้วย ทำให้เราสามารถ scope ต้นเหตุของปัญหาได้ประมาณนี้

### 1. GitHub PAT หมดอายุ และหรือมี scope ไม่ครบ
GitHub PAT ที่ใช้กับ GitHub Actions self-hosted runner ต้องมี scope ที่ถูกต้อง เพื่อให้ runner สามารถ register และรับงานได้สำเร็จ ถ้า PAT ไม่มี scope ที่เพียงพอ runner จะไม่สามารถเชื่อมต่อกับ GitHub API ได้ และ workflow jobs จะไม่สามารถทำงานได้ โดย scope คร่าว ๆ ที่ควรจะมีได้แก่

| **Permission** | **เหตุผลที่ต้องใช้** |
|--------------|----------------------|
| `repo` | ให้สิทธิ์ runner ในการเข้าถึง repository เพื่อดึง code และ push กลับ (ถ้ามี) และ register และจัดการ runner ในระดับ repository |
| `admin:org` | จำเป็นสำหรับการ register และจัดการ runner ในระดับ organization |
| `actions` | ให้สิทธิ์ในการรับ workflow jobs และสื่อสารกับ GitHub Actions API |

หลังจากตรวจสอบแล้วก็พบว่า scope ที่มีก็ครบถ้วนสมบูรณ์ดี **ก็ยังไม่สามารถแก้ปัญหาได้** 🤔

### 2. Secrets ไม่ sync เข้า actions-runner-controller  
โดยปกติ เมื่อเรา update Kubernetes Secret ที่เก็บ GitHub PAT ใหม่ เราคาดหวังว่า `actions-runner-controller` จะดึงค่าล่าสุดมาใช้ทันที แต่ในความเป็นจริง มันไม่ auto-reload ซึ่งอาจจะเป็นสาเหตุที่ทำให้ runner ยังคงใช้ค่าเก่าที่ผิดพลาดอยู่  

วิธีแก้ก็คือลอง restart `actions-runner-controller` เพื่อให้มัน reload ค่า Kubernetes Secret ใหม่และสร้าง runner ใหม่ที่ใช้ค่า PAT ล่าสุด
 **แต่ก็ยังไม่สามารถแก้ปัญหาได้** 🤔

### 3. ค่า PAT token ใน Secrets ไม่ถูกต้อง 
จากการตรวจสอบ GitHub PAT ที่ใช้ update ใน Kubernetes Secret (ซึ่งจะต้องถูก base64 encode ก่อน) พบว่ามี 41 bytes แทนที่จะเป็น 40 bytes (เพราะ PAT มีความยาว 40 ตัวอักษร) จากการนำไป decode และอ่านเอกสาร [GitHub Actions Runner Troubleshooting](https://github.com/actions/actions-runner-controller/blob/master/TROUBLESHOOTING.md#invalid-header-field-value) ก็พบว่ามันมี newline character (`\n`) ติดมาด้วย ทำให้ค่า Authorization header ที่ส่งไปยัง GitHub ไม่ถูกต้องตาม error message ในหัวข้อก่อนหน้า 💡

![Kubernetes Secret GitHub PAT](/assets/2025-02-09-kubernetes-secret-github-pat.png)

## วิธีแก้ไขที่ถูกต้อง  
ตอนที่ encode GitHub PAT จะต้องมั่นใจว่าไม่มี newline (`\n`) โดยใช้คำสั่งนี้  

```sh
echo -n $GITHB_PAT | base64
```

เมื่อ update secret และ restart `actions-runner-controller` **งานก็เริ่มถูกรับโดย GitHub Actions self-hosted runner ตามปกติ** 🎉  

## สรุป
✅ หาก GitHub Actions runner ไม่รับงาน ให้ check log ดูว่าเกิดปัญหากับ GitHub PAT หรือไม่  
✅ ตรวจสอบ GitHub PAT ที่ถูก base64 encode ว่ามี newline (`\n`) หรือไม่  
✅ ใช้ `echo -n $GITHUB_PAT | base64` เพื่อสร้างค่า secret ที่ถูกต้อง  
✅ Update secret และ restart `actions-runner-controller`  
