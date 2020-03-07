---
layout: post
title:  "บันทึกการทำ Integration testing ด้วย Spring Embedded Kafka"
date:   2020-03-07
tags: [spring, kafka, integration-testing]
---

ในระบบงานที่ทำอยู่มี Feature ที่จะต้อง integrate กับ Kafka ซึ่งเป็น publish-subscribe messaging โดยที่ระบบของเราจะ publish message ไปให้ consumer ที่ subscribe topic ของเราอยู่ แน่นอนว่าใน Spring สามารถทดสอบได้ด้วย `spring-kafka-test` มาเริ่มกันเลย  

## ขั้นตอนที่ 0 ติดตั้ง dependencies กันก่อน
มี 2 ตัวคือ 
- `org.springframework.kafka:spring-kafka` สำหรับ implementation
- `org.springframework.kafka:spring-kafka-test` สำหรับการทดสอบด้วย Embedded kafka server
- `org.springframework.boot:spring-boot-configuration-processor` สำหรับทำ auto-completion เวลา configure kafka ใน properties file (ทั้ง YAML และ Properties) ลงไม่ลงก็ได้แล้วแต่

<script src="https://gist.github.com/raksit31667/5f1748e24d8a9e9d50f40cb0266278f2.js"></script>

## ขั้นตอนที่ 1 มา configure Kafka กันก่อน
ในตัวอย่างนี้เราจะทดสอบการ publish message ฉะนั้นเราต้อง configure ส่วนของการ serialization ในฝั่ง producer ด้วย

<script src="https://gist.github.com/raksit31667/47174d36ff947ea1b676c21df9d12d91.js"></script>

## ขั้นตอนที่ 2 เตรียมเครื่องมือในการทดสอบ
สมมติว่าเราทำการส่ง notification message ไปหาฝั่ง consumer ผ่าน Kafka topic ชื่อ `order.created` หลังจากการสร้าง order สำเร็จ จะได้ตัวอย่างโค้ดประมาณนี้

<script src="https://gist.github.com/raksit31667/26edc7d54659e09e2338aa801c3f04d0.js"></script>

<script src="https://gist.github.com/raksit31667/509c26bc247c7c55451161425e631ae6.js"></script>

ทำการสร้าง abstract class เพื่อ setup embedded kafka broker แล้ว reuse กับทุกๆ การทดสอบที่ต้องการ

<script src="https://gist.github.com/raksit31667/86d41bade04b247c883a7b3b16e52111.js"></script>

#### คำอธิบาย
- สร้าง embedded kafka broker ที่มี topic `order.created` อยู่ 1 partition 
- แต่ละการทดสอบจะสร้าง consumer ใน consumer group ชื่อ `test-group` ขึ้นมาจาก consumer factory ที่ configure การ deserialize ทั้ง key และ value
- หลังจากทดสอบแต่ละเคสเสร็จ จะทำการ close connection ของ consumer ทิ้ง (ต่างจาก unsubscribe ตรงที่มันจะไม่ keep connection กับ broker แล้ว)
- จบแต่ละ class ก็ `shutdown` broker ทิ้ง รวมถึงต้อง `awaitShutdown` เพื่อรอให้มันทำเสร็จก่อนรัน class ถัดไป
- นอกจากนั้นยังมีการ configure อื่นๆ ที่จำเป็นอีก เช่น
  - `consumerProps.put(AUTO_OFFSET_RESET_CONFIG, "earliest");` เพื่อ read data จาก consumer API ตั้งแต่เริ่มต้น
  - `@TestInstance(Lifecycle.PER_CLASS)` บังคับให้ instantiate embedded kafka broker เพียงแค่ครั้งเดียวต่อ 1 test class เพราะมันนาน
  - `@DirtiesContext` เพื่อ clear Spring context ทั้งหมดไม่ให้เกิด side-effect ต่อการทดสอบอื่นๆ

จบด้วยการ configure การทดสอบให้ใช้ embedded kafka broker ตามนี้
<script src="https://gist.github.com/raksit31667/74b40fd7083cd6cd95a360f82f55ef5e.js"></script>

## ขั้นตอนที่ 3 เริ่มการทดสอบ
<script src="https://gist.github.com/raksit31667/6a4aa5a95f29cae99e9770153cd155ca.js"></script>

#### คำอธิบาย
นำ consumer ที่ได้สร้างไว้ในขั้นตอนที่ 2 มา subscribe Kafka topic `order.created` แล้วแปลงค่าให้เป็น `OrderKafkaMessage` โดยใช้ `ObjectMapper`  
  
  
## ปิดท้ายด้วยการรันชุดการทดสอบ
```
com.raksit.example.order.create.service.OrderServiceKafkaIntegrationTest > shouldReturnOrderResponseWithNumberOfItemsAndTotalPriceWhenCreateOrderGivenOrderRequest() PASSED
2020-03-07 13:45:24.989  WARN 15345 --- [ad | test-group] org.apache.kafka.clients.NetworkClient   : [Consumer clientId=consumer-test-group-1, groupId=test-group] Connection to node 0 (localhost/127.0.0.1:52210) could not be established. Broker may not be available.
```

## References
[http://kafka.apache.org/21/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html](http://kafka.apache.org/21/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html)