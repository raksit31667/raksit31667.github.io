---
layout: post
title: "บันทึกการจัดการ Git configuration แยกกันในแต่ละ project"
date: 2023-01-23
tags: [version-control, git]
---

ช่วงนี้มีโอกาสได้เข้า project ใหม่ แล้วลูกค้าอนุญาตให้ใช้ laptop เครื่องเดียวกันกับที่ใช้ในบริษัทได้เลย ดูเหมือนจะดีที่ไม่ต้องพก laptop 2 เครื่อง แต่เราติดปัญหาตรงที่ว่า Git configuration ที่มีอยู่ตอนนี้ มัน share กันทั้งเครื่อง หมายความว่าเราไม่สามารถแยก configuration ระหว่าง ส่วนตัว กับ งานลูกค้าได้เลย จริง ๆ มันมีวิธีแก้ง่าย ๆ อยู่คือทุกครั้งที่เข้า project ลูกค้าจะต้องเพิ่มคำสั่ง

```shell
$ git config user.email raksit.mantanacharu@company.com
$ git config user.name Raksit Mantanacharu
```

ซึ่งมันดูน่าเบื่อมาก ๆ ไม่ควรจะต้องมาทำซ้ำ ๆ ดังนั้นเรามาออกแรงแยก configuration กันดีกว่านะ

## พูดถึง Git configuration
Git configuration จะถูกเก็บไว้ในรูปแบบของ file โดยที่ file หลักจะอยู่ที่ `$HOME/.gitconfig` ซึ่งเราสามารถเพิ่ม configuration ในส่วนนี้เพื่อให้เกิดผลกับทุก project ได้

<script src="https://gist.github.com/raksit31667/d33f9e01fd0f9af23bbb65669bad7ab3.js"></script>

นั่นหมายความว่าชื่อและ email ของ user ที่ใช้ commit (committer) จะเป็น `Earth Raksit` และ `raksit.m@ku.th` ทุก project โดยอัตโนมัติ เป็นสาเหตุของปัญหาที่กล่าวไว้ตั้งแต่ต้น  

## แยก Git configuration
1. แยก Git configuration ตาม directory ที่เก็บ source code และ version control ออกจากกันก่อน เช่นสร้าง 2 directories คือ `Personal` กับ `Work` (เหมือนแยกเรื่องส่วนตัวออกจากงาน ฮ่า ๆๆ)

```
$HOME
│   
└───Personal
│   │
│   └───personal-project-1
│   │
│   └───personal-project-2
│   
└───Work
│   │
│   └───work-project-1
│   │
│   └───work-project-2
│     
```

2. สร้าง Git configuration file ในแต่ละ project ตามตัวอย่างก็คือจะได้ `$HOME/Personal/.gitconfig` และ `$HOME/Work/.gitconfig`

<script src="https://gist.github.com/raksit31667/d9db66526916ff18fb82442f90902ea7.js"></script>

<script src="https://gist.github.com/raksit31667/13117541823ab65cdedfe9708e30b4ee.js"></script>

```
$HOME
│   
└───Personal
│   │
│   └───.gitconfig
│   │
│   └───personal-project-1
│   │
│   └───personal-project-2
│   
└───Work
│   │
│   └───.gitconfig
│   │
│   └───work-project-1
│   │
│   └───work-project-2
│     
```

3. ปิดท้ายแก้ไข Git configuration file หลักอยู่ที่ `$HOME/.gitconfig` ให้ทุก project ที่อยู่ในแต่ละ directory ใช้ configuration ตาม file ที่สร้างแยกไว้ใน directory ของตัวเอง

<script src="https://gist.github.com/raksit31667/8890c2bda4ef8ac758b5a3dd74cb3ef9.js"></script>

จะเห็นว่าถ้าเข้าไปใน project ก็จะเห็นว่า configuration เปลี่ยนไปตาม `.gitconfig` ที่กำหนดแยกกันไว้แล้ว ไม่มีการ commit ผิด user แน่นอนตราบใดที่เราเอา project ไว้ตาม directory ที่ถูกต้อง

```
$ git config --list

...
user.name=Earth Raksit
user.email=raksit.m@ku.th
...

```

> ลองนำไปปรับใช้กันดูครับ จะได้ไม่ต้องมา overwrite Git configuration กันทีละ project