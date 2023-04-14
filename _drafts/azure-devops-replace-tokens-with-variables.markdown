---
layout: post
title: "ทำให้ Azure DevOps pipeline เป็น dynamic ด้วย Replace Tokens task"
date: 2023-04-14
tags: [azure, azure-devops]
---

หนึ่งในสิ่งที่เหล่านักพัฒนา CI/CD pipeline ด้วย Azure DevOps หลาย ๆ คนจะต้องเจอคือเราต้องการที่จะทำให้ pipeline ของเราเป็นแบบ dynamic หมายถึงว่าทุกครั้งที่ pipeline run จะได้ผลลัพธ์ออกมาต่างกันตาม variable เช่น จะต้องมี build number ต่างกัน เป็นต้น  

จากปัญหานี้แปลว่าจะต้องการจัดการ variables หรือ parameters ซึ่งจะถูกใช้ภายใต้ task ที่แตกต่างกันไป ถ้าเป็น task ที่ built-in ใช้ได้แค่ใน Azure DevOps เราก็สามารถส่ง variables ผ่าน task input ตรง ๆ ได้เลย

<script src="https://gist.github.com/raksit31667/4cc1a3ff2b0f21ae64a3440c622b0101.js"></script>

แต่ถ้า task ไปเรียก script หรือ file ต่าง ๆ ล่ะ เราอาจจะต้องส่งไปผ่าน environment variables หากเรามี script ชั้นเดียวชีวิตก็ง่าย แต่ถ้ามี nested script แล้วเราก็ต้อง check ให้แน่ใจว่ามันได้ถูก pass ไปที่ script ที่ต้องการใช้งานด้วย ใน Bash อาจจะทำโดยการใช้ `sed` command ในการแทนค่าลงไป อาจจะต้องมี task ใหม่ในการแทนค่าก็ได้

<script src="https://gist.github.com/raksit31667/3eed9be3ab5edc0301e1e18cde5c1cb0.js"></script>

หรือถ้า script เรา run อยู่ภายใต้ Docker ก็ต้องส่ง environment variable เข้าไปผ่าน `--env` หรือ `--env-file`

<script src="https://gist.github.com/raksit31667/d0228ad44d8562e162126b609486433c.js"></script>

จะพบว่ายิ่ง variable เยอะ ยิ่ง file เยอะ ยิ่งมีความซับซ้อนในการดูแลรักษามากขึ้นไป ใน blog นี้ก็จะมาแนะนำ task ที่ลดความซับซ้อนที่อธิบายตามข้างบน แต่ต้องแลกมากับการทำความเข้าใจ task นี้สักหน่อย

## Enter Replace Tokens
[Replace Tokens](https://marketplace.visualstudio.com/items?itemName=qetza.replacetokens) เป็น task ที่จะแทนค่า token ด้วย variable ใน file ที่ต้องการ เพียงแค่เราเขียน token นั้นให้ตรงกับชื่อของ variable จากนั้นก็เพิ่ม Azure DevOps task ลงไป

<script src="https://gist.github.com/raksit31667/1b5ad52378aa21acc6547f25f371f221.js"></script>

format ของ token ที่ Replace Tokens task ตั้งมาให้จะมาในรูปแบบของ `#{variable_name}#` แต่เราสามารถตั้งค่า `tokenPrefix` และ `tokenSuffix` ได้ผ่าน input ของ task เลย นอกจากนั้นตัว task รองรับการแทนค่าลงไปใน file ได้มากกว่า 1 file ด้วย

<script src="https://gist.github.com/raksit31667/cec41fb6c69ddd3a9e0481939164285a.js"></script>

> จากประสบการณ์ในการใช้งานแล้ว พบว่าช่วยแยก concern ระหว่างการ run script กับการจัดการ configuration ออกจากกัน ทำหใ้ให้การดูแล Azure DevOps pipeline code เป็นไปได้ง่ายขึ้น ลองนำไปใช้กันดูครับ