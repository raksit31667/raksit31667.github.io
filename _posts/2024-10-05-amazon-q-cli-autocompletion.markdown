---
layout: post
title: "แนะนำ Amazon Q สำหรับการทำ AWS CLI autocompletion"
date: 2024-10-05
tags: [aws, amazon-q, ai, productivity, tools]
---

ทุกวันนี้ ใครที่ใช้ AWS CLI เป็นประจำ อาจจะมีบ้างที่ต้องพิมพ์คำสั่งยาว ๆ หรือจำ parameter ไม่ได้ทั้งหมด จึงต้องเข้า internet ไปเปิด CLI documentation ของ AWS ซึ่งก็เข้าใจไม่ได้ง่ายเลย

![AWS CLI documentation](/assets/2024-10-05-aws-cli-documentation.webp)

เผอิญเพื่อนร่วมงานแนะนำให้ลองใช้ [Amazon Q](https://aws.amazon.com/q/) ที่เป็นเครื่องมือจาก AWS ที่จะช่วยให้การทำงานของเราง่ายขึ้นมาก ด้วยความสามารถของ Autocompletion

## Amazon Q คืออะไร

Amazon Q เป็น Generative AI ที่พัฒนาโดย AWS เพื่อตอบโจทย์กลุ่มเป้าหมาย 2 กลุ่มใหญ่ ๆ

- **Amazon Q Business**: ช่วยบริษัทในการจัดการคลังความรู้ (knowledge repository) ภายในองค์กร user สามารถถามคำถามผ่าน web interface หรือใช้งานร่วมกับเครื่องมืออย่าง Slack ได้เลย ซึ่งช่วยเพิ่มประสิทธิภาพในการทำงานเพราะสามารถให้คำตอบได้ รวมทั้งเชื่อมต่อกับแหล่งข้อมูลต่าง ๆ เพื่อสร้างคำตอบที่แม่นยำมากขึ้น

- **Amazon Q Developer**: ช่วย developer ด้วยการแนะนำ code snippet สนับสนุน programming language และเชื่อมกับเครื่องมือต่าง ๆ เช่น IDEs และ CLI ทำให้การพัฒนางานมีประสิทธิภาพมากขึ้น สำหรับ AWS CLI คิดง่ายๆ ก็คือมันช่วยเดาคำสั่งที่เรากำลังจะพิมพ์ใน CLI และแนะนำคำสั่งหรือ parameter ให้เราไม่ต้องพิมพ์เองทั้งหมด เหมาะสำหรับคนที่ใช้งาน AWS CLI บ่อยๆ แต่ยังไม่เชี่ยวชาญทุกคำสั่ง หรือมีคำสั่งที่ยาวจนจำไม่หมด

## ตัวอย่างการใช้งาน

สมมติว่าเรากำลังจะรันคำสั่งเพื่อเช็ค instance บน EC2

```
aws ec2 describe-instances --filters
```

ถ้าใช้ Amazon Q เวลาเราพิมพ์ `aws ec2` ระบบจะเสนอคำสั่งถัดไปอย่าง `describe-instances` ทันที ไม่ต้องพิมพ์เองทั้งหมด และเมื่อเราพิมพ์ `--filters` ระบบจะช่วยแนะนำ filter ที่สามารถใช้ได้  

นอกจาก AWS CLI แล้ว ยังรองรับ CLI อื่น ๆ อีกมากกว่า 500 อัน เช่น `git`, `npm`, `docker` และสามารถทำงานร่วมกับ Shell, Terminal ได้อีกหลายตัวเลย

![Amazon Q CLI completions](/assets/2024-10-05-amazon-q-command-line-completions.gif)

## สรุป
Amazon Q เป็นอีกหนึ่งเครื่องมือที่ช่วยให้การใช้ AWS CLI ง่ายขึ้นมาก โดยการแนะนำคำสั่งและ parameter ที่เหมาะสมกับสิ่งที่เรากำลังจะพิมพ์ ลดการพิมพ์ผิดและเพิ่มความเร็วในการทำงาน ใครที่ใช้งาน AWS CLI บ่อย ๆ น่าจะได้ประโยชน์จากเครื่องมือนี้อย่างแน่นอน ลองไปติดตั้งตาม [documentation นี้](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-getting-started-installing.html) ได้เลย

> ข้อจำกัด ณ ตอนที่เขียน blog นี้คือมันใช้ได้กับแค่ระบบ macOS เท่านั้นนะ
