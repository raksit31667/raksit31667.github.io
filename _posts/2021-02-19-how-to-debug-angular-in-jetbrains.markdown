---
layout: post
title:  "วิธีการ debug Angular application ใน Jetbrains IDE (update ปี 2021)"
date:   2021-02-19
tags: [angular, debugging, intellij, ide]
---

ปกติผมใช้ Jetbrains IDE สำหรับการเขียน code รวมถึง Angular เพราะผมชอบ UI และชินกับ keymap แล้ว (อีกสาเหตุนึงคือเสียค่า Ultimate edition ไปแล้วต้องใช้ให้คุ้ม ฮา)
พอเข้าไปอ่านบทความ [Debugging your Angular application in Intellij IDEA](https://itnext.io/debugging-your-angular-application-in-intellij-idea-411a9b08759f) แล้วพบว่ามัน outdated เนื่องจาก plugin สำหรับการ debug มันหายไปแล้ว  

## TLDR;
Jetbrains ได้ทำการ update debugger บน browser มาเป็นแบบ built-in แล้ว ซึ่งมี [tutorial](https://www.jetbrains.com/help/idea/angular.html#angular_running_and_debugging_debug) ไว้แล้ว จบ
  
  
## เริ่มจาก configure ให้ใช้ Angular CLI ผ่าน IDE
1. ไปที่ `Run > Edit configurations > Templates > npm > Angular CLI Server`
2. เลือก `package.json` และ runtime และ package manager ต่างๆ

![Angular CLI configuration](/assets/2021-02-19/2021-02-19-angular-cli-ide-configuration.png)

## จากนั้น configure browser ผ่าน IDE (optional)
1. ไปที่ `Run > Edit configurations > Templates > JavaScript Debug > Angular Application`
2. Configure web browser ตามต้องการ
![Angular browser configuration 1](/assets/2021-02-19/2021-02-19-angular-browser-ide-configuration-1.png)
  
![Angular browser configuration 2](/assets/2021-02-19/2021-02-19-angular-browser-ide-configuration-2.png)

## เริ่ม Debug
1. เปิด Debug ใน `Angular CLI Server` มันจะไป run คำสั่งที่ configure ไว้ ตามรูปข้างบนก็คือ `yarn start`
2. กด `Ctrl + Shift` ค้าง แล้วค่อย click ไปที่ link `http://localhost:port` เพื่อเปิด debug mode จะเห็น `JavaScript Debug` tab ขึ้นมา
3. เพิ่ม breakpoint เป็นอันจบงาน

![Angular browser configuration 2](/assets/2021-02-19/2021-02-19-angular-debug-example.png)

**Debug แบบนี้มันดีกว่ามา log ทีละบรรทัดนะ** 

> แต่ไม่ว่าจะทำท่าไหนถ้าเราต้องมาทำบ่อยๆ แสดงว่ามันผิดปกติแล้วหรือเปล่านะ