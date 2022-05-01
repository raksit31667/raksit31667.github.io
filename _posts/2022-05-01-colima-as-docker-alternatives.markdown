---
layout: post
title:  "ลองใช้ Colima แทน Docker Desktop on macOS"
date:   2022-05-01
tags: [colima, docker]
---

![Docker Desktop](/assets/2022-05-01-docker-desktop.jpg)

<https://www.docker.com/blog/updating-product-subscriptions/>

สืบเนื่องจาก Docker for Desktop เปลี่ยนรูปแบบการคิดเงินเมื่อตอนต้นปีที่ผ่านมา ทำให้หลายองค์กรต้องหาตัวเลือกอื่นที่ฟรีแทน [Colima](https://github.com/abiosoft/colima) ก็เป็นตัวเลือกที่น่าสนใจ เพราะใช้ [containerd](https://containerd.io/) ซึ่งเป็น runtime เดียวกันกับ Kubernetes ดังนั้นเราก็จะได้ความมั่นใจมากขึ้นว่า container มันทำงานข้างบนได้เหมือนกับ run บนเครื่องตัวเอง  

## 1. ลบ Docker ตัวเดิมออกก่อน
ก่อนที่เราจะทำการติดตั้ง Colima เราควรจะต้องลบ Docker context ตัวเดิมออกเพื่อไม่ให้ context มันไปทับกับ Colima สำหรับ macOS ตัว Docker ที่ได้รับความนิยมก็จะเป็น Docker Desktop ซึ่งเป็น application ที่ติดตั้ง Docker CLI มาให้พร้อมเลย  

สำหรับการลบ Docker Desktop ทำได้โดย

- ตาม [official guidelines ของ Docker](https://docs.docker.com/desktop/mac/install/#uninstall-docker-desktop)
- ถ้าลงผ่าน Homebrew ก็ run คำสั่ง

```shell
$ brew uninstall --cask docker
```

- ลบ Docker config file ซึ่งโดยปกติจะอยู่ใน `${HOME}/.dockercfg` และ `${HOME}/.docker/config.json` แค่ส่วน `auths` อย่างเดียวก็ได้

```jsonc
{
     "auths": {}, // ลบส่วนนี้
     "currentContext": "default"
}
```

## 2. ติดตั้ง Colima
สำหรับ macOS เราจะติดตั้ง Docker CLI, Docker-Compose CLI ตามด้วย Colima

```shell
$ brew install docker docker-compose colima
```

## 3. ทดสอบการใช้งาน
หลังจากติดตั้งเสร็จแล้ว ทำการเปิด Colima ด้วยคำสั่ง

```shell
$ colima start
```

หลังจากใช้งานเสร็จแล้ว ทำการปิด Colima ด้วยคำสั่ง

```shell
$ colima stop
```

ถ้าต้องการจะใช้ Containerd เป็น runtime ก็ใช้คำสั่ง

```shell
$ colima start --runtime containerd
```

ถ้าต้องการจะเปิดการใช้งาน Kubernetes ด้วยก็ใช้คำสั่ง

```shell
$ colima start --with-kubernetes
```

เราสามารถกำหนด resource ของ Colima ได้ผ่านคำสั่ง

```shell
$ colima start --cpu 4 --memory 8 --disk 100 // หน่วยเป็น core, GB
```

ปล. จะต้องปิด Colima ก่อนถึงจะสามารถแก้ไข resource ได้

## ปัญหาที่อาจจะเกิดขึ้น
จากใน README ของ Colima ระบุไว้ว่า

> The project is still in active early stage development and updates may introduce breaking changes.

ดังนั้นตอนใช้งานจริง เราจะเจอปัญหาเยอะหน่อย มาดูว่ามีอะไรกันบ้าง

### Cannot connect to the Docker daemon
ปัญหานี้เกิดจากการติดตั้งผิดขั้นตอน หรือยัง clear Docker context เก่าไม่หมด ถ้าลองทำแต่ต้นแล้วไม่ได้ ลอง restart Colima ผ่านคำสั่ง

```shell
$ colima delete

$ colima start
```

จากนั้นตรวจสอบสถานะของ Colima ผ่านคำสั่ง

```shell
$ colima status

INFO[0000] colima is running
INFO[0000] runtime: docker
INFO[0000] arch: aarch64
```

หรือจะลอง run Docker image `hello-world` ก็ได้

```shell
$ docker run hello-world
```

### java.lang.IllegalStateException: Could not find a valid Docker environment
ในกรณีที่ใช้ [Testcontainers](https://www.testcontainers.org/) ค่าตั้งต้นจะหา Docker host ซึ่งเราได้ลบไปผ่าน Docker Desktop แล้ว วิธีแก้คือเพิ่ม environment variable เพื่อ configure Docker host ให้ชี้ไปหา Colima แทน

```shell
$ export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
$ export DOCKER_HOST="unix://${HOME}/.colima/docker.sock"
```

**Reference website**: [Testcontainers Custom configuration](https://www.testcontainers.org/features/configuration/)

### “docker-crenditial-desktop”: executable file not found in $PATH
สาเหตุคือ Docker config file ไม่ถูกต้อง วิธีแก้คือ บน file `${HOME}/.docker/config.json` เปลี่ยน `credsStore` เป็น `credStore`
หรือลบ `credsStore` ออกไปเลย  

## สรุปการใช้งานทั่วไป
โดยรวมแล้ว Colima ถือเป็นตัวเลือกที่ดีในการใช้งานแทน Docker Desktop เนื่องจากตอบโจทย์การใช้งานทั่วไปโดยส่วนตัวไม่ติดปัญหาอะไรจุกจิก(ยกเว้นที่บอกไว้ข้างบน)

- Build/run image จาก Dockerfile
- Push/pull image จาก Docker Hub
- ใช้งาน Docker-Compose โดย container มีการเชื่อม network เข้าด้วยกัน

ในส่วนของ GUI ก็สามารถใช้เครื่องมืออื่น ๆ มาทดแทนได้ เช่น [Portainer](https://docs.portainer.io/v/ce-2.11/start/install) เป็นต้น