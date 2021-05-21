---
layout: post
title:  "มา Secure AWS credentials บน local machine ด้วย aws-vault กัน"
date:   2021-05-07
tags: [aws, credentials]
---

ช่วงนี้มีโอกาสได้มาทำระบบที่ provision อยู่บน **Amazon Web Services (AWS)** แน่นอนว่าเวลาเราได้แตะส่วน Authentication เพื่อเข้าไป operate กับ AWS resource ต่างๆ ผ่าน CLI นั้น เราจะต้องเก็บ access key และ profile configuration ไว้ด้วย มาดูกันว่า [aws-vault](https://github.com/99designs/aws-vault) จะสามารถช่วยให้เราเก็บ AWS credentials อย่างปลอดภัยได้อย่างไร

ผมย้ายบทความนี้ไปไว้ใน [Medium](https://medium.com/nontechcompany/%E0%B8%A1%E0%B8%B2-secure-aws-credentials-%E0%B8%9A%E0%B8%99-local-machine-%E0%B8%94%E0%B9%89%E0%B8%A7%E0%B8%A2-aws-vault-%E0%B8%81%E0%B8%B1%E0%B8%99-75079ca97efd) แล้วนะครับ ไปติดตามกันได้