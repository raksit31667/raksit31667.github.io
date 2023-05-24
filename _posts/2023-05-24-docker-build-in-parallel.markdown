---
layout: post
title:  "บันทึกการประหยัดเวลาในการ build Docker image ด้วย parallel mode"
date:   2023-05-24
tags: [docker, docker-compose]
---

## ระบบในปัจจุบัน
ปัจจุบันในทีมจะมี CI/CD pipeline ที่ใช้ร่วมกันโดยที่จะ build และ push Docker image ขึ้น registry เพื่อที่จะให้ engineering team ทำการ pull ไปใช้ต่อไป เราจะ build Docker image โดยที่เราเก็บ [Dockerfile](https://docs.docker.com/engine/reference/builder/) directory หน้าตาประมาณนี้

```
.
├── app
│   └── Dockerfile
├── test
│   └── Dockerfile
├── build
│   ├── Dockerfile
│   ├── custom_script.sh

...
```

ผลลัพธที่เราอยากได้คือ Docker image ที่มีชื่อตาม subdirectory ประมาณนี้

```
docker.registry.com/app
docker.registry.com/test
docker.registry.com/build
...
```

เราก็เลยจะเขียน code เข้าไปวน loop ในแต่ละ directory แล้วก็ run คำสั่ง `docker build` ประมาณนี้

```shell
find "$DIRECTORY" -type d -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' directory; do
  NAME=$(basename "$directory")
  DOCKER_IMAGE="docker.registry.com/$NAME"

  docker build -t "$DOCKER_IMAGE" "$directory"
  echo
done
```

Code นี้ได้ผลลัพธ์ออกมาถูกต้อง แต่เราเห็นจุดที่ปรับปรุงต่อไปได้เนื่องจากการ script นี้จะ build Docker image ทีละ directory ไปจนครบ นั่นหมายความว่าถ้าเรามี directory เยอะมากเท่าไร ก็มีแนวโน้มที่จะใช้เวลาในการ build มากขึ้นเท่านั้น  

เกริ่นมาตั้งนาน ปัญหาที่คาใจทุกคนในทีมคือมันใช้เวลา build นานจัง เราจะใช้ parallel mode มาแก้ปัญหานี้ได้อย่างไร

## แก้ด้วย docker-compose

พอเราศึกษาแนวทางการแก้ไขไปเรื่อย ๆ เราก็พบว่า [docker-compose](https://docs.docker.com/compose/) มันมี [parallel mode](https://docs.docker.com/engine/reference/commandline/compose/#configuring-parallelism) อยู่ โดยที่เราแค่ใส่ `--parallel` flag พร้อมระบุจำนวนของ process เข้าไป ถ้าไม่ใส่จะเป็นค่า `-1` ก็คือไม่จำกัดจำนวน process นั่นเอง  

สิ่งที่เราต้องทำคือสร้าง `docker-compose.yml` โดยระบุ image ที่จะต้อง build รวมถึง directory และ Dockerfile หน้าตาประมาณนี้

```yaml
version: '3.8'
services:
 app:
  image: "docker.registry.com/app:${IMAGE_TAG}"
  build:
   context: ./app
   dockerfile: Dockerfile
 build:
  image: "docker.registry.com/app:${IMAGE_TAG}"
  build:
   context: ./build
   dockerfile: Dockerfile
...
```

ทีนี้เราก็ไปแก้ไข script ให้ run คำสั่งในการ build ด้วย `docker-compose` ก็เป็นอันเสร็จ

```shell
IMAGE_TAG="..." docker-compose --file "path/to/docker-compose.yaml" build --parallel
```

จากการปรับปรุงแล้วทดสอบพบว่าเวลาที่ใช้ลดลงไป**เท่านึง**เลยทีเดียว (ในการ build 8 images จาก ~2 นาที เหลือ ~1 นาที) ดูเหมือนจะไม่มากแต่ถ้า CI/CD pipeline เรา run เป็นสิบ ๆ build ต่อวันก็ถือว่าประหยัดเวลาได้พอสมควรเลยนะ

![Docker build comparison](/assets/2023-05-24-docker-build-comparison.png)

## ข้อจำกัด
ข้อจำกัดของวิธีนี้ได้แก่

- เมื่อมี image ใหม่ขึ้นมาก็ต้องแก้ `docker-compose.yml` ด้วย ในขณะที่ script เก่าไม่ต้องเพราะมัน dynamic
- Log อ่านยากมากขึ้นเนื่องจากไม่เป็นลำดับเป็นขั้น มีผลต่อ debugging โดยตรง
- กิน resource มากขึ้นจากการ run แบบ parallel

จากการพูดคุยกับทีมแล้ว ข้อจำกัดเหล่านี้ไม่ใช่ปัญหาของเราเท่าไรเพราะ

- ไม่มี requirement ในการสร้าง image ใหม่มาเท่าไร อย่างมากก็แก้ไขของเดิมซึ่งไม่ต้องแก้ code
- เรามี unit testing ในการทดสอบ Docker image ที่ build อยู่แล้ว ดังนั้นเราได้ feedback loop ที่ชัดเจนจากการ build บนเครื่อง local
- Image ที่เรา build ไม่ได้ต้องการ resource มากมาย

> เมื่อเห็นดังนี้แล้วก็ขอให้พิจารณาข้อดี-ข้อเสียของระบบเราก่อนแล้วค่อยลงมือแก้ไขเพื่อสร้างปัญหาใหม่ ๆ ขึ้นมาให้น้อยที่สุด
