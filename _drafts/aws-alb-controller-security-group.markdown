---
layout: post
title: "ปัญหาที่อาจจะเจอกับการใช้งาน AWS Load Balancer Controller กับ Security Group"
date: 2025-04-02
tags: [aws, kubernetes]
---

ช่วงนี้มีงานหนึ่งที่ทีมเราเจอปัญหาแปลก ๆ ตอน deploy Kubernetes Service ที่ใช้ [AWS Load Balancer Controller (LBC)](https://kubernetes-sigs.github.io/aws-load-balancer-controller) แล้วฝั่งลูกค้าไม่สามารถเข้าถึง service ได้ทั้งจากใน office และจากที่บ้านที่ต่อ VPN เข้า AWS

ปัญหานี้ทำให้เราต้องกลับมาทบทวนเรื่อง Security Group (SG) ใน AWS และการทำงานของ LBC อีกรอบ แล้วก็พบว่ามีจุดน่าสนใจหลายอย่าง เลยขอมา share ไว้ตรงนี้เผื่อใครเจอเคสคล้าย ๆ กันครับ

## ปูพื้นฐานของ AWS กันก่อน

### AWS Load Balancer Controller คืออะไร
AWS LBC เป็น Kubernetes controller ที่ช่วยให้เราสามารถสร้างและจัดการ AWS Elastic Load Balancers (ELB) ได้โดยอัตโนมัติจาก Kubernetes resource `Service` (OSI layer 4 = TCP) หรือ `Ingress` (OSI layer 7 = HTTP) ซึ่งช่วยให้การทำงานร่วมกันระหว่าง Kubernetes กับ AWS เป็นไปอย่างราบรื่น  

Service manifest ของเราตอนแรกหน้าตาประมาณนี้

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-service
  ports:
    - port: 443
      name: https
      targetPort: 8080
```

AWS LBC มันก็จะไปสร้าง ELB ขึ้นมาตัวนึงที่ชื่อว่า `my-service-XXX` ให้โดยอัตโนมัติ แล้วเราก็สามารถเข้าถึง Kubernetes workload ผ่าน ELB อันนั้น

### Security Group ใน AWS คืออะไร
[Security Group](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) เป็นกลุ่มของกฎที่ควบคุมการเข้าถึง network ของ AWS Resources เช่น EC2 Instances หรือ Load Balancers โดยกำหนดว่า IP หรือ port ใดบ้างที่สามารถเข้าถึงหรือออกจาก Resource นั้นได้

## กลับมาที่งานของเรา

> โจทย์ของเราคือทำอย่างไรให้ traffic สามารถเข้าถึง `my-service` ทั้งจากใน office และจากที่บ้านที่ต่อ VPN เข้า AWS 

วิธีการแก้ปัญหามีด้วยกัน 2 วิธี ได้แก่

### 1. กำหนด `loadBalancerSourceRanges` ใน Kubernetes Service
`loadBalancerSourceRanges` เป็น field ที่ใช้ใน Kubernetes Service แบบ `type: LoadBalancer` ซึ่งช่วยกำหนดว่า IP ranges ไหนบ้างที่สามารถเข้าถึง Load Balancer นี้ได้ พูดง่าย ๆ มันเป็น whitelist ของ IP address ที่เรายอมให้เข้า service นี้ได้จากภายนอก โดย AWS LBC จะไปสร้าง Security Group แบบ default ของมันเอง แล้วเปิด rule ให้ตรงกับ IP พวกนี้

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-service
  ports:
    - port: 443
      name: https
      targetPort: 8080
  loadBalancerSourceRanges:
    - 203.0.113.0/24
    - 198.51.100.0/24
```

### 2. Configure Security Group ที่จะใช้กับ Load Balancer
เราสามารถ configure Security Group ที่จะใช้กับ Load Balancer ได้โดยใช้ annotation `service.beta.kubernetes.io/aws-load-balancer-security-groups` เช่น

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-security-groups: sg-0123456789abcdef0
spec:
  type: LoadBalancer
  selector:
    app: my-service
  ports:
    - port: 443
      name: https
      targetPort: 8080
```

ในกรณีที่เราไม่ได้กำหนด annotation นี้ AWS LBC จะสร้าง Security Group ใหม่โดยอัตโนมัติและจัดการ access control ให้เอง  

หากเรากำหนด Security Group เองโดยใช้ annotation ข้างต้น หมายความว่าเราต้องการควบคุม Security Group เองแทนที่จะใช้ default เช่น ต้องใช้ Security Group เดียวกันกับ resource อื่นใน AWS, ต้องใช้ร่วมกับ firewall policy, หรือมี workflow พิเศษ (ซึ่งก็ครอบคลุมไปถึงโจทย์ของเรา) เราจำเป็นต้องจัดการ access control ระหว่าง Load Balancer กับ Backend Instances หรือ ENIs เอง  

> ถ้าใส่ทั้งสองอย่างพร้อมกัน ระบบจะเลือกใช้ Security Group ที่เรากำหนดไว้ผ่าน annotation `service.beta.kubernetes.io/aws-load-balancer-security-groups` และ จะไม่สนใจค่าใน `loadBalancerSourceRanges` เลย

แต่ AWS LBC มี annotation `service.beta.kubernetes.io/aws-load-balancer-manage-backend-security-group-rules` ที่เมื่อกำหนดเป็น `"true"` จะช่วยจัดการกฎเหล่านี้ให้อัตโนมัติ ถึงแม้เราจะระบุ Security Group เองไว้ก็ตาม เช่น

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-security-groups: sg-0123456789abcdef0
    service.beta.kubernetes.io/aws-load-balancer-manage-backend-security-group-rules: "true"
spec:
  type: LoadBalancer
  selector:
    app: my-service
  ports:
    - port: 443
      name: https
      targetPort: 8080
  loadBalancerSourceRanges:
    - 203.0.113.0/24
    - 198.51.100.0/24
```

เท่านี้ตัว Load Balancer ก็จะเปิดทางให้กับ Backend Instances ได้ถูกต้อง แม้ Security Group ที่ระบุจะถูกควบคุมจากเราก็ตาม

## ข้อควรระวัง
หากเราลบ Security Group ที่ถูกสร้างโดย AWS LBC ออกผ่าน AWS Console แล้วทำการ redeploy Service ใน Kubernetes ใหม่ AWS LBC จะไม่ทราบว่า Security Group ถูกลบไปแล้ว และจะไม่สร้างหรือ update อะไรเพิ่มเติม ดังนั้น ควรหลีกเลี่ยงการลบ Security Group โดยตรงจาก AWS Console
