---
layout: post
title: "บันทึกการแก้ปัญหา Docker exec format error บน Kubernetes"
date: 2024-05-07
tags: [docker, kubernetes]
---

เมื่ออาทิตย์ก่อนเอา infrastructure ของระบบงานขึ้นบน environment จริงใน [AWS](https://aws.amazon.com/) ซึ่งหนึ่งในนั้นก็จะมี [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/) ด้วย หลังจาก provision ด้วย [Terraform](https://www.terraform.io/) เสร็จเราก็มาทดสอบว่าเราสามารถ access [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) ใน Kubernetes cluster ได้ไหมด้วยการลองสร้าง HTTP server ด้วย [NGINX](https://www.nginx.com/) โดย Dockerfile ก็จะมีหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/66c7b0ba81b71369612e388f9a74c796.js"></script>

แต่ว่าเราก็มาพบกับ error ประมาณนี้

```shell
exec docker-entrypoint.sh: exec format error
```

เราก็กลับไป check Dockerfile อีกครั้งก็พบว่าไม่ได้มีปัญหาอะไร พอลอง build Docker image แล้วเอามา run บนเครื่องตนเองก็ run ได้ปกติ แต่พอเอาขึ้นไป run บน Kubernetes ดันไม่ผ่าน ซึ่งก็มีกันได้หลายสาเหตุประมาณนี้

- Format ใน `docker-entrypoint.sh` ไม่ถูกต้อง
- Kubernetes deployment YAML file mount `docker-entrypoint.sh` ไปผิดที่
- เครื่องเรากับ Node บน Kubernetes น่าจะไม่เหมือนกัน

ซึ่ง 2 สาเหตุด้านบนจะถูกตัดทิ้งเพราะเราไม่ได้เขียน `docker-entrypoint.sh` เอง ดังนั้นเราต้องมาหาว่าเครื่องเรากับ Node บน Kubernetes มันมีความต่างกันตรงไหน  

สรุปก็ไปเจอว่าเราใช้ macOS ที่มี architecture เป็น [arm64](https://en.wikipedia.org/wiki/AArch64) (ใช้ M1 chip ขึ้นไป) แต่ว่า Node ข้างบนยังเป็น [x86_64](https://en.wikipedia.org/wiki/X86-64) โดย arm64 จะเน้นการประหยัดพลังงานและ memory ส่วน x86_64 จะเน้นเรื่อง performance ที่สูง  

เพื่อให้ Docker image เรา run ได้บน Kubernetes cluster เราจะต้อง build โดยใช้ architecture ให้ตรงกับ Node ข้างบน สามารถทำได้โดยการใส่ flag `--platform` เข้าไปดังนี้

```shell
docker build --platform linux/amd64 -t <image-name>:<tag> .
```

![NGINX 404](/assets/2024-05-07-nginx-404.png)

> หลังจากลองใส่แล้วลอง deploy อีกครั้ง ก็เป็นอันว่าใช้งานได้ละ
