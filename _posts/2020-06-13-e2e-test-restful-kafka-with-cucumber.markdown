---
layout: post
title:  "ทำ E2E testing กับ RESTful และ Kafka ด้วย Cucumber"
date:   2020-06-13
tags: [end-to-end-testing, cucumber]
---
ว่างๆ ผมคิดดูว่าถ้าเราจะทำ end-to-end testing กับระบบปัจจุบันของเราที่ประกอบไปด้วย API และ Kafka น่าจะมี tool ให้เลือกใช้อยู่บ้าง งั้นลองใช้ Cucumber ซึ่งเป็น behavior-driven-development (BDD) ดู น่าจะช่วยทำให้ development team ทำงานด้วยกันได้ง่ายขึ้น เนื่องจากภาษาที่ใช้เขียนเป็น Given-When-Then แบบคนธรรมดาเข้าใจได้เลย

![Trigger result](/assets/2020-06-13-example-e2e-diagram.jpg)
  
<https://www.melvinvivas.com/developing-microservices-using-kafka-and-mongodb/>

## Cucumber มีส่วนประกอบคร่าวๆ อยู่ 2 ส่วน
- Feature ไว้กำหนด scenario เขียนโดยใช้ Gherkin syntax เช่น กำหนดตัวแปรของ test หรือจัดกลุ่มโดยใช้ `@tags`
- Step definitions เป็น code ที่ใช้เขียนตาม Scenario ที่เราได้กำหนดไว้ (ในตัวอย่างจะใช้ Java)

## เริ่มจากสร้าง Scenario มาซักเคสนึงก่อน
<script src="https://gist.github.com/raksit31667/31f88c3d1678c5eb3c5ed0cbec2c3d1b.js"></script>

<script src="https://gist.github.com/raksit31667/6dce24e3fe2dcf2c3047798b717f1a33.js"></script>

**ระวัง** ถ้าตัวแปรของเราเป็น String ต้องมี double-quote ด้วยนะ ไม่งั้น Cucumber มันนึกว่าเป็น description เฉยๆ  

## มาถึงในส่วนของ coding ละ

### เริ่มจาก dependencies เหมือนเคย
ทำตาม <https://cucumber.io/docs/tools/java/#gradle> ได้เลยสำหรับคนใช้ Gradle
<script src="https://gist.github.com/raksit31667/7dacf37c7dea85533a489ac22a30bd58.js"></script>

### เอา Scenario file พร้อมกับ JSON file ไปไว้ใน `src/test/resources`
```
src
│   build.gradle
└───test
│   │
│   └───your.package.name // สำหรับเก็บ step definitions
│       |   
|       └───YourStepDefinitions.java
│   |   
|   └───resources // สำหรับเก็บ feature
│       |   
|       └───YourScenario.feature
│       |   
|       └───your.json
│
│       
```

### สร้าง class เอาไว้ใช้จัดการกับ Kafka
ปัญหาคือเราทำการทดสอบกับระบบจริงๆ ทีนี้ตอนเรา subscribe message มาเราจะรู้ได้ไงว่าอันไหนเป็นของเรา วิธีของผมง่ายๆคือ ก็ให้ Kafka client ทำการ poll หรือ subscribe และดึง message ออกมาเรื่อยๆ ทุกๆ วินาทีก็ได้ แล้วค่อยเอา message มาเทียบหาเอา เช่น id เป็นต้น  

สร้าง `kafka.properties` ไว้ใน `src/test/resources`
<script src="https://gist.github.com/raksit31667/f6cdd05936043f2914f5e8f0e0bb59ba.js"></script>

<script src="https://gist.github.com/raksit31667/19bcd777318089de9e233ffce23bf077.js"></script>

### สร้าง Step definitions
<script src="https://gist.github.com/raksit31667/236804a990c37502305da8db10ad189e.js"></script>

### ปิดท้ายด้วยการ run ผ่าน Gradle CLI
```sh
./gradlew cucumber -Dtoken=<your-token-here> -DorderHostName=<your-api-hostname> -DkafkaBootstrapServers=<your-kafka-here>

```

ได้ผลลัพธ์หน้าตาประมาณนี้  
```
Scenario: Happy path                                          # src/test/resources/CreateAnOrder.feature:2
  Given a order request as described in "order.json"          # com.raksit.example.CreateAnOrderStepDefinitions.readAnOrderRequestFromJsonFile(java.lang.String)
  When send a request to create an order successfully         # com.raksit.example.CreateAnOrderStepDefinitions.createAndOrder()

{"orderId":"c62c5eb4-62b4-48dc-bf55-64629dc800a6"}
  And wait for notification from the system within 5 seconds  # com.raksit.example.CreateAnOrderStepDefinitions.waitForSystemNotification(int)
  Then a user should receive a notification with a correct id # com.raksit.example.CreateAnOrderStepDefinitions.shouldReceivedNotificationWithCorrectId()

1 Scenarios (1 passed)
4 Steps (4 passed)
0m6.729s
```

![Trigger result](/assets/2020-06-16-example-e2e-test-results.png)
  
> code ตัวอย่าง <https://github.com/raksit31667/example-cucumber-restassured-kafka>