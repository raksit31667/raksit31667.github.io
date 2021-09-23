---
layout: post
title:  "แนะนำ direnv เครื่องมือในการจัดการ local environment variables"
date:   2021-09-20
tags: [direnv, environment-variables, productivity]
---

## ว่าด้วยเรื่องของ environment variables

ในการพัฒนา software ขึ้นระบบ production ส่วนมากเราจะต้องเจอกับการจัดการ credentials ที่จำเป็นต้องใช้ในการทดสอบบน local machine หรือเอาไว้ debug เป็นต้น ซึ่งแน่นอนว่าเราก็คงไม่ hardcode หรือนำขึ้น version control system กันอยู่แล้ว (ใครรู้ตัวว่ามีลองทำตาม[บทความ]({% post_url 2021-09-18-remove-exposed-credentials-from-git-history %})นี้ดูครับ) หนึ่งในวิธีการที่เราทำได้คือนำไปไว้บน environment variables แล้วเรียกใช้โดยระบุ key ลงไป  

ปัญหาที่เราพบเจอคือถ้าเรามี environment variables ที่ต้อง export หลายตัว คงจะเป็นเรื่องเสียเวลาหากเราต้องมา export มันทุกครั้งที่ใช้งาน เพราะเพียงแค่เรา reset terminal session สิ่งที่เรา export ไว้ก็หายหมด การนำไปไว้บน `runcom` file เช่น `~/.bashrc`, `~/.zshrc` น่าจะไม่ใช่เรื่องที่ดีเพราะเราก็ไม่ค้องการ export variables เหล่านี้แบบ global ด้วยเช่นกัน  

```shell
export FOO=foo
export BAR=bar
...
```

## direnv ทำอะไรได้บ้าง
> "`direnv` is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory." - <https://direnv.net/>

เราสามารถใช้ `direnv` ในการ load environment variables ที่เราระบุไว้ใน file `.envrc` ใน directory ใดๆ ถ้าเราออกจาก directory นั้นตัว `direnv` ก็จะทำการ unload environment variables ด้วย ทำให้เวลาเรา switch ไปทำอีก project ตัว environment variables ที่มี key เดียวกันก็จะไม่ทับกันนั่นเอง

### วิธีการติดตั้ง
ข้อจำกัดของ `direnv` คือมันสามารถใช้ได้แค่กับ Unix-based เท่านั้น ดังนั้นตาม [documentation](https://direnv.net/docs/installation.html) จะเป็นพวก Linux หรือ macOS ไป สำหรับสาย Windows ถ้าใช้ Linux subsystem ก็ไม่น่ามีปัญหา แต่ถ้าไม่ก็อาจจะต้องมองหา[เครื่องมืออื่น](https://direnv.net/#related-projects)  

หลังจากนั้นเราจะต้องติดตั้ง shell ที่จะถูก hook เพื่อเปิดใช้งาน `direnv` ตัวอย่างเช่น Bash หรือ Zsh หรือ Fish เป็นต้น ดูตามตัวอย่างใน [documentation](https://direnv.net/docs/hook.html) ได้เลย

### การใช้งานใน local directory
1. ใน project directory สร้าง file `.envrc` ขึ้นมา ข้างในก็ระบุ environment variables ที่เราต้องการ

<script src="https://gist.github.com/raksit31667/38c1cb622cedf8314554921bf4d6941a.js"></script>

2. Ignore `.envrc` ออกจาก version control อย่างใน Git ก็เพิ่ม `.envrc` ลงไปใน `.gitignore` ซะ

3. Load environment variables ด้วยคำสั่ง เป็นอันจบงาน

```shell
$ direnv allow

direnv: loading ~/path/to/.envrc                                                                                                                                                                 
direnv: export +FOO +BAR

$ echo $FOO
foo

$ echo $BAR
bar
```

4. แนะนำให้สร้าง file `.envrc.template` ขึ้นมาซึ่งข้างในจะคล้ายกับ `.envrc` แต่ให้เอา credentials ออก จากนั้นเอาขึ้น version control เวลาที่เพื่อนร่วมทีมจะใช้ `direnv` ก็ copy template file แล้วเปลี่ยนชื่อเป็น `.envrc` จากนั้นก็ใส่ credentials ที่ถูกต้องลงไป

> ลองนำไปใช้กันดูครับ ของโคตรดี




