---
layout: post
title:  "จดปัญหาที่เจอเกี่ยวกับ MySQL และ TLS v1.2 บน Java"
date:   2021-07-05
tags: [mysql, tls, java, security]
---

เมื่ออาทิตย์ก่อนเจอปัญหาว่า application ไม่สามารถ connect กับ MySQL server ได้ มี error เกี่ยวกับ TLS Handshake ประมาณนี้

```
{"{"@timestamp":"2021-07-02T03:12:09.676+00:00","@version":"1","message":"HikariPool-1 - Exception during pool initialization.","logger_name":"com.zaxxer.hikari.pool.HikariPool","thread_name":"main","level":"ERROR","level_value":40000,"stack_trace":"com.mysql.cj.jdbc.exceptions.CommunicationsException: Communications link failure

The last packet sent successfully to the server was 0 milliseconds ago. The driver has not received any packets from the server.
    java.base/jdk.internal.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
    java.base/jdk.internal.reflect.NativeConstructorAccessorImpl.newInstance(Unknown Source)
    java.base/jdk.internal.reflect.DelegatingConstructorAccessorImpl.newInstance(Unknown Source)
    java.base/java.lang.reflect.Constructor.newInstance(Unknown Source)
    com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:61)
    com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:105)
    com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:151)
    com.mysql.cj.exceptions.ExceptionFactory.createCommunicationsException(ExceptionFactory.java:167)
    com.mysql.cj.protocol.a.NativeProtocol.negotiateSSLConnection(NativeProtocol.java:334)
    com.mysql.cj.protocol.a.NativeAuthenticationProvider.connect(NativeAuthenticationProvider.java:164)
    com.mysql.cj.protocol.a.NativeProtocol.connect(NativeProtocol.java:1342)
    com.mysql.cj.NativeSession.connect(NativeSession.java:157)
    com.mysql.cj.jdbc.ConnectionImpl.connectOneTryOnly(ConnectionImpl.java:956)
    com.mysql.cj.jdbc.ConnectionImpl.createNewIO(ConnectionImpl.java:826)
\t... 40 common frames omitted
Caused by: javax.net.ssl.SSLHandshakeException: No appropriate protocol (protocol is disabled or cipher suites are inappropriate)
    java.base/sun.security.ssl.HandshakeContext.<init>(Unknown Source)
    java.base/sun.security.ssl.ClientHandshakeContext.<init>(Unknown Source)
    java.base/sun.security.ssl.TransportContext.kickstart(Unknown Source)
    java.base/sun.security.ssl.SSLSocketImpl.startHandshake(Unknown Source)
    java.base/sun.security.ssl.SSLSocketImpl.startHandshake(Unknown Source)
    com.mysql.cj.protocol.ExportControlled.performTlsHandshake(ExportControlled.java:336)
    com.mysql.cj.protocol.StandardSocketFactory.performTlsHandshake(StandardSocketFactory.java:188)
    com.mysql.cj.protocol.a.NativeSocketConnection.performTlsHandshake(NativeSocketConnection.java:99)
    com.mysql.cj.protocol.a.NativeProtocol.negotiateSSLConnection(NativeProtocol.java:325)
\t... 45 common frames omitted
","applicationName":"..."}
```

## ต้นเหตุ
- พบว่าปัญหานี้ไม่เคยเกิดขึ้นมาก่อน และก่อนหน้านี้ไม่เคยเป็น
- ไม่มีการเปลี่ยนแปลงทางฝั่ง MySQL Server ดังนั้นน่าจะอยู่ที่ฝั่ง application ละ
- พบว่า application มีการ upgrade dependency ของ `mysql-java-connector` จาก `5.x.x` เป็น `8.x.x`
- เริ่มค้นหาจาก [released notes](https://dev.mysql.com/doc/refman/5.7/en/ssl-libraries.html) พบว่ามีการเปลี่ยนแปลงดังนี้

    - MySQL version ก่อนหน้า `5.7.28` จะใช้ [yaSSL](https://en.wikipedia.org/wiki/WolfSSL) สำหรับทำ TLS handshake ซึ่งจะถูกเปลี่ยนไปใช้ [OpenSSL](https://en.wikipedia.org/wiki/OpenSSL)
    - *yaSSL* รองรับแค่ *TLSv1* และ *TLSv1.1* เท่านั้น

- จาก [documentation](https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-using-ssl.html) พบว่า MySQL ใช้ Connector/J ในการ connect และ encrypt data ระหว่าง JDBC driver และ server ผ่าน SSL (ไม่นับตอน handshake)
- Connector ที่ใช้ version ต่ำกว่า `8.0.18` ไม่ได้เปิด *TLSv1.2* หรือสูงกว่าไว้ตั้งแต่ต้น ดังนั้นเมื่อต่อกับ server ที่กำหนด TLS version ไว้ชัดเจน จะต้องระบุ TLS version ด้วยผ่าน `enabledTLSProtocols` property
- ใน Exception ระบุว่า **No appropriate protocol (protocol is disabled or cipher suites are inappropriate)** ดังนั้นเลย assume ได้ว่า server ตั้ง TLS ไว้ที่ *TLSv1.2* ในขณะที่ client *yaSSL* ยังไง TLS ก็ไม่เกิน *TLSv1.2* ดังนั้น version ไม่ match กันแน่นอน

## วิธีแก้ปัญหา
ระบุ TLS version ผ่าน `enabledTLSProtocols` property เช่น `jdbc:mysql://${MYSQL_URL}:3306/${MYSQL_DB_NAME}?enabledTLSProtocols=TLSv1.2`

## สิ่งที่ได้เรียนรู้
- การ secure communication ระหว่าง JDBC driver กับ server เป็น tradeoff ระหว่าง security กับ performance (ขึ้นอยู่กับขนาดของ query และ network ด้วย)
- ใน [Amazon Aurora](https://aws.amazon.com/rds/aurora/) สามารถ configure SSL ผ่าน property `required_secure_transport` (ค่าตั้งต้นเป็น `false`)
- สามารถเข้าไปดู TLS version ที่ server support ได้ผ่าน [documentation](https://dev.mysql.com/doc/refman/5.7/en/encrypted-connection-protocols-ciphers.html) หรือ SQL command

```sql
mysql> SHOW GLOBAL VARIABLES LIKE 'tls_version';

+---------------+-----------------------+
| Variable_name | Value                 |
+---------------+-----------------------+
| tls_version   | TLSv1,TLSv1.1,TLSv1.2 |
+---------------+-----------------------+
```

- ใน MySQL version `5.7.28` ขึ้นไป สามารถใช้ *OpenSSL* ทำการทดสอบ secured connection ได้ด้วยการระบุ protocol เป็น `mysql` ผ่าน `starttls` option 

```shell
$ openssl s_client -starttls mysql -connect <mysql-url>:443
```

- Amazon เลือกใช้ CLI เป็น MariaDB แทนที่ MySQL
- [จากคำถามในStackOverflow](https://stackoverflow.com/questions/67332909/why-can-java-not-connect-to-mysql-5-7-after-the-latest-jdk-update-and-how-should?noredirect=1&lq=1) ไม่แนะนำให้แก้ไขปัญหานี้ด้วยการแก้ `jdk.tls.disabledAlgorithms` ใน `jre/lib/security` เนื่องจากอาจจะเกิดปัญหา security ขึ้นมาได้

> เมื่อมีการ upgrade dependency เราต้องระมัดระวังว่ามันอาจจะมี breaking change แบบนี้เกิดขึ้นได้ น่าสนใจว่าเราควรจะป้องกันไม่ให้มันเกิดขึ้นไหม แล้วถ้าเกิดขึ้นแล้วเราจะป้องกันยังไงไม่ให้มันเกิดซ้ำ