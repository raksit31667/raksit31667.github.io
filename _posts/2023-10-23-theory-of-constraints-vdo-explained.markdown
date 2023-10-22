---
layout: post
title: "ดู VDO เรื่อง Thoery of Constraints แล้วได้อะไร"
date: 2023-10-23
tags: [theory-of-constraints, lean]
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/PMiTVUDiNQ4?si=j2jhugQvqOjLGZgr" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

ในระหว่างการเตรียมตัวการไปจัด workshop ให้กับลูกค้าเมื่อ 2 อาทิตย์ก่อนมีโอกาสได้ดู VDO เกี่ยวกับเรื่อง [Theory of Constraints](https://en.wikipedia.org/wiki/Theory_of_constraints) พบว่าหลายคนดูแล้วก็ "งง" ว่ามันจะสื่ออะไรกันแน่นอกจากว่ามันทำให้เรานึกถึงรายการทีวีวิทยาศาสตร์ตอน 3 ทุ่ม [Mega Clever ฉลาดสุดสุด](https://th.wikipedia.org/wiki/Mega_Clever_%E0%B8%89%E0%B8%A5%E0%B8%B2%E0%B8%94%E0%B8%AA%E0%B8%B8%E0%B8%94%E0%B8%AA%E0%B8%B8%E0%B8%94)   
สิ่งที่เราได้คือมันทำให้เราเข้าใจการจัดการกับคอขวด (bottleneck) ของระบบมากขึ้นและพบว่าเป็นแนวคิดที่น่าสนใจที่น่าไปปรับใช้ในการปรับปรุงพัฒนา software development ใน project ถัด ๆ ไปได้

## Theory of Constraints คืออะไร
Theory of Constraints คือแนวคิดในการจัดการกับระบบงานให้เกิดประสิทธิภาพสูงสุด (เนื้อหาเดิมเน้นไปที่การผลิตสิ่งของแต่ก็สามารถนำมาประยุกต์กับการพัฒนา software ได้) โดยแนวคิดนี้มีที่มาจากหนังสือเรื่อง [“The Goal”](https://www.tocinstitute.org/the-goal-summary.html) โดย [Dr. Eliyahu Goldratt](https://en.wikipedia.org/wiki/Eliyahu_M._Goldratt) ซึ่งพูดถึงแนวคิดและแนวปฏิบัติในการจัดการและอยู่ร่วมกับคอขวดที่เกิดขึ้นในระบบงาน โดยมองจากมุมที่ว่า

> ในระบบงานจะมีคอขวดเกิดขึ้นอยู่เสมอ ประสิทธิภาพของระบบงานจะถูกจำกัดโดยความเร็วตรงส่วนของคอขวด ถ้าเราอยากให้ระบบงานให้เกิดประสิทธิภาพสูงสุด เราจะต้องเพิ่มความเร็วให้ผ่านตรงคอขวดให้ได้เร็วที่สุด

![Theory of Constraints](/assets/2023-10-23-theory-of-constraints.webp)  
[Theory of Constraints 101: Applying the Principles of Flow to Knowledge Work](https://medium.com/praxis-blog/theory-of-constraints-101-2d4d9cf1916a)

ซึ่งการเพิ่มความเร็วให้ผ่านตรงคอขวดให้ได้เร็วที่สุดก็ต้องแก้ที่ตรงจุดนั้น ๆ จุดอื่น ๆ ที่ถูกแก้นั้นไม่ได้ทำให้ความเร็วตรงคอขวดเร็วขึ้น หนำซ้ำยังทำให้ช้าลงไปอีกด้วย เช่น focus แต่การแก้ปัญหาของตัวเองแต่ส่งผลกระทบต่อภาพรวมให้แย่ลง (local optimization)

![Bottleneck throughput](/assets/2023-10-23-bottleneck-throughput.webp)  
[Theory of Constraints 101: Applying the Principles of Flow to Knowledge Work](https://medium.com/praxis-blog/theory-of-constraints-101-2d4d9cf1916a)

การเพิ่มความเร็วตรงคอขวดมีแนวปฏิบัติอยู่ด้วยกัน 5 ข้อ

1. **Identify the constraint** ค้นหาคอขวดในระบบให้เจอ
2. **Optimize the constraint** ปรับปรุงความเร็วของคอขวดจากสิ่งที่มีอยู่ในตอนนี้ (ดังนั้นการเพิ่มคนเพิ่มอะไรทั้งหลายแหล่ไม่นับ!) เช่น [กำจัดความสิ้นเปลืองตรงคอขวดออก]({% post_url 2023-10-18-7-wastes-of-software-development %}) เป็นต้น ผลลัพธ์จากข้อนี้คือส่วนที่ไม่ใช่คอขวดจะมี resource เหลือ
3. **Subordinate every other decision to the bottleneck** นำ resource เหลือจากส่วนที่ไม่ใช่คอขวดมาช่วยคอขวด เช่น ช่วยงานที่ priority สูงแต่ low value, ทุกส่วนงานต้องทำงานด้วยความเร็วเท่ากันกับความเร็วตรงคอขวดเพื่อไม่ให้ไปบีบตรงคอขวด, นำงานที่มี quality ดีเข้าตรงคอขวดเพื่อลดการ rework กลับไปกลับมา เป็นต้น
4. **Elevate the bottleneck** เพิ่มคน เพิ่มทักษะ เพิ่มเครื่องมือ ขั้นตอนนี้ทำเท่าที่จำเป็นเพราะมันแพง
5. **Continuous improvement** วนกลับไปทำข้อ 1 เพราะคอขวดจะเปลี่ยนที่ไปเรื่อย ๆ เกิดเป็น feedback loop ให้เราได้ปรับปรุงพัฒนาระบบต่อไป

ที่จริงแล้ว Theory of Constraints มีรายละเอียดเยอะกว่านี้มาก ๆ สามารถอ่านเพิ่มเติมใน Medium ที่เป็น series นี้ได้เลยครับ [Theory of Constraints by Tiago Forte](https://medium.com/forte-labs/theory-of-constraints-101-table-of-contents-8bbb6627915b)

## กลับมาที่ VDO
ใน VDO จะมีการสาธิตการเทน้ำออกจากขวดด้วย 3 วิธีด้วยกัน ซึ่งแสดงให้เห็นถึงคอขวดที่เกิดขึ้นและวิธีการจัดการกับมันตามแนวคิด Theory of Constraints  

ตามหลักการวิทยาศาสตร์แล้วเวลาเราเทน้ำออกจากขวด สิ่งที่เกิดขึ้นคือน้ำไหลจากบนลงล่าง (จะบอกทำไมใคร ๆ ก็รู้ ​ฮ่า ๆๆ) แต่ในขณะเดียวกันอากาศจะเข้าไปตรงขวดในส่วนที่ไม่มีน้ำ

### วิธีแรก: คว่ำขวดเทน้ำออกมาปกติ
สิ่งที่เกิดขึ้นคือตอนที่อากาศเข้าไปแทนที่น้ำ อากาศจะดันน้ำกลับขึ้นไป (เกิดเป็นฟอง) ทำให้น้ำที่ไหลออกมามีน้อยลง แสดงให้เห็นถึงการชนกันของอากาศและน้ำบริเวณคอขวดที่เกิดขึ้นในระบบ (**Identify the constraint**)

### วิธีสอง: หมุนขวดจนเกิดอากาศวนในขวด (vortex)
สิ่งที่เกิดขึ้นคือตอนที่อากาศเข้าไปแทนที่น้ำมันจะไม่ชนกันเองเหมือนวิธีแรกเนื่องจากอากาศก็จะวิ่งผ่านรูของอากาศวน ในขณะที่น้ำก็จะวนไปในทางเดียวกันทำให้น้ำไหลออกมาได้มากขึ้น แสดงให้เห็นถึงการจัดการกับ constraint ด้วยการ **Optimize the constraint** และ **Subordinate every other decision to the bottleneck**

### วิธีสาม: ใช้หลอดช่วยเป่าอากาศเข้าไป
สิ่งที่เกิดขึ้นคืออากาศเข้าไปผ่านหลอดด้วยปริมาณมากขึ้นทำให้อากาศเข้าไปตรงขวดในส่วนที่ไม่มีน้ำได้มากขึ้น เกิดเป็นแรงดันให้น้ำไหลออกมาเร็วขึ้น (และเร็วที่สุดใน 3 วิธี) แสดงให้เห็นถึงการจัดการกับ constraint ด้วยการ **Elevate the bottleneck** ก็คือเพิ่มหลอดและเป่าอากาศเข้าไปนั่นเอง

> จากตรงนี้น่าจะพอเห็นภาพแล้วว่า Theory of Constraints มันไม่ใช่การตัดคอขวดทิ้ง แต่เป็นการอยู่กับคอขวดโดบใช้ทรัพยากรที่มีอยู่ให้เกิดประโยชน์สูงสุดก่อนที่จะเพิ่มทรัพยากรเข้าไปเท่าที่จำเป็น คอขวดจะเปลี่ยนที่ไปเรื่อย ๆ ดังนั้นเราต้องมีการ monitor เพื่อปรับปรุงพัฒนาระบบต่อ ๆ ไป
