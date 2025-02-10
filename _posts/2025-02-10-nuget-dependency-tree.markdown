---
layout: post
title: "ใช้ .NET, ChatGPT, Mermaid และ Excalidraw วิเคราะห์ NuGet dependency"
date: 2025-02-10
tags: []
---

ช่วงนี้มีงานที่ต้องทำการ upgrade .NET version ใน NuGet shared library ที่มันเป็น legacy ซึ่งเป็นเรื่องซับซ้อนเพราะ dependency มันเชื่อมโยงกันหลายชั้น สิ่งที่ต้องคำนึงถึงในการทำการ upgrade คือ

> "จะ upgrade ตัวไหนก่อน?"
> "Upgrade แล้วจะกระทบอะไร?"

หาก upgrade ผิดลำดับ อาจทำให้ project พังหรือเกิด breaking changes ได้ ซึ่งนี่ก็เป็นปัญหาที่ตามมาของการใช้ shared component ไม่ว่าจะเป็น **การทำ versioning** และ **ความซับซ้อนในการปรับแก้สูงขึ้นในระยะยาว** (อ่านเพิ่มเติมในบทความ [คิดให้ดีก่อนลงทุนกับ shared component ใน microservices]({% post_url 2024-12-22-shared-component-in-microservices %})) 

เพื่อให้ชีวิตเราง่ายขึ้น เราจะใช้เครื่องมือต่าง ๆ เข้ามาช่วยวิเคราะห์งานเพื่อ 

1. แสดงโครงสร้าง dependency ของ shared library  
2. วิเคราะห์ลำดับการ upgrade แบบ Bottom-Up  
3. แปลงโครงสร้าง Mermaid เป็น diagram ใน Excalidraw  

มาเริ่มกันเลย!

## 1. ใช้ dotnet-nuget-tree สร้าง dependency tree

เราจะใช้ [dotnet-nuget-tree](https://github.com/ramosisw/dotnet-nuget-tree) ในการสร้าง dependency tree ออกมา ข้อจำกัดของตัวนี้คือมันไม่สามารถสร้าง tree แบบ recursive ได้ ต้องกำหนดว่าจะให้ tree มันลึกลงไปกี่ชั้นเอา แล้วก็ไม่ได้ generate transitive dependencies ด้วย แต่ก็เพียงพอที่จะทำการวิเคราะห์ในกรณีนี้ได้แล้วอ่ะนะ  

หน้าตา project structure ของ shared library ก็มาประมาณนี้

```
shared-libs/
│── src/                      
│   ├── A.CoreLib/            
│   │   ├── A.CoreLib.sln
│   │   ├── A.CoreLib/
│   │   │   ├── A.CoreLib.csproj
│   │   │   ├── CoreClass1.cs
│   │   │   ├── CoreClass2.cs
│   │   │   └── ...
│   │   ├── tests/
│   │   │   ├── A.CoreLib.Tests/
│   │   │   │   ├── A.CoreLib.Tests.csproj
│   │   │   │   ├── CoreClass1Tests.cs
│   │   │   │   └── ...
│   │   ├── README.md
│   │   ├── CHANGELOG.md
│   ├── B.Logging/
│   ├── C.Validation/
│   ├── D.Utilities/
└── shared-libs.sln
```


เริ่มทำการติดตั้ง
```bash
dotnet tool install --global dotnet-nuget-tree
```

จากนั้น run คำสั่งเพื่อดูโครงสร้าง dependency

```bash
dotnet-nuget-tree
```
ตัวอย่าง output:
```
├── A.CoreLib/ 5 packages
│   ├── B.Logging [1.2.3]
│   ├── C.Validation [2.3.4]
│   ├── D.Utilities [3.4.5]
│   ├── Microsoft.Extensions.Logging [5.0.0]
│   └── Newtonsoft.Json [13.0.1]
├── B.Logging/ 3 packages
│   ├── D.Utilities [3.4.5]
│   ├── Microsoft.Extensions.Logging [5.0.0]
│   └── Serilog [2.10.0]
├── C.Validation/ 2 packages
│   ├── Newtonsoft.Json [13.0.1]
│   └── FluentValidation [10.3.4]
├── D.Utilities/ 1 package
│   └── Microsoft.Extensions.Configuration [5.0.0]
```

## 2. ใช้ ChatGPT วิเคราะห์ bottom-up package
แนวคิดสำคัญในการ upgrade dependency คือ เริ่ม **upgrade จาก package ที่ไม่มี dependency ก่อน (bottom-up มองว่าข้างล่างสุดของ tree)** แล้วค่อยไล่ขึ้นไป  

ซึ่งเราสามารถใช้ Generative AI อย่าง [ChatGPT](https://chatgpt.com/) มารับ prompt เพื่อวาด dependency tree ออกมาก่อน

> Draw the Mermaid dependency graph for only packages starting with A, B, C, D based on:
> <Output จาก dependency tree>

ผลลัพธ์ก็จะออกมาประมาณนี้

```mermaid
flowchart TD
    D.Utilities --> B.Logging
    D.Utilities --> C.Validation
    B.Logging --> A.CoreLib
    C.Validation --> A.CoreLib
```

ต่อมาเราก็นำ Mermaid ไป prompt ต่อเพื่อหาว่า**ลำดับก่อนหลังในการ upgrade** มันควรจะเป็นอย่างไร

> If I have to upgrade these dependencies bottom-up, can you order the sequence of upgrading from first to last?

ผลลัพธ์ก็จะได้หน้าตาประมาณนี้

1. **D.Utilities** (ไม่มี dependency)  
2. **C.Validation** (depends on `D.Utilities`)  
3. **B.Logging** (depends on `D.Utilities`)  
4. **A.CoreLib** (depends on `B.Logging` และ `C.Validation`)  

## 3. แปลง Mermaid graph เป็น diagram ด้วย Excalidraw  
ขั้นตอนนี้ก็อาจจะไม่จำเป็นถ้า Markdown บาง platform อย่าง GitHub README สามารถ render diagram ในรูปแบบของ Mermaid ได้เลย แต่ถ้าไม่ได้เราก็สามารถใช้ Excalidraw ในการแปลงให้เป็น diagram ให้ดูเข้าใจง่ายขึ้น  

1. เปิด [Excalidraw](https://excalidraw.com/)  
2. ไปที่ **"More tools" > "Generate"** แล้วเลือก **Mermaid to Excalidraw**  
3. Copy code Mermaid ข้างบน แล้ว **แปลงเป็น diagram** ใน Excalidraw  
4. ปรับสี, เปลี่ยนลูกศร, เพิ่ม note ให้เข้าใจง่ายขึ้น  

![Mermaid to Excalidraw](/assets/2025-02-10-mermaid-to-excalidraw.png)

เอาไปใส่แล้วจะได้หน้าตาประมาณนี้

![Dependency tree](/assets/2025-02-10-dependency-tree.png)

## สรุป
- `dotnet-nuget-tree` → ใช้ดูโครงสร้าง dependency ของทั้ง project 
-  `ChatGPT` → ใช้สร้าง dependency tree สำหรับ package ที่สนใจ และวิเคราะห์ลำดับการ upgrade 
- `Excalidraw` → วาด diagram ให้เข้าใจง่าย  

> ลองใช้เครื่องมือต่าง ๆ เหล่านี้ น่าจะช่วยให้การวิเคราะห์และ upgrade dependency ให้ปลอดภัยมากขึ้น
