---
layout: post
title: "บันทึกวิธีการติดตั้ง Docker Buildkit ใน Colima สำหรับ Apple silicon"
date: 2023-03-14
tags: [docker, buildkit, colima]
---

![BuildKit](/assets/2023-03-14-buildkit.avif)
<https://qiita.com/po3rin/items/deb798ed9c1edac5cc4b>

ในระบบที่ทำงานปัจจุบันมีความจำเป็นที่จะต้องใช้ [BuildKit](https://github.com/moby/buildkit) เพื่อพัฒนาประสิทธิภาพในการ build image ให้รวดเร็วขึ้น โดย feature หลัก ๆ ที่ใช้คือ parallel build และ build caching เพราะมีการ build Docker image หลาย ๆ ตัวคล้าย ๆ กันพร้อมกันนั่นเอง  

ทีนี้เวลาเราจะใช้งาน BuildKit ผ่าน Docker เราจะต้องติดตั้งผ่าน [Docker Buildx](https://github.com/docker/buildx) กันก่อน ถ้าเราใช้ [Docker Desktop](https://www.docker.com/products/docker-desktop/) เรา run คำสั่งเดียวก็น่าจะใช้ได้เลยอย่าง

```shell
$ docker buildx install
```

แต่ว่าเราใช้ [Colima]({% post_url 2022-05-01-colima-as-docker-alternatives %}) ดังนั้นก็เลยมีขั้นมีตอนขึ้นมานิดหน่อย เลยจดบันทึกวิธีการติดตั้งใน [Terminal](https://en.wikipedia.org/wiki/Command-line_interface) ไว้ซะหน่อย

## 1. เริ่มจากการติดตั้ง Docker Buildx
เราสามารถทำตาม [official documentation ของ Docker](https://docs.docker.com/build/install-buildx/) หรือจะใช้ Homebrew เหมือนเราก็ได้

```shell
$ brew install docker-buildx
```

## 2. สร้าง directory สำหรับ Docker CLI plugin
เนื่องจาก Buildx มันคือ Docker CLI plugin ตัวนึง ถ้าเรายังไม่เคยติดตั้ง plugin ใด ๆ มาก่อน เราต้องสร้าง directory ขึ้นมาด้วยคำสั่ง

```shell
$ mkdir -p ~/.docker/cli-plugins # -p ใส่ไว้เพื่อสร้าง parent directory และไม่ให้ exit code 1 ถ้ามี directory อยู่แล้ว
```

## 3. เพิ่ม Docker Buildx ลงไปใน Docker CLI plugin
วิธีการก็คือทำการ symbolic link (การอ้างอิงถึง file หรือ directory ผ่าน path) จาก path ของ Buildx จากข้อแรก ไปที่ CLI plugin ของ Docker ผ่านคำสั่ง

```shell
$ ln -sfn /path/to/docker-buildx ~/.docker/cli-plugins/docker-buildx
```

ซึ่งเราสามารถหา path ของ Buildx ได้จากคำสั่ง `which` อย่างของเราก็จะได้ผลลัพธ์ประมาณนี้

```shell
$ which docker-buildx

/opt/homebrew/bin/docker-buildx
```

## 4. ตั้งค่าให้ Docker ใช้ Buildx เป็น builder ตั้งต้น
เราก็จะใช้ท่าเดิมที่ทำกับ Docker Desktop ได้แล้ว เป็นอันเสร็จ

```shell
$ docker buildx install
```
