---
layout: post
title:  "นำ Docker image จาก non-production ขึ้น production cluster บน OpenShift"
date:   2020-04-16
tags: [docker, openshift, jenkins, skopeo]
---
วันนี้จะมาแบ่งปันเรื่องการนำ docker image ขึ้นงานบน production หลังจากผ่านการ build ในระบบ Continuous integration จาก non-production มาแล้ว งานที่ทำอยู่ใช้ OpenShift เป็น container platform deploy ใช้เองในบริษัท (เป็น on-premise อ่ะนะ)  

blog นี้ต่อยอดมาจาก blog ใน OpenShift อีกที [Promoting container images between registries with skopeo](https://www.openshift.com/blog/promoting-container-images-between-registries-with-skopeo)

### อธิบายคร่าวๆ ว่าเราจะทำยังไง
เราจะให้ pipeline ใน non-production ไป trigger เจ้า pipeline ใน production พร้อมกับส่งข้อมูลที่จำเป็น (เช่น ชื่อ image, tag) จากนั้น pipeline ก็จะมี Stage ในการ copy image โดยใช้ [Skopeo](https://github.com/containers/skopeo#copying-images) ซึ่งมาในรูปแบบของ Jenkins slave วาดรูปคร่าวๆ ก็จะได้ประมาณนี้
![Overview diagram](/assets/2020-04-22-openshift-docker-promotion-0.png)

### สิ่งที่ต้องมีก่อนเริ่ม
- OpenShift 2 clusters (non-production กับ production) หรือจะใช้ cluster เดียวแต่แยก 2 projects ก็ได้เหมือนกัน
- [OpenShift CLI](https://formulae.brew.sh/formula/openshift-cli) หา download ได้ใน Homebrew สำหรับคนใช้ macOS
- Docker image ที่ถูก build บน non-production cluster มี tag (อาจจะเป็น git commit hash ก็ได้) เพื่อให้ production refer ถึง
- Jenkins ซึ่งมากับ OpenShift อยู่ละ แต่ต้องลง [Docker Slave plugin](https://plugins.jenkins.io/docker-slaves/) เพิ่ม

### 1. ใน Non-production cluster สร้าง ServiceAccount และ assign RoleBinding สำหรับการ pull image ข้าม cluster หรือ project
OpenShift จริงๆ มันถูกสร้างต่อยอดจาก Kubernetes ดังนั้น concept เรื่อง resources [แทบไม่ต่างจาก Kubernetes เลย](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions)  

```sh
oc process -f across-project-image-puller.yaml | oc apply -f -
```

<script src="https://gist.github.com/raksit31667/23dc016ae6a897f6a1ec12666a92b3c7.js"></script>

### 2. สร้าง Secret ที่เก็บ Bearer token ของ ServiceAccount เพื่อให้ production มา authenticate ได้
ใส่ flag `--dry-run=true` เพราะไม่ต้องการ create ใน non-production cluster แต่ให้ผลลัพธ์ออกมาเป็น YAML file แล้วค่อยไป apply ใน production cluster แทน

```sh
oc create secret generic non-production-cluster-token --dry-run=true -o yaml \
    --from-literal=token=$(oc serviceaccounts get-token across-project-image-puller) \
    > non-production-cluster-token.yaml
```

จะได้ file ออกมาหน้าตาประมาณนี้
<script src="https://gist.github.com/raksit31667/67871d9dfa73a16367c116cf26546370.js"></script>

เอา token ไปแกะดูเล่นๆ ใน [jwt.io](http://jwt.io/) จะได้หน้าตา payload ประมาณนี้
<script src="https://gist.github.com/raksit31667/03ccd0440c4e43130721c840ac3fe71b.js"></script>

เสร็จแล้วก็ apply ใน production cluster
```sh
oc apply -f non-production-cluster-token.yaml
```

![After applying Secret](/assets/2020-04-22-openshift-docker-promotion-1.png)

### 3. ใน Non-production cluster สร้าง Secret ที่จะ trigger production pipeline ผ่าน webhook
OpenShift จะรับ Secret text ที่เรากำหนดเองเป็น base64 ฉะนั้นต้อง encode ก่อน

```sh
oc apply -f production-pipeline-webhook-secret-text.yaml
```

<script src="https://gist.github.com/raksit31667/4038bddd1894169f66a6979875a6dd1e.js"></script>

**คำอธิบาย**  
- การใส่ label `credential.sync.jenkins.openshift.io: "true"` ทำให้ OpenShift secret sync ขึ้นไปบน Jenkins credentials จะได้ maintain แค่ที่เดียว
- สามารถแก้ไขชื่อ credentials ที่จะปรากฎบน Jenkins ผ่าน annotations `jenkins.openshift.io/secret.name: <your-custom-credentials-name-here>`

### 4. สร้าง Pipeline ใน Non-production cluster

```sh
oc apply -f non-production-pipeline.yaml
```

<script src="https://gist.github.com/raksit31667/98e1bcda8fc0b5eb2fdfb288d98e5def.js"></script>

<script src="https://gist.github.com/raksit31667/93b6d3cf11840de2fcc6c4d8b1de25e5.js"></script>

**คำอธิบาย**  
เราจะ trigger OpenShift production pipeline ผ่าน webhook โดยส่ง parameter ที่ใช้ในการ copy image ผ่าน request body และ refer webhook จาก secret ที่สร้างในข้อ 3  



