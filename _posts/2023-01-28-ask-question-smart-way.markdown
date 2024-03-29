---
layout: post
title: "ถามคำถามยังไงให้ได้ประโยชน์ทั้งคนถามและคนรับ"
date: 2023-01-28
tags: [soft-skill]
---

เราได้เรียนรู้เกี่ยวกับ soft skill เพิ่มจากหลาย ๆ ที่ ส่วนหนึ่งก็มาจาก community ของทางบริษัทด้วย สำหรับเดือนนี้จะเน้นไปทางการถามคำถาม แล้วมันมีเนื้อหาหลากหลายก็เลยรวมมาเป็น blog เดียวเลย ขึ้เกียจเขียนแยก ๆ กัน

## Before You Ask
ก่อนถามคำถาม ให้ดูว่าเราได้ทำสิ่งเหล่านี้แล้วหรือยัง

- ลองหาคำตอบในที่ที่เราจะไปถามตำถามแล้วหรือยัง
- ลองหาคำตอบใน internet แล้วหรือยัง
- ลองหาคำตอบจาก README, wiki, user manual หรือ FAQ แล้วหรือยัง
- ลองหาคำตอบด้วยการสังเกตและลองผิดลองถูกด้วยตนเองแล้วหรือยัง
- ลองหาคำตอบด้วยการถามเพื่อนแล้วหรือยัง
- ลองหาคำตอบด้วยการอ่าน source code แล้วหรือยัง

## Don't ask to ask, just ask
ในการถามคำถามซึ่งหน้า เรามักจะเกริ่นก่อนถามเพื่อดูว่าใครที่เราสามารถเข้าไปถามได้เป็นมารยาท เช่น

> Hi there!

> May I ask a question?

> Guys, I have a question about ...

> Any Java experts around?

แต่ใน chat สถานการณ์มันต่างกันไปเพราะจะต้องเกิดการ "รอ" กัน เพราะคนที่อ่านก็รอให้เราพิมพ์คำถามต่อ ส่วนเราก็รอให้คนอ่าน(สักคนในกลุ่ม)ตอบว่า **"Yes, you can."** หรือ **"Yes, I am an expert."** คำถามคือใครคือคนสักคนในนั้น แล้วถ้าไม่ได้เป็น expert แต่รู้พอได้ล่ะจะกล้าพิมพ์ตอบไปไหม ก็จะเห็นว่ามันเสียเวลาทั้งเราคนถามและคนที่มีโอกาสจะตอบ  

วิธีแก้ก็คือแทนที่จะถามเพื่อ "ถาม" (meta-question) เราก็ "ถาม" ไปเลย เช่น

> How do I do ... with Java and ...? Context: ...

ประโยชน์ก็คือ เราได้เริ่มบทสนทนาแล้วในรูปแบบ asynchronous แล้ว ทำให้ทั้งคนถามและคนตอบไม่ต้องรอกัน ใครว่างก็มาถาม-ตอบกันไป

### References
- <https://dontasktoask.com/>
- <https://nometa.xyz/>
- <https://nohello.net/en/>

## The XY Problem
The XY Problem พูดถึงปัญหาที่เกิดขึ้นจากการที่เรา focus ไปกับ "การแก้ปัญหา" มากกว่า "ปัญหาจริง ๆ" ผลก็คือเสียเวลาทั้งคนถามและคนตอบ เนื่องจากเวลาแก้ปัญหาไม่ได้ ในหัวของเราก็จมอยู่กับการแก้ปัญหาด้วยวิธีนั้นอย่างเดียว ไม่ได้ออกมากดูภาพรวมหรือย้อนกลับไปที่ปัญหาใหม่อีกครั้ง เช่น

> เราอยากจะแก้ปัญหา X แต่ไม่รู้ว่าแก้ X ยังไง เราเลยคิดว่าต้องทำ Y ก่อน แต่เราก็ไม่รู้ว่าทำ Y ยังไงเหมือนกัน เลยขอความช่วยเหลือตยอื่นให้แก้ปัญหาเรื่อง Y ทีนี้คนอื่นก็คิดว่า Y มันแปลก ๆ นะ สืบไปสืบมากลายเป็นว่าจริง ๆ เราอยากแก้ X โดยที่ Y ไม่ได้เป็นวิธีการแก้ปัญหาที่เหมาะสมของ X

ตัวอย่างของการถามคำถามที่ติดกับ XY Problem ก็เช่น

> My program doesn't work. I think system X is broken.

> How can I use X to do Y?


วิธีการแก้ปัญหา XY ก็คือ
- เวลาถามคำถาม ให้เพิ่มข้อมูลภาพรวมพร้อมกับวิธีการแก้ปัญหาที่เคยลองดูแล้ว
- ให้ข้อมูลเพิ่มเติมเมื่อมีคนขอ
- ถ้ามีวิธีแก้ปัญหาที่ตัดออกไป ให้อธิบายเหตุผลด้วยเพื่อตีกรอบปัญหาให้แคบลง

### References
- <https://xyproblem.info/>

## If You Can't Get An Answer
ในการถามคำถาม ถ้าเราถามแล้วไม่ได้คำตอบหรือไม่มีใครมาตอบ ไม่ได้หมายความว่าเขาไม่สนใจเราเสมอไป แต่อาจจะหมายว่าไม่มีใครรู้จริง ๆ ซึ่งปัญหาอาจจะเป็นว่าเราถามผิดที่หรือเปล่า หรือคำถามของเรามันไม่ clear พอที่คนตอบจะต่อยอดไปได้

## Further reading
- [How To Ask Questions The Smart Way](https://github.com/selfteaching/How-To-Ask-Questions-The-Smart-Way/blob/master/How-To-Ask-Questions-The-Smart-Way.md)