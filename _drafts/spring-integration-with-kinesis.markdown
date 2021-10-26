---
layout: post
title:  "จดบันทึกวิธีการ integrate Amazon Kinesis กับระบบที่พัฒนาใน Java Spring Boot"
date:   2021-10-25
tags: [java, spring, aws, kinesis]
---

ในระบบงานปัจจุบันมีการเชื่อมต่อกับ Amazon Kinesis ซึ่งมันคือ event streaming platform (ใครนึกภาพไม่ออกมันคือพวกเดียวกับ [Apache Kafka](https://medium.com/linedevth/apache-kafka-%E0%B8%89%E0%B8%9A%E0%B8%B1%E0%B8%9A%E0%B8%9C%E0%B8%B9%E0%B9%89%E0%B9%80%E0%B8%A3%E0%B8%B4%E0%B9%88%E0%B8%A1%E0%B8%95%E0%B9%89%E0%B8%99-1-hello-apache-kafka-242788d4f3c6) อ่ะครับ) โดย feature ที่เราใช้คือ data stream ไปทำการ read/write ข้อมูล นอกจากนั้นยังมี feature อื่นๆ เช่น Firehose (stream ข้อมูลไปหา Amazon S3 หรือ Amazon OpenSearch Service เพื่อทำ analytics) หรือ Video streaming  

บทความนี้จะมาแบ่งปันตัวอย่างแบบ update ล่าสุดปี 2021 ว่าเราจะเชื่อมต่อกับ Kinesis บน Spring application ได้อย่างไร รวมถึงหลักการเบื้องหลังของ library ที่เราใช้ด้วย

## พูดถึง Library ก่อน
Library ที่เราจะใช้คือ [spring-cloud-stream-binder-kinesis](https://github.com/spring-cloud/spring-cloud-stream-binder-aws-kinesis/blob/main/spring-cloud-stream-binder-kinesis-docs/src/main/asciidoc/overview.adoc) ซึ่งหลักการของมันเป็นตามภาพ

![Amazon Kinesis architecture](/assets/2021-10-26-amazon-kinesis-architecture.png)
<https://docs.aws.amazon.com/streams/latest/dev/key-concepts.html>

ใน data stream จะประกอบไปด้วยหลายๆ `shard` ซึ่งมันเอาไว้ระบุลำดับของข้อมูลซึ่ง read จะได้ 5 transactions/second หรือ 2 MB/second ส่วน write จะได้ 1000 transactions/second ซึ่ง shard มันประกอบไปด้วย `partitionKey` ซึ่งใช้ตอน group shard เข้าด้วยการเวลาเรา write data ลงไปจะต้องใช้คู่กับ `sequenceNumber` ซึ่งจะถูก assign ด้วย Kinesis เอง การที่เราจะ read/write เราสามารถใช้ Kinesis Producer และ Client library (KPL/KCL) ได้ ซึ่งเป็นส่วนนึงของ `spring-cloud-stream-binder-kinesis` ด้วย  

สิ่งที่ต่างจาก Apache Kafka คือ Amazon Kinesis จะไม่มีแนวคิดเรื่อง consumer group สิ่งที่ library นี้ทำคือจะเก็บ metadata และ lock ไว้ใน DynamoDB แยกกัน 2 table ซึ่งทำ logic ให้ consumer ตัวเดียวใน group เดียวกันทำการอ่าน message จาก shard นั้นๆ นอกจากนั้น library ยังสามารถ configure ให้กระจาย message ออกไปให้ consume group แบบเท่าๆ กันได้ด้วย  

## ติดตั้ง dependencies
ตัวอย่างการ declare dependencies ใน Gradle
<script src="https://gist.github.com/raksit31667/d641b07e833690f18f709a5f6f546521.js"></script>

## สร้าง function สำหรับการ produce หรือ consume
แต่เดิมเราใช้ [Spring Cloud Stream](https://spring.io/projects/spring-cloud-stream) ในการสร้าง producer หรือ consumer โดยที่ไม่จำเป็นต้องรู้เลยว่าเราใช้ตัวไหน middleware ตัวไหนก็ได้ ไม่ว่าจะเป็น Apache Kafka หรือ RabbitMQ หรือแม้กระทั่ง Kinesis โดยจะทำผ่าน interface ดังนี้

- `Source` สำหรับการกำหนด producer
- `Sink` สำหรับการกำหนด consumer
- `Processor` สำหรับการ process message จาก input นึงไป output นึง

<script src="https://gist.github.com/raksit31667/3298085d665dd9b878bdc975f2a1b188.js"></script>

<script src="https://gist.github.com/raksit31667/b097148ca9732b51bf10e7ea0ba3755e.js"></script>

<script src="https://gist.github.com/raksit31667/4b27da51aa114702a03f85c81b61e8a3.js"></script>

การมาของ functional programming ใน Java ผ่าน `java.util.function` ซึ่งข้อดีคือ function เหล่านี้สามารถนำไปประยุกต์ใช้กับ functional programming ส่วนอื่นๆได้ โดยทีี่ไม่ต้องผูกติดกับ Spring Cloud Stream โดยจะเปลี่ยนเป็น

- `Supplier` สำหรับการกำหนด producer
- `Consumer` สำหรับการกำหนด consumer
- `Function` สำหรับการ process message จาก input นึงไป output นึง

<script src="https://gist.github.com/raksit31667/4bdff51c046c6457d5d6e0211a822cd3.js"></script>

<script src="https://gist.github.com/raksit31667/1ac22cfcbf109380f29e642d7f919828.js"></script>

<script src="https://gist.github.com/raksit31667/af49575edfc734d6786b3f324e2c3ebb.js"></script>

![Amazon Kinesis architecture](/assets/2021-10-26-stream-applications-layered-architecture.png)
<https://spring.io/blog/2020/07/13/introducing-java-functions-for-spring-cloud-stream-applications-part-0>

สำหรับ non-application เราสามารถเขียนเป็น Function แบบนี้ก็ได้

<script src="https://gist.github.com/raksit31667/cc5cff857922a99b8fecb3621254fd33.js"></script>

สำหรับ Spring cloud stream configuration เราจะย้ายไปไว้ใน application configuration แทน

## Configuration
ในส่วนของ Kinesis เราสามารถกำหนดใน `application.properties` หรือ `application.yml` เบื้องต้นได้ตามนี้

<script src="https://gist.github.com/raksit31667/ec7c144369fd4d870a21f64a35032509.js"></script>

สำหรับการตั้งชื่อ binding จะมี format คือ

- output - <functionName> + -out- + <index> สำหรับ producer
- input - <functionName> + -in- + <index> สำหรับ consumer

โดยที่ `index` คือลำดับของการ binding [ในกรณีที่มีหลาย input ต่อหลาย output](https://cloud.spring.io/spring-cloud-stream/reference/html/spring-cloud-stream.html#_functions_with_multiple_input_and_output_arguments) สำหรับ case ปกติ ก็จะเป็น `index` ก็จะเป็น `0`  

สำหรับ [Kinesis Client Library](https://docs.aws.amazon.com/streams/latest/dev/developing-consumers-with-kcl.html) / [Kinesis Producer Library](https://docs.aws.amazon.com/streams/latest/dev/developing-producers-with-kpl.html) เป็นประโยชน์ในกรณีที่เราต้องการ feature ในการ re-balance ให้ consumer ไป consume shard เพื่อทำให้ consume ได้เร็วขึ้น

> น่าจะทำให้การเริ่มต้น integrate กับ Amazon Kinesis เป็นเรื่องง่ายขึ้น แน่นอนว่างานในส่วนอื่นๆ เช่น configuration และการกำหนด permission ให้ Spring application มีสิทธิ์เข้าถึง Kinesis ก็จำเป็นเช่นเดียวกัน โดยสามารถเข้าไปดูในส่วนของ configuration ตัวเต็มได้ที่ <https://github.com/spring-cloud/spring-cloud-stream-binder-aws-kinesis/blob/main/spring-cloud-stream-binder-kinesis-docs/src/main/asciidoc/overview.adoc>














