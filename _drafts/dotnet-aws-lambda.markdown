---
layout: post
title: "วิธี upgrade .NET runtime ใน AWS Lambda แบบเข้าใจง่าย"
date: 2025-10-24
tags: [dotnet, aws]
---

ช่วงนี้ใครที่มี Lambda function ที่เขียนด้วย .NET version เก่า ๆ อยู่ อาจเริ่มเจอข่าวว่า AWS จะทยอยหยุดรองรับ runtime เก่า ๆ และถ้าไม่ upgrade ก็อาจเสี่ยงทั้งด้าน security และ maintenance ในอนาคต วันนี้เลยอยากจดบันทึกขั้นตอน upgrade จาก .NET runtime ที่ทำได้ง่ายมาก ๆ ไม่ต้องเปลี่ยน logic ใน code ด้วยซ้ำตาม [Using the .NET Lambda Global CLI](https://docs.aws.amazon.com/lambda/latest/dg/csharp-package-cli.html) และ [Deploying an AWS Lambda Project with the .NET Core CLI](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/lambda-cli-publish.html)

### โครงสร้าง project ของ Lambda ทั่วไป

โดยปกติ Lambda ที่สร้างจาก AWS Toolkit หรือ AWS CLI ผ่านคำสั่ง 

```shell
dotnet new install Amazon.Lambda.Templates

dotnet tool install -g Amazon.Lambda.Tools

dotnet new lambda.EmptyFunction --name MyLambdaProject
```


จะมีโครงสร้างประมาณนี้

```
/MyLambdaProject
│
├── Function.cs
├── MyLambdaProject.csproj
└── aws-lambda-tools-defaults.json
```

เวลาเราจะ upgrade runtime จริง ๆ ก็แค่แก้ 2 file นี้เท่านั้น

## 1. เปลี่ยน Target Framework ใน .csproj

เปิดไฟล์ `MyLambdaProject.csproj` แล้วเปลี่ยนบรรทัดของ `<TargetFramework>` จาก `netx.0` เป็น `nety.0` เช่น

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Amazon.Lambda.Core" Version="2.2.0" />
    <PackageReference Include="Amazon.Lambda.Serialization.SystemTextJson" Version="2.4.0" />
  </ItemGroup>
</Project>
```

อย่าลืม upgrade NuGet package ของ AWS Lambda ให้เป็นเวอร์ชันล่าสุดที่รองรับ .NET 8 ด้วยนะ เช่น `Amazon.Lambda.Core` หรือ `Amazon.Lambda.Serialization.SystemTextJson`

## 2. เปลี่ยน runtime ใน aws-lambda-tools-defaults.json

เปิดไฟล์ `aws-lambda-tools-defaults.json` แล้วหาบรรทัดที่เป็น `"function-runtime"` จากนั้นเปลี่ยนเป็น `"dotnety"`

```json
{
  "profile": "default",
  "region": "ap-southeast-1",
  "function-runtime": "dotnet8",
  "function-memory-size": 256,
  "function-timeout": 30,
  "function-handler": "MyLambdaProject::MyLambdaProject.Function::FunctionHandler"
}
```

เสร็จแค่นี้ Lambda จะรู้เองว่าให้ใช้ runtime ใหม่ตอน deploy

## 3. Build และทดสอบก่อน deploy

ก่อน deploy แนะนำให้ลอง build ในเครื่องดูก่อน ว่าทุกอย่างยัง compile ผ่าน

```bash
dotnet clean
dotnet build
dotnet test
```

## 4. Deploy ขึ้น AWS

ถ้าใช้ AWS Lambda Tools อยู่แล้ว (ที่ติดมากับ `Amazon.Lambda.Tools` NuGet package) ก็สามารถ deploy ได้เลยด้วยคำสั่งนี้

```bash
dotnet lambda deploy-function
```

คำสั่งนี้จะอ่านค่า runtime จาก `aws-lambda-tools-defaults.json` แล้ว update function ให้อัตโนมัติ

## 5. ตรวจสอบใน AWS Console

เข้าไปดูที่ AWS Console -> Lambda ตรง Runtime จะเห็นว่าค่า runtime เปลี่ยนเป็น `.NET 8` แล้ว แค่นี้ถือว่า upgrade เสร็จสมบูรณ์


## ถ้าใช้ Container-based Lambda

บางทีม Lambda ถูก deploy ผ่าน container image (เช่น ใน ECR)
กรณีนี้ก็ update base image ใน `Dockerfile` แทน

```dockerfile
FROM public.ecr.aws/lambda/dotnet:8 AS base
WORKDIR /var/task
COPY ./bin/Release/net8.0/publish/ .
CMD ["ProjectName::ProjectName.Function::FunctionHandler"]
```

จากนั้น build และ push image ขึ้น ECR ตามปกติ
