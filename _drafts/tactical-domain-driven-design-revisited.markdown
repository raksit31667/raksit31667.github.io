---
layout: post
title:  "บันทึกทบทวนความเข้าใจในการใช้ Tactical Domain-Driven Design"
date:   2024-01-09
tags: [domain-driven-design]
---

เมื่ออาทิตย์ที่แล้วได้มีโอกาสได้เข้า course [Tactical Domain-Driven Design](https://www.skooldio.com/courses/tactical-domain-driven-design) เพื่อเตรียมตัวสำหรับการเข้า project ใหม่ ส่วนตัวเคยเรียนจาก website แหล่งอื่น ๆ เช่น [vaddin](https://vaadin.com/blog/ddd-part-2-tactical-domain-driven-design) ทำให้เรารู้จักกับ termonologies ต่าง ๆ เช่น

- Value Objects
- Entity
- Aggregates
- Repositories
- Domain Service
- Domain Events

แต่เพื่อเป็นการปัดฝุ่นและทำความเข้าใจลึกลงไปอีกระดับนึงจึงตัดสินใจลงเรียนอีกรอบ มาดูกันว่าเราได้เรียนรู้อะไรใหม่บ้าง

## Domain-Driven Design คืออะไร และค่าใช้จ่ายของมัน

Domain-Driven Design (DDD) คือแนวคิดในการออกแบบระบบ software ที่ทำให้ความรู้ความเข้าใจในระบบ (business domain) เป็นไปตามสิ่งที่ผู้เชี่ยวชาญ (domain expert หรือ subject-matter expert) ได้บอกกล่าว ซึ่งผู้เชี่ยวชาญนั้นก็คือฝั่ง business หรือคนที่ให้ requirement กับนักพัฒนานั่นเองเพื่อทำให้การทำงานร่วมกันระหว่างฝั่ง business และ technical ราบรื่น

> หลาย ๆ คนอาจจะเข้าใจว่างี้ Business Analyst หรือ Project Manager ที่ทำหน้าที่ "วุ้นแปลภาษา" ก็ตกงานเอาล่ะสิ ให้ลองคิดในทางกลับกันครับว่าพวกเขาสามารถเอาเวลาที่เหลือไปอะไรอย่างอื่นที่มันมีคุณค่ามากกว่านี้ได้อีกเยอะ!

ด้วยความที่ว่าแนวคิดนี้เป็นที่แพร่หลายมากขึ้นจึงเกิดการนำไปใช้กับหลากหลาย use case เนื่องจากมันไม่มีข้อจำกัดด้าน technical หรือ programming language บางกรณีส่วนน้อย gap ระหว่างสิ่งที่ domain expert คิดในหัวกับความเป็นจริงมันไม่สามารถสอดคล้องกันได้จริง ๆ เช่น AWS IAM (ที่ treat ทุกอย่างเป็น resource, action, effect, principal แทนที่จะเป็นไปตามแต่ละ resource) และ WordPress (ที่ treat plugin เป็น hooks, actions, filter แทนที่จะเป็น website component) จึงจำเป็นต้องสร้าง mental model ใหม่เพื่อแลกกับ maintainability และ scalability ที่ดีขึ้น (ลองจินตนาการดูว่าต้องมาออกแบบ model เฉพาะทีละ resource หรือ plugin มันจะ scale ได้ยากมาก)  

จากประสบการณ์ของคนสอน หลายที่หรือหลายองค์กรคิดว่าตนเองอ่ะเป็นกรณีส่วนน้อยอย่างที่กล่าวมาก็เลยเลือกที่จะทำ model ใหม่ ทั้งที่ความจริงแล้วสิ่งที่พวกเขาลืมไปคือ

- Scale ไม่ถึงจริง ๆ ไม่คุ้มกับการลงทุนออกแบบ ไม่สามารถใช้ model/abstraction นี้รองรับได้เป็นหมื่น ๆ use case
- ไม่ได้ลงทุนกับ documentation และ onboardng มากพอ เพราะออกแบบจากความเคยชินของตนเอง ก็เลยคิดว่า gap ระหว่างสิ่งที่ domain expert คิดในหัวกับความเป็นจริงมันแคบ "แม่งไม่เห็นจะยากตรงไหน มึงโง่เอง ฮ่า ๆๆ"

> ดังนั้นการออกแบบ model เหล่านี้ต้องคิดโดยยก bias และความเคยชินของตนเอง และเอาใจของคนใหม่และตัวเราในอนาคตมาใส่ใจของเรา ณ ตอนนี้"

## DDD ใน Software Development Lifecycle
ด้วยความที่ว่า DDD คือแนวคิดในการออกแบบระบบ software ดังนั้นเราสามารถใช้แนวคิดนี้ได้กับหลาย ๆ ช่วงในการพัฒนา software ไล่มาตั้งแต่

- **Domain Discovery**: เราจะใช้ Exploratory DDD ในการทำความเข้าใจ model ในปัจจุบันและอันที่เราจะเปลี่ยนไปแบบคร่าว ๆ ผ่าน ceremonies เช่น [Event Storming](https://en.wikipedia.org/wiki/Event_storming)
- **Software Architecture**: เราจะใช้ Strategic DDD ในการแบ่งระบบให้เป็น model ที่แยกกันตาม domain (domain model) แต่สื่อสารผ่านกันอยู่
- **Software Design**: เราจะใช้ Tactical DDD ในการแปลง domain model จากขั้นตอนที่แล้วเป็น code และใช้ patterns และ terminologies ต่าง ๆ ตามความเหมาะสม

ซึ่งก่อนจะไปที่ลงที่ Tactical DDD เราควรจะมีการสร้างสิ่งต่อไปนี้เตรียมไว้แล้ว ได้แก่

- **Ubiquitous language**: ภาษาที่ใช้ร่วมกันระหว่าง domain expert และทีมพัฒนา โดยมีคุณลักษณะดังนี้
  - ต้องมีระบุหรือแสดงไว้ใน domain model เพื่ออธิบายสิ่งที่อยู่ในหัว domain expert ได้
  - ควรทำให้ความเข้าใจผิดระหว่าง domain expert และทีมพัฒนา น้อยลง
  - ไม่ได้ถูกกำหนดโดย business อย่างเดียว
  - ไม่จำเป็นต้องเป็นภาษาที่ใช้กันในวงการทั่ว ๆ ไป
  - สามารถเปลี่ยนแปลงตามความเข้าใจ หรือ requirement ใหม่ ๆ ภายหลังได้ ไม่จำเป็นต้อง define ทีเดียวจบ
  - หากมีแนวคิดใหม่ ๆ เข้ามา Ubiquitous language จะต้องถูกปรับแก้ให้รองรับสิ่งเหล่านั้นได้ก่อนถึงจะเอาเข้ามาได้
- **Bounded context**: ขอบเขตของ Ubiquitous language เพื่อรองรับระบบที่ใหญ่จนไม่สามารถมี Ubiquitous language เดียวได้ (เช่น Promotion สำหรับ HR กับ E-commerce ไม่เหมือนกัน) เพื่อลดเหตุการณ์ที่ domain model ไม่สามารถ scale รองรับ feature ใหม่ ๆ ได้ โดยจะเลือก implement ด้วยท่าไหนก็ได้ เช่น namespace, package, library, multi-service เป็นต้น
- **Context mapping**: integration และ communication ระหว่าง bounded context โดยจะเลือก implement ด้วยท่าไหนก็ได้ เช่น event, API เป็นต้น

หลังจากนั้นเราจะมีการลงมือทำ Ubiquitous language analysis ซึ่งรายละเอียดจะยกไปในหัวข้อถัดไป

## เข้าเรื่อง Tactical DDD (ในที่สุด)

### Ubiquitous language analysis
โดยส่วนมากแล้ว Ubiquitous language สามารถเกิดใหม่หรือเปลี่ยนแปลงตามความเข้าใจหรือ requirement ใหม่ ๆ ดังนั้นเราจะต้องทำการต้นหาและวิเคราะห์ language ที่อาจจะกลายเป็น Ubiquitous language จาก requirement, user story หรือแม้กระทั่ง meeting นั่งจิบกาแฟคุยกันทั่ว ๆ ไป ก่อนที่จะพูดคุยเพื่อตกลงร่วมกันต่อไป มีขั้นตอนดังนี้

1. Extract noun หรือบางทีจะมาในรูปแบบของ verbing ซึ่งส่วนใหญ่จะเป็นสิ่งที่จับต้องได้ เช่น จองคิว ทำนัดรับรถ กรอกงานขายเข้าระบบ เป็นต้น 

    > As an **acquisition crew**, I want to schedule **car collection**, So that I can pick up **car** on-time.

    > As an **acquisition crew**, I want to collect **car**, So that I can pick up **car** on-time.

2. Extract verb

    > As an **acquisition crew**, I want to *schedule* **car collection**, So that I can *pick up* **car** on-time.

    > As an **acquisition crew**, I want to *collect* **car**, So that I can *pick up* **car** on-time.

3. จะเห็นว่า noun และ verb ที่ได้จะกลายเป็น object และ method ตามลำดับ เรานำผลลัพธ์มาวาด model คร่าว ๆ
4. เลือกสิ่งที่จำเป็นในการ implement ชิ้นงานจาก model ที่ได้ ไม่จำเป็นต้อง implement ทั้งหมดเพราะบางอย่างมันไม่ต้องเก็บในระบบแค่เป็นสิ่งที่เกิดในโลกความเป็นจริงเท่านั้น
5. ทำการจัดกลุ่ม noun ต่อซึ่งรายละเอียดจะขอยกไว้ในหัวข้อถัดไป

สิ่งที่หลาย ๆ คนมักจะผิดพลาดคือ "มโน" object และ method ตามความเข้าใจและความคุ้นเคยของตนเอง เช่น หากเราทำระบบ CRUD เราก็จะใช้ method "create" แทนที่จะเป็น "schedule" หรือ "collect" ซึ่งมันไม่ได้การันตีเลยว่ามันคือการ "สร้าง" อย่างเดียวจริง ๆ ผลที่เกิดขึ้นคือ model ในหัวไม่ตรงกับใน code ละ

> "We respect our familiar (usually technical) model over domain model”

### Entity vs Value Object
หลังจากที่เราได้ noun ที่จะกลายเป็น object เราก็จะพบว่าในการเขียน code เราจะมีวิธีในการจัดการแต่ละ object ต่างกัน เช่น อันไหนต้องเชื่อมกับ database, การทำ transaction, concurrency, thread-safe, equality เป็นต้น ซึ่งใน Tactical DDD ได้แนะนำให้เราจัดกลุ่มเป็น 2 แบบได้แก่ Entity และ Value Object โดยที่ความต่างคือ

- **Entity**: สิ่งที่เปลี่ยนไปตามกาลเวลา เช่น User, ShoppingCart, Invoice
- **Value Object**: สิ่งที่ตายตัว ไม่เปลี่ยนไปตามกาลเวลา เช่น DateTime, Price with Currency, Color

<script src="https://gist.github.com/raksit31667/2a72680de73dbf1f4c40cec9ac16b191.js"></script>

<script src="https://gist.github.com/raksit31667/84bd47b29ea29fa01dd05a9f105fec62.js"></script>

จะเห็นได้ว่าการจัดการ Entity จะเป็นคนละแบบกับ Value Object ตาม concern ด้านบนเพราะมีเวลามาเกี่ยวข้องนั่นเอง ทำให้เรา focus กับการจัดการแยกกันเครียดได้ง่ายขึ้น ไม่ต้องมาระแวงมากจนเกินไป

ส่วนว่าจะจัดกลุ่มด้วยท่าไหน อย่างที่กล่าวไปในหัวข้อที่แล้วคือ DDD ไม่ได้เจาะจงว่าจะทำยังไง เลือกเอาตามที่ทีมและ technical สะดวกกันได้เลย

> สาเหตุที่บางคนบอกว่า Entity มันคือ domain object ที่มี ID เป็นเพราะว่าเมื่อมันเปลี่ยนไปตามกาลเวลา มันจะต้องมีการ track เสมอว่าตอนนี้หน้าตามันเป็นยังไงแล้วนะ ซึ่งท่ามาตรฐานก็คือการมี ID นั่นเอง 

### Aggregates
ในระบบที่ใหญ่ขึ้นเราจะเจอกับ domain object ที่ใหญ่ขึ้นประกอบไปด้วย object ย่อย ๆ เป็นลูกหลาย ๆ อัน (เช่น `CarCollection` กับ `Pickup`) แล้วการเปลี่ยนข้อมูลของลูกอาจจะกระทบกับข้อมูลของ object หลักแล้วเราอยากให้ข้อมูลมันสอดคล้องกันเสมอ เช่น

> As an **acquisition crew**, I want to be able to *see* detail of **pickups** in a single **car collection**, so that I *understand* what happened when car does not *arrive* on time.

> **Pickup** has a status. And if there is one **pickup** with Success status, **Car Collection** Status should become PickedUp.

ปัญหาที่พบเจอบ่อย ๆ คือจะมีการเขียน code เพื่อไป "ล้วงข้อมูลจาก object ลูก" ออกมาแก้ไขเองโดยไม่ได้คำนึงว่ามันจะมีผลกระทบกับ object หลักยังไง

<script src="https://gist.github.com/raksit31667/496f7479fadc6e9feaf86a70a28374de.js"></script>

ผลที่เกิดขึ้นคือมีความเสี่ยงที่ในอนาคตคนจะมาล้วงข้อมูลโดยไม่ได้ระวังผลกระทบ ทำให้ข้อมูลไม่สอดคล้องกันส่งผลให้เกิด bug ตามมา เพื่อแก้ปัญหาเหล่านี้ DDD จึงมี object พิเศษเรียกว่า **"Aggregates"** โดยหากมีการปรับแก้ object ที่อยู่ในขอบเขตเดียวกัน ให้ทำบน object บนสุดของ relationship (Aggregate root) แปลว่ามันก็จะลดการ "ล้วงลูก" จากภายนอกขอบเขตได้นั่นเอง 

ผลพลอยได้ที่เกิดขึ้นจากการสร้าง Aggregates คือ สามารถ guarantee ความเป็น atomicity และ consistency ตามหลัก [ACID](https://en.wikipedia.org/wiki/ACID) ของระบบได้ด้วยการทำ transaction แต่ก็ต้องแลกมากับ performance และ availability ที่ตกลง ซึ่งตรงนี้เราก็ต้องไปตกลงกับ domain expert ละว่าเรื่องเหล่านี้มันพอจะหยวน ๆ กันได้ไหม  

ประเด็นสำคัญที่สุดในการสร้าง Aggregates คือเราต้องแยก relationship ของ object ให้ออกว่า domain object ไหนที่เวลามันถูกใช้งานแล้วมันจะต้องไปด้วยกันเสมอใช่หรือไม่ (เช่น `CarCollection` กับ `Pickup`) ซึ่งถ้าใช่ก็แปลว่ามันควรอยู่ใน context เดียวกัน ทำให้เราตีกรอบ Aggregates ได้ แต่ถ้าไม่ใช่มันก็เป็นแค่ Entity หรือ Value Object (เช่น `Status` ใน `CarCollection`)

> We invent aggregate to focus on their children, so that we know which children are accessible and which children must be handle within rigid boundary of consistency.

### Domain Service
ในระบบที่ใหญ่ขึ้นเราจะเจอกับ requirement ที่มี operation ที่ต้องใช้ domain object หลาย ๆ ก้อนมาคิดคำนวนด้วยกัน ปัญหาคือเราไม่รู้ว่า operation ที่ว่านั้นมันควรจะไปอยู่ใน domain object ไหนดี เช่น

> When car is *dropped* at the warehouse:
> - Update **a stock** count of a car with same model
> - Change status of a **car collection** to be dropped

จะสังเกตว่า method *DropCar* เนี่ยมันจะอยู่ใน **Stock** entity ก้ไม่ใช่ จะอยู่ใน **CarCollection** ก็ไม่เชิง ใน DDD ก็แก้ปัญหา gray area นี้ด้วย **Domain Service** ซึ่งจะต้องเป็น stateless เพื่อลด concern เรื่อง transaction, lifecycle, equality เป็นหน้าที่ของ Value Object, Entity, Aggregates ไป  

แต่จากประสบการณ์ของคนสอนเขาพบว่ามันน้อย ๆ มากเลยนะที่ระบบจะไม่ต้อง track lifecycle ของ method เหล่านี้ เช่น การ *DropCar* จะอาาจะต้องมี **Loading Form** เพื่อ track ว่าใครเข้า-ออกอู่รถเพื่อความปลอดภัย แปลว่า **Loading** ก็จะกลายเป็น Entity ใหม่ทันที 

> ดังนั้นตอนที่เรารับ requirement มาแล้วไม่แน่ใจว่าจะเอาไปไว้ใน domain object ไหนดีแล้วต้องพึ่งพา Domain Service มันเป็นสัญญาณให้เราขุด requirement ลึกลงไปว่ามันต้องมีอะไรมา track จริง ๆ ไหม 

### Domain Purity และ Dependency Rule