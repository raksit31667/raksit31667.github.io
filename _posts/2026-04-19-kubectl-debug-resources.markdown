---
layout: post
title: "Debug container ที่ run ใน Kubernetes pod ด้วยคำสั่ง kubectl debug"
date: 2026-04-19
tags: [kubernetes, tools]
---

เวลาทำงานกับระบบที่ deploy บน Kubernetes เชื่อว่าหลายคนน่าจะเคยเจอ case ที่ต้องเข้าไปแก้ปัญหาโดย debug จาก pod ตรง ๆ เพราะตั้งสมมติฐานว่ามันมีอะไรบางอย่างพังอยู่ข้างใน เช่น networking setup ผิด ทำให้ pod ส่ง outbound traffic ออกไปไม่ได้ก็ดี DNS resolution พังก็ดี หรือ dependency บางอย่าง fail เพราะติด firewall ก็ดี หลายคน (รวมถึงตัวเราเองก่อนหน้านี้ ฮ่า ๆๆ) มักจะใช้ `kubectl exec` เข้าไปดูใน container ซึ่งหลายครั้งก็ใช้ได้ดี แต่บางกรณีก็ไม่สามารถใช้แก้ปัญหาได้เพราะ

- container อาจจะไม่มี tools ที่เราต้องใช้ (เช่น curl, nslookup)
- หรือบางที image เป็นแบบ minimal มาก (distroless) เข้าไปแล้วทำอะไรแทบไม่ได้ จะลงเพิ่มผ่าน package manager อย่าง `apt`, `dns`, `yum` นี่เลิกหวังได้เลย

ล่าสุดมีเพื่อนแบ่งปันเรื่องการใช้งานคำสั่ง `kubectl debug` มาว่ามันช่วยทำให้การ debug สะดวกมากขึ้น เป็นยังไงลองไปดูกัน

## คำสั่งนี้มันทำอะไร
`kubectl debug` คือการ สร้าง container ใหม่เข้าไปใน pod ที่กำลังรันอยู่ เพื่อใช้เป็น debug container ข้อดีคือ:

- ไม่ต้อง redeploy หรือ restart
- ใช้ image อะไรก็ได้ที่ไม่ติด policy ของ cluster/namespace
- Share network / process namespace กับ container ใน pod

## ตัวอย่างการใช้งาน

```shell
kubectl --context="$CONTEXT" debug \
  -it "$DEBUG_TARGET_POD" \
  --image="$DEBUG_IMAGE" \
  --target="$DEBUG_TARGET_CONTAINER" \
  --namespace="$DEBUG_TARGET_NAMESPACE" \
  -- <command>
```

คำอธิบาย:
- `--image`: image ของ debug container เช่น `curlimages/curl`, `busybox`
- `--target`: Container เป้าหมายใน pod ที่เราอยาก debug
`--namespace`: namespace ของ pod
`-it`: เปิด interactive mode
`-- <command>`: command ที่จะรันใน debug container เช่น `/bin/sh`

หลังจาก run แล้วใน pod เดิม จะมี container ใหม่โผล่มา เช่นสมมติว่าเรามี pod ของ service ชื่อ `app` ที่มี 1 container ที่มี prefix ว่า `app` หลังจาก run คำสั่งแล้วใน target pod นั้นจะมี container ใหม่ขึ้นมาประมาณนี้

```
app
debugger-xxxxx
```

ถ้า run หลายรอบ ก็จะมีหลาย debug container ขึ้นมา

> ไปลองใช้กันดูครับ Happy debugging!

## References
- [Debug Running Pods | Kubernetes](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod)
