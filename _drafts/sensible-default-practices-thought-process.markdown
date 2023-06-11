---
layout: post
title: "ว่าด้วยเรื่องของกระบวนความคิดกว่าจะมาเป็น engineering practices ต่าง ๆ"
date: 2023-06-11
tags: [practice]
---

![LeSS Thailand Meetup](/assets/2023-06-11-less-thailand-meetup.webp)

เมื่อเดือนก่อนมีโอกาสได้ไปเข้างาน LeSS Thailand Meetup ครั้งที่ 3 ในหัวข้อ [Social Team Practices that Require Technical Skill by Bas Vodde](https://www.meetup.com/large-scale-scrum-less-thailand/events/293778207) โดยรวมแล้วเป็นหัวข้อที่เนื้อหาไม่ใหม่ แต่เป็นการเชื่อมโยงแนวคิดพื้นฐานที่นำมาสู่แนวทางปฏิบัติ engineering practices ได้ เลยสรุปมาไว้ใน blog นี้หน่อย

## พูดถึง Technical practices

> Technical practices == Social team practices that require technical skills

เวลาเราพูดถึง [technical practices]({% post_url 2022-04-19-9-practices-for-4-key-metrics %}) เช่น test-driven development (TDD), test automation, Continuous Integration (CI) กับเหล่า business หรือ project managers ก็จะดูเป็นสิ่งที่ "มีก็ดี ไม่มีก็ได้" เพราะมันเป็นแนวทางปฏิบัติที่ส่งเสริมต่อคุณภาพของการส่งมอบ software สุดท้ายแล้วคนสนใจแค่ "software ที่มัน work" ก็พอ หรือถ้าเข้าสถานการณ์คับขันก็ต้องละทิ้ง quality ออกไปถ้าจำเป็น  

ในทางกลับกัน business หรือ project managers ก็อยากปรับองค์กรเข้ากับการเปลี่ยนแปลงตามกระแสโลกให้เร็วขึ้น ดังนั้นองค์กรจึงต้องพัฒนา software ที่สามารถตอบสนองต่อการเปลี่ยน requirement ได้เร็วขึ้น ซึ่งมันจะเร็วหรือช้านั้นขึ้นอยู่กับ 2 สิ่งได้แก่

1. **Learning**: ยิ่งทีมมีความรู้ความเข้าใจใน software จากการเรียนรู้กันและกันมากเท่าไร ก็ยิ่งแก้ software ได้เร็วขึ้นมากเท่านั้น
2. **Cost of change**: ยิ่งทีมต้องออกค่าใช้จ่ายในการพัฒนา (ในรูปแบบของแรง เงินและเวลา) มากเท่าไร ก็ยิ่งปรับแก้ software ได้ช้าลง

## Learning
Learning มันก็จะขึ้นอยู่กับ **Work-in-progress (WIP)** เพราะยิ่งทีมต้องถือจำนวนงานที่ต้องทำพร้อมกันมากเท่าไร ก็จะเกิดการเรียนรู้ได้น้อยลง ทำให้แก้ software ได้ช้าลง เพราะต่างคนต่างทำกันมากขึ้นทีมไม่มีเวลามาพัฒนาร่วมกัน  

จึงเป็นที่มาของแนวปฏิบัติอย่าง [Pair development](https://en.wikipedia.org/wiki/Pair_programming) เนื่องจากพอมาทำคู่กันก็ทำให้มีเวลามาพัฒนาร่วมกันมากขึ้น ทำให้เกิดการเรียนรู้มากขึ้นนั่นเอง และในการพัฒนา software โดยมากเราก็จะทำเป็นทีม เราจะได้เรียนรู้สิ่งใหม่ จากการทำงานเป็นทีมมากกว่าคนเดียวเนื่องจากมีหลายคนช่วยกันเรียนแล้วมาแบ่งปันความรู้กันต่อไป  

นอกจากแนวปฏิบัติแล้ว การทำงานแบบ remote working ก็มีส่วนทำให้ทีมใช้เวลาทำงานร่วมกันน้อยลงเนื่องจากแต่ละคนอยู่ในพื้นที่ส่วนตัวทำให้เกิดการแลกเปลี่ยนเรียนรู้กันน้อยลง วิธีแก้เท่าที่เคยเห็นก็จะมี [always-on video conference](https://teachingsupport.forestry.ubc.ca/files/2020/12/Tip-Sheet_-Creating-an-Always-Available-Meeting-in-Zoom.pdf)  

การแบ่งงานก็มีความสำคัญเนื่องจากขนาดของการแบ่งงานมีผลต่อเวลาที่ทีมทำงานด้วยกัน สมมติว่าเราพัฒนา web application
- ถ้าเราแบ่งงานซอยย่อยมาก ๆ เช่น เปลี่ยน HTML, เปลี่ยน CSS สามารถทำคนเดียวเสร็จภายในเวลาแปบเดียวทำให้เวลาทำงานร่วมกันน้อยลง
- ถ้าเราแบ่งงานใหญ่มาก ๆ เช่น เปลี่ยน frontend, เปลี่ยน backend โดยมากต้องทำเป็นทีมหรือเป็นคู่ทำให้เวลาทำงานร่วมกันมากขึ้น

## Cost of change
ค่าใช้จ่ายในการพัฒนา software มักจะเกิดมาจาก 2 ปัจจัยได้แก่

1. **Ease of change**: software มันเปลี่ยนยากง่ายขนาดไหนก็ขึ้นอยู่กับ code ด้วย ยิ่งได้ code ที่เรียบง่ายเท่าไรก็ยิ่งประหยัดค่าใช้จ่าย
2. **Faster feedback**: ยิ่งเราพัฒนาแล้วรู้่ว่าระบบมัน work ไม่ work เร็วขนาดไหน ก็ยิ่งประหยัดค่าใช้จ่ายเช่นเดียวกัน

ถ้าอยากจะปรับให้ได้ code ที่เรียบง่ายแล้วจะมั่นใจได้ไงว่ามันทำงานถูกต้องเหมือนก่อนที่จะปรับ จึงเป็นที่มาของแนวปฏิบัติอย่าง [Test-driven development](https://en.wikipedia.org/wiki/Test-driven_development) ถ้าทำถูกต้องจะเกิด code ที่ออกมาเรียบง่ายแล้วเพียงพอที่จะผ่านการทดสอบนั่นเอง  

เราจะรู้ว่าระบบมัน work ไม่ work เร็วก็ขึ้นอยู่กับขนาดของการเปลี่ยนแปลง ยิ่งเราทยอยเปลี่ยนแล้วทดสอบทีละน้อย ๆ (incremental design) ถ้าเกิดข้อผิดพลาดเราก็จะเจอได้ไวขึ้นเพราะจุดที่ต้องไปตรวจสอบมันมีขนาดเล็ก จึงเป็นที่มาของแนวปฏิบัติอย่าง
- [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration)
- [Fast automated build](https://en.wikipedia.org/wiki/Build_automation)

นอกจากนั้นยังมีแนวปฏิบัติอื่น ๆ ที่สอดคล้องกับ incremental design ตามแนวคิด [Extreme programming](https://en.wikipedia.org/wiki/Extreme_programming) ด้วยอย่างเช่น
- [Test-Commit-Revert](https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864)
- [Limbo](https://medium.com/@kentbeck_7670/limbo-scaling-software-collaboration-afd4f00db4b)

## สรุป 
เมื่อการทำงานเกิดเป็นทีมที่เป็นสังคมที่ทุกคนต้องอยู่ร่วมกัน จะอยู่ด้วยกันอย่างไม่วุ่นวายก็ต้องมีกฎระเบียบจากแนวทางปฏิบัติดังที่กล่าวมา ส่งผลให้ทุกคนมีหน้าที่ความรับผิดชอบร่วมกันในทีม เกิดการเรียนรู้ซึ่งกันและกันให้บรรลุไปถึงเป้าหมายของค์กรคือสามารถปรับเข้ากับการเปลี่ยนแปลงตามกระแสโลกให้เร็วขึ้น

> Technical practices are team practices, can't separate from each other.
