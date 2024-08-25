---
layout: post
title: "การ sync AWS CloudFormation กับ Git โดยใช้ Git Sync"
date: 2024-08-25
tags: [aws]
---

หลายคนที่ใช้ [AWS CloudFormation](https://aws.amazon.com/cloudformation/) เพื่อบริหารจัดการ infrastructure บน AWS อาจเคยเจอปัญหาว่าการ sync ระหว่าง code ที่อยู่ใน Git repository กับ CloudFormation stacks นั้นอาจจะไม่สะดวกหรือไม่ต่อเนื่องเมื่อต้องทำงานกับทีม จึงต้องออกแรงในการ setup process หรือเครื่องมือขึ้นมา เช่น CI/CD pipeline เพื่อลดโอกาสที่จะเกิดความไม่สอดคล้องกันระหว่าง code และ infrastructure ที่เรา deploy ขึ้นไปบน AWS  

หนึ่งใน solution การแก้ปัญหานี้แบบชิล ๆ คือ AWS CloudFormation เขามี feature ที่เรียกว่า "[AWS CloudFormation Git Sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-concepts-terms.html)" ซึ่งช่วยให้เราสามารถ sync การเปลี่ยนแปลงจาก Git repository ไปยัง CloudFormation stacks ได้แบบอัตโนมัติ โดยไม่ต้อง setup process หรือเครื่องมือนอก AWS เลย

## AWS CloudFormation Git Sync ทำงานอย่างไร?
การทำงานของ AWS CloudFormation Git Sync ประกอบด้วย:
- **Repostory:** ที่เราจะเก็บ Template ไว้ เช่น GitHub, BitBucket, AWS CodeCommit เป็นต้น (ตอนที่เขียนบทความนี้ AWS จะ[ไม่ support CodeCommit](https://news.ycombinator.com/item?id=41104997) แล้วนะ)
- **[AWS Connections](https://docs.aws.amazon.com/codeconnections/latest/APIReference/Welcome.html):** ใช้สำหรับเชื่อมต่อ AWS กับ GitHub อย่างปลอดภัย
- **AWS CloudFormation:** ที่เราจะใช้ในการสร้างหรือ update stack โดยการดึง template จาก Repository

## วิธีการตั้งค่า AWS CloudFormation Git Sync (Step-by-Step)

1. สร้าง IAM Role ที่จะให้สิทธิ์ในการจัดการ CloudFormation และ resource ใน stack รวมถึง CodeConnections

    <script src="https://gist.github.com/raksit31667/7abb90dd8da745f3bf7a9bdfcbdbae47.js"></script>

2. สร้าง AWS CodeConnections ในตัวอย่างนี้จะเชื่อมต่อกับ GitHub ของเราเอง

    <script src="https://gist.github.com/raksit31667/f85677b13bd9c521b6ecec6e325919b9.js"></script>

    หลังจากที่ Deploy CloudFormation stack นี้เข้าไปแล้ว เราจะต้องเขาไป activate connection ด้วย เช่น grant permission และเลือก repository ใน GitHub สำหรับการเชื่อมกับ AWS GitHub Apps ดูเพิ่มเติมได้ที่ [Guide to Connecting AWS with GitHub for Automated Workflow](https://community.aws/content/2dGy2OO7M5GOMc0gksNz46GdmLK/step-by-step-guide-to-connecting-aws-with-github-for-automated-workflow)

    ![AWS CodeConnections](/assets/2024-08-25-aws-codeconnections.png)

3. สร้าง CloudFormation template สำหรับ resource ที่เราต้องการจะใช้ Git Sync โดยนอกจาก template file แล้ว จะต้องมี **stack deployment file** เพื่อที่จะให้ AWS ทำการ monitor status เมื่อมีการ commit และ push ขึ้น repository ซึ่งจะประกอบไปด้วย

   - **template-file-path:** ระบุ path เต็มของไฟล์ CloudFormation Template ที่อยู่ใน repository ซึ่งไฟล์นี้เป็นตัวกำหนด resource ที่จะถูกสร้างใน Stack

   - **parameters:** เป็น key-value pairs สำหรับการตั้งค่า resource ใน Stack เพื่อใช้ในการควบคุม resource ต่าง ๆ เช่น ขนาดของ instance หรือ ชื่อของ S3 bucket เป็นต้น

   - **tags:** เป็น key-value pairs สำหรับระบุและจัดหมวดหมู่ resource ใน Stack เช่น ระบุทีมที่รับผิดชอบ environment (production, development) เป็นต้น

   **ตัวอย่าง Stack Deployment File:**

    <script src="https://gist.github.com/raksit31667/12dfee7d328b38d9009b818b37c5124a.js"></script>

4. สร้าง CloudFormation stack ที่ดึง Template จาก GitHub อัตโนมัติเมื่อมีการ update ใน branch ที่กำหนดโดยใช้ AWS CloudFormation ร่วมกับ AWS Connections โดยวิธีการก็ให้ทำตาม guideline [Create a stack from repository source code with Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-walkthrough.html) ได้เลย
5. ทำการทดสอบ Git Sync ของเราโดยการตรวจสอบว่า resource ใน CloudFormation stack ถูกสร้างอย่างถูกต้องใช่หรือไม่ จากนั้นก็ลอง push update ขึ้นไปบน repository เช่น ลองเปลี่ยน parameter stack deployment file ถ้าทำถูกต้องก็จะสามารถเห็น CloudFormation update บน AWS หลังจาก push ไป

    ![AWS CloudFormation Git Sync](/assets/2024-08-25-aws-cloudformation-git-sync.png)

## ทางเลือก: ใช้ GitHub OIDC Provider และ GitHub Actions
ถ้าไม่อยากใช้ AWS Git Sync เราสามารถใช้ GitHub OIDC Provider ร่วมกับ GitHub Actions เพื่อ run CloudFormation ได้เช่นกัน วิธีนี้เราจะใช้ GitHub Actions เพื่อดึง Template จาก repository และ deploy ไปยัง AWS CloudFormation โดยไม่ต้องใช้ key หรือ static credentials แต่จะใช้ 
[OIDC (OpenID Connect)](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) เป็น authentication method ที่ช่วยให้สามารถเชื่อมต่อ application กับ Identity Provider ได้อย่างปลอดภัย ซึ่ง GitHub จัดเตรียมไว้ให้ เพื่อให้เราสามารถออก token ที่ใช้พิสูจน์ Identity กับ AWS

### การทำงานของ GitHub OIDC Provider ร่วมกับ GitHub Actions

![GitHub OIDC](/assets/2024-08-25-github-oidc.webp)

1. **GitHub Actions Workflow:**
   - กำหนด Workflow ใน GitHub Actions ซึ่งระบุว่าจะมีการ Deploy CloudFormation Stack บน AWS โดยใช้ Template ที่อยู่ใน GitHub Repository
   - ภายใน Workflow นี้ เราจะตั้งค่าเพื่อรับ OIDC token จาก GitHub OIDC Provider และใช้ token นั้นในการ assume IAM Role ที่มีสิทธิ์ในการ Deploy Stack บน AWS

   <script src="https://gist.github.com/raksit31667/94dfdc536b89c71fa3a3d705c09d05e3.js"></script>

2. **IAM Role บน AWS:**
   - สร้าง IAM Role ใน AWS ที่อนุญาตให้ GitHub Actions สามารถ assume IAM Role เพื่อทำการ Deploy Stack ได้
   - IAM Role นี้จะต้องกำหนด IAM Policy ที่อนุญาตให้ทำงานต่าง ๆ เช่น การสร้างหรือ update Stack ผ่าน CloudFormation

   <script src="https://gist.github.com/raksit31667/0a894628f5ed693cc2540685f2177dca.js"></script>

3. **GitHub Actions เรียกใช้ AWS API:**
   - เมื่อ GitHub Actions เรียกใช้ Workflow ที่กำหนดไว้ มันจะรับ OIDC token จาก GitHub OIDC Provider และใช้ token นั้นในการ assume IAM Role ที่สร้างไว้ใน AWS
   - จากนั้น Workflow จะใช้ AWS CLI หรือ SDK ในการ Deploy CloudFormation Stack โดยใช้ Template และ Parameters ที่กำหนดไว้ใน repository

การเลือกใช้วิธีใดขึ้นอยู่กับความต้องการของเรา ถ้าเราต้องการ run คำสั่งอื่น ๆ หลังจากการ deploy CloudFormation stack ทางเลือก GitHub OIDC Provider และ GitHub Actions น่าจะดีกว่า ไม่งั้นก็ใช้ AWS Git Sync ก็พอ
