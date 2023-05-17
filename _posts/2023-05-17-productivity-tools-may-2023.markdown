---
layout: post
title:  "รวบรวมเครื่องมือ Productivity ที่น่าสนใจในเดือนพฤษภาคม 2023"
date:   2023-05-17
tags: [productivity]
---

หลังจากที่เข้าไปทำ project มาสักพักใหญ่แล้วตอนนี้กำลังจะจบแล้ว ในระหว่างก็ได้เรียนรู้ว่ายังเครื่องมือ productivity ใหม่ ๆ ที่จะมาช่วยทำให้กิจวัตรประจำวันของ Developer นั้นสะดวกสบายมากขึ้น มาดูกันว่าในเดือนนี้มีเครื่องมืออะไรน่าสนใจบ้าง

## MonitorControl
[MonitorControl](https://github.com/MonitorControl/MonitorControl) เป็นเครื่องมือที่ทำให้เราปรับแสงและเสียงของ macOS ได้โดยที่เรายังต่อกับอุปกรณ์ข้างนอกอยู่ ยกตัวอย่างเช่น เวลาเราต่อจอเสริมเพื่อทำงานเพราะว่าจอใน laptop มันเล็ก ถ้ามันมืดหรือสว่างไปเราก็ไม่สามารถปรับผ่าน keyboard ได้ ก็ต้องใช้มือไปคลำ ๆ หาปุ่มเอา กดแล้วใช่ก็โชคดีไป ฮ่า ๆๆ จะดีกว่าถ้าเราใช้ MonitorControl application เพื่อปรับแสงหรือเสียงได้โดยไม่ต้องไปแตะจอหรือลำโพงเลย เป็นต้น การติดตั้งก็ใช้ Homebrew เอา จากการใช้งานจริงจะมีข้อจำกัดตรงที่ว่าปรับแสงให้สว่างขึ้นได้แต่ปรับลงไปได้ไม่เกินค่าที่จอตั้งไว้ล่าสุด

```shell
brew install MonitorControl
```

![MonitorControl](/assets/2023-05-17-monitor-control.png)

<https://github.com/MonitorControl/MonitorControl>

## Grammarly
[Grammarly](https://app.grammarly.com/) เป็นเครื่องมือช่วยในการพิมพ์ภาษาอังกฤษให้ดีขึ้น การใช้งานทั่ว ๆ ไปก็คือมันจะตรวจข้อความของเราที่เรากำลังพิมพ์อญู่ผ่าน application ต่าง ๆ (ถ้าเป็นแบบเปิดเข้าไปดูอย่างเดียวมันจะไม่ตรวจให้นะ) แล้วก็เสนอว่าควรจะเปลี่ยนเป็นอะไร ทั้งในด้าน grammar, vocabulary ไปจนถึงความสั้นกระชับ (conciseness) สามารถติดตั้งได้ทั้ง browser extension และ Desktop application มีข้อควรระวังคือถ้ามีความกังวลด้าน data privacy ก็ควรหลีกเลี่ยงการใช้งานเนื่องจาก Grammarly จะมีสิทธิ์นำข้อความของเราไปทำอะไรต่อก็ได้นั่นเอง

![Grammarly](/assets/2023-05-17-grammarly.jpeg)

<https://chrome.google.com/webstore/detail/grammarly-grammar-checker/kbfnbcaeplbcioakkpcpgfkobkghlhen>

## Menu World Time
[Menu World Time](https://apps.apple.com/us/app/menu-world-time/id1446377255?mt=12) เป็น application บน macOS ที่ใช้ในการดูเวลาจากเมืองต่าง ๆ ทั่วโลก (ให้นึกถึงเวลาไปโรงแรมแล้วเห็นนาฬิกาหลาย ๆ เรือนตั้งเรียงกันแล้วมีชื่อเมืองกำกับ) ผ่าน menu bar มีประโยชน์มากโดยเฉพาะเวลาเราทำงานกับเพื่อน ๆ ข้าม time zone หรือต้องพัฒนา software ที่เกี่ยวข้องกับ time zone

![Menu World Time](/assets/2023-05-17-menu-world-time.png)

<https://www.macupdate.com/app/mac/62282/menu-world-time>

> วิธีการติดตั้งอยู่ใน link ที่แนบไว้แล้ว ลองนำไปปรับใช้กันดูครับ
