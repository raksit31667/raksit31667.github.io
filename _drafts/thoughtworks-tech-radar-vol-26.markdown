---
layout: post
title:  "สิ่งที่น่าสนใจจาก Thoughtworks Tech Radar ฉบับที่ 26"
date:   2022-03-29
tags: [technology-radar]
---

จากรายงานเรื่อง [Technology Radar Vol. 26](https://www.thoughtworks.com/radar) ของ ThoughtWorks ซึ่งทำการสรุปเรื่องของ technique เครื่องมือ language และ framework ต่าง ๆ สำหรับการพัฒนา software ออกมา จึงนำมาสรุปสิ่งที่ (เรา) สนใจมาดังนี้

## Technique

### Four key metrics (Adopt)
เทคนิคการวัดคุณภาพขององค์กรมีผลเกี่ยวข้องกับคุณภาพของการส่งมอบ software โดยใช้เกณฑ์การวัด 4 ข้อได้แก่

- **Lead time for changes**: ทีมของคุณใช้เวลาตั้งแต่เริ่มนำงานเข้ามาจนกระทั่งส่งมอบถึงลูกค้าเท่าไร
- **Deployment frequency**: ทีมของคุณ deploy ระบบงานบ่อยแค่ไหน
- **Mean time to restore (MTTR)**: เมื่อระบบงานเกิดปัญหา เช่น service outage ทีมของคุณใช้เวลาเท่าไรถึงในการแก้ไขให้ระบบกลับมาทำงานได้เหมือนเดิม  
- **Change fail percentage**: เมื่อนำระบบงานขึ้น production มีโอกาสที่ระบบจะไม่สามารถ deploy ได้หรือเกิด major issue ขึ้นกี่เปอร์เซ็นต์

แน่นอนว่า metrics นี้มีไว้วัดแนวทางการทำงานของทีม ไม่ใช่การเปรียบเทียบกับคนอื่นหรือเอาไปโชว์ใน dashboard เท่ๆ ลองดู[บทความเดิมที่เราเคยเขียนไว้]({% post_url 2020-04-07-four-key-metrics-sharing %})ได้ครับ

### Single team remote wall (Adopt)
ในการทำงานแบบ remote ในช่วง 2 ปีที่ผ่านมา สิ่งที่ขาดหายไปสำหรับบางทีมคือ artifact ที่ใช้ในการพูดคุยและตกลงร่วมกันในทีม เช่น team wall ที่ประกอบไปด้วย story backlog ตามสถานะต่างๆ ทำให้การพูดคุยเป็นไปได้ยาก วิธีแก้คือใช้เครื่องมือ online เช่น Trello หรือ Jira ปัญหาที่ตามมาคือ เอกสาร online ต่างๆ ก็อยู่กระจัดกระจายกัน ทำให้ตาม update ค่อนข้างยาก และมีความซับซ้อนในการทำความเข้าใจภาพรวม-ภาพย่อย แนวคิดของเทคนิคนี้คือการนำทุกอย่างมารวมไว้ที่เดียว เครื่องมือที่น่าสนใจก็อย่างเช่น [MURAL](https://www.mural.co/) หรือ [Miro](https://miro.com/)

### Data mesh (Trial)
ยังคงเป็นกระแสอย่างต่อเนื่องกับ Data mesh ซึ่งก็คือการจัดการข้อมูลแบบ Big Data ในระบบ Distributed architecture แบ่ง product team ตาม data และแยกความซับซ้อนในการสร้าง product ให้ infrastructure team เป็นคนดูแล แต่การใช้งานจริงก็ยังมีข้อจำกัดในแง่ของการ integrate ระหว่างระบบด้วยกัน โดยเฉพาะในบริษัทใหญ่ๆ ที่มักจะถูกป้ายยาโดย vendor ที่ต้องการจะขาย product ของตนเอง  

อ่านต่อเพิ่มเติมได้ที่ [Data Mesh: Delivering Data-Driven Value at Scale](https://www.amazon.com/Data-Mesh-Delivering-Data-Driven-Value/dp/1492092398)

### Definition of production readiness (Trial)
Definition of production readiness (DPR) เป็นแนวคิดการเตรียมความพร้อมในการขึ้นระบบ หรือ service ใหม่ ซึ่งจะมาในรูปแบบของ checklist หรือ guideline ว่าต้องมี service-level objectives (SLOs) อะไรบ้างแบบคร่าวๆ ไม่ว่าจะเป็น

- เรื่องของเอกสาร
- เรื่องของ observability (distributed tracing, monitoring, logging)
- เรื่องของ standards ในองค์กร

ประโยชน์ของการเตรียมความพร้อมเหล่านี้ ก็คือการนำไปแปลงเป็น requirement ที่จะถูกนำไปจัด priority ในการส่งมอบงานต่อไป และจะมีประโยชน์มากถ้าในองค์กรไม่มี site reliability engineering team (SRE) แยกต่างหาก เพราะไม่มีใครจะมาวาง guideline ให้ตั้งแต่แรกนั่นเอง  

มีแนวคิดที่คล้ายๆ กันจาก Google คือ [production readiness review](https://sre.google/sre-book/evolving-sre-engagement-model)

### Documentation quadarants (Trial)
เป็นเทคนิคในการทำเอกสารรูปแบบหนึ่ง โดยแบ่งกลุ่มเอกสารเป็น 4 กลุ่มตามแกน X-Y

- แกน X คือรูปแบบของข้อมูลในเชิง ปฏิบัติ/ทฤษฎี
- แกน Y คือจะเอาเอกสารไปช่วยเราในด้านไหนระหว่าง ศึกษา/ทำงาน

จากการแบ่งกลุ่มเราก็จะได้

- **How-to guides**: ข้อมูลเชิงปฏิบัติที่เอาไว้ช่วยทำงาน เน้นในเรื่องของการแก้ปัญหา
- **Tutorial**: ข้อมูลเชิงปฏิบัติที่เอาไว้ช่วยศึกษา เน้นในเรื่องของการศึกษา
- **Explanation**: ข้อมูลเชิงทฤษฎีที่เอาไว้ช่วยศึกษา เน้นในเรื่องของการทำความเข้าใจ
- **Reference**: ข้อมูลเชิงทฤษฎีที่เอาไว้ช่วยทำงาน เน้นในเรื่องของข้อมูล

อย่างไรก็ตาม ไม่ว่าจะใช้เทคนิคนี้หรือไม่ เอกสารที่ดีย่อมมีประโยชน์มากสำหรับ onboard developer ใหม่เข้าสู่ทีม

### Rethinking remote standups (Trial)
แต่ก่อนที่เราจะมาเน้นทำงานแบบ remote นอกจากการมี standup meeting ซึ่งต้องสั้นและกระชับ ถ้ายังไม่ clear เราก็สามารถที่จะเดินมาคุยแยกกันอีกทีได้เมื่อไรก็ได้ แต่ในสถานการณ์แบบ remote มันก็จะทำได้ยากขึ้น เพราะต้องนัดประขุม ตั้ง calendar หลายขั้นตอน จึงมีแนวคิดคือเพิ่มระยะเวลาทำ standup เข้าไป แล้วก็รวบการประชุมแยกอื่นๆ มาไว้ที่อันเดียวแทน ข้อดีคือมันจะช่วยลดจำนวนประชุมลงไปได้ นอกจากนั้นยังเวลาที่ทีมจะได้อยู่ด้วยกันก็นานขึ้นในแต่ละวัน ทำให้ไม่เฉาจนเกินไปด้วย

### Software Bill of Materials (Trial)
Software Bill of Materials (SBOM) คือ list ของ open-source และ third-party software ในระบบของเรา ซึ่งประกอบไปด้วย licenese, version, และ security status ประโยชน์ของ SBOM คือจะช่วยให้เราตรวจสอบความเสี่ยงทางด้าน security ได้รวดเร็วขึ้น มีเครื่องมือที่ช่วยสร้าง SBOM ให้เราได้อัตโนมัติเลยก็อย่างเช่น [Syft](https://github.com/anchore/syft)

### CUPID (Assess)
อีกหนึ่งแนวคิดในการเขียน code ที่ดี นอกจากความเรียบง่าย สามารถเปลี่ยนแปลงง่ายของ SOLID principle เข้าไปดูเพิ่มได้ที่ [CUPID—for joyful coding](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/)

### Service mesh without sidecar (Assess)
ถ้าเราพูดถึงการทำ service mesh เรามักจะนึกถึงท่า sidecar proxy ซึ่งวางไว้ข้างๆ service ปัญหาที่เกิดขึ้นคือความยุ่งยากในการติดตั้ง sidecar ทั้ง service ที่มีอยู่ปัจจุบัน และ service ใหม่ นอกจากนั้นยังเปลือง resource ถ้ามีการ scale out ที่สูงขึ้น การมาของ eBPF จะช่วยนำเรื่อง observability, reverse proxy จาก user space ลงไปไว้ใน kernel space เพราะสุดท้าย operation เหล่านี้ก็ต้องติดต่อกับ kernel อยู่ดี ข้อดีคือไม่ต้องเสียแรงติดตั้ง sidecar และได้ performance ที่ไม่ต่างกันมากจากการเข้าถึง kernel ตรงๆ

<iframe width="560" height="315" src="https://www.youtube.com/embed/jYtJVHCsKpw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### Miscellaneous platform teams (Hold)
ในองค์กรขนาดใหญ่เริ่มมีการสร้าง platform team เพื่อช่วยเหลือ developer ภายในด้วยกันด้วยการลดแรงในการดูแลรักษาระบบของทีมส่งมอบลง เช่น infrastructure หรือ CICD pipeline แต่กลับกลายเป็นว่าทีมเหล่านี้ถูกนำไปเข้า project ที่ไม่มีเป้าหมายและกลุ่มลูกค้าชัดเจน กลายสภาพเป็นทีมจับฉ่ายช่วย support งานทั่วๆ ไปแทน ดังนั้นการนำแนวคิด platform engineering product team มาใช้จะต้องวางเป้าหมาย และมีกลุ่มเป้าหมายที่ชัดเจน ถึงจะประสบความสำเร็จ


## Platforms

### CI/CDs (Azure DevOps, GitHub, GitLab)
ใน Volume 26 นี้ได้เห็น feature ใหม่ๆ จาก CICD ของผู้ให้บริการ version control ดังนี้

- **Azure DevOps**: มี [Azure Pipeline templates](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops) ที่ลด duplicate code ในการเขียน pipeline ลงด้วยการใช้ parameter หรือ reuse จาก template ที่มีอยู่แล้ว
- **GitHub**: มี [Reusable workflows for GitHub Actions](https://docs.github.com/en/actions/using-workflows/reusing-workflows) ซึ่งทำได้คล้ายๆ กับ Azure Pipeline templates จะเหมาะกับ project ที่ใช้ GitHub อยู่แล้วมากกว่า เพราะ code กับ pipeline จะได้อยู่ใน platform เดียวกัน และถ้าเราต้องการจะ run action ที่อยู่ใน host ของเราเอง (self-host runner) GitHub Actions ก็มี [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller) ที่สามารถ run บน Kubernetes cluster ของเราได้เลย
- **GitLab**: นอกจาก self-host runner แล้ว GitLab CI/CD ยังมี [Services](https://docs.gitlab.com/ee/ci/services/) ที่ติดตั้ง Docker image สำหรับการทดสอบ เช่น MySQL PostgreSQL หรือ Redis ทำให้ง่ายต่อการทดสอบไม่ต้องติดตั้งใน pipeline เองเพิ่มเติม ในส่วนของ [Auto Devops](https://docs.gitlab.com/ee/topics/autodevops/) ก็เหมาะสำหรับทีมที่ต้องการ pipeline ที่ configure step พื้นฐานมาให้เลยอย่าง run ชุดการทดสอบ ตรวจสอบ code quality และช่องโหว่ด้าน security ไปจนถึงการ deploy

<iframe width="560" height="315" src="https://www.youtube.com/embed/0Tc0YYBxqi4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### Colima (Assess)
สืบเนื่องจาก Docker for Desktop เปลี่ยนรูปแบบการคิดเงินเมื่อตอนต้นปีที่ผ่านมา ทำให้หลายองค์กรต้องหาตัวเลือกอื่นที่ฟรีแทน [Colima](https://github.com/abiosoft/colima) ก็เป็นตัวเลือกที่น่าสนใจ เพราะใช้ [containerd](https://containerd.io/) ซึ่งเป็น runtime เดียวกันกับ Kubernetes ดังนั้นเราก็จะได้ความมั่นใจมากขึ้นว่า container มันทำงานข้างบนได้เหมือนกับ run บนเครื่องตัวเอง


## Tools

### tfsec (Adopt)
[tfsec](https://github.com/aquasecurity/tfsec) เป็น static code analysis ที่ scan หาช่องโหว่ด้าน security สำหรับ Terraform

### AKHQ (Trial)
[AKHQ](https://akhq.io/docs/#installation) เป็น GUI สำหรับ Apache Kafka ที่เพิ่มความสะดวกในการจัดการ topic, partition, consumer group, จำนวน message, ไปจนถึง replication factor

### kube-score (Trial)
[kube-score](https://github.com/zegl/kube-score) เป็น static code analysis ที่ scan เพื่อให้คำแนะนำให้การกำหนด Kubernetes resource เช่น การกำหนด resource limit ของ Pod หรือ การกำหนด image `pullPolicy` เป็นแบบ `Always`

### Volta (Trial)
[Volta](https://volta.sh/) เป็นเครื่องมือที่ช่วยจัดการ Node.js version เมื่อต้องทำงานกับหลายๆ project ที่ใช้ version แตกต่างกัน สิงที่ Volta ทำได้มากกว่าเครื่องมือยอดนิยมอย่าง nvm คือมันสามารถปักหมุด version ไว้ เวลาที่เรา run คำสั่งใน project ตัว Volta ก็จะสับเปลี่ยน version ของ Node.js ที่เราปักหมุดไว้ให้โดยที่ไม่ต้องเปลี่ยนเอง

### CDKTF (Assess)
แนวทางการจัดการ infrastructure ด้วย Infrastructure-as-a-Code เป็นท่าที่หลายองค์กรนำไปปรับใช้กันอย่างเต็มตัวแล้ว หนึ่งในเครื่องมือยอดนิยมอย่าง Terraform มีข้อสังเกตอย่างนึงคือ มันจะข้อจำกัดทางด้าน syntax อยู่เนื่องจากมันใช้ Hashicorp configuration language ซึ่งมีรูปแบบที่ต่างจาก programming language ที่ developer ใช้งานอยู่ในส่วนของการสร้าง application service ต่างๆ จึงมีการสร้างเครื่องมือสำหรับ Infrastructure-as-a-Code แต่ยังคงใช้ programming language ที่คุ้นมือสำหรับ developer มากกว่า เช่น Pulumi หรือ [CDKTF](https://www.terraform.io/cdktf) ซึ่งรองรับทั้งภาษา TypeScript, Python, Java, C#, และ Go

### Infracost (Assess)
แน่นอนว่าหนึ่งในข้อดีของการย้ายระบบไปไว้บน cloud คือเราสามารถตรวจสอบค่าใช้จ่ายในการดูแลรักษาได้อย่างละเอียด แต่ในความจริงเราก็มักจะตัดสินใจในด้าน technical โดยลืมด้านค่าใช้จ่ายไป รู้ตัวอีกทีก็คือตอนเราต้องเสียเงินจริง ดังนั้นน่าจะเป็นเรื่องที่ดีกว่าถ้าเรารู้การเปลี่ยนแปลงของค่าใช้จ่ายในทุกๆ การเปลี่ยนแปลงของ infrastructure เรา [Infracost](https://www.infracost.io/) ก็เป็นตัวเลือกที่น่าใจสำหรับทีมที่ใช้ Terraform ในการทำ Infrastructure-as-a-Code อยู่แล้ว โดยที่ Infracost จะแสดงให้เห็นค่าใช้จ่ายบน pull request ให้เราตรวจสอบก่อนการเปลี่ยนแปลงจริงๆ ได้เลย


## Languages and Frameworks

### Testcontainers (Adopt)
[Testcontainers](https://www.testcontainers.org/) เป็น library ที่ช่วยสร้าง dependencies ของการทดสอบในรูปแบบของ container ซึ่งใกล้เคียงกับของจริง เช่น database, messaging queue, web browser นอกจากนั้นยังรองรับ customization ต่างๆ เช่น Dockerfile หรือ Docker Compose ไปจนถึง networking และ container lifecycle รวมถึงรองรับ framework ในการทดสอบอย่าง JUnit ด้วย

### Capacitor (Assess)
[Capacitor](https://capacitorjs.com/) เป็น hybrid runtime (web + native) แบบ cross-platform หมายถึงรองรับทั้ง iOS, Android, web, progressive web app แน่นอนว่ามีข้อดีคือดูแลรักษา code เพียงชุดเดียว ใช้ภาษาเดียวในการเขียน และด้วยความที่เป็น hybrid ก็จะมีความสามารถในการเข้าถึง native APIs ได้ด้วย แต่ข้อเสียก็คือการจัดการ plugin และ third party dependencies ที่ยากขึ้นตามไปด้วย

### SpiceDB (Assess)
[SpiceDB](https://github.com/authzed/spicedb) เป็นระบบ open source สำหรับเก็บข้อมูลเกี่ยวกับ authorization รองรับการทำงานกับ database อย่างเช่น PostgreSQL และ CockroachDB โดย SpiceDB จะแยกการเก็บข้อมูลแยกกันกับ policy และสร้าง relationship ในรูปแบบของ graph เพื่อตอบโจทย์เกี่ยวกับ user และ permission สิ่งที่ต้องระวังคือ data consistency ระหว่าง database และตัว SpiceDB เอง

> ทั้งหมดที่สรุปมานี้เป็นเพียงแค่ส่วนหนึ่งของ [Technology Radar ฉบับนี้](https://www.thoughtworks.com/radar)เท่านั้น ยังมี technology อื่นๆ ที่น่าสนใจสำหรับสาย IoT หรือ Big Data ไปจนถึง mobile application (ไม่มี blockchain นะ ฮ่าๆๆ)