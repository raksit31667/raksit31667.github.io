---
layout: post
title: " สร้าง .NET Template เบื้องต้นง่าย ๆ ใช้เองในทีม"
date: 2025-07-31
tags: [dotnet, platform, code-scaffolding, tools]
---

ช่วงนี้ใน platform team เรากำลังมี onboarding service ใหม่หลายตัว แล้วแน่นอนว่าเรามี template อยู่แล้วที่เป็น base structure ของ microservice ตัวนึง ซึ่งก็มี file พื้นฐานที่ต้องมีเหมือนกันทุกตัว เช่น `Program.cs`, `appsettings.json`, controller เบื้องต้น, และการ config DI ต่าง ๆ  

ถ้าเราทำแบบเดิม ๆ ก็คือไป copy folder ทั้งก้อน แล้วนั่งไล่ rename ทีละ file ทีละ folder แก้ namespace แก้ชื่อ class เอง... บอกได้เลยว่า **เสียเวลาและเสี่ยงพลาดมาก**

> แล้วถ้าเราทำให้มันเป็น Template ล่ะ?

ข่าวดีคือ .NET มีระบบ custom template ที่ใช้ `template.json` ช่วยให้เราสร้าง scaffolding ได้ด้วยคำสั่ง `dotnet new` ใช้ได้ทั้ง file ชื่อ folder และเนื้อหาใน file  

จริง ๆ แล้ว `dotnet new` มันไม่ได้มีไว้แค่รันกับ template ที่เราสร้างเองนะครับ โดย default .NET ก็มี template ติดมากับ SDK อยู่แล้ว หากเรา run คำสั่ง

```bash
dotnet new list
```

```
These templates matched your input: 

Template Name                                 Short Name                  Language    Tags                            
--------------------------------------------  --------------------------  ----------  --------------------------------
API Controller                                apicontroller               [C#]        Web/ASP.NET                     
ASP.NET Core Empty                            web                         [C#],F#     Web/Empty                       
ASP.NET Core gRPC Service                     grpc                        [C#]        Web/gRPC/API/Service            
ASP.NET Core Web API                          webapi                      [C#],F#     Web/WebAPI/Web API/API/Service  
ASP.NET Core Web API (native AOT)             webapiaot                   [C#]        Web/Web API/API/Service         
ASP.NET Core Web App (Model-View-Controller)  mvc                         [C#],F#     Web/MVC                         
ASP.NET Core Web App (Razor Pages)            webapp,razor                [C#]        Web/MVC/Razor Pages             
ASP.NET Core with Angular                     angular                     [C#]        Web/MVC/SPA                     
ASP.NET Core with React.js                    react                       [C#]        Web/MVC/SPA                     
Blazor Server App                             blazorserver                [C#]        Web/Blazor                      
Blazor Server App Empty                       blazorserver-empty          [C#]        Web/Blazor/Empty                
Blazor Web App                                blazor                      [C#]        Web/Blazor/WebAssembly          
Blazor WebAssembly App Empty                  blazorwasm-empty            [C#]        Web/Blazor/WebAssembly/PWA/Empty
Blazor WebAssembly Standalone App             blazorwasm                  [C#]        Web/Blazor/WebAssembly/PWA      
Class Library                                 classlib                    [C#],F#,VB  Common/Library                  
Console App                                   console                     [C#],F#,VB  Common/Console                  
dotnet gitignore file                         gitignore,.gitignore                    Config                          
Dotnet local tool manifest file               tool-manifest                           Config                          
EditorConfig file                             editorconfig,.editorconfig              Config                          
global.json file                              globaljson,global.json                  Config                                                                   
MSBuild Directory.Build.props file            buildprops                              MSBuild/props                   
MSBuild Directory.Build.targets file          buildtargets                            MSBuild/props                   
MSTest Playwright Test Project                mstest-playwright           [C#]        Test/MSTest/Playwright          
MSTest Test Project                           mstest                      [C#],F#,VB  Test/MSTest                     
MVC Controller                                mvccontroller               [C#]        Web/ASP.NET                     
MVC ViewImports                               viewimports                 [C#]        Web/ASP.NET                     
MVC ViewStart                                 viewstart                   [C#]        Web/ASP.NET                     
NuGet Config                                  nugetconfig,nuget.config                Config                          
NUnit 3 Test Item                             nunit-test                  [C#],F#,VB  Test/NUnit                      
NUnit 3 Test Project                          nunit                       [C#],F#,VB  Test/NUnit                      
NUnit Playwright Test Project                 nunit-playwright            [C#]        Test/NUnit/Playwright           
Protocol Buffer File                          proto                                   Web/gRPC                        
Razor Class Library                           razorclasslib               [C#]        Web/Razor/Library               
Razor Component                               razorcomponent              [C#]        Web/ASP.NET                     
Razor Page                                    page                        [C#]        Web/ASP.NET                     
Razor View                                    view                        [C#]        Web/ASP.NET                     
Solution File                                 sln,solution                            Solution                        
Web Config                                    webconfig                               Config                          
Worker Service                                worker                      [C#],F#     Common/Worker/Web               
xUnit Test Project                            xunit                       [C#],F#,VB  Test/xUnit                      
```

อย่างถ้าเรา run

```bash
dotnet new console -n HelloWorld
```

ก็จะได้ C# console app แบบ basic ออกมาเลย สิ่งที่เรากำลังจะทำก็คือการเพิ่ม template ใหม่เข้าไปในระบบ เพื่อใช้สร้าง project ที่เราต้องการได้ง่าย ๆ เหมือนกับของที่มาพร้อม SDK

## ขั้นตอนง่าย ๆ ในการสร้าง Template

### 1. เตรียมโครงสร้าง project ต้นแบบ

เอา template หรือ project อะไรก็ตามที่อยากใช้เป็น base มาเก็บไว้ เช่น

```
Template/
├── Dockerfile
├── Source
│   ├── Your.Project.Template.SubProject
│   ├── Your.Project.Template.AnotherSubProject
│   ├── Your.Project.Template.YetAnotherSubProject
│   └── Solution.sln
├── Tests
│   └── Your.Project.Template.SubTestProject
├── global.json
└── nuget.config
```

จากนั้นก็สร้าง `.template.config/template.json` อยู่ใน root ของ Template ที่เราจะติดตั้ง

### 2. เขียน `template.json`

ตัวอย่าง config ง่าย ๆ:

```json
{
  "$schema": "http://json.schemastore.org/template",
  "author": "YourName",
  "identity": "your.project.id", // id ไม่ซ้ำ ใช้ internal
  "name": "Example Template", // ชื่อเต็มของ template
  "shortName": "microservice", // ชื่อที่ใช้กับ dotnet new <...>
  "sourceName": "Template", // คำที่ใช้แทนใน file/folder
  "symbols": {
    "ParameterName": {
      "type": "parameter", // รับ input จาก parameter ตอน run dotnet new
      "datatype": "string",
      "replaces": "Something",
      "defaultValue": "DefaultValue",  // แทนที่คำนี้ในทุก file/folder
      "description": "Example parameter"
    }
  },
  "sources": [
    {
      "include": "**/*", // ใช้ทุก file ใน template
      "exclude": [ "**/bin/**", "**/obj/**", "**/.git/**" ] // ตัดของไม่จำเป็น
    }
  ]
}
```

### 3. ติดตั้ง Template ของเรา

```bash
dotnet new -u path/to/template/root/directory   # ถ้าเคยติดตั้งมาก่อน
dotnet new -i path/to/template/root/directory
```

### 4. ใช้งาน

```bash
dotnet new <your-shortName> --ParameterName "<Something>" -o your/output/directory
```

สร้าง project ใหม่ทั้งชุด พร้อมแก้ชื่อ, namespace, class name ให้เรียบร้อยอัตโนมัติ สามารถแก้ได้แบบ case-insensitive และ file ที่ไม่ได้เกี่ยวกับ C# ก็รวมด้วย สะดวกมาก!

```
Foobar/
├── Dockerfile
├── Source
│   ├── Your.Project.Foobar.SubProject
│   ├── Your.Project.Foobar.AnotherSubProject
│   ├── Your.Project.Foobar.YetAnotherSubProject
│   └── Solution.sln
├── Tests
│   └── Your.Project.Foobar.SubTestProject
├── global.json
└── nuget.config
```

## ประเด็นที่เจอระหว่างใช้จริง

* ระวังอย่าใส่ file ใหญ่ ๆหรือ build artifact ไปใน template เช่น `.git/`, `.vs/`,  `bin/` กับ `obj/` เพราะ ตอน run `dotnet new` มันจะช้า แนะนำให้ลบออกไปจาก template ก่อน หรือจะใส่ `"exclude": ["**/[Bb]in/**", "**/[Oo]bj/**", ...]` ใน `template.json` เพื่อกรองพวกนี้ออก

* ในกรณีที่ template ยังแทนค่าได้ไม่ตรงตามต้องการเนื่องจากเป็นอักษขระพิเศษหรืออะไรก็ตามแต่ เราสามารถใส่ placeholder อย่างเช่น `{{ParameterName}}` ไว้ใน namespace, ชื่อ class, หรือแม้กระทั่งชื่อ file/folder เช่น

    namespace Your.Project.&#123;&#123;ParameterName&#125;&#125;.Controllers


    หรือในชื่อ file

    TemplateService.csproj -> &#123;&#123;ParameterName&#125;&#125;Service.csproj

## สรุป
การสร้าง .NET template สำหรับใช้ในทีมช่วยให้เราสามารถ

* เริ่ม project ใหม่ในไม่กี่วินาที
* ลดความผิดพลาดจากการ rename
* ทำให้ service onboarding มีมาตรฐาน

ถ้าใครอยากเจาะลึกเพิ่มเติม แนะนำอ่านตรงนี้

* Microsoft Docs:
  * <https://learn.microsoft.com/en-us/dotnet/core/tools/custom-templates>
  * <https://github.com/dotnet/templating/wiki/Reference-for-template.json>
* GitHub ตัวอย่างจากทีม .NET:
  * <https://github.com/dotnet/templating>
* Code scaffolding:
  * [The Layperson’s Guide to Code Scaffolding](https://medium.com/nontechcompany/the-laypersons-guide-to-code-scaffolding-750aa299e904)