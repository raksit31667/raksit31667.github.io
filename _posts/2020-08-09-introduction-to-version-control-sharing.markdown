---
layout: post
title:  "บันทึกการแบ่งปันเรื่อง Version Control ในบริษัท"
date:   2020-08-09
tags: [version-control, git, cicd]
---

เมื่อวันศุกร์ที่ผ่านมาผมได้รับโอกาสไปแบ่งปันเรื่อง Introduction to Version Control ให้กับเพื่อนๆ พี่ๆ น้องๆ ในบริษัท เป็นครั้งแรกเลยที่สอน technical เป็นภาษาอังกฤษ ใช้เวลา 2 ชั่วโมง ต้องเตรียมตัวเยอะพอสมควร ~~เพราะถนัดการพูดเรื่องง่ายๆ ให้เป็นเรื่องยากๆ ฮ่าๆๆๆ~~ เลยขอเอามาสรุปให้ดูคร่าวๆ กันครับ

## เริ่มจาก Version Control คืออะไรกันก่อน
คร่าวๆ คือเป็น software ที่ช่วยเก็บประวัติและการเปลี่ยนแปลงของไฟล์ ซึ่งสามารถกลับมาเรียกดูได้ตลอดเวลา ใน session ผมได้ยกตัวอย่างมา 4 สถานการณ์

1. **Backups** ระหว่างที่เราทำงานอยู่ สมมติเราเผลอไปลบไฟล์ แต่ดันไม่มีไฟล์สำรองอะไรไว้เลย หายนะก็เกิดขึ้นทันที หรือต้องไปเสียเวลากู้ไฟล์ version control จะช่วยเก็บ backups ให้ ดังนั้นเราสามารถกู้กลับมาได้

2. **History and Changes** สมมติว่าเราโดนย้ายไปทำอีกโปรเจคนึงเป็นเวลาครึ่งปี กลับมาก็ลืมไปละว่าทำอะไรไปบ้าง หรือโค้ดแบบนี้มาได้ยังไง version control จะเก็บ history และ change ทั้งหมด ดังนั้นเราสามารถเรียกดูได้เป็นบรรทัดต่อบรรทัดตามต้องการเลย

3. **Experiment** เรามีไอเดียเจ๋งๆ แต่ไม่อยากไปแก้งานหลัก เพราะเพื่อนๆ ก็ใช้อยู่ กลัวพัง version control เค้ามีที่ไว้ให้เราเล่น จะแก้อะไรก็จะไม่โดนงานหลัก (มันคือ branching ใน Git นั่นเอง)

4. **Collaboration** เนื่องจากเราสามารถแก้โค้ดไฟล์เดียวกันพร้อมกันได้เลย เดี๋ยว version control มันจะแยกหรือให้เราตัดสินใจว่าจะเอาโค้ดใครขึ้น

## ความแตกต่างระหว่าง Centralized vs Distributed
*หลักๆ ก็คือเรื่องของ internet เนี่ยแหละ* เพราะ Centralized VCS ต้อง sync ขึ้น remote server ตลอดเวลา แถมถ้าไม่มี internet ก็ทำงานต่อไม่ได้เลย แต่ Distributed เค้ามี file ที่ mirror มาจาก remote server ไง ดังนั้นทีมก็ทำในเครื่องตัวเองก่อนได้ แล้วพอจะ sync ค่อยรันคำสั่ง  

แต่ Centralized เค้าก็มีข้อดีเรื่องความง่าย เพราะอย่างน้อยก็ไม่ต้องเรียน Git ฮ่าๆๆ ส่วนการดูแลก็ง่ายเพราะมีแค่ repo กลางอันเดียว

## ทำไมเราถึงใช้ Git ล่ะ
- เป็น Distributed VCS
- เร็ว
- ฟรี เป็น Opensource
- มี staging area ซึ่งเป็นโซนคล้ายๆ กับ confirmation area ป้องกัน human error เอา change ที่ไม่พึงประสงค์ขึ้นไป

## แบ่งคำสั่งที่ใช้งานเป็น 2 หมวด
### หมวด Basic Daily คือใช้แทบทุกวัน
[![asciicast](https://asciinema.org/a/352029.svg)](https://asciinema.org/a/352029)

### หมวด Advanced คือใช้ไม่บ่อยเท่าข้างบน แต่มีประโยชน์มาก
[![asciicast](https://asciinema.org/a/352037.svg)](https://asciinema.org/a/352037)

## พูดถึงเรื่อง utility file ของ Git กันบ้าง
- **.gitconfig** เก็บพวก configuration ของ Git หรือจะรันผ่านคำสั่ง `git config (--global) key value` ก็ได้นะ

- **.gitignore** ก็จะยกเว้นไฟล์หรือ directory บางอันที่ไม่ต้องการ track โดย Git เช่น build file หรือ secret หรือ configuration ต่างๆ

## มีโชว์การแก้ merge conflicts
จำลองสถานการณ์ developer 2 คน ผ่านการแก้บน local machine กับไปแก้บน GitHub ตรงๆ พอเอามา merge กันก็จะมี conflict ให้คำแนะนำไปว่า *ไม่ควรจะแก้ conflict คนเดียวนะ* อย่างน้อยมีอีกคนมาช่วยแก้น่าจะลดโอกาสพลาดได้เยอะกว่า

## พูดถึงเรื่อง DevOps บ้าง
คือ Version control มันเป็นจุดเริ่มต้นของ **collaboration** และ **integration** ของ development team ที่แแท้จริงเลย คำถามคือเราจะมั่นใจได้ไงว่า พอเอามารวมกันแล้ว มันยังทำงานได้อยู่เหมือนเดิม แนวคิด **Continuous Integration (CI)** จึงแนะให้เรา integrate โค้ดกันบ่อยๆ อย่างต่อเนื่อง เพื่อให้ได้รับ feedback ที่รวดเร็ว (ลองนึกถึงรวมแล้วได้ 2 commits มันน่าจะมีโอกาสที่จะหาว่า commit มันมีปัญหาได้เร็วกว่า 10 commits นะ)

## ปิดท้ายด้วย Productivity tools
แน่นอนว่า developer ย่อมต้องขี้เกียจอย่างฉลาด หาของมาทำให้ชีวิตสบายขึ้น ที่แนะนำมี
- Text editors และ IDEs
- [GitKraken](https://www.gitkraken.com/)
- [gitignore.io](https://www.toptal.com/developers/gitignore)

ยังไม่รวมพวก [git-standup](https://github.com/kamranahmedse/git-standup) หรือ [oh-my-zsh](https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh) นะ มีอีกเยอะ

> ตัวอย่างโปรเจคที่ใช้ demo <https://github.com/raksit31667/git-practice>



