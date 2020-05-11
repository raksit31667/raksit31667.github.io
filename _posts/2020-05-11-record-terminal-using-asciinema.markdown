---
layout: post
title:  "บันทึกและแชร์ Terminal ด้วย asciinema"
date:   2020-05-11
tags: [productivity, tools]
---
ตอนที่ผมกำลังเขียน blog ก่อนๆ ก็อยากจะลอง capture terminal สวยๆ แบบที่เห็นใน tutorial หรือ Readme ต่่างๆ บ้าง  
มันน่าจะดีกว่าแปะ command ทีละอันนะ  

คำถามคือ มีเครื่องมืออะไรบ้าง  

หนึ่งในนั้นคือ [asciinema](https://asciinema.org/) ซึ่งข้อดีหลักๆ เลยคือติดตั้งง่าย โดยเฉพาะ macOS ก็ลงผ่าน [Homebrew](https://formulae.brew.sh/formula/asciinema) ได้เลย มาพร้อมกับ Embbedded player เอาไปแปะใน **Markdown** หรือ **HTML page** ก็ได้

![Asciinema embedding](/assets/2020-05-11-asciinema-embedding.png)

จะอัดก็รันคำสั่ง
```sh
asciinema rec your-file-name-here
```

แล้วก็ upload ขึ้นเว็บได้เลย หรือจะเก็บเป็นไฟล์ไว้ upload ทีหลังก็ได้เหมือนกัน

```sh
asciinema upload your-file-name-here.cast
```

<script id="asciicast-329178" src="https://asciinema.org/a/329178.js" async></script>