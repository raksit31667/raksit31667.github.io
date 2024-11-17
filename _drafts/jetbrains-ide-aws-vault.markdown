---
layout: post
title: "วิธีใช้งาน JetBrains IDE กับ aws-vault"
date: 2024-11-17
tags: [ide, aws]
---

ถ้าใครเคยใช้งาน [JetBrains IDE](https://www.jetbrains.com/ides/) (ไม่ว่าจะเป็น IntelliJ, Rider, PyCharm หรืออื่นๆ) เพื่อ debug program ที่จะต้องเชื่อมกับ resource บน AWS ก็อาจจะเจอปัญหาที่ว่าไม่สามารถเรียกใช้ AWS resources หรือ services ได้ เช่น **"Access Denied"** หรือ **"Unable to locate credentials"** ถึงแม้ว่าจะ set environment variable ไว้ใน Shell ผ่านวิธีการต่าง ๆ รวมไปถึงการใช้เครื่องมืออย่าง [aws-vault](https://github.com/99designs/aws-vault) ก็ตาม  

แน่นอนว่าปัญหานี้สร้างความปวดหัวไม่น้อย ในบทความนี้เรามีวิธีแก้แบบง่าย ๆ มาแนะนำ

## aws-vault คืออะไร

[aws-vault](https://github.com/99designs/aws-vault) เป็นเครื่องมือที่ช่วยจัดการ credentials และใช้งาน AWS ผ่าน command-line โดยเก็บข้อมูลในรูปแบบที่ปลอดภัย (เช่น keychain บน macOS หรือ encrypted file บน Linux) แล้วสร้าง environment variables ขึ้นมาเพื่อ authentication ไปยัง AWS โดยที่ไม่ต้อง run หลาย ๆ คำสั่งเพื่อ set environment variables, assume IAM role ผ่าน CLI หรือ dotfiles อื่น ๆ เลย  

สามารถเข้าไปอ่านเนื้อหา *aws-vault* เพิ่มเติมได้ในบทความ [มา Secure AWS credentials บน local machine ด้วย aws-vault กัน](https://medium.com/nontechcompany/%E0%B8%A1%E0%B8%B2-secure-aws-credentials-%E0%B8%9A%E0%B8%99-local-machine-%E0%B8%94%E0%B9%89%E0%B8%A7%E0%B8%A2-aws-vault-%E0%B8%81%E0%B8%B1%E0%B8%99-75079ca97efd) 

```bash
aws-vault exec <PROFILE> -- aws s3 ls
```  

จากตัวอย่างคำสั่งด้านบนนี้ สิ่งที่ *aws-vault* ทำคือจะสร้าง session พร้อม environment variables ที่จำเป็นสำหรับการ authenticate ไปยัง AWS (เช่น `AWS_ACCESS_KEY_ID` หรือ `AWS_SECRET_ACCESS_KEY` หรือ `AWS_SESSION_TOKEN`)

### ปัญหาของ JetBrains IDE กับ Shell environment  

JetBrains IDE (Integrated Development Environment) ถูกออกแบบมาเพื่อช่วยนักพัฒนา software เขียน code ได้สะดวกและมีประสิทธิภาพมากขึ้น ซึ่งมีคุณสมบัติหลากหลายแบบไม่ว่าจะเป็น

- **Auto-completion**: แนะนำคำสั่งหรือโครงสร้าง code
- **Version control**: มี user interface สำหรับใช้งานคำสั่งใน version control เช่น Git
- **Testing**: การ run ชุดการทดสอบเพียงแค่กดปุ่มเพื่อเลือก test case ที่จะ run ได้ตามต้องการ
- **Debugging**: วาง breakpoints เพื่อตรวจสอบค่าตัวแปร หรือจะเป็น step-through execution เพื่อตรวจสอบการทำงานของ program ทีละขั้น

กลับมาที่ว่าเมื่อเรา run debug mode ใน program ที่ต้องทำงานกับ AWS SDK หรือ CLI อาจเจอปัญหาที่กล่าวไปข้างต้น เพราะ**หาก JetBrains IDE ถูกเปิดจาก GUI (graphical user interface) โดยตรง ตัว IDE จะไม่ได้เรียกใช้งาน Shell environment เดียวกันกับ command-line ทำให้ environment variables ซึ่งถูกสร้างไว้ใน Shell ข้างนอกไม่ถูกส่งต่อไปที่ IDE ทำให้ environment ของ IDE ไม่มี environment variables เหล่านั้นนั่นเอง**  

ในทางกลับกันหากเรา run program ขึ้นมาบน Shell environment ที่ได้ตั้งค่า environment variables ไว้แล้วก็จะสามารถ authenticate ไปยัง AWS ได้ เพียงแต่เราจะไม่สามารถใช้ debug mode ของ IDE ได้นั่นเอง ซึ่งไม่ใช่สิ่งที่เราต้องการ  

## แล้วจะแก้ปัญหานี้อย่างไร

แนวคิดในการแก้ปัญหานี้คือเราจะทำอย่างไรให้ environment variables ที่ *aws-vault* (หรือจาก CLI อื่น ๆ) สร้างไว้ใน shell ถูกส่งต่อไปที่ IDE  

### วิธีที่ 1: ตั้งค่า environment variables ใน JetBrains IDE โดยตรง

วิธีหนึ่งในการแก้ปัญหานี้คือการ **ตั้งค่า environment variables ด้วยตัวเองผ่านเมนู "Edit Configuration"** ใน IDE โดยตรง สามารถดูขั้นตอนเต็มได้ใน [Run/debug configuration: Application](https://www.jetbrains.com/help/idea/run-debug-configuration-java-application.html)

1. คัดลอก environment variable จาก CLI หรือถ้าใช้ *aws-vault* ก็ใช้คำสั่ง

    ```bash
    aws-vault exec <PROFILE> -- env | grep AWS_
    ```

2. เปิด menu **"Run/Debug Configurations" > "Edit Configurations"** 
3. เลือก project ที่ต้องการแก้ไข
4. ตั้งค่า environment variables ได้แก่ `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`
5. Save และทดสอบ run หรือ debug project เพื่อตรวจสอบว่า environment variables ถูกตั้งค่าเรียบร้อย  

#### ข้อควรระวังของวิธีนี้  
- หากตั้ง AWS credentials แบบ plain-text ใน IDE อาจมีความเสี่ยงด้าน security โดยเฉพาะถ้า IDE ถูก share กับคนอื่น
- ถ้าเราใช้หลาย AWS profile (เช่น dev, staging, production) เราต้องเข้ามาเปลี่ยน environment variables ทุกครั้งที่สลับ profile   

### วิธีที่ 2: เปิด JetBrains IDE ผ่าน aws-vault

อีกหนึ่งวิธีง่าย ๆ ที่ช่วยแก้ปัญหานี้คือการเปิด JetBrains IDE ผ่าน command-line โดยใช้ `aws-vault exec` เช่น  

```bash
aws-vault exec -n <PROFILE> -- /path/to/jetbrains-ide
```  

- `<PROFILE>` คือชื่อโปรไฟล์ AWS ใน *aws-vault*  
- `/path/to/jetbrains-ide` คือ path ของ file ที่ run IDE เช่น `intellij-idea` หรือ `pycharm` ซึ่งสามารถหาได้ตาม [documentation ของ JetBrains ได้เลย](https://www.jetbrains.com/help/idea/working-with-the-ide-features-from-command-line.html#macos)  

เมื่อเปิด IDE จากคำสั่งนี้ JetBrains IDE จะรับ environment variables จาก *aws-vault* โดยตรง ทำให้ใช้งาน AWS SDK, CLI หรือ services ต่างๆ ใน project ได้ตามปกติ

## สรุป  

ถ้าเจอปัญหา application ที่ run/debug ผ่าน JetBrains IDE ไม่สามารถเชื่อมต่อกับ AWS ผ่าน SDK หรือ CLI เพราะไม่มี environment variables วิธีแก้ง่าย ๆ คือ  
1. ใช้ aws-vault เพื่อสร้าง environment variables  
2. เปิด IDE ผ่าน command-line
