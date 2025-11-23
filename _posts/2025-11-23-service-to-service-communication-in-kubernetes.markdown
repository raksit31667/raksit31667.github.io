---
layout: post
title: "ข้อจำกัดของ Service-to-Service communication technology ใน Kubernetes"
date: 2025-11-23
tags: [microservices, service-mesh, kubernetes, aws]
---

![Service Mesh](/assets/2025-11-23-service-mesh.png)

<https://blog.bytebytego.com/p/api-gateway-vs-service-mesh-which>

ถ้าพูดถึง microservices บน Kubernetes สิ่งแรกที่เราต้องคิดถึงคือการสื่อสารกันระหว่าง service ต่าง ๆ หรือที่เรียกว่า service-to-service communication นั่นเอง หลายคนสงสัยว่าของเดิมที่ Kubernetes ให้มาซึ่งก็คือ [internal Kubernetes DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) ก็เหมือนจะเพียงพออยู่แล้ว แล้วทำไมบางองค์กรถึงเลือกใช้ technology อื่น ๆ เช่น [Service Mesh](https://www.thoughtworks.com/radar/techniques/service-mesh) ถึงแม้ว่ามันจะมีต้องมีค่าใช้จ่ายในการดูแลรักษาเพิ่มเติมขึ้นมาอีกพอสมควรก็ตาม  

## Internal K8s DNS คืออะไร
หนึ่งใน feature ของ Kubernetes คือ networking แปลว่ามันสามารถจัดการ route traffic ได้ ซึ่งในบริบทนี่ traffic จะสามารถวิ่งไปยัง [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) ใด ๆ ได้แม้ว่า Pod จะเปลี่ยนไปก็ตาม ไม่ว่า traffic จะมาจากภายนอก (ผ่าน load balancer) หรือจะเป็นการสื่อสารระหว่าง workload ผ่าน IP หรือ hostname ได้ ซึ่งการจะทำอย่างหลังนั้นได้เนี่ยมันจะต้อง resolve DNS เพื่อแปลง hostname ไปหา Pod ต่าง ๆ ได้  

ใน Kubernetes traffic ไม่ควร access ผ่าน Pod โดยตรงเพราะ private IP ของ Pod เปลี่ยนได้เสมอ ดังนั้น Kubernetes จึงมี [Service](https://kubernetes.io/docs/concepts/services-networking/service/) มาคั่นกลางด้วยชื่อที่เข้าใจง่าย ๆ และจะถูกนำมาใช้เป็นหนึ่งใน domain หรือ subdomain ใน hostname เปรียบเสมือน “ชื่อ” ที่ใช้เรียกกันได้ทันที และ DNS จะช่วยแปลชื่อเหล่านี้เป็น IP ของ service ให้ Kubernetes ทำการ route traffic ไปหา Pod ที่อยู่ภายใต้ Service อีกทีได้นั่นเอง  

ชื่อเต็มของ service DNS ประกอบด้วย 4 ส่วน

```
<service-name>.<namespace>.svc.cluster.local
```

สมมติ service ของเราชื่อ `checkout` หน้าตาของ DNS ก็จะเป็นประมาณนี้

| Scenario                                | ชื่อ DNS                              |
| --------------------------------------- | ----------------------------------- |
| Pod เรียก service ใน namespace เดียวกัน    | `checkout`                          |
| Pod เรียก service ข้าม namespace          | `checkout.orders`                   |
| DNS แบบเต็ม                              | `checkout.orders.svc.cluster.local` |


การทำงานของ Kubernetes networking (แน่นอนว่ารวมถึง DNS) ในบริบทของ [AWS Elastic Kubernetes (EKS)](https://aws.amazon.com/eks/) จะใช้ 3 component หลัก ๆ ดังนี้

### 1. CoreDNS
[CoreDNS](https://coredns.io/) เป็น component ที่ Kubernetes ใช้เป็น DNS server ภายใน cluster โดยหน้าที่หลักของเขาคือ รับคำสั่ง DNS lookup เช่น `checkout.default.svc.cluster.local -> IP` จากนั้นก็ไปสร้าง DNS record ตามข้อมูลผ่าน Kubernetes API และ update DNS แบบอัตโนมัติเมื่อมี Service หรือ Pod ใหม่

### 2. kube-proxy
หลังจากที่ CoreDNS resolve IP ได้แล้ว แต่ว่า IP เองไม่ใช่ endpoint จริง ๆ มันเป็นเพียงแค่ Service รูปแปบนึงของ Kubernetes ที่ expose ให้เข้าถึง Pod ในลักษณะ IP ได้นั่นเอง (ต่อไปนี้จะเรียกว่า [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/cluster-ip-allocation/)) ตัวที่ทำให้ ClusterIP สามารถกระจายไปยัง Pod ได้คือ `kube-proxy` นั่นเอง โดยที่ตัวเขาจะจัดการ iptables rule เพื่อ forward traffic จาก ClusterIP -> Pod และทำ load balancing ระหว่าง Pod แบบ [round-robin](https://kubernetes.io/docs/reference/networking/virtual-ips/) หรือ algorithms อื่น ๆ

### 3. CNI plugin (เช่น aws-node / Amazon VPC CNI)
ถ้า cluster รันบน AWS EKS ที่ใช้ [Amazon VPC CNI](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html), component ที่ชื่อ `aws-node` จะทำหน้าที่จัดการ networking โดยจะจัด IP ให้ Pod (Pod ได้ IP จริงจาก VPC) และทำ pod-to-pod routing ผ่าน VPC networking นอกจากนั้นยังจัดการ networking ระหว่าง EC2 และ VPC ([ENI management](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html))

ตัวอย่างของการทำงานร่วมกันของทั้ง 3 ตัว เช่น เมื่อมี service-to-service call `service A -> http://checkout.default.svc.cluster.local` สิ่งที่จะเกิดขึ้นคือ

1. CoreDNS resolve `checkout.default.svc.cluster.local` -> ได้ `ClusterIP` เช่น `10.100.12.15`
2. kube-proxy ดูว่า `ClusterIP` นี้ map กับ Pod อะไรบ้าง แล้ว forward traffic ไป Pod ที่เหมาะสม
3. CNI plugin ทำให้ packet เดินทางระหว่าง nodes ได้ ผ่าน VPC networking ส่งไปยัง Pod IP ใน node ปลายทาง

ทุกอย่างดูดี แค่นี้ก็น่าจะเพียงพอสำหรับ service-to-service communication แล้ว แต่ว่า Kubernetes DNS เขาก็มีขีดจำกัดอยู่

## ขีดจำกัดของ Kubernetes DNS
ถึงแม้ DNS จะดีและง่าย แต่ก็มีขีดจำกัดชัดเจน เวลาที่จำนวน service เยอะขึ้น มี developer เข้ามา deploy ระบบงานใน cluster มากขึ้น ความต้องการในการพัฒนาจะไปมากกว่าแค่การ resolve DNS แล้ว

### เรื่อง availability
ในระบบที่ต้องการ availability สูงบน cloud ตัว workload มักจะถูก deploy ไปไว้มากกว่า 1 availability zone (AZ) เนื่องจากว่าถ้าเกิดปัญหาบน data center ของ zone นั้น ก็ยังมี zone อื่น ๆ ที่ช่วยรับ load ซึ่งเป็นสิ่งที่เกิดขึ้นได้  
แต่ข้อจำกัดของ Kubernetes DNS คือมันทำ load balancing แบบ zone-agnostic คือ กระจายไปทุก AZ แบบไม่สนว่ามี latency หรือ cost มากน้อยแค่ไหน นั่นหมายความว่าถ้า traffic ดันเกิดข้าม AZ ก็อาจจะมี latency สูงหรือมีค่าใช้จ่ายมากขึ้นนั่นเอง

### เรื่อง security
หลายคนที่ใช้ Kubernetes มักคิดว่า “workload มันอยู่ใน VPC ของเราอยู่แล้ว ปลอดภัยแหละ” ซึ่งก็ถูกส่วนนึง แต่ก็แบกรับความเสี่ยงว่าถ้ามีใครสามารถแอบเข้า node ได้ (ผ่าน configuration, container หรือ supply-chain attack)

- ก็สามารถแอบดัก traffic ระหว่าง service ได้ทันที เพราะเป็น plain text กล่าวคือ Password, token, PII data ที่ส่งกันระหว่าง service เหล่านี้อาจถูกดักได้ทั้งหมดหากไม่มีการเข้ารหัส
- สามารถเกิด [man-in-the-middle attack](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) เพราะไม่มีการ verify identity ของผู้ส่ง/ผู้รับ ต่อให้ใครวิ่งบน networking ใน cluster ก็สามารถปลอมตัวเป็น service อื่นได้ง่ายมาก
- ไม่ผ่าน security compliance ส่วนใหญ่ ที่ต้องการ encryption in transit ระหว่าง internal systems อยู่แล้ว

### เรื่อง traffic management
- ไม่สามารถทำ routing strategy เช่น canary, blue-green, A/B testing ได้ ต้องพึ่ง ingress หรือ tool เป็นหลัก
- ไม่มี retries, timeouts, circuit breaking ไม่งั้นก็ต้องเขียน logic ในระดับ application เอง ซึ่งกระจัดกระจายและดูแลยาก

## Service Mesh มาทลายข้อจำกัด
Service Mesh เพิ่มระดับ control ให้กับการสื่อสารของ service ใน cluster โดยไม่ต้องแก้ code ของ application สิ่งที่ทำให้ได้ 
เช่น

- ใช้ [mutual TLS (mTLS)](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS) ระหว่างทุก service ทำให้ traffic ระหว่าง service ถุก secure เพราะ client กับ server จะ validate กันและกัน
- รองรับ [topology-aware load balancing](https://kubernetes.io/docs/concepts/services-networking/topology-aware-routing/) หมายความว่าเวลา routing traffic ไปหา Service เขาก็จะพยายาม load balance ไปหา Pod ที่อยู่ใน AZ เดียวกันก่อน ช่วยลด inter-AZ egress cost และ latency ได้จริง
- รองรับ service-level access policy เช่น การ configuration ให้อนุญาติแค่ service A เรียก B ได้ แต่เรียก C ไม่ได้ (ซึ่งใน Kubernetes default มันก็ทำได้ แค่จะต้องทำความรู้จักและกำหนด [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) ขึ้นมา)
- รองรับ resiliency pattern เช่น retries / timeouts / circuit breaking เพิ่มให้โดยสามารถ configure ตรงส่วนกลางของ Mesh ได้เลย

ทั้งหมดนี้ทำให้ระบบ microservices ควบคุมได้ดีขึ้นมาก ลด logic ใน application ให้มาตั้งจากส่วนกลางแทน  

## สิ่งที่ต้องยอมแลกกับการใช้ Service Mesh
แม้ Service Mesh จะให้ feature ดี ๆ เช่น mTLS, traffic management, resiliency observability ที่ลึกขึ้นโดยไม่ต้องติดตั้ง solution แยก แต่ก็มี “ต้นทุน” ที่องค์กรต้องแบกรับเหมือนกัน

1. **Operational cost สูงขึ้นอย่างชัดเจน** โดยเฉพาะการทำความเข้าใจและดูแลรักษา component ใน cluster เช่น Control Plane, Sidecar หรือ Proxy ในระดับ Kernel และ ลำดับชั้นของ policy ที่สามารถ override กันได้ เพิ่ม learning curve ให้ทั้งคนใช้และคนดูแลรักษา เวลามีปัญหา observability จะต้องทำใให้ดีขึ้นกว่าเดิม เพราะมี layer เพิ่มขึ้นนั่นเอง
2. **Performance overhead จาก Sidecar** ในกรณีที่ใช้ Service Mesh ที่มี Sidecar container มาให้ เพื่อตอบโจทย์ปัญหาที่กล่าวไปในหัวข้อก่อนหน้าโดยการดัก traffic ทั้ง inbound/outbound ผลคือ latency เพิ่มขึ้นเล็กน้อย (ก็ยังอยู่ในระดับ ms ในเลขตัวเดียว แต่จะเพิ่มขึ้นตาม policy ที่ configure ซับซ้อนมากขึ้นตามระบบ) นอกจากนี้ resource consumption (CPU, memory) ใน Pod เพิ่มขึ้นอย่างชัดเจน ซึ่งจะเห็นค่าใช้จ่ายเพิ่มสูงขี้นใน cluster ใหญ่ ๆ เพราะ Sidecar proxy วิ่งทุก Pod
3. **Upgrading service mesh มีความซับซ้อน** Service Mesh ดัง ๆ หลายเจ้า เช่น [Istio](https://istio.io/), [Linkerd](https://linkerd.io/) มี backward compatibility issues อยู่บ้าง เช่น Sidecar config update แล้วพัง, Certificate rotation, [CustomResourceDefinition](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/) เปลี่ยน API version ดังนั้นการทดสอบจะต้องมีหลากหลายทีมเข้ามาร่วมวงไม่น้อยเลย เพราะต้อง test ดี ๆ ก่อน rollout

## ปิดท้าย

ส่วนตัวเรานั้น ควรใช้แค่ Kubernetes DNS ก็พอถ้า
- Cluster ขนาดเล็กถึงกลาง
- Traffic pattern ไม่ซับซ้อน
- Latency ข้าม AZ ไม่ใช่ปัญหาใหญ่
- ไม่มีข้อกำหนดด้าน security ที่ต้องมี mTLS

แล้วเมื่อไหร่ที่ควรใช้ Service Mesh ก็ต่อเมื่อ
- Cluster มี service จำนวนมาก
- ต้องการ mTLS เพื่อตอบโจทย์ด้าน security, compliance (zero-trust) โดยไม่ต้องไปหา solution อื่น
- ต้องการทำ traffic management เช่น canary, A/B test
- ต้องการ optimise ค่าใช้จ่ายด้าน latency และ cost โดยเฉพาะ cross-AZ
- ต้องการลด logic resilience ใน application ให้มาตั้งจากส่วนกลางแทน
