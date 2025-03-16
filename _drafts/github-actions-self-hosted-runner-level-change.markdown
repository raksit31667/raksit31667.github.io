---
layout: post
title: "ย้าย GitHub Actions Self-hosted runner จากระดับ repository ไปเป็น organization"
date: 2025-03-16
tags: [github-actions, cicd, kubernetes]
---

ใน project ที่กำลังทำอยู่ใช้ [GitHub Actions Self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) สำหรับรับ CI/CD pipeline job ของ developer ภายในองค์กรมา run โดย runner จะ deploy อยู่บน **Kubernetes**  

แต่เดิม runner ถูกใช้งานเพียงแค่ repository เดียว ก็เลยติดตั้งไว้ที่ระดับ **Repository** เมื่อเราอยาก scale runner ให้ใช้ได้กับหลาย ๆ repository จึงต้องเปลี่ยน runner ให้ run ระดับ **Organization Level** แทน แต่ก็เจอปัญหาแล้วก็ค่อย ๆ แก้ไปตามทาง เลยบันทึกไว้หน่อยว่าทำอะไรลงไปบ้าง ฮ่า ๆๆ  

## ทำไมต้องย้ายจาก Repository runner ไปเป็น Organization runner  
ปกติแล้ว Self-hosted runner สามารถสมัครได้ 3 ระดับ  
1. **Repository Level**: ใช้ได้เฉพาะกับ repository นั้น ๆ  
2. **Organization Level**: ใช้ร่วมกันได้หลาย repository  
3. **Enterprise Level**: ใช้ร่วมกันได้หลาย ๆ organization  

โดยข้อดีของ Organization runner ก็คือใช้งานร่วมกันระหว่างหลาย ๆ repository ได้ ลดจำนวน runner ที่ต้องสมัครซ้ำ ๆ ในแต่ละ repository แต่ก็มีข้อควรระวังที่ว่ามันก็สามารถนำไปใช้บน repository อื่น ๆ ใน organization โดยไม่จำเป็น (ซึ่ง ณ ตรงนี้สามารถจัดการได้ผ่าน `runnerGroup` อีกที)  

การย้ายระดับของ runner อาจทำให้ runner เดิมใช้ไม่ได้ไปชั่วคราว ทำให้ GitHub Actions job ที่ schedule ไว้ค้างเพราะไม่มี runner มารับนั่นเอง ดังนั้นถ้า runner deploy อยู่บน **Kubernetes** เราก็ขอแนะนำให้ติดตั้ง [Actions Runner Controller](https://github.com/actions/actions-runner-controller/blob/master/docs/about-arc.md) (ARC) จะทำให้การย้าย runner ไปเป็น Organization runner ง่ายขึ้น แต่ก็แลกกับการทำความเข้าใจและ maintain ARC  

---

## นอกเรื่อง: Actions Runner Controller (ARC) คืออะไร ทำงานอย่างไร 
**Actions Runner Controller (ARC)** เป็น [Kubernetes Controller](https://kubernetes.io/docs/concepts/architecture/controller/) ที่ช่วยให้เราสามารถ **บริหารจัดการ Self-hosted runners** สำหรับ GitHub Actions **ในรูปแบบ Kubernetes Native** พูดง่าย ๆ ก็คือ ARC ช่วยให้เราสามารถ

✅ Provision Self-hosted runners แบบอัตโนมัติ  
✅ ควบคุมจำนวน runner ตามความต้องการ (Autoscaling)  
✅ จัดการ runner ผ่าน YAML เหมือน Kubernetes resource อื่น ๆ  
✅ ลดภาระการดูแล server สำหรับ runner (แต่เพิ่มภาระการดูแล Controller แทน ฮ่า ๆๆ)
  
ARC ใช้ [Kubernetes Custom Resource Definitions (CRDs)](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) และ Controllers เพื่อช่วยให้เราสามารถควบคุม runner ผ่าน **Kubernetes API** โดยมีองค์ประกอบหลัก 3 อย่าง  

1. **Runner**: Self-hosted runner หนึ่งตัวที่ใช้รัน GitHub Actions โดย ARC จะสร้าง runner ในรูปของ `Pod`  
2. **RunnerDeployment**: เปรียบเหมือน `Deployment` ที่มีหลาย ๆ `Pods` ใช้สำหรับสร้างและกำหนดกลุ่มของ runner ประเภทเดียวกัน
3. **HorizontalRunnerAutoscaler**: ใช้ควบคุม Autoscaling ของ `RunnerDeployment` ขยายและลดจำนวน runner ตาม workload ของ GitHub Actions  

---

## วิธี update ARC ให้ใช้ Organization runner
เดิมที ARC อาจกำหนดให้สมัครที่ระดับ repository แบบนี้

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: repo-runner
  namespace: actions-runner
spec:
  template:
    spec:
      repository: myorg/myrepo
```

เราต้องแก้ให้สมัครที่ระดับ **Organization** แทน

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: org-runner
  namespace: actions-runner
spec:
  template:
    spec:
      organization: myorg  # เปลี่ยนจาก repository เป็น organization
```

จากนั้น register runner ใหม่
```sh
kubectl apply -f org-runner.yaml
```

ถ้า run แล้วพบว่า runner ยังไม่สามารถหยิบ job จาก repository อื่นได้ ให้เข้าไปดู log ใน ARC container ถ้าพบว่ามี log

> "403 Forbidden – “You must be an org admin or have fine-grained permissions"

ให้ตรวจสอบว่า **Personal Access Token (PAT)** ที่ใช้กับ ARC มีสิทธิ์ที่ถูกต้อง

- **ถ้าใช้ Classic PAT** ต้องมี `admin:org` scope  
- **ถ้าใช้ Fine-grained PAT** ต้องมี `Read & Write` สำหรับ  
  - **Actions**  
  - **Runners & Runner Groups**  

Check PAT ที่ใช้ใน Kubernetes `Secret` กันก่อน

```sh
kubectl get secret controller-manager -n actions-runner -o jsonpath="{.data.github_token}" | base64 --decode
```

ถ้า PAT ไม่มีสิทธิ์ครบถ้วน ให้ update หรือสร้าง PAT ใหม่ จากนั้นนำ PAT มา update ใน Kubernetes `Secret`

```sh
kubectl create secret generic controller-manager -n actions-runner --from-literal=github_token=<NEW_TOKEN> --dry-run=client -o yaml | kubectl apply -f -
```

จากนั้น restart ARC เพื่อใช้การตั้งค่าใหม่

```sh
kubectl rollout restart deployment actions-runner-controller -n actions-runner
```

จากนั้นตรวจสอบว่า runner สมัครสำเร็จหรือไม่ผ่าน log ของ ARC หรือดูว่า runner หยิบงานไปทำอย่างถูกต้อง
```sh
kubectl logs -l app=github-actions-runner-controller -n actions-runner --tail=50 -f
```

ถ้าติดปัญหาว่า runner ยังไม่ work หนึ่งในสาเหตุที่อาจจะเป็นไปได้คือ repository ไม่ได้อยู่ใน `runnerGroup` ที่ถูกต้อง  

อย่างที่เกริ่นไปก่อนหน้านี้ว่า runner สามารถนำไปใช้บน repository อื่น ๆ ใน organization โดยไม่จำเป็น GitHub Actions ก็เลยมี `runnerGroup` เพื่อกำหนดว่า job จาก repository/organization ไหนที่สามารถจะใช้ runner นั้น ๆ ได้บ้าง ถ้าไม่ได้ตั้งค่ามันจะใช้ `runnerGroup` เป็น `Default` ซึ่งอาจจะไม่ได้ configure ตามที่กำหนดไว้  

วิธีแก้ก็คือกำหนด `runnerGroup` ให้กับ runner 
1. เข้าไปที่ **GitHub → Organization Settings → Actions → Runners**  
2. เลือก **Runner Groups** และตรวจสอบว่า runner ปรากฏในกลุ่มนั้น
3. กำหนด repository/organization ไหนที่สามารถจะใช้ runner นั้น ๆ ได้   
4. ตรวจสอบว่า `runnerGroup: "ชื่อกลุ่ม"` อยู่ใน YAML  

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: org-runner
  namespace: actions-runner
spec:
  template:
    spec:
      organization: myorg  # เปลี่ยนจาก repository เป็น organization
      runnerGroup: "myrunnergroup"  # กำหนด runner Group
```

จากนั้น update runner เข้าไปใหม่
```sh
kubectl apply -f org-runner.yaml
```

> ทำตามนี้แล้ว GitHub Actions Self-hosted runner ของเราจะย้ายเข้ามาที่ระดับ Organization ได้อย่างสมบูรณ์  

## References
- [Adding ARC runners to a repository, organization, or enterprise](https://github.com/actions/actions-runner-controller/blob/master/docs/choosing-runner-destination.md)
