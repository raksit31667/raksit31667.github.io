---
layout: post
title:  "เปลี่ยน version ของ Python ด้วย pynenv"
date:   2020-04-25
tags: [python]
---
ช่วงนี้กลับมาเขียน python พบว่าจะเปลี่ยน version ผ่าน Homebrew เริ่มยาก เพราะต้องเข้าไปดู​ git history ของ [python ใน Homebrew](https://github.com/Homebrew/homebrew-core/blob/master/Formula/python.rb) เลยไปเจอ tool เฉพาะชื่อว่า [pyenv](https://github.com/pyenv/pyenv) โดยมี feature คร่าวๆ คือ

- เปลี่ยน python version ทั้งแบบ local และ global
- ลง python ระบุ version ได่
- แสดง python version ที่เราลงไว้ทั้งหมด

ตัวอย่างการทำงานของ `pyenv` เป็นแบบนี้
1. ปกติเวลาเรารันคำสั่งเช่น `pip` ระบบจะไปหา executable file ชื่อว่า `pip` ซึ่งจะเก็บอยู่ใน environment variable ชื่อว่า `PATH` เช่น `/usr/local/bin/pip`
2. `pyenv` จะไปหา executable file ที่เรียกว่า `shims` ที่มีชื่อตรงกับคำสั่งเราจากข้อ 1 ถ้าอย่างของ `pip` ก็จะเจอประมาณนี้ `/Users/raksit/.pyenv/shims/pip`
3. รัน `shims` ตัวนั้นโดย pass คำสั่งและ argument จาก `pyenv` ลงไป

<script id="asciicast-329178" src="https://asciinema.org/a/329178.js" async></script>