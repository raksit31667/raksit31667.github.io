---
layout: post
title:  "บันทึกการทำ Integration testing ด้วย Spring Embedded Kafka"
date:   2020-02-24
tags: [spring, kafka, integration-testing]
---

ในระบบงานที่ทำอยู่มี Feature ที่จะต้อง integrate กับ Kafka ซึ่งเป็น publish-subscribe messaging โดยที่ระบบของเราจะ publish message ไปให้ consumer ที่ subscribe topic ของเราอยู่ แน่นอนว่าใน Spring สามารถทดสอบได้ด้วย `spring-kafka-test` มาเริ่มกันเลย  

## ขั้นตอนที่ 0 ติดตั้ง dependencies กันก่อน
มี 2 ตัวคือ 
- `org.springframework.kafka:spring-kafka` สำหรับ implementation
- `org.springframework.kafka:spring-kafka-test` สำหรับการทดสอบ

ซึ่งปัจจุบันใน version 2.4.x อ้างอิงจาก [doc](https://docs.spring.io/spring-kafka/reference/html/#deps-for-24x) จะต้องทำการ override Kafka dependencies จาก Spring Boot ตามนี้  

<script src="https://gist.github.com/raksit31667/5f1748e24d8a9e9d50f40cb0266278f2.js"></script>

## @EmbeddedKafka

## @BeforeEach setUp consumer using consumerFactory

## consumer.subscribe(...)

## @AfterEach tearDown close consumer connection

## @AfterAll close embedded kafka servers

[http://kafka.apache.org/21/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html](http://kafka.apache.org/21/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html)