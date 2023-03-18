---
layout: post
title: "สรุปสิ่งที่ได้เรียนรู้จากการทำ project เกี่ยวกับ Backstage"
date: 2023-03-18
tags: [backstage, platform, developer-experience]
---

เมื่อช่วง 2 เดือนที่ผ่านมามีโอกาสได้เข้าร่วมกิจกรรมภายในบริษัทที่รวมกลุ่มกันนำเสนอ idea เจ๋ง ๆ ที่ช่วยลูกค้าและสังคม ซึ่งก็มีโจทย์ต่าง ๆ มากมายในองค์กรที่ต้องการจะริเริ่ม หนึ่งในนั้นก็คือเรื่องของ [Developer experience](https://developerexperience.io/articles/good-developer-experience) ที่ทีมของเราได้เข้าไปฟังปัญหาและมีความสนใจที่อยากจะแก้  

## พูดถึงปัญหาก่อน

ปัญหาที่มีในปัจจุบันคือด้วย trend ของ Developer experience ที่เกิดขึ้น ทำให้หลาย ๆ องค์กรหันมาลงทุนกับการสร้าง Internal Developer Platform เพื่อทำให้ชีวิตของ Developer ดีขึ้น ส่งผลดีหลายอย่างกับทั้งองค์กร ([อ่านบทความเพิ่มเติมเกี่ยวกับบทความเกี่ยวกับ Platform ได้ครับ]({% post_url 2023-02-19-platform-thinking %})) หนึ่งใน platform ที่ถูกนำมาใช้อย่างแพร่หลายก็คือ [Backstage](https://backstage.io/) ที่มีความสามารถหลัก ๆ คือ

- มีงานที่ต้องมาทำซ้ำ ๆ กัน เช่น เอกสารอ้างอิงไปถึง source code คู่การ deployment
- การค้นหาระบบที่ซับซ้อน เช่น ในองค์กรมีระบบอะไรบ้าง ใครเป็นเจ้าของ ต้องติดต่อใคร

แต่เมื่อบริษัทเข้าหาลูกค้าและเริ่มการพัฒนา Backstage กลับพบว่ามันต้องใช้เวลาเยอะและทำอะไรที่คล้าย ๆ กันซ้ำ ๆ กัน เช่น เชื่อมกับ CI/CD pipeline, version control, project management platform ต่าง ๆ ก่อนที่จะพัฒนาตามความต้องการของแต่ละองค์กรต่อไป ในขณะที่เขียนบทความนี้การพัฒนาใน Backstage ก็คือต้องเขียน code น่ะแหละ นั่นก็หมายความว่าบริษัทเราก็จะเสียเปรียบกับคู่แข่งในตลาดด้วยกัน และด้วยความที่ต้องเขียน code แปลว่ามันก็มี learning curve อยู่พอสมควร ทำให้กลุ่มคนที่จะเข้าหาลูกค้าในช่วงแรกต้องเข้าใจ Backstage ในระดับที่ลึกกว่าที่ควรจะเป็น

![Backstage adopters](/assets/2023-03-18-backstage-adopters.png)

## วิธีแก้ปัญหา
สิ่งที่เรานำเสนอก็คือเราจะสร้างเครื่องมือขึ้นมาที่จะช่วยประหยัดเวลาในการขึ้น Backstage project ใหม่ประกอบไปด้วย 4 feature หลัก ๆ (ถ้าจะเข้าใจทั้งหมด แนะนำว่าให้[ทำความเข้าใจ Backstage](https://backstage.io/docs/overview/architecture-overview) เบื้องต้นก่อนครับ)

- User สามารถเลือก integration, plugin ที่เราเตรียมไว้ให้เบื้องต้นได้ จากนั้นกรอกข้อมูลที่จำเป็น ผลลัพธ์ก็จะได้ Backstage project ที่มี code ให้พร้อม run แล้วก็จะได้ใช้ของที่ User เลือกไว้ก่อนหน้าเลย
- เวลาขึ้น project ใหม่ น่าเสียดายที่ Backstage ไม่ติดตั้ง search feature มาให้ ซึ่งเป็นสิ่งที่ใช้กันทั่ว ๆ ไป เราก็เลยตัดสินใจที่จะติดตั้งให้เลย โดยที่ User ก็สามารถเลือกว่าจะให้เชื่อม search กับแหล่งข้อมูลไหนได้บ้าง เช่น StackOverflow, Confluence, Google Drive เป็นต้น
- User สามารถใช้ [Code scaffolding](https://en.wikipedia.org/wiki/Scaffold_(programming)) ในการขึ้น application ใหม่ได้อย่างรวดเร็ว และใน code ก็จะแฝงเรื่องของ engineering practice เข้าไปด้วย เช่น coding standards, code analysis, secret management, security, CI/CD, architecture เป็นต้น
- User สามารถใช้เครื่องมือนี้ในรูปแบบของ web application ที่ไม่ได้แค่สร้าง Backstage project อย่างเดียว แต่ยังคงการจัดการ project lifecycle ไว้อยู่ เช่น ยังสามารถใช้ Backstage CLI ในการ upgrade dependencies version ได้

สิ่งที่บริษัทจะได้รับประโยชน์คือบริษัทจะใช้งบในการขึ้น Backstage project น้อยลง และสร้างความแตกต่างกับคู่แข่งในตลาดได้

![Backstage visual design](/assets/2023-03-18-backstage-visual-design.png)

## Timeline ในการทำงานกับทีม
ในการทำ project ทีมมีเวลา 2 อาทิตย์กว่า ๆ ในการปั่นให้ได้เป็นรูปเป็นร่างตามหัวข้อที่แล้ว โดยสิ่งที่ทีมได้ตัดสินใจทำมีดังนี้

- ทำ market research เกี่ยวกับ Backstage เพื่อเข้าใจ use case, project ที่คล้าย ๆ กัน, opportunity size, และมุมมองจาก business
- สัมภาษณ์ developer ที่เคยหรือกำลังทำ project ที่ใช้ Backstage อยู่ เพื่อเข้าใจ use case และ pain point
- ตกลงเรื่องของการทำ minimum viable project (MVP) ว่าทำอันไหน ไม่ทำอันไหนบ้าง
- ออกแบบ MVP จนได้ออกมาเป็น web application [wireframe](https://en.wikipedia.org/wiki/Website_wireframe) หน้าตาเรียบง่าย
- ค้นคว้าและพัฒนา MVP ออกมาจนได้ working software ใช้งาน feature หลักได้บางส่วน
- ทำ slide แบบเรียบง่ายแต่เนื้อหาชัดเจนโดยดู [Pitch deck ของ AirBnB](https://www.slideshare.net/PitchDeckCoach/airbnb-first-pitch-deck-editable) เป็นตัวอย่าง (แต่ไม่ได้ลอกมานะ ฮ่า ๆๆ)
- ทำ video สั้น 5 นาทีเพื่อพูดถึง project ของเรา 💥
- เข้า pitching session และตอบคำถามจากกรรมการ

## ผลลัพธ์
โดยรวมผลลัพธ์ก็ออกมาดีกว่าที่ทีมคาดไว้ โดยจบในลำดับที่ 2 และจะได้เข้ารอบไปต่อ ในส่วนของการตอบคำถามก็ยังต้องปรับปรุงเตรียมตัวให้มากขึ้นเนื่องจากคำถามส่วนใหญ่ไม่ได้เกี่ยวข้องกับตัวเครื่องมือ ไปเน้นเรื่องการขายแนวคิด platform ให้กับลูกค้า (Why platform?) มากกว่า ซึ่งเครื่องมือของเราไม่ได้ช่วยตรงนั้น แต่จะไปช่วยตอนที่เลือก technology ให้ได้เร็วขึ้น (What platform?)

## สิ่งที่ได้เรียนรู้
ตอนที่ทีมเราตั้งขึ้น สิ่งแรกที่ได้พูดคุยกันคือเป้าหมายของแต่ละคนในการเข้ามาทำ project นี้ โดยตกลงได้ว่า

> ทุกคนได้เรียนรู้เกี่ยวกับแนวคิดของ platform, Developer experience, Backstage มากขึ้นไม่มากก็น้อย

ส่วนตัวเราว่าเราได้ตามเป้าหมายนอกเหนือจาก platform thinking แล้ว ยังได้ลงมือทำ MVP ขึ้นมาด้วย โดยทำการต่อยอดจาก [@backstage/create-app](https://backstage.io/docs/getting-started/create-an-app/) CLI อีกที เราก็แค่ถอด logic ในส่วนของการสร้าง template และ compile code จาก input ของ User โดย library ที่ใช้คร่าว ๆ ก็จะมี

- [Commander.js](https://github.com/tj/commander.js) สำหรับสร้าง CLI เช่น รับ argument, สร้าง help command เป็นต้น
- [chalk](https://github.com/chalk/chalk) สำหรับตกแต่งเพิ่มสีสันให้ CLI
- [Inquirer.js](https://github.com/SBoudrias/Inquirer.js/) สำหรับทำ command ใน CLI ในรูปแบบ form
- [fs-extra](https://github.com/jprichardson/node-fs-extra) สำหรับจัดการ file system รองรับ [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [recursive-readdir](https://github.com/jergason/recursive-readdir#readme) สำหรับ list file แบบ recursive เพื่อทำ templating โดยไม่ต้องสนใจว่า file จะอยู่ใน directory ไหน อยู่ลึกขนาดไหน
- [handlerbars](https://handlebarsjs.com/) สำหรับทำ templating

นอกนั้นก็จะเป็นการเขียน integration และ plugin ของ Backstage โดยตัวที่หยิบมาใช้ก็จะมี

- [GitHub OAuth + repository](https://backstage.io/docs/integrations/github/locations)
- [Software catalog](https://backstage.io/docs/features/software-catalog/)
- [Software templates](https://backstage.io/docs/features/software-templates/)
- [Cloud Carbon Footprint](https://github.com/cloud-carbon-footprint/ccf-backstage-plugin/blob/trunk/README.md)
- [GitHub Actions](https://github.com/backstage/backstage/tree/master/plugins/github-actions)

> โดยรวมแล้วเป็นประสบการณ์ที่ดีที่ได้ลองทำงานกับเพื่อน ๆ ที่ไม่เคยทำด้วยกันมาก่อน และทุกคนช่วยเหลือกันดี ที่สำคัญสิ่งที่ทำมันเป็นงานนอกเวลา ทุกคนก็สละเวลาส่วนตัวมาช่วยกัน ผลลัพธ์ที่ออกมาก็ดีเกินคาดไปเยอะ ถ้าหลงเข้ามาอ่านก็ขอขอบคุณทุกคนมาก ๆ นะ ❤️

![Backstage retro](/assets/2023-03-18-backstage-retro.png)