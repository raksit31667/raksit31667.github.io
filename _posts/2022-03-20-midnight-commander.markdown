---
layout: post
title:  "แนะนำ Midnight Commander เครื่องมือสำหรับการจัดการ file บน terminal"
date:   2022-03-20
tags: [midnight-commander, linux, productivity]
---

วันก่อนได้มีโอกาสไปฟังในงาน [Dev Mountain Tech Festival](https://www.thairath.co.th/news/tech/2338157) ซึ่งเป็นงานที่ได้ความรู้ใหม่ๆ ไปเยอะมาก โดยเฉพาะในสายที่ตัวเองยังไม่ถนัดครับ ระหว่างตอนที่เราเขียนก็คงจะมี blog อื่นๆ สรุปเนื้อหาในงานให้อย่างแน่นอนครับ  

ที่เกริ่นมาไม่ได้เกี่ยวกับบืความนี้แต่อย่างใด (ฮา) แค่ในงานมีการ demo แล้วไปเจอว่าผู้พูดใช้เครื่องมือที่น่าสนใจในการ ดู หรือ แก้ไข file ผ่าน Terminal ที่ดูเข้าใจง่ายมากๆ  

![Midnight Commander](/assets/2022-03-20-midnight-commander.png)

[Midnight Commander](https://midnight-commander.org/) เป็น open-source application ที่ใช้จัดการกับ file โดยมี feature ทั่วๆ ไปอย่างการ ดู ค้นหา แก้ไข สร้าง ลบ copy file และ directory แต่ที่เด่นกว่าคือมันสามารถ 

- Run บน subshell ได้
- Compress file เป็น `tar` ได้
- ใช้งานกับ SSH จาก local ไปหา remote directory ได้
- ทำคำสั่ง Linux บางอย่างได้ เช่น `symlink` หรือ `chown` ได้
- Interact กับ menu ผ่าน mouse (รวมถึงเครื่องหมาย `>` `<` `^`) และ keyboard ได้

การติดตั้งบน macOS สามารถทำได้ผ่าน Homebrew เลย

```shell
$ brew install mc
```

เริ่มต้นการใช้งานผ่านคำสั่ง `mc` สำหรับเราชอบสีที่มันเข้ากันกับ theme ของ shell ก็เลยใส่ flag `--nocolor` เข้าไป

```shell
$ mc --nocolor
```

![Midnight Commander Search](/assets/2022-03-20-midnight-commander-search.png)

![Midnight Commander Permission](/assets/2022-03-20-midnight-commander-chmod.png)

> หลังจากใช้งานไปสักพัก พบว่าเป็นเครื่องมือที่ใช้จัดการกับ file บน terminal ได้ดีมากๆ ประหยัดเวลาในการ run คำสั่ง Linux ไปได้หลายคำสั่ง นอกจากนั้นยังมีประโยชน์มากในการ access subsystem ที่ไม่มี GUI ได้

> ไปดูตัวอย่างการใช้งานเพิ่มได้ที่ [Linux Command Line Adventure: Midnight Commander](https://linuxcommand.org/lc3_adv_mc.php)