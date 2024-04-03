---
layout: post
title: "จดบันทึกวิธีแก้ Connection refused ระหว่าง integration test โดยใช้ Testcontainers"
date: 2024-03-23
tags: [docker, testcontainers, integration-testing]
---

วันนี้กลับมาเขียน Java อีกครั้งเพื่อเตรียมสอน workshop เกี่ยวกับการพัฒนา software ด้วย project จำลองคล้าย production เพื่อให้สมจริงเราจึงต้องมีการใช้ integration test ด้วย Testcontainers ซึ่งเคย[เขียนบทความไว้เมื่อ 3 ปีที่แล้ว]({% post_url 2021-09-06-database-testcontainers-in-docker %}) แต่ 2 ปีผ่านไปพอลองมา run ในเครื่องแล้วทำไมมัน fail แล้วขึ่้น exception แบบนี้

```
21:29:20.394 [main] DEBUG org.testcontainers.shaded.com.github.dockerjava.core.exec.InspectContainerCmdExec - GET: DefaultWebTarget{path=[/containers/5409773a80d2342cbdc6a5c1b9533749bd23c7dc837d8378575e49c4bee70222/json], queryParams={}}
21:29:22.593 [testcontainers-ryuk] WARN org.testcontainers.utility.ResourceReaper - Can not connect to Ryuk at localhost:55005
java.net.ConnectException: Connection refused: connect
	at java.base/java.net.PlainSocketImpl.connect0(Native Method)
....
```

พบว่าแท้จริงแล้วปัญหามันอยู่ที่ [Colima](https://github.com/abiosoft/colima) แต่เราก็ได้แก้ด้วยการเพิ่ม environment variable เพื่อ configure Docker host ให้ชี้ไปหา Colima แทนแล้วตาม[บทความเมื่อ 2 ปีที่แล้วเช่นกัน]({% post_url 2022-05-01-colima-as-docker-alternatives %}) 

```shell
$ export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
$ export DOCKER_HOST="unix://${HOME}/.colima/docker.sock"
```

แต่แล้ว error มันก็ยังอยู่ พอกลับไปไล่ดูใน [official documentation](https://java.testcontainers.org/supported_docker_environment/) ก็พบว่าปัญหามันอยู่ที่ [Ryuk](https://github.com/testcontainers/moby-ryuk) ซึ่งเป็นตัวช่วยลบ containers/networks/volumes/images เพื่อ clean up หลังจากทดสอบนั่นเอง คราวนี้ Ryuk จะ run เป็น [privileged container](https://learn.snyk.io/lesson/container-runs-in-privileged-mode/) แปลว่า container จะได้ root access เท่ากับ host ที่ run มัน แต่ว่า Colima มันปิด IP address เป็นค่าตั้งต้นเพราะว่าการเปิด root access มันไม่ secure และจะ start ได้ช้าลง  

วิธีแก้คือต้องไปเปิด IP address ใน Colima ด้วยการเพิ่ม `--network-address` flag ลงไปตอน start Colima แล้วตั้ง environment variables ดังนี้

```shell
$ colima start --network-address
$ export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
$ export TESTCONTAINERS_HOST_OVERRIDE=$(colima ls -j | jq -r '.address')
$ export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
```

> แต่พอลอง run แล้วมันก็ยังไม่ work แล้ว network address ก็ไม่ขึ้นอยู่ดี ดูใน [GitHub issues](https://github.com/abiosoft/colima/issues/449) แล้วมันยังเปิดอยู่เลย

สุดท้ายแล้ววิธีแก้คือต้องเพิ่มอีกหนึ่ง properties คือการ disable Ryuk ทิ้งไปเลยโดยการเพิ่ม environment variable ตาม [official documentation](https://java.testcontainers.org/features/configuration/) ลงไปตามนี้

```shell
$ export TESTCONTAINERS_RYUK_DISABLED=true
```

> ข้อจำกัดก็อาจจะอยู่ตรงที่ถ้าหยุด run test ลางคันแล้วตัว containers/networks/volumes/images อาจจะไม่ได้ถูก clean up อย่างที่ควรจะเป็น
