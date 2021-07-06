---
layout: post
title:  "แนะนำ Bluesnooze - โปรแกรมตัด Bluetooth ตอน sleep สำหรับ macOS"
date:   2021-07-06
tags: [productivity, bluesnooze, macos]
---

![Bluesnooze](https://raw.githubusercontent.com/odlp/bluesnooze/main/images/screenshot.png)
<https://github.com/odlp/bluesnooze/>

ช่วงนี้ทำงานจากบ้าน แน่นอนว่าเราก็ต้องเข้าประชุมผ่าน conference call จาก app ต่างๆ ซึ่งผมก็จัดหูฟัง bluetooth แบบ wireless มาเพื่อการนี้โดยเฉพาะ เนื่องจากเวลาประชุมนานๆ นั่งนานๆ มันก็เมื่อย ต้องลุกยืนกันบ้าง โดยที่ไม่ต้องลืมถอดหูฟัง (เป็นประจำ หัวสั่นเลย ฮ่าๆๆ)  

ปัญหาคือพอเราพักจากหน้าคอม เราก็อยากจะฟังเพลง เล่น social media บ้าง แต่เสียงดันหายไป เพราะว่าสัญญาณถูกแย่งจากมือถือไปหา laptop ซะงั้น ซึ่งวิธีแก้มันก็ง่ายครับ

1. Disconnect bluetooth จาก laptop ก่อน sleep
2. กลับไปใช้หูฟังมีสาย 3.5mm
3. ใช้โปรแกรมเสริม

[Bluesnooze](https://github.com/odlp/bluesnooze/) เป็นโปรแกรมที่ช่วยตัด bluetooth connection เมื่อ Mac เข้าสู่ sleep mode และจะ connect อีกครั้งเมื่อออกจาก sleep mode  

สามารถ download ลงมาผ่าน [GitHub](https://github.com/odlp/bluesnooze/releases) หรือ Homebrew ได้เลย

```shell
$ brew install bluesnooze
```

> ลองนำไปใช้กันดูครับ สำหรับชาวหูฟัง bluetooth ชีวิตดีขึ้นเยอะ ฮ่าๆๆ