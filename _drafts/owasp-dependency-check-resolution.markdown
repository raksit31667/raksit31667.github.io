---
layout: post
title:  "สรุปแนวทางการแก้ไข dependencies จาก OWASP dependency check"
date:   2022-03-22
tags: [spring, owasp, security]
---

ปัจจุบันในงานที่ทำอยู่มีการเสริมความมั่นใจทางด้าน security ด้วยการตั้ง schedule ในการ scan เพื่อหาช่องโหว่ (vulnerabilities) ที่ถูกรายงานจาก OWASP ซึ่งไปเอาข้อมูลมาจาก [NVD](https://nvd.nist.gov/) อีกที  

จากการพูดคุยกับทีมอื่นๆ พบว่าไม่ค่อยมีประโยชน์เท่าไร เพราะ report ที่ออกมาส่วนใหญ่มันบอกว่ามีช่องโหว่ ความจริงคือไม่มีช่องโหว่ เราเรียกว่า false-positive 

- report ที่ออกมาส่วนใหญ่มันบอกว่ามีช่องโหว่ ความจริงคือไม่มีช่องโหว่ เราเรียกว่า false-positive ต้องลงเอยด้วยการ suppress มันตลอด สุดท้ายเราก็เอามันออกไปถาวร
- ไม่มีเวลาค้นหา ไม่มีเวลาแก้ไข ไม่มี business value ตรงๆ ก็ suppress ไว้ก่อน แล้วก็เอาไว้ทำทีหลัง (ง่ายๆ คือเราไม่ทำ *later == never*)

สุดท้ายถ้าระบบเราถูกโจมตีจากช่องโหว่นั้น ทีมพัฒนาก็ต้องเป็นคนรับผิดชอบอยู่ดี ดังนั้นน่าจะเป็นเรื่องที่ดีกว่าถ้าเราใส่ใจกับเรื่อง security ตั้งแต่ต้นสายของการพัฒนา (shift left security) บทความนี้จะมาสรุปแนวทางแก้ไข dependencies จาก OWASP กัน

## Upgrade plugin ให้เป็น version ล่าสุด
ในความจริงที่ว่าบาง dependencies ที่มันเป็น false-positive ความจริงกว่าคือมันมีช่องโหว่จริงๆ แต่ plugin เราไม่ up-to-date เป็นข้อมูลล่าสุดต่างหาก การ upgrade plugin ก็จะทำให้ข้อมูลจาก NVD รวมถึง list ของ false-positive dependencies เป็นล่าสุดด้วย ยกตัวอย่างจาก Gradle plugin  

<script src="https://gist.github.com/raksit31667/77afcb57970faae33ba7dbaa4d3c07b7.js"></script>

## ทำความเข้าใจช่องโหว่แบบคร่าวๆ
แต่ละช่องโหว่จะมี [Common Vulnerabilities and Exposures score](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures) (CVE score) และจะมี report พร้อมคำอธิบายของช่องโหว่ สิ่งที่เราแนะนำคืออ่านและทำความเข้าใจกับช่องโหว่เหล่านั้นสักหน่อย ถ้าเราไม่ได้รับผลกระทบจากมันเลย ก็ไม่มีความจำเป็นที่จะต้องไป upgrade

### log4shell ในตำนาน

![CVE for Log4shell](/assets/2022-03-22-cve-log4shell.png)

<https://nvd.nist.gov/vuln/detail/CVE-2021-44228> เป็นตัวอย่าง CVE ที่เราควรจะจัดการอย่างด่วนที่สุด แต่จาก [blog ใน Spring](https://spring.io/blog/2021/12/10/log4j2-vulnerability-and-spring-boot) ระบบจะมีช่องโหว่ถ้าเราเปลี่ยน default logging เป็น Log4j2 เท่านั้น  

วิธีการ upgrade ก็คือเราจะประกาศตรงๆ (direct dependencies) เพื่อมาทับ dependency ที่ซ้อนอยู่อีกชั้นนึง (transitive dependencies)

<script src="https://gist.github.com/raksit31667/8f9cb9e5ef9f15437ee86dbe77faf080.js"></script>

จากใน blog เดียวกัน บอกว่า

> Spring Boot 2.5.8 and 2.6.2 haven been released and provide dependency management for logback 1.2.9 and Log4J 2.17.0.

ดังนั้นเราก็มีอีกทางเลือกนึงคือ upgrade Spring Boot version ซะ

<script src="https://gist.github.com/raksit31667/bbdadfbd3e28d881104b76270056eb76.js"></script>

### Apache Tomcat

![CVE for Apache Tomcat](/assets/2022-03-22-cve-apache-tomcat.png)

<https://nvd.nist.gov/vuln/detail/CVE-2022-23181> กระทบกับ Apache Tomcat ซึ่ง Spring Boot ใช้ Embedded Tomcat เป็น default web server นั่นเอง ถึงแม้ว่า CVE score จะสูง แต่คำอธิบายบอกว่า

> This issue is only exploitable when Tomcat is configured to persist sessions using the FileStore.

<script src="https://gist.github.com/raksit31667/952abb368cd4cb63d0a84166286b5b28.js"></script>

หมายความว่าถ้าเราไม่ได้ configure persist sessions ตามที่บอก ก็ไม่จำเป็นต้อง upgrade ทันที เลือกที่จะ suppress และรอ Spring Boot upgrade ดีกว่า

## Upgrade dependencies อื่นๆ ที่ได้รับผลกระทบ
**การ upgrade dependencies มันก็มีค่าใช้จ่าย** เช่น เราต้องทำการทดสอบระบบว่า หลัง upgrade มันยังทำงานได้อยู่เหมือนเดิมไหม ทั้ง functional และ non-functional รวมไปถึงการ upgrade dependencies อื่นๆ ที่ได้รับผลกระทบ เนื่องจาก dependencies มันก็ขึ้นกันเองด้วย ดังนั้นตอนที่เราตัดสินใจว่าจะ upgrade เราควรจะตรวจสอบว่ามันมี case เหล่านี้เกิดขึ้นหรือไม่ เช่น Spring Boot และ Spring Cloud  

![Spring Cloud compatibility with Spring Boot](/assets/2022-03-22-spring-cloud-boot-compatibility.png)

<https://spring.io/projects/spring-cloud#overview>

## Shift left security
ยิ่งเราใส่ใจกับเรื่อง security ตั้งแต่ต้นสายของการพัฒนา (shift left security) มากเท่าไร ค่าใช้จ่ายในการค้นหาต้นเหตุของปัญหา security ก็จะยิ่งน้อบลงไปเท่านั้น ดังนั้นการตรวจสอบ dependencies ควรจะอยู่ในขั้นตอนการ development เลย เช่น ใส่ไว้ใน Git hooks ตอน `pre-push` หรือสร้าง schedule ไว้ run ทุกวันก็ยังได้ หรือจะไปทางเครื่องมือ scan อย่างพวก [dependabot](https://github.com/dependabot) หรือ [Snyk](https://github.com/dependabot) ยิ่งดี และจะดีมากขึ้นถ้ามีการทดสอบทาง security อื่นๆ เช่น 

- Container security scan
- Pen testing
- Threat modeling
- Security standards ในองค์กร

![Shift left security](/assets/2022-03-22-shift-left-security.png)

<https://www.klogixsecurity.com/blog/shift-left-the-rise-of-devsecops>