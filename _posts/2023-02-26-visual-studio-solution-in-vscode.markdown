---
layout: post
title: "แนะนำ extension ในการแก้ไข Solution file ด้วย Visual Studio Code"
date: 2023-02-26
tags: [c-sharp, dotnet, visual-studio, tools]
---

ในการแก้ไข .NET project ที่พัฒนาด้วยภาษา C# ด้วยความที่เป็นมือใหม่จึงเกิดปัญหาที่ไมไ่ด้คาดคิดขึ้นมาคือเรื่องของ Solution file (`.sln` file) และ file system มันไม่สัมพันธ์กัน เช่น เมื่อมีการลบ-ย้าย file ออกจาก directory ใด ๆ ผ่าน file system โดยไม่ได้ผ่านการใช้ integrated development environment (IDE) ใด ๆ ก็จะไม่ส่งผลกับ Solution file ส่งผลให้ file ไม่แสดงใน IDE บางเจ้า เช่น Visual Studio หรือ JetBrains Rider

![File system](/assets/2023-02-26/2023-02-26-file-system.png)

![Solution explorer](/assets/2023-02-26/2023-02-26-solution-explorer.png)

วิธีแก้ก็คือหลังจากเราย้าย file แล้ว เราก็ต้อง update solution file ด้วย ซึ่งถ้าจะมาแก้เองแค่คิดก็เหนื่อยแล้วครับ

![Solution file (before)](/assets/2023-02-26/2023-02-26-solution-file-before.png)

หรือจะเอา IDE อย่างพวก Visual Studio หรือ JetBrains Rider มาใช้ก็หมดเรื่องดีนะแต่ที่ตามมาแน่ ๆ คือ[ค่า license](https://visualstudio.microsoft.com/vs/pricing/?tab=business) เนี่ยแหละ ซึ่งถ้าไม่สามารถเสียเงินได้จริง ๆ เรามี extension ใน editor ในการแก้ไข solution file อย่าง Visual Studio Code (VS Code) มาแนะนำ

## เริ่มจากการติดตั้งก่อน
ใน VS Code ติดตั้ง extension ที่ชื่อว่า [vscode-solution-explorer](https://marketplace.visualstudio.com/items?itemName=fernandoescolar.vscode-solution-explorer) ซึ่งความสามารถก็ตามชื่อเลย ซึ่งถ้าจะใช้ให้ได้อย่างเต็มรูปแบบใน .NET project ก็แนะนำให้ติดตั้งเพิ่มอีก 2 อย่างได้แก่

- [.Net SDK](https://dotnet.microsoft.com/en-us/download) ซึ่งน่าจะมีกันอยู่แล้วสำหรับนักพัฒนาด้วย .NET
- [Microsoft C# extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp) สำหรับแก้ไข C# รวมถึง syntax highlight

จากนั้นกดไปที่ Solution icon ตรง VS Code sidebar เพื่อเปิด Solution ขึ้นมา เราก็จะเห็น structure โดยที่ไม่ต้องใช้เครื่องมือ IDE อันอื่นละ

![Solution file explorer](/assets/2023-02-26/2023-02-26-solution-file-explorer.png)

ต่อไปเราก็ทำการเพิ่ม folder ที่หายไปเมื่อเทียบกับ file system ด้วยการ click ขวาที่ directory ที่เราต้องการแล้วก็ **Create folder** แล้วก็ตั้งชื่อให้ตรงกัน ทีนี้เราก็ click ขวาที่ folder ใหม่นั้นแล้วก็เลือก **Add Solution File** แล้วก็เลือก file จาก file system ที่เราต้องการ

![Update Solution file](/assets/2023-02-26/2023-02-26-update-solution-file.png)

จะสังเกตว่า solution file มีการแก้ไขเกิดขึ้นซึ่งก็เป็นผลมาจาก extension ที่จัดการให้เราเสร็จสรรพนั่นเอง

![Solution file (after)](/assets/2023-02-26/2023-02-26-solution-file-after.png)

> สุดท้ายแล้วนี่ก็เป็นเพียงแค่หนึ่งในวิธีแก้ปัญหาที่อยากจะจดบันทึกไว้สำหรับคนที่ต้องการที่จะใช้ Visual Studio Code อย่างเดียวเท่านั้น สิ่งที่ดีที่สุดคือการที่ทุกคนในทีมของเราใช้เครื่องมือที่คล้ายกันมากที่สุดในการพัฒนาเพื่อลดการปวดหัวอย่างนี้ลง