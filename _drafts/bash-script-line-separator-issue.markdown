---
layout: post
title: "บันทึกการแก้ปัญหา /bin/bash: - : invalid option ใน Linux EC2 โดยเปลี่ยน Line Separator"
date: 2024-08-15
tags: [linux, shell]
---

เมื่อวันก่อนใน project จะต้องเขียน Shell script เพื่อไป run ใน AWS EC2 instance ที่เป็น Linux ปรากฎว่าเจอ error ว่า

```shell
/bin/bash: - : invalid option
```

ทำให้งงไปตาม ๆ กันเพราะว่า run ได้ตามปกติบน local machine ซึ่งเรามาพบว่าต้นเหตุมันเกิดจากการขึ้นแต่ละบรรทัดใหม่ใน script file

## ทำความเข้าใจความต่างระหว่าง CRLF vs. LF
คอมพิวเตอร์ที่ detect ตัวหนังสือเพื่อนำไปแสดงบนหน้าจอของเรารู้ได้อย่างไรว่าตรงไหนที่จะต้องขึ้นบรรทัดใหม่ คำตอบคือใช้อักขระพิเศษในการระบุว่าตรงจุดนั้นคือการขึ้นบรรทัดใหม่นะ ทีนี้แต่ละ operating system จะใช้อักขระต่างกันไป โดย

- **Windows** จะใช้ **CRLF** (Carriage Return and Line Feed, `\r\n`).
- **Linux/Unix** จะใช้ **LF** (Line Feed, `\n`).

ดังนั้นหากเราสร้างหรือแก้ไข script บน Windows โดยใช้ CRLF แล้วนำไป run บน Linux system ซึ่งใช้ LF อาจจะทำให้ script fail ตาม error ข้างต้นได้นั่นเอง

## แล้วจะรู้ได้อย่างไรว่าเราใช้ Line Separator แบบไหน
หากสมมติฐานของเราว่าต้นเหตุที่ script fail คือเป็นที่ Line Separator แล้ว ให้ลองเพิ่ม `cat -v` command เพื่อ print script ออกมาพร้อมกับอักขระพิเศษ

```bash
cat -v your_script.sh
```

ถ้าเราเห็นอักขระ `^M` เป็นอันสุดท้ายในแต่ละบรรทัดก็แปลว่าเราใช้ CRLF

## แล้วจะเปลี่ยนหรือกำหนด Line Separator ได้อย่างไร
- วิธีง่่ายที่สุดคือใช้ text editor ทั่วไปอย่าง VSCode, Sublime Text และอื่น ๆ ในการปรับ line separator หรือถ้าจะให้ดีก็ตั้ง coding standards ไปเลย เช่น ใช้ [EditorConfig](https://editorconfig.org/) เป็นต้น
- ใช้ Linux command อย่าง [dos2unix](https://dos2unix.sourceforge.io/), [sed](https://man7.org/linux/man-pages/man1/sed.1.html) หรือ [tr](https://man7.org/linux/man-pages/man1/tr.1.html) ในการลบอักขระพิเศษออก

  ```bash
  dos2unix your_script.sh
  ```

  ```bash
  sed -i 's/\r$//' your_script.sh
  ```

  ```bash
  tr -d '\r' < your_script.sh > temp.sh && mv temp.sh your_script.sh
  ```

- ใช้คำสั่ง Vim เพื่อปรับ Line Separator

    ```vim
    :set ff=unix
    :wq
    ```

- ปรับ `.gitattributes` ใน repository เพื่อบังคับ line separator LF สำหรับ shell scripts

  ```bash
  *.sh text eol=lf
  ```
