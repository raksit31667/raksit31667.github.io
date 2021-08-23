---
layout: post
title:  "สรุปสิ่งที่ได้เรียนรู้จาก workshop Software Architecture ปี 2019"
date:   2021-08-19
tags: [architecture]
---

เมื่อ 2 ปีที่แล้วได้มีโอกาสได้เข้า workshop เกี่ยวกับ Software architecture โดยคุณ [Liauw Fendy](https://au.linkedin.com/in/liauw-fendy) บทความนี้ผมจะสรุปสิ่งที่ผมได้เรียนรู้เกี่ยวกับแนวคิดของ architecture ในภาพที่กว้างขึ้นกว่าเดิม

## Software architecture คืออะไร

> "Architecture represents the **significant design decisions** that shape a system where **significant** is measured by **cost of change**." - Grady Booch

> "Software Architecture is a set of **significant design decisions** about how the software is **organised** to promote desired **quality attributes** and other properties." - Michael Keeling

มันคือการตัดสินใจที่สำคัญรวมๆ กันซึ่งแสดงให้เห็นถึงระบบที่ตอบโจทย์บางอย่างโดยความสำคัญนั้นวัดจากค่าใช้จ่ายในการเปลี่ยนแปลงนั่นเอง โดยมี keyword ที่น่าสนใจดังนี้

### Software architecture กับ Software design
เวลาเราพูดถึง **Design** มักจะนึกถึงแนวทางที่สร้างขึ้นมาเพื่อใช้แก้ปัญหาโดยเฉพาะ เช่น หน้าตาของ UI หรือ framework หรือภาษาที่ใช้ หรือ hardcode vs configuration แต่เวลาเราพูดถึง **Architecture** เรามักจะเน้นไปที่โครงสร้างว่าระบบมันมีอะไร มันเชื่อมกันอย่างไรด้วย  

ข้อสังเกตคือ ทั้งสองอย่างมันสร้างขึ้นมาเพื่อใช้แก้ปัญหาโดยเฉพาะเหมือนกัน แต่สิ่งที่ต่างกันคือ **Design** ตามตัวอย่างข้างบน มันไม่ได้มีผลอะไรต่อภาพใหญ่ หรือ **Architecture** เลย แต่ถ้าเราพูดถึง authentication หรือ Build vs Buy แน่นอนว่ามันก็อาจจะมีผลโดยตรงเพราะมันไปกระทบกับ quality attributes

> "All architecture is design but not all design is architecture." - Grady Booch

### Cost of change
แปลตรงๆ ก็คือค่าใช้จ่ายที่เกิดจากการเปลี่ยนแปลง ซึ่งมันจะมีในรูปของ เวลา โอกาส เงิน หรือจิตใจก็ได้นะ ซึ่งเป็นส่วนหนึ่งของสิ่งที่เรียกว่า "ต้นทุนจม" (sunk cost)

> Sunk cost คือ ค่าใช้จ่ายที่เสียไปแล้วไม่สามารถเรียกคืนมาได้ ไม่ว่าปัจจุบันจะเปลี่ยนไปมากเท่าไร

โดย Sunk cost ของ software architecture มีกันอยู่หลักๆ 2 อันคือ
- **การลงแรงทำ analysis**: ถ้าเรา analyse ผิด หมายความว่าเราก็ต้องเสียค่าใช้จ่ายในการ analyse อย่างอื่นเพิ่ม สิ่งที่น่าสนใจคือเราจะรู้ได้ไงว่าอันไหนถูกตั้งแต่แรก
- **งานที่ลงมือทำไปแล้ว**: ถ้าเรา analyse ผิดแล้วดันทำงานไปแล้วด้วย แปลว่าเราก็ต้องเสียค่าใช้จ่ายในการขยำงานนั้นทิ้งเลย

ปัจจัยที่ทำให้เกิด sunk cost มีอะไรบ้างหละ
- **Incomplete information**: รู้อะไรไม่สู้รู้งี้
- **Incorrect assumptions**: ตั้งสมมติฐานผิดจากการที่ได้ข้อมูลมาผิดๆ
- **Changing environments**: สิ่งที่เรารู้มามันเปลี่ยนไปแล้ว

### Quality attributes
มันคือสิ่งที่วัดคุณภาพของ software ในเชิง technical หรืออีกชื่อนึงคือ non-functional requirement ซึ่ง [ISO/IEC 25010](https://www.iso.org/obp/ui/#iso:std:iso-iec:25010:ed-1:v1:en) เค้าเรียงมาให้ดูประมาณนี้
![Quality attributes](/assets/2021-08-20-quality-attributes.png)

### Software organisation
ในการพัฒนา software นั้น ปัญหาที่ทีมพัฒนาเจอทำให้เกิดรูปแบบในการแก้ปัญหาที่เหมือนๆ กันเป็น pattern ซึ่งหลักๆ ก็ช่วยแก้ปัญหาในการดูแลรักษา หรือการแก้ไขเมื่อเกิดปัญหา ชื่อ pattern ที่อาจจะผ่านหูผ่านตามาบ้างก็อย่างเช่น layered architecture หรือ event-driven architecture หรือ microservices architecture

![Conway's Law](/assets/2021-08-20-conway-law.jpeg)

ทีนี้มันมีกฎที่ชื่อว่า [Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law) อยู่ซึ่งกล่าวถึงรูปแบบของ architecture สะท้อนให้เห็นถึงรูปแบบขององค์กรที่ทำอยู่ ซึ่งถ้าเรามองในมุมกลับกัน การที่ architecture มันจะเป็นรูปเป็นร่างได้มันก็ต้องมาจากรูปแบบขององค์กรที่ตอบโจทย์ด้วย

## Software architect คือใคร ทำอะไรบ้าง

Software architect จะทำการสวมบทบาท 6 อย่างไปด้วยกัน
- **Investigator**: **สืบสวนสอบสวน**เพื่อเข้าใจปัญหาก่อนที่จะเสนอแนวทางการแก้
- **Butcher**: **สับแบ่ง**ปัญหาออกเป็นปัญหาย่อยๆ
- **Tactician**: **วางแผน**ในภาพใหญ่ๆ
- **Judge**: **เข้าใจและตัดสินใจ**จากข้อดี-ข้อเสียที่มี (trade-offs)
- **Instructor**: **เพิ่มพูนความรู้**ด้าน architecture ให้กับคนอื่นๆ
- **Entepreneur**: **จัดการ**ความเสี่ยงและหนี้ทางเทคนิค (technical debt) ให้อยู่ในจุดที่สมดุล

โดย Software architect นั้นจะเล่นบทบาทโดยคำนึงถึง 3 มุมมอง ก็คือ business และ technical และ user
![Software architect](/assets/2021-08-20-software-architect.png)

## มีแนวคิดในการ design อย่างไร
สามารถสรุปได้เป็นตัวย่อ **HART** โดยมี 4 หัวข้อด้วยกัน ดังนี้
### 1. Design for **Humans**

> Process should serve people, not people serve process

แนวคิดที่ดีคือเราควรจะออกแบบมาเพื่อคนจริงๆ เพราะคนเนี่ยแหละจะได้เข้าใจ ไม่ใช่ว่าแค่ทำตามๆ design กันไปโดยที่ไม่เข้าใจว่ามัน design ไว้เพื่ออะไร ดังนั้นคำถามที่น่าสนใจที่บ่งบอกถึงหัวข้อนี้คือ

- **Fill people's needs?**: ไอ design นี้มันตรงกับความต้องการของคนไหม เช่น ออกแบบร่มมาแต่ดันทำจากปูน คือมันก็กันฝนได้แหละ แต่มันหุบไม่ได้เนี่ยสิ
![Concrete umbrella](/assets/2021-08-20-concrete-umbrella.jpeg)

[The Uncomfortable by kkstudio](https://www.pinterest.com/pin/456693218436463412/)

- **Easily understand?**: ถ้าเราออกแบบเพื่อคน มันก็ควรจะทำออกมาให้เข้าใจง่ายๆ ไหม

![Scramble drawing](/assets/2021-08-20-skribbl-io.jpeg)

- **Collaborative process?**: ไอการออกแบบเนี่ย มันมาจากความเห็นของทุกคนที่มีส่วนเกี่ยวข้องไหม ไม่ใช่เหตุการณ์แบบ "คนคิดไม่ได้ทำ คนทำไม่ได้คิด"

![Ivory tower](/assets/2021-08-20-ivory-tower.png)

[Connecting Research and Teaching: Discourse on New Education Paradigm](https://supporthere.org/sites/default/files/connecting_research_and_teaching.pdf)

### 2. Preserve **Ambiguity**

> Delay decisions to the last responsible moment

ในการตัดสินใจจากทางเลือกหลายๆ ทางที่มี เราอาจจะใช้ข้อสังเกตหรือสมมติฐานซึ่งไม่ได้เป็นความจริง 100% สิ่งที่เกิดขึ้นคือเมื่อเราชะลอการตัดสินใจ ทางเลือกนั้นก็อาจจะไม่ใช่อีกต่อไปก็ได้เนื่องจากเรารู้อะไรมากขึ้นนั่นเอง เช่น เรามีตัวเลือกอยู่ 3 อันก่อน COVID-19 lockdown ถ้าเราชะลอการตัดสินใจไปได้ หลัง COVID-19 lockdown เราอาจจะเหลือแค่ตัวเลือกเดียวเพราะไม่มี budget พอก็ได้

ปัจจัยอะไรบ้างที่ทำให้เราต้องชะลอการตัดสินใจออกไปบ้างหละ
- **Change**: เราหลีกเลี่ยงการเปลี่ยนแปลงไม่ได้อยู่แล้ว จึงไม่น่าแปลกใจที่แนวคิด Agile มาแรงเป็นเพราะมันสนับสนุนการลด cost of change ด้วยการจัดการกับความไม่แน่นอน (uncertainty)
- **Information**: ข้อมูลที่ได้มาตอนนี้หนักแน่นพอไหม เช่นเราจะ Build หรือ Buy ดี?
- **Pragmatism**: ประสบการณ์และสิ่งที่ได้เรียนรู้เปลี่ยนใจคนได้
- **Budget**: เงินมันไม่เข้าใครออกใครนะ ฮ่าๆๆ

ในขณะเดียวกันหากเราชะลอการตัดสินใจไปเรื่อยๆ มันก็จะมีจุดนึงที่มันไปต่อไม่ได้ถ้าไม่ตัดสินใจ ซึ่ง ณ จุดนั้นเองสิ่งที่ตามมาก็คือค่าใช้จ่ายนั่นเอง ยกตัวอย่างเช่น ตัดสินใจไม่ได้ว่าจะใช้ frontend framework ตัวไหนดี จนเสียเวลาที่ใช้ในการพัฒนาไป

### 3. All Design is **Redesign**

> Reuse correctly & timely

เป็นแนวคิดที่ต้องการจะสื่อว่าจริงๆ แล้ว design ใหม่ที่เราเห็นในทุกวันนี้มันก็มาจากการ redesign จากสิ่งที่มีอยู่แล้วให้มันดีขึ้นหรือเท่าเดิมนั่นแหละ ยกตัวอย่างเช่น

- เมื่อเราต้องเจอกับ legacy system แทนที่เราจะ "เขียนใหม่ดีกว่า" เราก็ค่อยๆแยกส่วนที่แยกได้ออกมาทีละส่วนๆ
- ถ้าเราต้องทำระบบจองตั๋วหนังให้คนๆ เดียว เราอาจจะใช้คนจดกระดาษไปก่อน แต่ถ้าเราต้องทำหลายๆ คนเหมือนๆ กัน เราอาจจะคิดถึงการทำ application แล้วไหม

ดังนั้นเมื่อเราต้องคิดเรื่อง architecture เราสามารถเรียนรู้จาก solution ที่มีอยู่แล้วได้ เช่น
- [Google Cloud Architecture Center](https://cloud.google.com/architecture)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)

### 4. Make Design **Tangible**
Design ของเรามันควรจะจับต้องได้ ซึ่งเราสามารถใช้เครื่องมือที่ช่วยให้การสื่อสารง่ายขึ้น เช่น

#### C4 diagram
![C4 diagram](/assets/2021-08-20-c4-diagram.png)

#### Context map
![Conway's Law](/assets/2021-08-20-ddd-context-map.png)

[BoundedContext by Martin Fowler](https://martinfowler.com/bliki/BoundedContext.html)

#### Architecture decision record
แทนที่จะเขียน solution architecture เป็นร้อยๆ หน้า ที่มีโอกาสสูงที่จะไม่ update เขียนเป็น decision log เก็บไว้ใน source code น่าจะดีกว่า technique นี้ผมอธิบายไว้[ในบทความว่าด้วยเรื่องของ Evolutionary architecture กับทีม development แล้วครับ]({% post_url 2020-02-02-capturing-evolutionary-architecture-using-adr %})

## แล้วตอน Design ควรจะต้องทำอะไรบ้าง

![Design mindset summary](/assets/2021-08-20-design-mindset-summary.png)

### Understand
จุดเริ่มต้นเราต้องเข้าใจ **business goals และ quality attributes** ก่อน ถ้าเราไม่เข้าใจหรือเข้าใจผิด มันก็มีโอกาสสูงที่จะ design ผิดไปด้วย โดยเราสามารถใช้ technique เข้ามาช่วยได้เช่น

- [Trade-off slider](https://www.oreilly.com/library/view/agile-experience-design/9780132869249/part03lev1sec30.html)
- Cross-functional requirements gathering

![Trade-off sliders](/assets/2021-08-20-trade-off-sliders.jpeg)

### Explore
ทำการค้นหาและออกแบบโดยใช้ patterns ที่เคยมี หรือจะออกแบบใหม่หมดเลยก็ได้ ซึ่ง design ที่ได้ควรจะตอบโจทย์ business goals และ quality attributes โดยเราสามารถทำผ่านกิจกรรมต่างๆ เช่น

- [Event storming](https://en.wikipedia.org/wiki/Event_storming)
- Round-robin design

### Make
สร้าง solution จากการ explore ที่สามารถใช้งานได้จริง ผลงานที่ได้ก็จะสะท้อนความเข้าใจของเรา โดยเราสามารถเริ่มจาก
- Prototyping
- Architecture decision record
- Spike หรือการทดลองภายในกรอบเวลาสั้นๆ

### Evaluate
หลังจากสร้างผลงานขึ้นมาแล้ว ก็ปิดท้ายด้วยการวัดผล ซึ่งสามารถทำได้ผ่าน
- Code review !!
- Scenario walkthrough

## ใครและเมื่อไรที่จะต้องตัดสินใจเรื่อง architecture
เราสามารถใช้หลักการ **RACI** ซึ่งประกอบไปด้วย

- **R** esponsible: ใครเป็นคนลงมือทำ
- **A** ccountable: ใครเป็นคนตัดสินใจ
- **C** onsulted: ใครมีข้อมูลพอที่สามารถช่วยเหลือคนอื่นได้
- **I** nformed: ใครต้องการ update

สังเกตว่า ในขณะที่ทีมพัฒนาอยู่ตรง **R** software architect จะอยู่ตรง **A กับ C** เนื่องจากส่วนใหญ่แล้ว architect จะอยู่ในระดับสูงและดูแลหลายๆ ทีม ดังนั้นเขาจะมีข้อมูลและมุมมองกว้างกว่าที่จะตัดสินใจเรื่อง quality attributes จัดการความเสี่ยง และสามารถชะลอการตัดสินใจไปได้ 

### แล้วถ้าทีมพัฒนาไม่ทำตาม architect ล่ะ
เพราะบางครั้งทีมพัฒนาเค้าก็อาจจะมีมุมมองที่คิดว่า solution ของเค้าดีกว่า ดังนั้นแทนที่จะไล่ออกไปซะ (?) จะดีกว่าไหมถ้าเราบันทึกการตัดสินใจเหล่านั้นไว้เพื่อแสดงให้เห็นมุมมองที่เท่ากัน แล้วมาคุยกันว่ามันมีเหตุผลอะไรถึงทำต่างจากนั้นไป โดย architect สามารถใช้เครื่องมือเหล่านี้ในการบันทึกได้

- [Architectual guardrail (manual fitness functions)](https://www.thoughtworks.com/radar/techniques/architectural-fitness-function) การใช้ชุดการทดสอบในการตรวจสอบ architecture ของเรา
- **Sensible defaults** เป็นเหมือน FAQ สำหรับ engineering practices ที่เป็นเหมือนมาตรฐานที่ใช้กันในองค์กร เช่น ถ้าจะเริ่มทำ [CI](https://www.thoughtworks.com/continuous-integration) จะต้องใช้อะไร เพราะอะไร เป็นต้น

### Time investment
> Development time + architect and risk reduction time + rework time (fixing defects, rewrites, mistakes)

![Time investment](/assets/2021-08-20-time-investment.png)

**คำอธิบาย**:
- ยิ่งใช้เวลาไปกับ architecture เท่าไร เวลาที่ใช้ในการ rework ยิ่งน้อยลง
- ยิ่งขนาดของ code ซึ่งวัดจากจำนวนบรรทัด (Line of Code) ใหญ่มากเท่าไร เวลาที่ต้องคิดเรื่อง architecture ยิ่งมากขึ้น
- ถ้าเราคิดเรื่อง architecture มากไปหรือน้อยไป จะทำให้เวลาที่ใช้ทั้งหมด (total) เพิ่มขึ้น
- มันจะมีจุดเวลาที่พอดีระหว่าง เวลาที่ใช้ในการคิด architecture กับ เวลาที่ใช้ในการ rework

คำถามที่ช่วยให้เราตัดสินใจในการตัดสินใจเรื่อง architecture ได้แก่
- **เราเริ่มต้นแบบง่ายๆ เล็กๆ ได้ไหม** ถ้าได้ก็เริ่มเลย
- **ถ้ามันใหญ่ เราแบ่งเป็นส่วนเล็กๆ ได้ไหม** ถ้าได้ก็แบ่งเลย
- **ถ้าแบ่งไม่ได้ เราสามารถใช้เวลาเพิ่มในการคิด architecture ได้ไหม** ถ้าไม่ได้ต้องหาแผนสองละ เช่น หลังจาก release ไป 2 เดือน เรากลับมาแก้หรือดูกันใหม่ดีกว่า
- **ถ้าขอเวลาเพิ่มได้ งั้นเราชะลอการตัดสินใจได้ไหม** ถ้าได้ก็ทำ analysis เพิ่ม แต่ถ้าไม่ได้ก็หาแผนสองเหอะ

## ปิดท้ายด้วย Video จาก course นี้ครับ

<iframe width="560" height="315" src="https://www.youtube.com/embed/uHy-2z80aBQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>