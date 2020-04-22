---
layout: post
title:  "นำ Docker image จาก non-production ขึ้น production cluster บน OpenShift"
date:   2020-04-22
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
- Jenkins ซึ่งมากับ OpenShift อยู่ละ แต่ต้องลง [Docker slave plugin](https://plugins.jenkins.io/docker-slaves/) เพิ่ม

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

### 5. สร้าง Pipeline ใน Production cluster

```sh
oc apply -f production-pipeline.yaml
```

<script src="https://gist.github.com/raksit31667/659a93eca2c90c9d2d9279128fb7da48.js"></script>
<script src="https://gist.github.com/raksit31667/598c2993c8dc554fdd5b0118d5391000.js"></script>

**คำอธิบาย**  
- รับ parameters จาก non-production pipeline และ refer webhook จาก secret ที่เราสร้างในขั้นตอนที่ 3
- อ่าน non-production token (secret ที่เราสร้างในขั้นตอนที่ 2) และ production token
- นำ parameters มาประกอบเป็น location ของ docker image
- ใช้ `set +x` เพื่อ print result ออกมาใน Jenkins console output

![After applying pipeline & WebhookKey](/assets/2020-04-22-openshift-docker-promotion-2.png)

### 6. สร้าง Skopeo ในรูปแบบของ Jenkins Slave ด้วย Dockerfile

```sh
oc process -f skopeo-slave-build-config.yaml -p PROJECT_NAME=<your-production-project-here> | oc apply -f -
```

<script src="https://gist.github.com/raksit31667/73205db096a33c3105e95a137c2f625f.js"></script>
<script src="https://gist.github.com/raksit31667/120140a0c2f509495c40f0d36e5bb712.js"></script>

**คำอธิบาย**  
Jenkins slave จะรันเป็น Docker container ซึ่งมี configuration เช่น 
- การผูก secret ที่เราสร้างในขั้นตอนที่ 2
- Refer ไปหา image ที่เรา build จาก Dockerfile
- CPU และ memory
- Proxy

มาถึงตรงนี้แล้ว ก็น่าจะเห็นภาพว่ามีขั้นตอนอะไรบ้าง ก็ขอสรุปเป็นเหตุการณ์ที่เกิดขึ้นแบบคร่าวๆ ตาม diagram นี้เลยละกัน
![Final results](/assets/2020-04-22-openshift-docker-promotion-3.png)
- เริ่มจาก generate token จาก ServiceAccount ที่มี permission ในการ pull image จาก non-production ไปไว้ใน production
- Non-production pipeline ไป trigger production pipeline พร้อมกับส่ง parameters ในการ copy image ไป
- Skopeo Jenkins slave ใน production ไปอ่าน token เพื่อทำการ authenticate ไปยัง non-production และดึง parameters เพื่อปั้น docker image location
- รันคำสั่ง `skopeo copy` เป็นอันจบงาน

> ดูตัวอย่างโค้ดได้ที่นี่เลยครับ [openshift-docker-image-promotion](https://github.com/raksit31667/openshift-docker-image-promotion)



