---
layout: post
title:  "แนะนำวิธีตรวจสอบ dependency ด้วย Gradle แบบง่าย ๆ"
date:   2022-05-28
tags: [gradle]
---

จากบทความเกี่ยวกับการ[สรุปแนวทางการแก้ไข dependencies จาก OWASP dependency check]({% post_url 2022-03-22-owasp-dependency-check-resolution %}) หนึ่งในวิธีการอุดช่องโหว่ทางด้าน security คือการ upgrade dependencies ที่ได้รับผลกระทบ จากนั้นเราต้องทำการทดสอบระบบว่า หลัง upgrade มันยังทำงานได้อยู่เหมือนเดิมไหม ทั้ง functional และ non-functional requirement  

วิธีการ upgrade ก็คือเราจะประกาศตรงๆ (direct dependencies) เพื่อมาทับ dependency ที่ซ้อนอยู่อีกชั้นนึง (transitive dependencies) แต่ในบางครั้ง ใน Gradle เราสามารถดูความสัมพันธ์ของ dependency ได้ 2+1 วิธี

## 1. Gradle dependencies

```shell
$ ./gradlew dependencies

+--- io.awspring.cloud:spring-cloud-starter-aws -> 2.3.2
|    +--- io.awspring.cloud:spring-cloud-aws-context:2.3.2
|    |    +--- io.awspring.cloud:spring-cloud-aws-core:2.3.2
|    |    |    +--- org.springframework:spring-beans:5.3.2 -> 5.3.20 (*)
|    |    |    +--- org.springframework:spring-aop:5.3.2 -> 5.3.20 (*)
|    |    |    +--- com.amazonaws:aws-java-sdk-core:1.11.951
|    |    |    |    +--- commons-logging:commons-logging:1.1.3 -> 1.2
|    |    |    |    +--- org.apache.httpcomponents:httpclient:4.5.13
|    |    |    |    |    +--- org.apache.httpcomponents:httpcore:4.4.13 -> 4.4.15
|    |    |    |    |    +--- commons-logging:commons-logging:1.2
|    |    |    |    |    \--- commons-codec:commons-codec:1.11 -> 1.15
|    |    |    |    +--- software.amazon.ion:ion-java:1.0.2
|    |    |    |    +--- com.fasterxml.jackson.core:jackson-databind:2.6.7.4 -> 2.13.3 (*)
|    |    |    |    +--- com.fasterxml.jackson.dataformat:jackson-dataformat-cbor:2.6.7 -> 2.13.3
|    |    |    |    |    +--- com.fasterxml.jackson.core:jackson-databind:2.13.3 (*)
|    |    |    |    |    +--- com.fasterxml.jackson.core:jackson-core:2.13.3 (*)
|    |    |    |    |    \--- com.fasterxml.jackson:jackson-bom:2.13.3 (*)
|    |    |    |    \--- joda-time:joda-time:2.8.1
|    |    |    +--- com.amazonaws:aws-java-sdk-s3:1.11.951
|    |    |    |    +--- com.amazonaws:aws-java-sdk-kms:1.11.951
|    |    |    |    |    +--- com.amazonaws:aws-java-sdk-core:1.11.951 (*)
|    |    |    |    |    \--- com.amazonaws:jmespath-java:1.11.951
|    |    |    |    |         \--- com.fasterxml.jackson.core:jackson-databind:2.6.7.4 -> 2.13.3 (*)
|    |    |    |    +--- com.amazonaws:aws-java-sdk-core:1.11.951 (*)
|    |    |    |    \--- com.amazonaws:jmespath-java:1.11.951 (*)
|    |    |    +--- com.amazonaws:aws-java-sdk-ec2:1.11.951
|    |    |    |    +--- com.amazonaws:aws-java-sdk-core:1.11.951 (*)
|    |    |    |    \--- com.amazonaws:jmespath-java:1.11.951 (*)
|    |    |    \--- org.slf4j:slf4j-api:1.7.30 -> 1.7.36
|    |    +--- org.springframework:spring-context:5.3.2 -> 5.3.20 (*)
|    |    \--- org.slf4j:slf4j-api:1.7.30 -> 1.7.36
|    +--- io.awspring.cloud:spring-cloud-aws-autoconfigure:2.3.2
|    |    +--- io.awspring.cloud:spring-cloud-aws-context:2.3.2 (*)
|    |    +--- org.springframework.boot:spring-boot-autoconfigure:2.4.1 -> 2.6.8 (*)
|    |    \--- org.slf4j:slf4j-api:1.7.30 -> 1.7.36
|    \--- org.slf4j:slf4j-api:1.7.30 -> 1.7.36
+--- com.amazonaws:aws-java-sdk-sts:1.12.141
|    +--- com.amazonaws:aws-java-sdk-core:1.12.141 -> 1.11.951 (*)
|    \--- com.amazonaws:jmespath-java:1.12.141 -> 1.11.951 (*)
```

วิธีนี้จะทำการแสดง dependency ในรูปแบบของ tree ของทั้ง project ทำให้เราเห็นความสัมพันธ์ว่า dependency อะไรเรียกใช้ dependency อื่น ๆ อะไรบ้าง นอกจากนั้นยังสามารถแสดง tree สำหรับ dependency ที่เป็นทั้ง compile classpath และ runtime classpath แยกกันได้ด้วย

## 2. Gradle dependencyInsight

```shell
$ ./gradlew dependencyInsight --dependency okhttp

com.squareup.okhttp3:okhttp:4.9.3 (selected by rule)
   variant "apiElements" [
      org.gradle.category                 = library
      org.gradle.dependency.bundling      = external
      org.gradle.jvm.version              = 8 (compatible with: 17)
      org.gradle.libraryelements          = jar (compatible with: classes)
      org.gradle.usage                    = java-api
      org.jetbrains.kotlin.localToProject = public (not requested)
      org.jetbrains.kotlin.platform.type  = jvm (not requested)
      org.gradle.status                   = release (not requested)

      Requested attributes not found in the selected variant:
         org.gradle.jvm.environment          = standard-jvm
   ]

com.squareup.okhttp3:okhttp:4.9.3
\--- compileClasspath

com.squareup.okhttp3:okhttp:4.2.2 -> 4.9.3
\--- io.jaegertracing:jaeger-thrift:1.3.2
     \--- io.jaegertracing:jaeger-client:1.3.2
          \--- io.opentracing.contrib:opentracing-spring-jaeger-starter:3.3.1
               \--- io.opentracing.contrib:opentracing-spring-jaeger-cloud-starter:3.3.1
                    \--- compileClasspath
```

วิธีนี้จะทำการแสดง dependency เฉพาะเป็นอัน ๆ ไปในรูปแบบของ tree คล้าย ๆ กันกับวิธีแรก แต่จะมีข้อมูลเพิ่มขึ้นมา เช่น JVM version ที่ใช้ หรือ dependency configuration ที่ใช้ (compile classpath และ runtime classpath)  

## 3. Software Bill of Materials
ขอแนะนำเพิ่มอีก 1 วิธีนอกเหนือจากการทำผ่าน Gradle คือ Software Bill of Materials (SBOM) คือ list ของ open-source และ third-party software ในระบบของเรา ซึ่งประกอบไปด้วย license, version, และ security status มีเครื่องมือที่ช่วยสร้าง SBOM ให้เราได้อัตโนมัติเลยก็อย่างเช่น [Syft](https://github.com/anchore/syft)  

```shell
NAME                    VERSION      TYPE
alpine-baselayout       3.2.0-r18    apk
alpine-keys             2.4-r1       apk
apk-tools               2.12.7-r3    apk
busybox                 1.34.1-r4    apk
ca-certificates-bundle  20211220-r0  apk
libc-utils              0.7.2-r3     apk
libcrypto1.1            1.1.1n-r0    apk
libretls                3.3.4-r3     apk
libssl1.1               1.1.1n-r0    apk
musl                    1.2.2-r7     apk
musl-utils              1.2.2-r7     apk
scanelf                 1.3.3-r0     apk
ssl_client              1.34.1-r4    apk
zlib                    1.2.12-r0    apk
```

วิธีนี้มีข้อดีกว่า 2 อันข้างบนคือเราจะเห็น dependency ในระดับ container ด้วย ในกรณีช่องโหว่มันเกิดจากตัว container เอง ไม่ใช่ application

> แน่นอนว่าทั้ง 3 วิธีก็มี use case ที่ต่างกันออกไป เราสามารถเลือกใช้ร่วมกันตามความลึกของข้อมูลที่เราจะนำไปวิเคราะห์เพื่อหาวิธีทางแก้ไขปรับปรุงกันต่อไป สิ่งสำคัญที่สุดคือการจัดการด้าน security ควรจะเกิดขึ้นตั้งแต่ตอนเริ่มพัฒนาระบบเลย ไม่ใช่มาแก้กันอีกทีตอนจะ release หรือตอน release ไปแล้ว
