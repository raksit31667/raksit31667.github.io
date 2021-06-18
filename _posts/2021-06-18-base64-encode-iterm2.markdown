---
layout: post
title:  "iTerm2 ก็สามารถ encode Base-64 ได้นะ"
date:   2021-06-18
tags: [productivity, iterm2, macos]
---

ทุกๆ วันหลังจากเปิดคอม จะมี popup เกี่ยวกับ tip of the day โผล่ขึ้นมาจาก [iTerm2](https://iterm2.com/index.html) ซึ่งผมก็อ่านบ้างไม่อ่านบ้าง ฮ่าๆๆ

![iTerm2 tip of the day](/assets/2021-06-18-iterm2-tip-of-the-day.png)

มีอันนี้ที่สะดุดตาคือความสามารถในการ encode text เป็น Base-64 เนื่องจากงานที่ทำในปัจจุบันมีส่วนที่ต้องแก้ไข credentials ซึ่งต้อง encode แต่ผมจะใช้อยู่ 2 ท่า

1. Base-64 Decode and Encode Online เช่น <https://www.base64decode.org/>
2. คำสั่ง `base64` ใน Linux

**Encoding**
```shell
$ echo 'raksit31667' | base64

aHR0cHM6Ly93d3cuYmFzZTY0ZGVjb2RlLm9yZy8=
```

**Decoding**
```shell
$ echo 'aHR0cHM6Ly93d3cuYmFzZTY0ZGVjb2RlLm9yZy8=' | base64 -D

raksit31667
```

บน iTerm2 มีคำสั่งง่ายๆ ในการ encode Base-64 ตามนี้

1. Copy text ที่เราต้องการจะ encode ไว้ก่อน
2. ไปที่ **Edit > Paste Special > Advanced Paste...** หรือใช้ shortcut `⌥⌘V` จะมีหน้าต่างขึ้นมา
3. Check box ตรง Base-64 encode

![iTerm2 advanced paste](/assets/2021-06-18-iterm2-advanced-paste.png)

จะเห็นว่า **Advanced paste** ยังสามารถจัดการกับ special character, escape character หรือ regex ได้ด้วย ไปลองใช้กันดูครับ

> Download iTerm2 ผ่าน <https://iterm2.com/index.html> สำหรับใครที่ใช้อยู่ ลองเข้าไปดู feature เข้าไปดูใน <https://iterm2.com/features.html> ส่วนตัวผมยังใช้ไม่ครบทุกอันเลย