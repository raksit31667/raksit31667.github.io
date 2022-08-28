---
layout: post
title:  "สรุปสิ่งที่น่าสนใจจากงาน XConf Thailand 2022"
date:   2022-08-28
tags: [conference]
---

## Evolutionary Testing in Evolutionary Architecture

> เมื่อไหร่ก็ตามที่การเขียน test ทำได้ยาก นั่นก็คือสัญญาณที่ดีว่าเราควรถอยมาพิจารณาภาพรวมของ architecture ว่ามีอะไรไม่ชอบมาพากลหรือไม่
> แต่ไม่ใช่ทุกคนจะมีสัมผัสที่ดี ที่สามารถอ่านถึงสัญญาณเหล่านี้ได้

ทำไมเราถึงไม่สามารถอ่านถึงสัญญาณเหล่านี้ได้

ผู้พูดเริ่มจากการตีความ test กันก่อน ซึ่งก็มีทั้งสายคลั่งไคล้ (zealot) และสายต่อต้าน (hater) แน่นอนว่ามันก็มีการโต้เถียงกันเกิดขึ้นว่า ขอบเขตของ test มันอยู่ที่ตรงไหน เช่น เรามี API สำหรับทำ healthcheck

- Controller vs API test (which one is right?)

นำไปสู่คำถามที่ว่า Unit ใน unit test คืออะไร ซึ่งมันจะเป็น class, function, method อะไรก็ได้ แล้วอะไรคือสิ่งถูกล่ะ

หากเราต้องการจะตอบคำถามนี้ เราต้องเข้าใจก่อนว่าแท้จริงแล้ว

> Architecture is a bunch of definitions and relationship

ดังนั้นสิ่งที่ทีมควรจะต้องตกลงร่วมกันคือขอบเขตของการทดสอบ (definition) นั่นเอง ซึ่งจะต้องชัดเจนและกระชับเจาะจง เช่น

 - เราจะทดสอบใน Repository ซึ่งหมายถึง code ส่วนที่ดึงข้อมูลจาก database ✅
 - เราจะทดสอบใน Utils ซึ่งหมายถึง code ที่ใช้งานทั่ว ๆ ไปใน application ❌

ต่อมาทีมจะต้องตกลงร่วมกันและสามารถอธิบายได้ว่าแต่ละส่วนมันเชื่อมโยงกันอย่างไร (relationship)

- Explanation how it works together (client -> controller -> service -> model)

การกำหนด definition และ relationship ควรจะไม่ต่างจากมาตรฐานที่หลาย ๆ ที่ใช้มากจนเกินไป เพื่อลดเวลาในการ onboarding คนใหม่ลงนั่นเอง เพื่อลดการถกเถียง เช่น ในบาง Framework ก็จะกำหนด definitions มาให้เลยว่า unit คืออะไร เช่น การแบ่งเป็น (Controller, Service, Repository)

ในบางครั้งเวลาเขียน unit test แล้วมันยาก หรือ ไม่ได้ ไม่รู้ว่าจะเอาไปไว้ตรงไหน นั่นอาจจะหมายถึงว่าเราอาจจะมี architecture smell หรือเปล่า ซึ่งสะท้อนให้เห็นถึงปัญหา 2 อย่าง คือ reusability และ testability ยกตัวอย่างเช่น  

สมมติว่าเราต้องการจะทดสอบ code ในส่วนที่เชื่อมต่อกับ database พบว่า code เริ่มมีความซับซ้อนมากขึ้น เพราะมันไปปนกับส่วนของการปั้น request-response เรามีทางเลือก 2 ทางคือ

1. Leave old test as is
2. Create new repository test

ซึ่งคำตอบคือข้อ 2 เพราะเราสามารถ reuse unit ในที่อื่น ๆ ได้ แต่มีข้อถกเถียงว่า ถ้าไม่เลือกข้อ 1 แล้ว unit test เดิมที่รวบไปกับการปั้น request-response ล่ะ จะเอาไปไว้ไหน ซึ่งเราจะพบว่า

- ตอนแยกออกมาเป็น unit test ใหม่ ก็ยังต้องใช้ unit test เดิมอยู่ เพื่อดูว่าระบบยังคงทำงานได้เหมือนเดิม หลังจากแก้ไข code แล้ว
- Unit test เดิมก็มีแนวโน้มที่จะกลายเป็น integration test เพราะ definition ของ unit ของเราได้เปลี่ยนไป โดยมีการเพิ่ม repository เข้ามานั่นเอง ดังนั้นถ้าเราสร้าง unit test ขึ้นมา ก็ไม่จำเป็นที่จะต้องเป็น unit test ไปตลอดกาล เนื่องจาก architecture ของเราเปลี่ยนไป  

จะเห็นว่าการที่ architecture จะเติบโตขึ้น มีการเปลี่ยนแปลงได้ง่าย แต่ละ unit จะต้องถูกทดสอบอย่างดีเสียก่อน ซึ่งมันก็กลับไปที่ definition ของ unit ตามที่กล่าวมาข้างบน หลายคนเลือกที่จะ test ทุก class ทุก methods เพราะใช้ได้กับทุก use case ทุก architecture แต่มันก็เป็นดาบสองคม เพราะมันไปขัดขวางการ refactor เมื่อมีการเปลี่ยนแปลง unit เราต้องมาแก้ test หลายที่ ส่งผลต่อค่าใช้จ่าย effort ที่ใช้ไปมากมาย  

## Developer Experience (DX) from Code to Platform

- Code
    - Unreadable code
    - Outdated document
    - No automation tests
    - Inconsitent API
    - Over-engineering

- Developer experience
    - No test devices
    - Context switching, cognitive overload
    - Poor onboarding
    - Manual steps in Testing
    - Blocked by open tickets
    - Constant crush time

- เครื่องมือผุดขึ้นมาเยอะแยะ
- มีใครรู้ทุกอย่างบ้าง
- Spotify (too many unknowns, duplication of effort, poor discoverability) -> Backstage
- Measurement and metrics (developer survey, weekly active users, time, four key metrics)

- Platform
    - Talk to networking, orchestration, observability, security & compliance
    - App team (move fast, flexible) vs Ops team (safety, reliable)
    - Journey: Checklist -> Tickets -> Collaboration -> Self-service
    - No one uses it? หมายความว่าเราไม่ตอบโจทย์ DEV?
    - Discover -> Define -> Deliver
    - ขายตัวมันเองได้ ไม่ต้องบีบคอ DEV มาทำ, สร้าง community เกิดการแลกเปลี่ยน, offer support
    - Pitfall (ไม่ตอบโจทย์, ไม่มีขอบเขต ทำทุกอย่างได้แต่ใช้ยาก, focus ที่ quality, ไม่มี business value)

## Beyond Fitting Models: How to Build Successful AI-driven Products

- Google use case (book flight -> add to calendar, show prompt to reply email)
- Bad use case (TayTweet, Tesla autopilot)
- Fitting models
    1. Data prep + Feature engineering
    2. Model selection + param tuning
    3. Model evaluation
- งาน fitting ทำซ้ำ -> automate เลย (AutoML) -> data scientist ตกงาน?
- Successful AI-driven products require the right:
    - Problem
        - Data scientist figures out what problems to solve, impact to biz
        - Do we need ML? -> user impact, ML impact (เดาถูกมากน้อยแค่ไหน)
        - Use case Gmail (you forgot to attach a file)
        - Use case Kbank มีปุ่มประเภท transaction vs ML มา predict ประเภท transaction
    - Data
        - Get out and talk to people
        - Data scientist + AutoML > AutoML > Data scientist
        - ข้อมูลที่ใช้ train ไม่ทันสมัยกับเหตุการณ์ปัจจุบัน (use case: Google ทำนายการระบาด United States Flu)
        - Bias (use case: dataset ไม่มีคนผิวสี -> gorilla)
        - Data-centric AI เราจัดการ data ให้มันมี quality ก่อน แทนที่จะเปลี่ยน algorithm ตาม dirty data
        - Explainable API (use case ตรวจรูปภาพ แล้วบอกว่าเป็นโรคอะไร)
    - Model
        - What human thinks vs What algorithm does (e.g. clickbait)
        - Recommendation (top 20 of 2019 vs your daily mixes)
        - เอาคนเข้าไปอยู่ใน model (capacity, seasonality and holidays)
        - Use case (facebook prophet, stitch fix ให้คน finalize เสื้อผ้า)
    - Decision
        - เผื่อ case ที่เดาผิด (false positive, false negative)
        - Use case (ลูกค้าไม่โดนโกง แต่เดาผิดว่าโดนโกง, ลูกค้าโดนโกงจริง แต่เดาผิดว่าไม่โดนโกง)
        - Use case (adversairal attacks, Lazada ads sex merch)

## Building data platforms "the right way"

- What kind of problems data platform face?
    - Requirement change
    - Time sensitivity
    - Complex orchestration
    - Difficult deployment
    - Data size

- What do we need
    - Scalability (latency, time to restore access to data, amount of data loss, data size, life cycle tracking, data freshness)
    - Deployability (CI/CD, IaaC)
    - Observability (monitoring, audit, alert)
    - Testability (data quality, data profiling, infrastructure, app & benchmark, integration tests between source & sinks)
    - Compliance (data security, RBAC, protection against data exfiltration, data governance)

- What does a data platform might look like?
    - Take care of every block in data component in architecture diagram
    - Automate infra, building capability over solutioning, threat modeling, monitor and alert, performance benchmarking, open mind, data governance, test

## Untangling Data Mesh | A Paradigm Shift in Big Data
- Failed attempts to expose data throufh centralized data warehouse/lake
- Challenged with a tech debt, legacy, siloed
- Faced with increasing pressure to move off of on-premises
    - Domain ownership (data product owner, governance) -> treat data as you treat business cap
    - Data-as-a-Product (code for data pipelines API policies, data & metadata, infra)
        - Discoverable
        - Addressable
        - Trustworthy
        - Self-describing
        - Interpoperability
        - Secure
    - Self-serve (data infra plane, data product DX, data mesh supervision plane)
    - Federated computational governance (through self-serve platform)
- How can create schema? What incentives to give to the team?
- Privacy-first (clear and trust domain data owner, verification through testing and auditing, governance, self-serve)

## High Performing Team Essentials

ใน session นี้ ผู้พูดได้แบ่งปันประสบการณ์ในการสร้างทีมศักยภาพสูง (high-performing team) โดยเริ่มแนวทางปฏิบัติต่าง ๆ ทีละขั้นตามระยะเวลาเช่น
- เริ่มแรก ทีมจะต้องละลายพฤติกรรมกันก่อน โดยใช้แนวทาง intentional and ongoing team building เช่น social contract, team building game, small messages in Slack, moments to celebrate, appreciation wall โดยประโยชน์ที่ได้รับคือ
  - Non toxic (no blame)
  - Open for sharing
  - Open for trying new things
  - Open for failure

- หลังจากละลายพฤติกรรมแล้ว ทีมเริ่มทำงานโดยใช้แนวคิด Hypothesis-driven development เนื่องจากงานในช่วงแรก ๆ นั้นมีความไม่แน่นอนเกิดขึ้นมากมาย หรือต้องการจะทำความเข้าใจระบบเดิมก่อนปรับปรุงเสียก่อน โดยวิธีการคือตั้งสมมติฐาน จากนั้นทำการทดลอง และมีการวัดก่อน-หลังการเปลี่ยนแปลง ประโยชน์ที่ได้รับคือ
  - Felt safe asking questions, negative results, requesting for help, learning together
  - BA คุยกับลูกค้า
  - Dealing with production issue (feature toggle, post mortem, support pair)
  - Autonomy, communication and transparency, build relationship, trust
  
- เวลาต่อมาทีมได้เปลี่ยนแนวทาง Hypothesis-driven development เป็น Feature development เพื่อเสริม engineering practice
- ต่อมาพัฒนาทักษะของคนในทีมด้วย Feature lead
  - grow leadership, build trust, path to tech lead
  - Safety, dependability, competence, character

## Accessibility | Building Tech for Everyone
- คนไทยบกพร่อง ทุพพลภาพ 2 ล้านคน
- Visual, hearing loss, speech, motor (muscle weakness), cognitive
- Ease (handicap parking space near entrance, bell, microsoft game stick)
- Mobile phone (screen reader, voiceover, talkback, voice command, sound notification)
- Interview with visual impairment
    - App relies on touch gesture
    - App requires scanning face
    - App cannot do screen reader
    - Dont try to assume that screen reader will do everything for you
- Normal vs better accessible
    - Select the option -> select option 2 -> change color to yellow
    - Screen reader read "Please select option 1, 2, 3" -> normal
    - Screen reader read "Please select option 1, 2 selected, 3" -> better
- Encourage the team to have accessbility mindset -> won't forget and undersntand concept rather than just checklists
- See guidelines -> w3accessibility, Apple, Android, experts
- Change ways of working

## Building the Best Code Doesn't Build the Best System

> เราพยายามสร้างและปรับปรุง code ที่ดีมีประสิทธิภาพเพื่อให้ประมวลผลได้อย่างรวดเร็ว โดยหวังว่าเราจะได้ระบบที่สมบูรณ์และตอบสนองต่อผู้ใช้งานได้อย่างรวดเร็ว แต่มันกลับกลายไม่เป็นอย่างที่คิด เราเคยสงสัยไหมว่าทำไหมถึงเป็นอย่างนั้น เป็นที่ความรู้ หรือทักษะของเรายังไม่ดีพออย่างนั้นหรือ

ผู้พูดยกตัวอย่าง Braess's paradox ซึ่งพูดถึงปรากฎการณ์ที่การสร้างเส้นทางพิเศษหรือขยายเส้นทางขึ้นมาใหม่ แต่ไม่สามารถแก้ปัญหาได้ ซ้ำร้ายกลับกลายเป็นทำให้การจราจรแย่กว่าเดิม  

<iframe width="560" height="315" src="https://www.youtube.com/embed/RmLrpci_tfo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

เปรียบเทียบกลับมาที่ระบบงานของเรา ซึ่งมันคือส่วนประกอบที่เชื่อมต่อกันที่ไม่สามารถแบ่งแยกออกจากกันได้ (product + interactions) ยกเว้นการแยกระบบ เพราะเราสามารถแยก 2 ระบบออกจากกันเองได้ การที่เราจะปรับปรุงระบบโดยเอาส่วนดีสุดมาประกอบกัน มันไม่ได้หมายความว่าจะได้ระบบที่ดีที่สุด เช่น

### Case 1
- ระบบของเรามี bug เยอะ เราเลยตั้ง QA army เพื่อมาดัก bug ในอนาคต ถึงแม้ว่าจะไม่มี bug เลย แต่ก็ไม่ได้ทำให้ระบบดีขึ้น -> คำถามคือทำไมเราไม่ focus ที่สิ่งที่เราต้องการจริง ๆ มากกว่า

### Case 2
- การทำ application ส่วนใหญ่ DEV ไม่ได้ focus ที่ภาพรวม แต่จะเน้นส่วนแยก ๆ กันมากกว่า เพราะเข้าใจภาพรวมมันยาก ก็เลยแบ่งงานตามความถนัด (frontend, backend, infra) เพื่อรองรับงานในอนาคต ต่อมาเราพบว่า frontend DEV ว่างงานเพราะว่างานที่เข้ามาส่วนใหญ่มีแต่ backend คือไม่ได้เท่ากันตลอด -> ทำไม DEV ไม่สามารถทำงานอะไรทดแทนกันได้
- แสดงให้เห็นถึงความแตกต่างระหว่างคำว่า Efficiency และ Effectiveness โดยที่
  - Efficiency = Do the things right
  - Effectiveness = Do the right things

### Case 3
- การทำ code review ทีมตัดสินใจว่าก่อนที่จะทำ code ขึ้นไป build และ deploy ได้ จะต้องให้ senior DEV/architect มา review กันก่อน เพราะคนเหล่านี้มีประสบการณ์มากที่สุด -> คำถามคือทำไม team member ไม่สามารถ review กันเองได้ จะได้ไม่เกิดคอขวด
- แสดงให้เห็นถึงความแตกต่างระหว่างคำว่า Management และ Leadership โดยที่
  - Management = Do the things right
  - Leadership = Do the right things

### Case 4
- ทีมนำแนวปฏิบัติ Pair programming มาใช้งาน แต่เจอปัญหาสุด classic ที่ management ไม่ชอบ ทำไมถึงไม่เอา 2 คนไปทำงานได้ตั้ง 2 งาน จะได้ไม่ต้องเสีย cost 2 เท่า -> งานวิจัยพบว่า DEV cost ขึ้นมาไม่ถึง 15% ไม่ใช่ 100% ตามบัญญัติไตรยางค์

### Case 5
- บริษัทอยากจ้างคนเก่งเข้ามาช่วยทีม เพื่อทำให้คนเดิมเก่งขึ้นเรื่อย ๆ ปัญหาก็คือมันไม่ได้การันตีว่า เอาคนเก่งเข้าทีมแล้วทีมจะเก่งขึ้นนะ -> มันต้องมีทีมที่มีโครงสร้างที่สร้างทีมที่เก่งมากพอ ถ้าทำให้ทีมเก่งขึ้น -> software ดีขึ้น -> ได้ feedback -> ทีมเก่งขึ้น

จะเห็นว่าตัวอย่างที่ได้ยกมา การที่เราจะปรับปรุงระบบนั้น
- ควรเข้าใจภาพรวมในระบบมันดีขึ้น เข้าใจส่วนประกอบที่เชื่อมกันก่อน
- ปรับปรุงกับปัจจุบัน ไม่ใช่อนาคต เพื่อให้มันดีขึ้นในอนาคต

ปิดท้ายด้วยความแตกต่างระหว่าง Programming และ software engineering คือ
- Programming แก้ปัญหา เขียน code ส่งออก
- Software engineering การสร้างระบบโดยใช้ programming + การทำงานกับ programmer คนอื่น

## Tech journeys, challenges, and learnings
- หนังสือ Designing Your Life
- จำความรู้สึกว่าตอนนี้ไฟแรงมันเป็นไง 10-20 ปี ถัดไป จะต้องยืนระยะให้ได้เหมือนเดิม
- เรียนรู้ให้ลึกซึ้งถึงแก่น
- เรามีเป้าหมายระยะยาวประมาณไหน แล้วทุกวันนี้เราทำให้เราเข้าใกล้เป้าหมายของเราแล้วยัง
- หลังจากที่เราผลักดันด้านงาน อย่าลืมสนใจคนรอบข้าง personal life
- Work-life balance ไม่ต้อง 50-50 แต่ให้เข้าใจเป้าหทายของเรา
