---
layout: post
title:  "จด Tips เล็กๆน้อยๆ การทำ Configuration บน local environment ของ Spring"
date:   2020-03-12
tags: [spring, configuration]
---
พอดีในระบบงานมี dependency เป็น legacy application ที่ต้องใช้ credentials ในการ access ซึ่งเป็นส่วนหนึ่งของ configuration ในแต่ละ environment นั่นเอง  

ปัญหาคือถ้า

- เราต้องการจะทดสอบระบบใน local machine
- ไม่สามารถติดตั้งระบบ ERP บน local machine ได้

แน่นอนว่าจะต้องเก็บ credentials ไว้ **และห้ามเอาขึ้น version control เด็ดขาด** อย่างเช่น  

<script src="https://gist.github.com/raksit31667/736efbd915de69fb90436c2266664bfb.js"></script>

> ใครทำแบบนี้อยู่รีบแก้ไขนะครับ อิอิ

ได้วิธีทำจาก [ZoomOutWarrior](https://github.com/chan43999) โดยการนำ configuration file ไปไว้ใน directory `config` ใน source module จะได้หน้าตาประมาณนี้  

```
src
│   
└───resources
│   │
│   └───bootstrap.yaml // สำหรับ global configuration
config
│   
└───bootstrap.yaml // สำหรับ local configuration
```

> สำคัญสุด อย่าลืมใส่ `config` ใน `.gitignore` นะครับ ไม่งั้นก็ตัวใครตัวมัน ฮ่าๆๆๆ
