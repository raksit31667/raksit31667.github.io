---
layout: post
title:  "เส้นทางการ upgrade ไปสู่ Spring Boot 3"
date:   2022-06-15
tags: [spring]
---

![Spring Boot](/assets/2022-06-15-spring-boot.png)

เมื่อสิ้นเดือนที่ผ่านมา Spring Boot ได้ออก minor release ใหม่ คือ [v2.7.0](https://spring.io/blog/2022/05/19/spring-boot-2-7-0-available-now) โดยมี update ใหม่ ๆ เช่น

- [Spring for GraphQL 1.0](https://spring.io/blog/2022/05/19/spring-for-graphql-1-0-release)
- [Docker alternative image building with Podman](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.7-Release-Notes#podman-support)
- [Actuator info endpoint ละเอียดขึ้น](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.7-Release-Notes#operating-system-information-in-info-endpoint)
- [Dependency upgrades ต่าง ๆ](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.7-Release-Notes#dependency-upgrades)

สำหรับ project ที่ expose auto-configuration เช่น Maven library เดิมทีเราจะกำหนด auto-configuration class ไว้ใน `META-INF/spring.factories` ใน resource classpath ดังนี้

<script src="https://gist.github.com/raksit31667/9e9b5dfa98650ab76c9221180c3d58e2.js"></script>

ใน Spring Boot 2.7 จะต้องเปลี่ยนเป็น `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` ใน resource classpath ดังนี้

<script src="https://gist.github.com/raksit31667/fe868ef17f30c6de71770bded42a9905.js"></script>

สิ่งที่น่าสนใจของการ upgrade ใน version นี้คือ มันจะเป็น version สุดท้ายก่อนที่จะ upgrade อีกเป็น 3.0 ที่จะมาใน November 2022 นั่นหมายความว่าเราจะต้องเตรียมตัวให้พร้อมแต่เนิ่น มาดูกันว่ามีอะไรต้องทำบ้าง

- **Upgrade JDK ให้เป็น Java 17** เนื่องจาก Spring Boot 3.0 จะใช้ Spring Framework 6.0 ซึ่งรองรับ Java 17 ขึ้นไป สำหรับแนวทางการ upgrade สามารถดูได้จากบทความ [การ migrate Java project ไป version ใหม่ต้องคำนึงถึงอะไรบ้าง]({% post_url 2022-02-23-java-migration-strategy %})
- **Upgrade Spring Boot ให้เป็น 2.7.x** เนื่องจากตอน release Spring Boot 3.0 จะมี migration guide จาก 2.7 เท่านั้น หมายความว่าก่อน migrate ตัว Spring Boot version ก็ควรจะอยู่ที่ 2.7.x แล้ว
- **Upgrade dependency ให้เป็นล่าสุด** เนื่องจาก third-party บางตัวอาจจะไม่รองรับ Spring Framework 6.0 หรือ Jakarta EE 9 ใน Spring Boot 3.0
- 

> สามารถดูรายละเอียดเพิ่มเติมได้ใน [Preparing for Spring Boot 3.0 จาก Spring Blog](https://spring.io/blog/2022/05/24/preparing-for-spring-boot-3-0)
