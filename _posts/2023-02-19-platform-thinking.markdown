---
layout: post
title: "ว่าด้วยเรื่องของ Platform thinking"
date: 2023-02-19
tags: [platform, practice]
---

![Platform Manifesto](/assets/2023-02-19-platform-manifesto.jpeg)
<https://www.infoq.com/presentations/platform-manifesto/>

ปีที่แล้วเราไปเข้า conference มา 2-3 ที่ก็พบว่ามีผู้คนพูดถึงเรื่อง platform กันขึ้นมาเป็นคำศัพท์ใหม่ ๆ ราวกับ blockchain โดยจะมีคำแนะนำราว ๆ ว่า

> ทุกองค์กรควรจะให้ความสนใจ(และลงทุน)เกี่ยวกับ platform มากขึ้น

แต่จริง ๆ แล้วมันคืออะไรกันแน่ ประโยชน์คืออะไร องค์กรแบบไหนที่เหมาะสมกับการนำมันมาใช้ มีวิธีวางแผนจัดการกับ platform อย่างไร เราจะมาตอบคำถามเหล่านี้ผ่านความรู้และประสบการณ์ที่เราได้จากการเข้า project ใหม่นี้ดู

## Platform คืออะไร
Platform คือ techology ที่มีโครงสร้างพื้นฐานที่ใช้และช่วยในการสร้าง product และ service ให้กับทาง business ให้เร็วขึ้น โดยแบ่งกลุ่มได้เป็น 3 รูปแบบ

1. **Business platform** เช่น API ที่ให้ข้อมูลเกี่ยวกับ business เพื่อให้ง่ายต่อ product team ที่จะรวบรวมข้อมูลเพื่อต่อยอด product
2. **Platform business models** เช่น social media อย่าง Facebook ที่เป็นตัวกลางเชื่อมระหว่างผู้ให้บริการต่าง ๆ กับลูกค้า
3. **Developer-focused infrastructure platforms** เช่น เครื่องมือหรือแหล่งรวบรวมเอกสารที่ช่วยให้ Developer ส่งมอบงานได้รวดเร็วขึ้นโดยยังคงคุณภาพด้าน technical ไว้อยู่

โดยบทความนี้เราจะเน้นไปที่ **Developer-focused infrastructure platforms** กัน (ต่อไปนี้จะขอเรียกสั้น ๆ ว่า **platform** ละกัน) มีหลักการที่น่าสนใจหลายข้อ

- **Foundation**: ถึงแม้ว่า platform เหล่านี้จะไม่ได้ออกสู่สายตาลูกค้าปลายทาง แต่มันก็ช่วยให้ Developer ส่งมอบคุณค่าให้ลูกค้าปลายทางได้เร็วขึ้น นั่นหมายความว่าถ้ามี platform ที่ดี ลูกค้าก็จะมีแนวโน้มที่ได้รับประโยชน์จากการใช้งาน product เร็วขึ้นนั่นเอง
- **Self-service, reduced coordination**: เวลาเราบอกว่าระบบมันเป็น self-service ก็จะหมายถึงว่าลูกค้าจะสามารถใช้งาน platform ได้โดยที่ team ที่ดูแล platform ไม่กลายเป็นคอขวดจากการต้องขอ approval ต่าง ๆ นา ๆ
- **Knowledge**: การที่ platform จะประสบความสำเร็จจะพึ่งเครื่องมืออย่างเดียวไม่ได้ จะต้องมีการแบ่งปันความรู้ที่เกี่ยวข้องว่า platform เหล่านี้มันมาช่วยให้ชีวิตผู้ใช้งาน ในแต่ละวันให้ดีขึ้นได้อย่างไร
- **Support**: การที่ platform จะประสบความสำเร็จจะพึ่งเครื่องมืออย่างเดียวไม่ได้ จะต้องมีการช่วยเหลือผู้ใช้งานด้วย
- **Compelling**: ผู้ใช้งานจะต้องเห็นว่า platform เป็นทางที่ดีที่สุดที่จะช่วยแก้ปัญหาโดยที่ไม่รู้สึกถูกบังคับขืนใจมาใช้
- **Product**: เช่นเดียวกับ product อื่น ๆ แนวคิดเรื่องของ [product thinking](https://www.thoughtworks.com/en-th/perspectives/edition6-product-innovation/article) และสำคัญมาก ๆ คือการเชื่อมคุณค่าของ technology กับ business เข้าด้วยกัน 
- **Reduction in cognitive load**: Platform จะต้องช่วยลดการปวดหัวกับการตัดสินใจหรือการประสานงานกับคนนู้นคนนั้นเพื่อแก้ปัญหา เอาเวลาและแรงไปส่งมอบคุณค่าให้ลูกค้าปลายทางจะดีกว่า

> "An internal developer platform is a foundation of self-service APIs, tools, services, knowledge and support which are arranged as a compelling internal product. Consumers of the platform, other delivery teams, can make use of the platform to deliver product features at a faster pace, with reduced coordination and an ongoing reduction in cognitive load." - Evan Bottcher

## ทำไมองค์กรถึงควรมาสนใจเรื่อง platform
องค์กรที่ควรมาสนใจเรื่อง platform จะมีสัญญาณบางอย่างตามนี้
- Architecture มีความซับซ้อน จะต้องมีค่าใช้จ่ายในการดูแลรักษามากขึ้น
- จำนวนของ product และทีมมีเยอะขึ้นเป็นจำนวนมาก เริ่มไม่สัมพันธ์กับโครงสร้างขององค์กรและ culture ที่เป็นอยู่
- ทีมเริ่มที่จะต้องมาทำงานเดิมที่ไม่ได้เกี่ยวข้องตรง ๆ กับ business ซ้ำ ๆ คล้าย ๆ กัน
- ทีมใช้เวลาในการส่งมอบคุณค่าให้ business จากการสร้าง service ใหม่ ๆ ได้ช้าลงเพราะต้องพึ่งทีมอื่น ๆ
- องค์กรมีความต้องการที่จะกำหนด cross-functional requirement เช่น security, privacy, reliability ให้บังคับใช้ทั้งองค์กร
- ทีมเริ่มนำเครื่องมือและ technology ใหม่ ๆ มาใช้งานได้ยากขึ้นถึงแม้จะรู้ว่ามันดีกว่าของเก่า

แต่ละ platform อาจจะไม่ได้ช่วยแก้ปัญหาข้างต้นได้ทุกอย่าง ดังนั้นการที่มี platform ทั้ง 3 รูปแบบรวมกัน จะมาช่วยแก้ปัญหาข้างต้นได้ตามนี้
- ลดค่าใช้จ่ายในการสร้าง ดูแลรักษาระบบที่ไม่ได้เกี่ยวข้องกับ business ตรง ๆ ซ้ำ ๆ คล้าย ๆ กัน รวมถึงการ onboard ทีมใหม่ ๆ
- การตอบโจทย์ cross-functional requirement ทำให้ง่ายขึ้นผ่าน platform ทำให้ทีมอื่น ๆ อยากมาใช้ platform บ้าง
- การใช้งานเครื่องมือ service และ data ใหม่ ๆ ในองค์กรเป็นไปได้ง่ายขึ้นผ่าน platform

## องค์กรแบบไหนที่(ไม่)เหมาะสมกับการนำมันมาใช้
ในหัวข้อที่แล้วเราพูดถึงสัญญาณที่องค์กรควรจะนำ platform มาใช้ เรามาดูกันว่าแล้วองค์กรแบบไหนที่ไม่ต้องเอา platform มาใช้ก็ได้ เพราะนอกจากจะให้คุณค่าของ platform น้อยลงแล้วยังเสียแรงเสียเวลาสร้าง platform อีกด้วย

- องค์กรที่มีจำนวนของ product น้อย และทีมเล็ก
- องค์กรมีการใช้งาน technology ที่หลากหลายยิบย่อยมาก
- องค์กรอยู่ในช่วงของการทดลองหรือค้นหาอะไรใหม่ ๆ ยังไม่เป็นรูปเป็นร่าง

Platform ไม่สามารถใช้ในการแก้ปัญหาทุกอย่างที่มีในองค์กรได้ ซ้ำไปกว่าเดิมหากองค์กรเรายังมีปัญหาต่าง ๆ ต่อไปนี้ก็ขอให้แก้ก่อนที่จะนำ platform มาใช้

- **Engineering practice ที่ต่ำ**: ถึงแม้ว่า platform จะช่วยนำพาไปหา practice ที่ดีได้ในระดับนึง แต่ก็ไม่ได้แก้ปัญหาที่สร้างขึ้นจาก practice ที่แย่อยู่ดี วิธีแก้ที่ถูกคือการสอนและให้ความรู้กับคนในองค์กร
- **โครงสร้างขององค์กรที่ไม่เหมาะสม**: ต่อให้มี platform ก็ไม่ได้ช่วยให้่เป้าหมายของ Dev (ส่งมอบคุณค่าให้เร็วที่สุดเท่าที่จะเป็นไปได้) กับ Ops (ทำให้ระบบเสถียรไม่ล่ม) ตรงกันได้ ซึ่งมันเกิดจากรูปแบบขององค์กรที่ไม่ได้เอื้อต่อการส่งมอบและมีการสื่อสารที่ดีจากกฎ [Conway’s law](https://en.wikipedia.org/wiki/Conway%27s_law)
- **การจัดลำดับความสำคัญของงานที่จะต้องส่งมอบได้ไม่ดี**: platform มีหน้าที่แค่ช่วยให้การค้นคว้าทดลองเร็วขึ้น ส่งผลทางอ้อมให้เห็นภาพในการจัดลำดัญงานจากความเป็นไปได้ที่ชิ้นงานจะเป็นจริง (feasibility)
- **การตัดสินทางด้าน architecture และ technology ที่แย่**: หนำซ้ำ platform อาจจะทำให้ปัญหานี้แย่ลงเนื่องจากแทนที่ผู้ใช้จะต้องมาเจอปัญหาเหล่านี้ด้วยตัวเอง ตัว platform กลับซ่อนมันไว้ใต้พรม

## มีวิธีวางแผนจัดการกับ platform อย่างไร
การที่จะสร้าง platform ที่ประสบความสำเร็จควรเริ่มจากข้อต่าง ๆ ดังนี้

### 1. Focus กับ Developer Experience
ควรจะสื่อสารและตกลงกับองค์กรให้ clear ว่า platform จะมาแก้ [Developer Experience (DX)](https://developerexperience.io/articles/good-developer-experience) ส่วนไหน ไม่แก้ส่วนไหนบ้าง โดยตลอดทางเราจะต้องเน้นย้ำและยึดตามจุดประสงค์ของการมี platform ไม่ให้หลงทางไปไกล

### 2. ทำให้องค์กรสนับสนุน platform เป็นที่รู้จักของคนในองค์กร
โดยคนที่จะมาดูแล platform ก็จะต้องมีประสบการณ์ที่เหมาะสมเพื่อที่จะเข้าใจหัวอกของผู้ใช้งานซึ่งก็คือ Developer นั่นเอง คำถามคือแล้วอะไรคือเหมาะสมบ้างล่ะ คำตอบคือมันจะต้องสอดคล้องไปกับปัญหาที่เราจะแก้ (capability) นั่นเอง เช่น

- Discoverability and collaboration
- Testing and quality automation
- Security
- Build, deploy and release
- Runtime and data
- Application building blocks
- Operations

### 3. กำหนดเกณฑ์การวัดความสำเร็จ และตรวจวัดอย่างสม่ำเสมอผ่าน feedback จากผู้ใช้งาน
คำถามคือแล้วเกณฑ์ที่ว่านั้นมันมีอะไรบ้างละ

#### Business metrics
- เวลาที่ใช้ไปในการส่งมอบคุณค่าให้ลูกค้าลดลงไหม เน้นไปที่การสร้าง product และ service
- รายรับ-รายจ่ายขององค์กรทั้งระยะสั้นและยาวดีขึ้นไหม

#### Customer/Talent metrics
- Developer experience ดีขึ้นไหม
- Developer มีความสุขที่จะอยู่ในองค์กรต่อมากน้อยขนาดไหน

#### Technology metrics
- จำนวนการใช้งาน platform ในการแก้ปัญหาคล้าย ๆ กันซ้ำ ๆ กัน
- [Four key metrics](https://www.thoughtworks.com/en-th/radar/techniques/four-key-metrics)

### 4. เริ่มต้นด้วยการเลือก use case ที่เหมาะสม
โดย use case นั้นจะต้องแก้ปัญหาที่ครอบคลุมผู้ใช้งานได้มากที่สุดด้วยเวลาที่สั้นที่สุด (thinnest slice of viable platform) และค่อย ๆ เพิ่ม slice ใหม่เข้าไปเรื่อย ๆ คำถามคือแล้วหน้าตาของ slice มันจะเป็นอย่างไร คำตอบคือ slice นึงจะประกอบไปด้วย 3 อย่าง ได้แก่

#### Capability
คำอธิบายแบบกว้าง ๆ ว่า slice นี้ทำแล้วจะได้อะไร เช่น Safe deployment and rollout เป็นต้น

#### Domain
กลุ่มของ capability ที่เกี่ยวข้องกัน เช่น Build, deploy and release domain ก็จะมีอย่างเช่น

- Safe deployment and rollout
- CI/CD pipeline
- Feature toggles

#### Offerings
คือวิธีการทำเพื่อสร้าง capability ขึ้นมา เช่นการทำ Safe deployment and rollout จะต้องใช้แนวคิดอย่าง

- [Blue-green deployment](https://en.wikipedia.org/wiki/Blue-green_deployment)
- [Canary deployment](https://en.wikipedia.org/wiki/Feature_toggle#Canary_release)
- [Rolling deployment](https://en.wikipedia.org/wiki/Rolling_release)

จุดประสงค์ที่มีทั้ง 3 อย่างนี้คือเพื่อให้ทุกคนเห็นวิธีการแก้ปัญหาจาก offerings และทำให้เห็น roadmap ของ platform คร่าว ๆ จาก capability ที่เกี่ยวข้องกันใน domain เดียวกัน

### 6. สร้าง product management ที่แข็งแกร่ง
ที่จะช่วยให้ทีมค้นหาสิ่งใหม่ ๆ ที่จะมาช่วยผู้ใช้งานให้ใช้งาน platform ได้ราบรื่นมากขึ้น คำถามคือนอกจาก metrics แล้วยังต้องมีอะไรอีกบ้าง

- **Platform roadmap** โดยเน้นไปที่ priority impact กว้างครอบคลุมผู้ใช้งานได้กว่าง และต่อรองได้น้อย เช่น security เป็นต้น โดยนำเสนอในรูปแบบที่ทำให้องค์กรเห็นถึงความสัมพันธ์ของ value-impact รวมถึง capability ที่เกี่ยวข้องกัน ผลที่ได้คือองค์กรจะเห็นความสำคัญของ capability นั้น ๆ

![Roadmap tree](/assets/2023-01-19-roadmap-tree.png)
<https://up.com.au/tree/>

- **Support and documentation** ที่ช่วยทำให้การใช้งาน platform เป็นไปได้อย่างราบรื่น ในการจัดการเอกสารเราสามารถใช้ technique เข้ามาช่วยได้อย่าง [Documentation quadrants](https://documentation.divio.com/)
- **New ways of working and team structures** องค์กรอาจเกิดการเปลี่ยนแปลงโครงสร้างและแนวทางการทำงานเพื่อขับเน้นประโยชน์ของ platform ให้สูงที่สุด อย่างเช่นการพัฒนา software ด้วย agile ก็จะไม่ใช่เพียงแค่ IT แผนกเดียวที่จะต้องเป็นคนเปลี่ยนละ
- **Short feedback loops** จาก metrics ที่เราเก็บจากผู้ใช้งาน โดยให้เน้นไปที่ผู้ใช้งานแรก ๆ เพราะพวกเค้าจะเห็นภาพของ platform ได้มากที่สุด จากนั้นก็ปรับเปลี่ยนให้ platform โตไปตามนั้น เพื่อให้ business เห็นคุณค่าของมี platform ในองค์กร

> ทั้งหมดที่ว่ามาในบทความนี้คือ **Platform thinking** ที่จำเป็นต่อการสร้าง platform เนื่องจาก platform ก็เหมือนกับ product อื่น ๆ ที่จะต้องดูแลรักษาให้เติบโตอยู่กับองค์กรไปอย่างยาวนานเพื่อส่งมอบคุณค่าให้กับผู้ใช้งานอย่างต่อเนื่อง

## Further readings
- [The enterprise guide to platform thinking](https://www.thoughtworks.com/content/dam/thoughtworks/documents/guide/tw_guide_enterprise_guide_to_platform_thinking.pdf)
- [The Platform Manifesto](https://www.infoq.com/presentations/platform-manifesto/)