---
layout: post
title: "บันทึกครั้งแรกกับการพูดใน public conference"
date: 2023-12-27
tags: [soft-skill, platform, talk]
---

ผ่านมาแล้ว 3 เดือนหลังจากการพูด public conference ครั้งแรกในงาน [XConf Thailand 2023](https://medium.com/nontechcompany/xconf-thailand-2023-summary-df72279e26d9) เป็นหนึ่งในเป้าหมายเล็ก ๆ ในปีนี้ที่ทำได้สำเร็จแล้วผลตอบรับได้ดีเกินคาด สำหรับใครที่ยังไม่รู้หรือยังไม่ได้ฟัง talk ของผมกับเพื่อน [Michael](https://th.linkedin.com/in/mlongerich) ในหัวข้อ **Our adventure in building an internal developer platform** ก็ไปเสพกันใน Youtube ได้ครับ (สารภาพว่าหลังจาก talk ก็ไม่เคยกลับไปฟังตัวเองอีกเลย ฟังตัวเองพูดแล้วมันแปลก ๆ ฮ่า ๆๆ)

<iframe width="560" height="315" src="https://www.youtube.com/embed/Wymz1-xInvs?si=ndkOXrHPLYzMwGe4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

ในบทความนี้ไม่ได้แค่จะมาอวด talk เท่านั้นเพราะสิ่งที่ประทับใจที่สุดใน talk ไม่ใช่ 40+ นาทีของตัว talk เอง แต่เป็นการเตรียมตัว เนื้อหา ความรู้ประสบการณ์ในการเตรียม talk เป็นร้อย ๆ ชั่วโมงต่างหาก ก็เลยขอบันทึกไว้เพื่อนำ technique และประสบการณ์ไปใช้กับ talk ถัด ๆ ไปที่จะเกิดขึ้นในอนาคต

## ช่วงส่งหัวข้อ
จุดเริ่มต้นคือมาจากการได้เข้าไปทำ project ที่เกี่ยวกับ internal developer platform ให้กับลูกค้าเจ้านึงซึ่งเป็นหนึ่งในประสบการณ์ที่ดีที่สุดในอาชีพเลย บวกกับว่ามันเป็นศาสตร์ที่เราชอบด้วยก็เลยลงแรงแบบจัดหนักกับ project นี้เพื่อเรียนรู้และเก็บเกี่ยวกับประสบการณ์ พอทำไป 3 เดือนแล้วพบว่ามันมีความรู้และประสบการณ์ที่น่าจะไป share นะ ก็เลยวางแผนว่างั้นเดี๋ยวไป share ใน talk ของบริษัทที่จัดทุกเดือนเอาละกัน แต่ก็ต้องล้มแผนเพราะบริษัทกำลังหา speaker ไปพูดในงานใหญ่ประจำปีและพี่ในทีมก็ช่วยกล่อมให้ออกจาก comfort zone ก็เลยตัดสินใจส่งหัวข้อไป  

ทีนี้จุดที่ยากที่สุดคือเราต้องเตรียม abstract เนี่ยแหละ ก็ไม่แน่ใจว่าจะพูดอะไรดี เนื้อหามันควรจะเป็นยังไง ความตื้น-ลึกของ technical เป็นยังไง จะใช้เวลาพูดเท่าไร ซึ่งคำตอบของคำถามพวกนี้คือ "ไม่รู้" ผลคือก็ส่งหัวข้อและเนื้อหาใน generate ผ่าน ChatGPT แบบกลวง ๆ ไป ส่วนเวลาก็ลอกคนอื่นเอา ฮ่า ๆๆ  

ขณะที่ส่งหัวข้อ เราไม่จำเป็นต้องเก่งหรือเซียนเกี่ยวกับเรื่องที่จะพูด เราไม่จำเป็นต้องมีเนื้อหาทุกอย่างใน talk แล้ว เดี๋ยวรายละเอียด ประสบการณ์มันจะตามมาจากการเตรียมเนื้อหานั่นเอง เพราะฉะนั้นอย่าไปกลัว ส่ง ๆ ไปก่อน ผ่านก็ดี ไม่ผ่านก็ไปพูดงานอื่น เราไม่ได้เสียอะไรเลย

> สรุปแล้วผลก็คือ "ผ่าน" ส่วนนึงคงเป็นเพราะว่าพี่ในทีมคือคนที่คัดเลือก talk นั่นแหละ ฮ่า ๆๆ

## ช่วงเตรียมเนื้อหา
อย่างที่กล่าวไปในช่วงก่อนหน้า การเตรียมเนื้อหาเป็นเรื่องยากเพราะ talk มันคือเรื่องของประสบการณ์ ปัญหาคือเราไม่สามารถพูดทุกประสบการณ์ที่เราเจอได้ แต่ถ้าเราจำประสบการณ์ที่สำคัญไม่ได้ก็งานเข้าเหมือนกัน และการที่บริษัทให้เวลาเตรียมตัว 5-6 เดือน ก็เป็นดาบสองคม เพราะถึงแม้จะมีเวลาเตรียมตัวเยอะขึ้น แต่ก็ต้องแลกมากับความเสี่ยงที่เนื้อหาของเราจะถูก disrupt ด้วย technology ใหม่ ๆ ในระหว่างนั้นด้วย ดังนั้นส่วนมากแล้ววิธีที่เราใช้คือ

- เขียน blog เพื่อบันทึกประสบการณ์
- ทำ knowledge sharing ในทีมเพื่อแบ่งปันประสบการณ์ (แปลว่ามีการเตรียมเนื้อหาทีเดียว อาจจะได้ใช้ใน talk ด้วย)
- ทำ project ที่คล้าย ๆ กับงานจริงเพื่อสรุปความเข้าใจ (เอาไว้ใน GitHub เป็น portfolio ไปในตัว)
- ฟัง talk เกี่ยวกับเรื่องที่เราจะพูด โดยส่วนใหญ่เราจะฟังของ Thoughtworks และ [PlatformCon 2023](https://www.youtube.com/@PlatformEngineering/videos)

ขณะที่เตรียมเนื้อหาต้องยอมรับว่ามันจะต้องใช้เวลานาน หลีกเลี่ยงเรื่องเหล่านี้มารบกวนงานจริง ในขณะเดียวกันเราอาจจะหลีกเลี่ยงไม่ได้ที่จะต้องปันเวลานอกงานมาเตรียม แปลว่าเราต้องตัดสิ่งที่ทำบางอย่างที่ไม่ได้ทำให้ชีวิตของเราดีขึ้นออกไป (cut the bullshit)

## ช่วงเตรียม presentation
เมื่อได้เนื้อหาและประสบการณ์แล้วก็กลับมารวมกัน ก็จะมี discussion ที่เห็นด้วยและเห็นต่างเป็นเรื่องปกติ ขอให้เราอดทนให้เพียงพอในการทำเข้าใจและรับฟังคู่ของเราอย่างแท้จริง แน่นอนว่าเนื้อหาบางอย่างของเราอาจจะมีผิด-ถูก บางอันก็ตื้นเกินไปราวกับดูถูกสติปัญญาคนฟัง บางอันก็ลึกเกินไปคนฟังก็งง เป็นเรื่องปกติที่จะต้องตัดทิ้งหรือเพิ่มเติมแก้ไขครับ  

ในส่วนของ presentation แนะนำว่าอย่าเริ่มด้วยการทำเองทั้งหมดตั้งแต่ศูนย์ เราควรจะหา slide หรือ graphic ที่คนอื่นเคยทำไว้แล้วมาประยุกต์เข้ากับ talk ของเรา จะช่วยทุ่นแรงของเราได้พอสมควรเลย  

ในส่วนของ talk เราได้เรียนรู้ว่ามันมีคู่มือในการเตรียม talk หลากหลายรูปแบบ โดยเราใช้ [Pip Decks](https://pipdecks.com/) เป็นเครื่องมือในการช่วย โดย Pip Decks มันก็เป็นแค่ card ที่แนะนำ [Storyteller Tactics](https://pipdecks.com/pages/storyteller-tactics-card-deck) รูปแบบต่าง ๆ โดยเราจะต้องตอบคำถามเหล่านี้เพื่อ build talk ของเราขึ้นมา

![Storyteller Tactics](/assets/2023-12-27-storyteller-tactics.webp)

ผลลัพธ์ของการตอบคำถามคือเราจะได้ guideline ของ talk เราขึ้นมาราวกับเป็นการเล่าเรื่อง (storytelling) ที่มีหลากหลายรูปแบบ เช่น

- **Concept**: มี theme เหมือนกับการผจญภัย
- **Explore**: มีรูปแบบการเล่าเรื่องที่งงหรือซับซ้อนให้คนฟังเดินตามได้ง่าย
- **Character**: มีคนพูดเป็นตัวละครให้คนฟังสนใจ
- **Function**: มีจุดที่คนฟังสามารถนำเรื่องราวของเราไปใช้ เช่น ใช้ขายของ
- **Structure**: มีรูปแบบชัดเจนเหมือนการเล่านิทาน
- **Style**: มีสิ่งที่ทำให้คนจดจำ
- **Organise**: มีการจัดเรียงลำดับเนื้อหาให้จำได้ง่าย

## ช่วงซ้อม talk
ช่วงนี้ก็จะเป็นอีกช่วงที่จะต้องมีการปรับแก้เนื้อหาเหมือนกัน เพราะเวลาเราพูดไปมันจะเริ่มจะติด ๆ ขัด ๆ เพราะในหัวเราก็จะคิดไปด้วยว่า "คนฟังจะเข้าใจไหม" "มันลึกเกินไปไหม" "มันยืดยาวเกินไปไหม" ซึ่งเราสามารถตอบคำถามเหล่านี้ด้วยการซ้อมครับ โดยเราได้ใช้ technique เข้ามาเสริมให้การซ้อมมีประสิทธิภาพมากขึ้น

- มีการจับเวลาเพื่อฝึกให้ talk ไม่เกินที่กำหนด นอกจากฝึกน้ำเสียงและจำลำดับเนื้อหาแล้ว ยังเป็นการตัดเนื้อหาที่เวิ่นเว้อออกไปด้วย
- แต่ละ slide ให้ระบุจุดประสงค์ที่ต้องการจะสื่อ และระยะเวลาที่คิดว่าจะใช้ใน slide นั้น ๆ เพื่อให้เราไม่ต้องจำทุกอย่างใน slide แต่เน้นพูดจากความเข้าใจของเราแทนจะได้เป็นธรรมชาติ
- ให้ feedback กันและกันหลังจบการซ้อม
- มีการให้คนนอกหรือคนที่เคยพูดเรื่องคล้าย ๆ เรามาสังเกตการซ้อมพร้อมกับขอ feedback เพื่อปรับปรุง
- มีการวางแผนในกรณีเกิดเหตุไม่คาดฝัน เช่น ตัดบางส่วนออกเพื่อให้จบ talk ทันเวลา
- อัดการซ้อมแล้วกลับไปฟังดูเพื่อหาจุดปรับปรุงในครั้งถัด ๆ ไป

## ช่วงก่อน-หลัง talk ในวันนั้น
ก่อนพูดสักชั่วโมงนึงก็ไปดูสถานที่ จุดยืน ไฟ นาฬิกาจับเวลา clicker ก่อนเพื่อกันตกใจ ละก็ซ้อมอีกรอบนึงเพื่อความมั่นใจ (ส่วนตัวเรามั่นใจมาก ๆ ตั้งแต่ซ้อมแล้ว) พอไปงานจริงก็ประหลาดใจตัวเองว่าอาการตื่นตระหนก มือสั่นที่แต่ก่อนจะเกิดขึ้นทุกครั้งมันไม่เกิดในครั้งนี้ ทำให้เราสามารถพูดได้ไหลลื่นเหมือนกับที่ซ้อมเอาไว้เลย สุดท้ายก็จบในเวลาและผลตอบรับก็ดีเกินคาด  

และแน่นอนว่าหลัง talk เราก็ [share ลง social media อย่าง LinkedIn](https://www.linkedin.com/posts/raksit-mantanacharu-828866175_last-friday-michael-marcel-longerich-and-activity-7115991584948584448-wSxk?utm_source=share&utm_medium=member_desktop) เพื่อเก็บเป็น portfolio ของเราและเป็นการขอบคุณทุกคนที่มีส่วนร่วมใน talk ครั้งนี้ด้วย ไม่ใช่แค่คู่ซ้อมและคนสังเกต แต่รวมถึงเพื่อนร่วมทีมเก่าและลูกค้าที่เคยร่วมงานกัน ณ ตอนอยู่ project นั้น

## สิ่งอื่น ๆ ที่ได้จากการ talk
- บริษัทได้ชื่อเสียงว่ามีประสบการณ์ในการสร้าง internal developer platform
- สร้าง branding ของเราว่าเป็นคนมีประสบการณ์ด้าน internal developer platform
- ได้เรียนรู้สิ่งใหม่ ๆ ทั้ง hard skill และ soft skill ระหว่างการเตรียมเนื้อหา

![XConf talk](/assets/2023-12-27-xconf-talk.jpeg)

> ก็เป็นอีกหนึ่งในเป้าหมายเล็ก ๆ ในปีนี้ที่ทำได้สำเร็จ คำถามถัดมาคือ "พอถึงเป้าหมายแล้วยังไงต่อ" คำตอบง่าย ๆ สำหรับเราตอนนี้คือ "เราก็สร้างเป้าหมายใหม่สิ"