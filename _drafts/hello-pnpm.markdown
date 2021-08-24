---
layout: post
title:  "สวัสดี pnpm - ทางเลือกสำหรับ Node.js package manager"
date:   2021-08-24
tags: [nodejs, pnpm]
---

พอเราพูดถึง Package manager สำหรับ Node.js เรามักจะใช้ [npm](https://www.npmjs.com/) ซึ่งเป็นมาตรฐานโลกอยู่แล้ว ในบทความนี้เราจะมาดู [pnpm](https://pnpm.io/) ซึ่งเป็นหนึ่งในทางเลือกในการใช้งานแทน npm

![Node.js package manager benchmark](/assets/2021-08-24-node-package-manager-benchmark.png)

[Benchmark](https://pnpm.io/benchmark)

## npm มันไม่ดียังไง

### Disk space
ปกติเวลาเรา download package ผ่าน `npm` มันจะมาเก็บใน folder ชื่อ `node_modules` ทีนี้ถ้าเราใช้ package version เดิมกับ 100 projects สิ่งที่เกิดขึ้นคือเราจะได้ copy ของ package มาอีก 100 อัน ซึ่งมันเปลืองที่เก็บเรานะ เช่นเดียวกัน ถ้าเรา update dependency version อันนึง นั่นหมายถึงเราต้อง clone dependency นั้นใหม่หมด

### Dependency tree กับ speed
เริ่มจากเดิมที npm ก่อน version 3 จะมีหน้าตาของ dependency tree ซึ่งแต่ละ child dependency จะมี `node_modules` เป็นของตัวเอง ประมาณนี้

```
node_modules
└─ foo
   ├─ index.js
   ├─ package.json
   └─ node_modules
      └─ bar
         ├─ index.js
         └─ package.json
```

ปัญหาของ structure นี้คือมันจะมี package ตัวเดียวกันซึ่งถูกใช้หลายๆ อัน ซ้ำๆ กัน ซึ่งมันก็จะไปเกี่ยวกับ disk space อีกอันหนึ่งคือมันมีโอกาสที่จะเกิด nested package ยาวมากๆ ซึ่งจะทำให้ปัญหา path ยาว สำหรับ Windows ตามมา  

เพื่อแก้ปัญหาข้างต้น npm version 3 เป็นต้นมาจึง[เปลี่ยนเป็น dependency tree ใหม่](https://npm.github.io/how-npm-works-docs/npm3/how-npm3-works.html)ให้ package ถูก flat อยู่ใน level `node_modules` ทั้งหมด เป็นหน้าตาแบบนี้

```
node_modules
├─ foo
|  ├─ index.js
|  └─ package.json
└─ bar
   ├─ index.js
   └─ package.json
```

แต่มันก็มีปัญหาเล็กๆ ตามมาอีก เช่น การ flat dependency มันใช้เวลานาน และ source code เราสามารถ access package ที่ไม่ได้ใช้ในนั้นได้

> ปล. [Yarn](https://yarnpkg.com/) ถึงแม้จะเร็วกว่า npm แต่ก็ใช้ approach นี้เหมือนกัน

## pnpm แก้ปัญหานี้ยังไง
`pnpm` ใช้ symlink (symbolic link คือการอ้างอิงถึง file หรือ directory ผ่าน path) สมมติว่าเรามี package `foo` ซึ่งใช้ `bar` ทั้งสองตัวจะถูกเก็บลงใน storage ของ `pnpm` เองและใน `foo` จะทำการ symlink ไปที่ `bar` หลังจากนั้น `foo` ก็จะถูก symlink โดย `node_modules` บนสุดเหมือนกัน เพราะ `foo` เป็น dependency ของ root project จะได้หน้าตาประมาณนี้

```
node_modules
├── foo -> ./.pnpm/foo@1.0.0/node_modules/foo
└── .pnpm
    ├── bar@1.0.0
    │   └── node_modules
    │       └── bar -> <store>/bar
    └── foo@1.0.0
        └── node_modules
            ├── foo -> <store>/foo
            └── bar -> ../../bar@1.0.0/node_modules/bar
```

ดังนั้นเวลาเราสั่ง `require('foo')` มันจะชี้ไปที่ `node_modules/.pnpm/foo@1.0.0/node_modules/foo/index.js` นั่นเอง  

แล้วสมมติเราเพิ่ม dependency ใหม่ชื่อ `qar` ซึ่งถูกใช้โดย root, `foo` และ `bar` ก็จะได้หน้าตาประมาณนี้

```
node_modules
├── foo -> ./.pnpm/foo@1.0.0/node_modules/foo
└── .pnpm
    ├── bar@1.0.0
    │   └── node_modules
    │       ├── bar -> <store>/bar
    │       └── qar -> ../../qar@2.0.0/node_modules/qar
    ├── foo@1.0.0
    │   └── node_modules
    │       ├── foo -> <store>/foo
    │       ├── bar -> ../../bar@1.0.0/node_modules/bar
    │       └── qar -> ../../qar@2.0.0/node_modules/qar
    └── qar@2.0.0
        └── node_modules
            └── qar -> <store>/qar
```

**ข้อสังเกต**  
- Data structure จะเปลี่ยนไปเป็น graph แทน เนื่องจากเราใช้การ symlink แทนนั่นเอง ทำให้การ access dependency เร็วขึ้น
- ประหยัด disk space เพราะการใช้ symlink ทำให้เราสามารถใช้ package เดียวอ้างอิงกับทั้ง project ได้เลย

## ปิดท้ายด้วยข้อเสีย
หลักๆ เลยคือด้วยความที่ package สามารถ access ได้แค่ dependencies ที่ระบุไว้ใน `package.json` เท่านั้น และความที่เป็น flatten `node_modules` ทำให้การย้ายจาก `npm` หรือ `Yarn` มาที่ `pnpm` อาจจะไม่ work 100% มีโอกาสสูง

> โดยรวมแล้ว pnpm เป็น package manager ที่น่าใจอีกตัวหนึ่ง ที่มีจุดเด่นคือความเร็วและประหยัด disk space นอกจากนี้ยัง[สนับสนุนการจัด workspace แบบ monorepos](https://pnpm.io/workspaces) ด้วย ไปลองกันได้ครับ

## References
- [Symlinked `node_modules` structure](https://pnpm.io/symlinked-node-modules-structure)
- [The Case for pnpm Over npm or Yarn](https://betterprogramming.pub/the-case-for-pnpm-over-npm-or-yarn-2b221607119)

