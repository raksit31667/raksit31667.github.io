---
layout: post
title: "ลองใช้งาน Broadcast feature ใน iTerm2"
date: 2024-07-11
tags: [iterm2, productivity, macos, kubernetes]
---

เมื่ออาทิตย์ก่อนฝึกงาน admin สำหรับการ maintain Kubernetes cluster ซึ่งเนื้องานคือจะต้อง Secure Shell (SSH) เข้าไปในเครื่อง VM เพื่อติดตั้งให้กลายเป็น Kubernetes node โดยแบบฝึกจะให้ลอง setup 2 เครื่องได้แก่ master node (control plane) และ worker node โดยมันจะมีขั้นตอนคล้าย ๆ กันคือ

1. Update `apt` repository ที่จะติดตั้งและเกี่ยวข้องกับ Kubernetes
2. Configure kernel modules สำหรับ networking
3. ติดตั้ง container runtime
4. ติดตั้ง Kubernetes repository และ package ที่เกี่ยวข้อง (`kubelet`, `kubeadm`, `kubectl`)
5. Configure `crictl` ในกรณีจะ debug container

จากนั้นก็จะต้องมีการ run คำสั่ง `kubeadm init` ใน master node และ `kubeadm join` ใน worker node แต่จะขอไม่ลงรายละเอียดละเพราะประเด็นคือเราจะต้องทำงานคล้าย ๆ กัน 2 รอบ หรือ N รอบตามจำนวนของ node เลย ซึ่งถ้าใครเจองานคล้าย ๆ แบบนี้แล้วมันต้องทำแค่ครั้งเดียวการเขียน automation ก็อาจจะยังไม่จำเป็น เผอิญไปเจอมาว่าใน [iTerm2](https://iterm2.com/) เขามี feature ที่สามารถ broadcast input ของ terminal pane นึงไปยัง pane อื่น ๆ ได้โดยไม่ต้องพิมพ์ซ้ำ

![iTerm2 broadcast demo](/assets/2024-07-11-iterm2-broadcast.gif)

มีขั้นตอนเปิดการใช้งานดังนี้

1. ใน iTerm2 ทำการสร้าง pane แยกออกมาตามจำนวนที่ต้องการ (**hotkey**: `Cmd + D` สำหรับแนวตั้ง หรือ `Cmd + Shift + D` สำหรับแนวนอน)
2. ก่อนจะเขียนคำสั่งแรกที่ใช้ร่วมกัน ให้เปิดการ broadcast โดยไปที่ menu `Shell` -> `Broadcast Input` -> `Broadcast Input to All Panes In Current Tab` (**hotkey**: `Option + Shift + I`)
3. จะมี dialog ขึ้นมาถามให้กด `OK`
4. คราวนี้พอพิมพ์คำสั่งใน pane นึงแล้วมันก็จะไปปรากฎใน pane อื่น ๆ
5. ถ้าต้องการจะปิดก็ทำเหมือนข้อ 2

> ลองเอาไปใช้กันดูครับ น่าจะทำให้ประหยัดเวลาการใช้งาน terminal ในการ run คำสั่งซ้ำ ๆ กันง่ายขึ้น
