---
layout: post
title:  "สรุป Libraries และ APIs ของภาษา Java ฉบับสิ้นคิดประจำปี 2021"
date:   2021-07-17
tags: [java, library]
---

ปฏิเสธไม่ได้ว่าภาษา [Java ยังคงได้รับความนิยมอยู่ในปี 2021](https://www.tiobe.com/tiobe-index/) เนื่องจากภาษาเริ่มพัฒนามาตั้งแต่ปี 1995 ทำให้มี ecosystem ที่แข็งแกร่งมาก มี documentation ที่ครบถ้วน มี community ที่ใหญ่มาก มี libraries, frameworks, และ APIs ให้เลือกใช้ครบ สามารถใช้พัฒนาระบบแบบสากกะเบือยันเรือรบ  

เมื่อเรายอมรับและเข้าใจปัญหาที่เกิดขึ้นรวมถึงวิธีการแก้ไข การที่เรามีคู่มือสิ้นคิดอย่าง [20+ Essential Java Libraries and APIs Every Programmer Should Learn in 2021](https://medium.com/javarevisited/20-essential-java-libraries-and-apis-every-programmer-should-learn-5ccd41812fc7) น่าจะช่วยให้ย่นระยะเวลาการพัฒนาระบบของเราให้สั้นลง มาดูกันครับ  

## 1. Testing
หนึ่งในเหตุผล (หรือข้ออ้าง) ในการไม่เขียนชุดการทดสอบคือการไม่รู้จักเครื่องมือ ซึ่ง Java ก็มีเครื่องมือมาตรฐานโลกหลายอย่างให้เรียนรู้และเลือกใช้ เช่น

- [**JUnit**](https://junit.org/junit5/) สำหรับ unit testing, integration testing
- [**Mockito**](https://site.mockito.org/) หรือ [**PowerMock**](https://powermock.github.io/) สำหรับ [test double](https://martinfowler.com/bliki/TestDouble.html)
- [**Cucumber**](https://cucumber.io/docs/installation/java/) หรือ [**Robot framework**](https://robotframework.org/) สำหรับ end-to-end testing

## 2. JSON
ถือว่าเป็นรูปแบบข้อมูลที่เป็นมาตรฐานโลกสำหรับ web application ซะแล้ว แนะนำเป็น [**Jackson**](https://github.com/FasterXML/jackson) หรือ [**Gson**](https://github.com/google/gson)

## 3. Logging
เป็นวิธีการที่ง่ายที่สุดที่จะ monitor ระบบของเรา (รวมไปถึงการ debug สำหรับบางคน ฮ่าๆๆ) สำหรับ library ที่ช่วยจัดการ level ของ log (info, debug, warn, error) รวมถึง format ก็อย่างเช่น [**Log4j**](https://logging.apache.org/log4j/2.x/), [**SLF4J**](http://www.slf4j.org/), และ [**Logback**](http://logback.qos.ch/)

## 4. Common operation
ใครที่เขียน Java อาจจะต้องเจอกับเรื่องพื้นฐานอย่าง IO, Collections, email, cryptographic, random number generator ซึ่งบางอย่างเราก็ไม่จำเป็นต้องเขียนใหม่ทุกรอบแล้วเอาไปไว้ใน package แบบ common หรือ helper นะ (ผมก็เคยทำ ฮ่าๆๆ) library ที่แนะนำเลยคือ [**Google Guava**](https://github.com/google/guava) กับ [**Apache Commons**](https://commons.apache.org/)

## 5. HTTP
ที่จริง Java มี [HttpClient](https://docs.oracle.com/en/java/javase/11/docs/api/java.net.http/java/net/http/HttpClient.html) อยู่แล้ว แต่ต้องมาจัดการเรื่อง caching และ compression เอง [**OkHttp**](https://square.github.io/okhttp/) หรือ [**Apache HTTPClient**](https://hc.apache.org/httpcomponents-client-5.1.x/) หรือ [**AsyncHttpClient**](https://github.com/AsyncHttpClient/async-http-client) หรือใครมาสาย Spring Boot ก็จัด [**RestTemplate**](https://spring.io/guides/gs/consuming-rest/) หรือ [**WebClient**](https://docs.spring.io/spring-boot/docs/2.0.3.RELEASE/reference/html/boot-features-webclient.html) ไปเลย

## 6. XML
สำหรับคนที่ต้องจัดการข้อมูลกับ XML แนะนำเป็น [**dom4j**](https://dom4j.github.io/) ครับ

## 7. Excel
จะทำยังไงถ้าต้องอ่าน-เขียนลงไปใน Microsoft Document อย่าง Excel บอกเลยว่า Java ก็ทำได้ครับ แนะนำเป็น [**Apache POI API**](https://poi.apache.org/)

## 8. Bytecode
ส่วนตัวไม่เคยใช้เหมือนกันครับ แต่ถ้าถามว่า Java สามารถดำลงไปถึง low-level API เช่นทำงานกับ JVM ได้ไหม คำตอบคือได้ครับ (ทำอะไรก็ได้หมดเลยป่ะเนี่ย ฮ่าๆๆ) สำหรับ case นี้แนะนำเป็น [**Javassist**](https://github.com/jboss-javassist/javassist) หรือ [**CgLib**](https://github.com/cglib/cglib)

## 9. Database
สำหรับการเชื่อมต่อกับ database แน่นอนต้องผ่าน connection pool อยู่แล้ว เพราะประหยัด resource และจัดการ consistency นะ สำหรับ library ลองเป็น [**DBCP**](https://commons.apache.org/proper/commons-dbcp/) หรือจะไปสาย Spring Boot เลยจะดีกว่าครับ

## 10. Messaging
ระบบหลายๆ ที่ก็เริ่มเปลี่ยนการ communication เป็นแบบ asynchronous กันแล้ว เพื่อแยกระบบออกเป็นส่วนๆ ลดผลกระทบเมื่อระบบเกิดปัญหาและการ scale แบบ horizontal ก็ทำได้ง่ายขึ้นผ่าน messaging queue ซึ่งเราสามารถนำ [**JMS API**](https://www.oracle.com/technical-resources/articles/java/intro-java-message-service.html) มาช่วยได้

## 11. PDF
จัดการ Excel ได้แล้ว PDF ล่ะ ได้เหมือนกันครับ ลองดู [**Apache PDFBox**](https://pdfbox.apache.org/) หรือ [**iText**](https://itextpdf.com/en) ครับ

## 12. Date and Time
เป็น case มาตรฐานโลกเหมือนกัน สำหรับ Java 8 ขึ้นไป แนะนำให้ใช้ [Date & Time API](https://docs.oracle.com/javase/8/docs/technotes/guides/datetime/index.html) ที่ให้มาเลยครับ ถ้าเก่ากว่านั้นแนะนำเป็น [**Joda-Time**](https://www.joda.org/joda-time/) สิ่งที่ผมอยากเน้นคือ _เลือกใช้ตัวใดตัวนึงไปเลยดีกว่าใช้ปนๆ กัน ไม่งั้นมันไปเพิ่มแรงในการ maintain code ครับ_

## 13. HTML
สำหรับคนที่ต้องจัดการข้อมูลบน HTML เช่นการทำ [web scraping](https://stackpython.co/tutorial/web-scraping-python-beautifulsoup-requests) ใช้ [**JSoup**](https://jsoup.org/) ก็ไม่เลวครับ หรือจะเปลี่ยนไปใช้ Python ก็ดีครับ

## 14. Embedded SQL Database
เหมาะมากสำหรับการทดสอบครับ เนื่องจากไม่ต้อง provision database ขึ้นมาเองทุกครั้ง แนะนำเป็น [**H2**](https://www.h2database.com/html/main.html) ครับ

## 15. JDBC Debugging
เพิ่งรู้เหมือนกันครับว่ามันมี library แบบนี้ด้วย ในบทความแนะนำให้ลอง [**p6spy**](https://github.com/p6spy/p6spy) ครับ

## 16. Networking
สำหรับสาย low-level ดำลงไปในระดับ [transport layer](https://www.cloudflare.com/learning/ddos/glossary/open-systems-interconnection-model-osi/) เช่น TCP หรือ UDP ผ่าน [Java NIO](https://docs.oracle.com/javase/8/docs/api/java/nio/package-summary.html) แนะนำเป็น [**Apache MINA**](https://mina.apache.org/)

## 17. Serialization
เป็นอีกหนึ่งทางเลือกในการรับ-ส่งข้อมูลแทนการใช้ JSON หรือ XML เพื่อเพิ่ม performance ของระบบ และไม่ผูกมัดกับระบบ ตัวอย่างเช่น [การใช้งาน gRPC แทน HTTP API + JSON](https://dev.to/techschoolguru/is-grpc-better-than-rest-where-to-use-it-3blg) ซึ่งเหมาะกับระบบที่ต้องการ throughput สูงๆ latency ต่ำๆ ในส่วนของ library เริ่มจาก [**Google Protocol Buffer**](https://developers.google.com/protocol-buffers) เลยก็ดีครับ

> เมื่อพบเจอปัญหา แนะนำให้ยอมรับและเข้าใจมันก่อนเรานำเครื่องมือไปใช้ อย่าเอาเครื่องมือมากำหนดการแก้ปัญหานะ ไม่งั้นจะทำให้เราลำบากทีหลังได้
