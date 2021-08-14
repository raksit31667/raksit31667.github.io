---
layout: post
title:  "ลองเขียน specification สำหรับ event-driven architecture ด้วย AsyncAPI"
date:   2021-08-05
tags: [asyncapi, specification, event-driven-architecture]
---

ในบทความนี้จะพามารู้จักกับ [AsyncAPI](https://www.asyncapi.com/) ซึ่งเป็น specification ในการพัฒนาระบบที่ใช้ [event-driven architecture](https://martinfowler.com/articles/201701-event-driven.html) ถ้าใครนึกภาพไม่ออก ลองเทียบกับระบบ API ดูก็ได้ครับ

## Documentation vs Specification
ในการพัฒนาระบบแบบ event-driven นั้น มักจะมีจุดเริ่มต้นมาจาก business requirements เพื่อกำหนดรูปแบบของคำสั่ง (command) และเหตุการณ์ (event) เช่นคำสั่ง TurnLightOff ทำให้เกิดเหตุการณ์ LightTurnedOff เป็นต้น ดังนั้น developer ก็จะมีการใช้เครื่องมือในการสื่อสารกับคนอื่นๆ ทั้ง business users รวมถึงเหล่า developer ด้วยกันเอง

**Documentation**: คู่มือในการใช้งานระบบสำหรับ publisher และ subscriber ที่ต้องการจะใช้งาน event ซึ่งควรทำออกมาเข้าใจง่าย รายละเอียดครบ สามารถทำตามได้
**Specification**: คู่มืออธิบายแบบกว้างๆ อธิบายวิธีทำให้ command และ event เกิดขึ้น และหน้าตาของมันเป็นยังไง และแต่ละ command หรือ event มีความเกี่ยวข้องกันยังไง ซึ่งเป็นสิ่งที่สะท้อนแนวทางการออกแบบระบบด้วย

> AsyncAPI เป็นทั้ง documentation และ specification เนื่องจากเราสามารถรายละเอียดในการใช้งานระบบ และรูปแบบของ command และ event ได้

![AsyncAPI specification](/assets/2021-08-12-asyncapi-specification.png)

## Code first vs Design first
ในการพัฒนา software ทั่วๆ ไปนั้น เราสามารถเลือกได้ว่าจะ design ก่อนหรือจะ code ก่อน ซึ่งทั้ง 2 แบบก็มีทั้งข้อดีและข้อเสียกันไป

**Code first**: เป็นแนวทางที่นิยมใช้กันอยู่แล้ว โดยเริ่มจากการแปลง business requirements ให้กลายเป็น code จากนั้นก็ทำการสร้าง documentation จาก code ของเรา โดยเราสามารถ document แยกเองหรือจะให้ระบบทำการสร้างให้อัตโนมัติก็ได้ เหมาะสำหรับงานที่ต้องการส่งมอบเร็วๆ หรือใช้กันแค่ภายในทีม เพราะไม่จำเป็นต้องมาร่าง documentation ก่อน ค่อยไปทำหลังจากส่งมอบก็ได้

**Design first**: เป็นแนวคิดใหม่ที่ตรงข้ามกับ code first ก็คือเราสร้าง documentation (contract) ขึ้นมาตาม business requirement จากนั้นระบบจะทำการสร้าง code จาก documentation นั้น โดยเราสามารถเขียน code เองหรือจะให้ระบบทำการสร้างให้อัตโนมัติก็ได้ เหมาะสำหรับระบบที่เน้นค่อยๆ เติบโตทีละเล็กๆ ซึ่งจะต้องใช้เวลาส่วนใหญ่ในการ design ให้เหมาะสมกับการใช้งานที่หลากหลายจาก user หรือทีมอื่นๆ ซึ่งแนวคิดจะสำเร็จได้ต้องมี documentation และ specification ที่ดีตามที่กล่าวไว้ข้างบน

> AsyncAPI สนับสนุนทั้งแนวคิด code-first และ design-first มี[เครื่องมือให้เลือกใช้ทั้งการพัฒนาและการทดสอบ](https://www.asyncapi.com/docs/community/tooling)

![Code first vs Design first](/assets/2021-08-12-code-first-vs-design-first.jpeg)

## ลองใช้งาน AsyncAPI
ในตัวอย่างนี้เราจะใช้แนวคิด design-first ในการสร้าง specification ผ่าน AsyncAPI กัน โดยเราจะสร้างระบบวัดความเข้มแสงของไฟถนน (Streetlight) โดยจะส่ง event ผ่าน event streaming platform อย่าง Apache Kafka

### ร่าง Contract
เราสามารถร่างและดู output ไปแบบ realtime ผ่าน [AsyncAPI Hub](https://hub.asyncapi.io/) โดย specification จะล้อมากับ OpenAPI ที่เป็น standard ของระบบ API เลย โดยมี component ตามรูป จะเยอะไปไหน

![AsyncAPI vs OpenAPI](/assets/2021-08-14-asyncapi-openapi.png)

- **Info**: ข้อมูลเบื้องต้น ของระบบ เช่น ชื่อหรือ version ของระบบ คำอธิบาย license เป็นต้น
- **Servers**: ข้อมูล server ที่ไว้ publish-subscribe event เช่น host port protocol รวมไปถึง security authentication ตอนที่เขียนบทความนี้ Async รองรับ protocol:
  - **AMQP**: สำหรับ messaging ไว้ใช้กับพวก RabbitMQ ActiveMQ
  - **MQTT**: สำหรับ Internet of Things (IoT)
  - **Kafka**: สำหรับ event streaming
  - **WebSocket**: สำหรับ web browser
  - **HTTP**: สำหรับ HTTP streaming API
- **Components**: ข้อมูล payload ทั้ง strucuture และ data type
- **Channels**: ข้อมูลของ command และ event ที่มีในระบบ ซึ่งเราสามารถ refer ข้อมูล payload จาก **Components** มาได้

code ของ contract ระบบเราจะเป็นประมาณนี้

<script src="https://gist.github.com/raksit31667/6d2805f650b9e5d151372038b23519f0.js"></script>

### ติดตั้งระบบ
เริ่มจากการ download [dependency](https://github.com/asyncapi/generator) ที่ใช้ในการ generate code ขึ้นมาก่อนผ่าน `npm` หรือ `yarn` ดังนั้นในเครื่องเราต้องมี Node.js ก่อน (ขณะที่เขียนบทความนี้ ระบบต้องมี Node.js version `>=12.16` ขึ้นไป)

```shell
$ npm i -g @asyncapi/generator
```

### Generate code
ทีนี้เราสามารถเลือกได้เลยว่าเราจะ generate code เป็นภาษาอะไร ขณะที่เขียนบทความมี option ให้เลือกประมาณนี้
- **JavaScript**: ผ่าน Node.js และ [Hermes](https://github.com/facebook/hermes) มี support WebSocket ด้วย
- **Java**: ผ่าน Spring framework หรือ Spring Cloud Stream
- **Python**: ผ่าน [Paho MQTT](https://www.eclipse.org/paho/index.php?page=clients/python/docs/index.php) เอาใจสาย IoT
- **Golang**: ผ่าน [Flogo](http://www.flogo.io/)
- **HTML และ Markdown**: สำหรับ generate contract เป็น static content

ในตัวอย่างนี้เราเลือกเป็น Java run คำสั่งผ่าน command-line

```shell
$ ag <your-contract-url-or-filename> @asyncapi/java-spring-template -o <your-output-directory>
```

เราก็จะได้ code ตัวอย่างมาประมาณนี้

<script src="https://gist.github.com/raksit31667/c4848487ceb3d95766a63a7a0b8240cb.js"></script>

<script src="https://gist.github.com/raksit31667/41fa5c2f5a3a53f2e72c942234f6a915.js"></script>

ถ้าเราอยากจะ run หน้า contract ไว้ดูต่างหน้า ก็สามารถ run อีกคำสั่งได้

```shell
$ ag asyncapi.yaml @asyncapi/html-template -o web
```

![AsyncAPI HTML](/assets/2021-08-14-asyncapi-html.png)

นอกจากนี้แล้วยังมี tool ที่น่าสนใจที่น่าไปลองอีก เช่น

- [Microcks.io](https://microcks.io/) สำหรับทำ API mocking และ testing โดยอ่านจาก AsyncAPI specification

<iframe width="560" height="315" src="https://www.youtube.com/embed/ise7ljoGdEY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## ว่าด้วยเรื่องของอนาคต
สำหรับอนาคตของ AsyncAPI ได้มีการประกาศ [roadmap](https://asyncapi.io/roadmap) ออกมาให้ดูกันเลย โดยมีหัวข้อที่น่าสนใจ เช่น
- การสร้าง documentation เป็น React app แทนการ host static web เอง
- Support schema เพิ่มเช่น Avro และ Protobuf
- การเติบโตของ opensource community เช่น จำนวนของ contributor !!

> โดยรวมแล้วคิดว่า AsyncAPI เป็นเครื่องมือที่ใช้แนวคิดคล้ายกับ OpenAPI ที่พัฒนา design-first ผ่าน specification เพียงแค่เปลี่ยนจากระบบ API เป็น event-driven เท่านั้นเอง

## References
- [Understanding the Differences Between API Documentation, Specifications, and Definitions](https://swagger.io/resources/articles/difference-between-api-documentation-specification/)
- [Design First or Code First: What’s the Best Approach to API Development?](https://swagger.io/blog/api-design/design-first-or-code-first-api-development/)