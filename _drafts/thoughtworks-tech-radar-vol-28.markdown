---
layout: post
title:  "สิ่งที่น่าสนใจจาก Thoughtworks Tech Radar ฉบับที่ 87"
date:   2022-11-04
tags: [technology-radar]
---

จากรายงานเรื่อง [Technology Radar Vol. 28](https://www.thoughtworks.com/radar) ของ ThoughtWorks ซึ่งทำการสรุปเรื่องของ technique เครื่องมือ language และ framework ต่าง ๆ สำหรับการพัฒนา software ออกมา จึงนำมาสรุปสิ่งที่ (เรา) สนใจมา

## Techniques

### Applying product management to internal platforms (Adopt)
ปัจจุบันหลายองค์กรได้ลงทุนกับการสร้าง internal developer platform เพิ่มขึ้นเพื่อลดค่าใช้จ่ายในการสร้าง ดูแลรักษาระบบที่ไม่ได้เกี่ยวข้องกับ business ตรง ๆ ซ้ำ ๆ คล้าย ๆ กัน การที่จะสร้าง platform ที่ประสบความสำเร็จนั้นมันไม่ใช่แค่เปลี่ยนชื่อหรือเปลี่ยนทีมแต่วิธีการทำงานยังเหมือนเดิมแล้วจบ จะต้องมีการนำ product thinking มาประยุกต์ด้วย เช่น 

- การมี product manager เพื่อช่วยเก็บ requirement กำหนดวัดความสำเร็จ และสร้าง roadmap ขึ้น
- ทำความเข้าใจปัญหาของทีมพัฒนาที่เป็นคนใช้ platform ของเราและร่วมกันออกแบบ platform

ประโยชน์ที่ได้คือ platform ขององค์กรจะยังคงส่งมอบคุณค่าทาง business ทั้งทางตรงและทางอ้อมได้

<https://raksit31667.github.io/platform-thinking>

### CI/CD infrastructure as a service (Adopt)
ในการใช้งาน CI/CD pipeline ปัจจุบันมี service หลายเจ้าให้เลือกใช้งาน เช่น [GitHub Actions](https://www.thoughtworks.com/radar/platforms/github-actions), [Azure DevOps](https://www.thoughtworks.com/radar/platforms/azure-devops) หรือ [Gitlab CI/CD](https://www.thoughtworks.com/radar/platforms/gitlab-ci-cd) ซึ่งมีข้อดีคือเราไม่ต้องมาดูแลรักษาและเสียค่าใช้จ่ายไปกับการ host CI/CD ด้วยตัวเอง และมี security ที่ติดตั้งมาให้พร้อม เมื่อเทียบกับการที่เราต้อง host ด้วยการใช้ platform อย่าง [actions-runner-controller](https://www.thoughtworks.com/radar/platforms/actions-runner-controller) หรือ [self-hosted GitHub runner ของบริษัท Phillip's](https://www.thoughtworks.com/radar/tools/philips-s-self-hosted-github-runner) เราควรจะต้องนำแนวคิด [zero-trust security](https://www.microsoft.com/th-th/security/business/security-101/what-is-zero-trust-architecture) เพื่อกำหนดสิทธิ์ในการเข้าถึง credentials เพื่อ build และ deploy ระบบงาน

### Dependency pruning (Adopt)
หลายองค์กรมีการใช้งาน software template เพื่อขึ้น project ใหม่ได้อย่างรวดเร็ว แต่ข้อเสียที่ตามมาด้วยคือ template เหล่านี้มักจะทำมาเพื่อตอบโจทย์กับทุก ๆ ทีม จึงต้องติดตั้ง dependencies ที่อาจจะไม่จำเป็นสำหรับบางทีม ทาง Thoughtworks ก็เลยแนะนำให้เข้าไปตรวจสอบหน่อยว่ามี dependencies ไหนที่ไม่ได้ใช้หรือเปล่า ถ้ามีก็ให้เอาออกซะเพื่อลดช่องโหว่จากการโจมตีด้าน security

### Run cost as architecture fitness function (Adopt)
การนำระบบขึ้นบน cloud provider หากไม่ติดตั้งอย่างระมัดระวังก็อาจจะตกใจเมื่อได้เห็นค่าใช้จ่ายรายเดือนที่งอกขึ้นมา การที่เรามีเครื่องมืออย่าง [Infracost](https://www.infracost.io/) เพื่อตรวจสอบและประเมินค่าใช้จ่ายที่กำลังจะเกิดขึ้น โดยค่าใช้จ่ายนั้นเกิดจากทั้งการใช้งานจริงและ architecture ที่ออกแบบไว้ ถ้ารีด optimize ระบบแล้วแต่ผลประเมินออกมาว่าค่าใช้จ่ายยังสูงอยู่ อาจจะเป็นสัญญาณที่ดีว่าถึงเวลาต้องปรับปรุง architecture ใหม่แล้วล่ะ

> ปล. หัวข้อนี้ถูกจัดอยู่ใน Adopt ตั้งแต่ปี 2019 แล้วนะครับ

### Accessibility annotations in designs (Trial)
ในการพัฒนา software แน่นอนว่าเรื่องของ accessbility ควรถูกนำมาพูดถึงตั้งแต่เนิ่น ๆ เพื่อให้ software เข้าถึงคนทุกคนให้ได้มากที่สุด ซึ่งจะมีผลต่อการ design ที่จะต้องคิดในส่วนนี้เพิ่ม เช่น การจัดเรียง HTML element ใหม่ หรือการเพิ่ม text เพื่อทดแทนปุ่มหรือรูปภาพ ให้ใช้งานผ่านเครื่องมือผู้บกพร่องทางการมองเห็นได้ง่ายขึ้น เป็นต้น ซึ่ง design system อย่าง [Figma](https://www.thoughtworks.com/radar/tools/figma) ก็ได้รองรับเรื่องนี้แล้ว เช่น

- [A11y Annotation Kit](https://www.figma.com/community/file/953682768192596304/A11y-Annotation-Kit)
- [Twitter Accessibility Annotation Library](https://www.figma.com/community/file/976946194228458698/Accessibility-Annotation-Library)
- [Axe for Designers](https://www.figma.com/community/plugin/1085612091163821851/Axe-for-Designers-(FREE))

### Bounded low-code platforms (Trial)
ปัจจุบัน low-code platform หลาย ๆ เจ้าก็มีความสามารถมากขึ้นและสอดคล้องไปกับ engineering practice สมัยใหม่ได้มากขึ้น ทำให้หัวข้อนี้ถูกขยับขึ้นมาจาก Assess เป็น Trial แต่ข้อจำกัดของ low-code ก็ยังอยู่เหมือนเดิม ก็คือสร้างมาให้แก้ปัญหาได้อย่างจำกัด นอกจากนั้นต้องรอให้ทาง platform เพิ่ม feature ที่สอดคล้องกับ engineering practice ใหม่ ๆ ลงไปถึงจะใช้ได้

### Demo frontends for API-only products (Trial)
ปัญหาในการพัฒนา API คือการนำเสนอให้คนเห็นถึง business value เนื่องจากในสายตาคนทั่วไปมันดูเป็นอะไรที่ technical เอามาก ๆ  การนำเครื่องมืออย่าง [Swagger](https://swagger.io/) หรือ [Postman](https://www.postman.com/product/what-is-postman/) มาช่วยก็ช่วยให้มันจับต้องได้มากขึ้น จึงเกิดแนวคิดในการสร้าง frontend application สำหรับนำเสนอ API ขึ้นมาโดยเฉพาะ ซึ่งอาจจะมาในรูปแบบของ UI ที่เป็น form ก็ได้ ก็จะช่วยให้ business user เข้าใจได้มากขึ้นเพราะพวกเค้าคุ้นชินกับมันมากกว่าเครื่องมือที่ว่ามาก่อนหน้า

### Verifiable credentials (Trial)

### Logseq as team knowledge base (Assess)
ทีมมีการจัดการคลังความรู้แตกต่างกันไปตามเครื่องมือ ส่วนมากที่เราเห็นก็จะเป็นในรูปแบบของ Wiki แต่วิธีใหม่ ๆ ยังเป็นส่วนน้อยอยู่ หนึ่งในนั้นก็คือการใช้ application อย่าง [logseq](https://logseq.com/) หรือ [Obsidian](https://www.thoughtworks.com/radar/tools/obsidian) ที่มี graph database ที่เก็บ notes ที่เชื่อมกันผ่าน application ทำให้เราเห็นการเชื่อมโยงของความรู้ต่าง ๆ เกิดการเรียนรู้ขึ้นใหม่ในทีม เป็นประโยชน์มากสำหรับการทำ onboarding ให้คนที่เข้าทีมใหม่ด้วย แต่ไม่ว่าจะใช้เครื่องมืออะไร การจัดเรียงความรู้ให้เป็นระบบระเบียบก็ยังจำเป็นอยู่ดี

### Reachability analysis when testing infrastructure (Assess)
ปัญหาในการ deploy ระบบงานผ่าน Infrastructure-as-a-Code คือเมื่อระบบไม่สามารถติดต่อกันผ่าน network ได้ และจะยิ่งหนักขึ้นถ้าระบบ network ของเรามีความซับซ้อน ส่งผลให้เราใช้เวลาในการวิเคราะห์หาต้นเหตุของปัญหานานขึ้่น จึงเกิดแนวคิดในการตรวจสอบเพิ่มว่าหลังจากที่เรา deploy แล้วระบบมันวิ่งไปหากันถึงหรือเปล่า (reachability) ทำให้เราตีปัญหาให้แคบลงได้เร็วขึ้น เข่น เรา configure port ถูกต้องไหม หรือ endpoint เข้าถึงได้หรือเปล่า เป็นต้น ตอนนี้ cloud provider เจ้าใหญ่ ๆ เขาก็มีเครื่องมือรองรับแนวคิดเหล่านี้อยู่แล้ว

- [Azure Network Watcher](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-connectivity-cli)
- [AWS Reachability Analyzer](https://docs.aws.amazon.com/vpc/latest/reachability/what-is-reachability-analyzer.html)
- [GCP Connectivity Test](https://cloud.google.com/network-intelligence-center/docs/connectivity-tests/concepts/overview)

### Tracking health over debt (Assess)
ปัญหาในการจัดการ [technical debt](https://martinfowler.com/bliki/TechnicalDebt.html) คือการจัดลำดับความสำคัญและการพูดคุยกับคนที่ถือกระเป๋าตังค์จ่ายเงินให้ทีมเรา จึงเกิดแนวคิดในการนำเสนอใหม่แทนที่จะพูดถึง debt นั้นว่ามันแย่ยังไง ให้มองจากอีกมุมนึงว่าเราคาดหวังว่าระบบเรามันควรจะเป็นยังไงจากมุมมองของ development, operations และ architecture แล้วปัจจุบันมันไปถึงจุดนั้นมากแค่ไหนแล้ว ทำให้ทีม focus ได้ว่า debt ที่กำลังจะแก้มันทำให้ระบบไปถึงจุดที่ทีมคาดหวังได้มากน้อยขนาดไหน แนวคิดนี้ก็จะคล้าย ๆ กับการวัด service-level objectives (SLOs) นั่นเอง

<https://www.rea-group.com/about-us/news-and-insights/blog/what-good-software-looks-like-at-rea/>

### Planning for full utilization (Hold)
เมื่อพูดถึง product management ในการพัฒนา software แล้ว Thoughtworks พบว่ายังมีอีกหลายทีมที่ plan งานให้ทุกคนในทีมแบบจัดเต็มโดยไม่เผื่อไว้สำหรับเหตุการณ์ที่ไม่คาดฝัน เช่น ลาป่วย แก้ปัญหาบน production แก้ technical debt รวมไปถึงกิจกรรมทางบวกอย่าง team building หรือ ideation workshop เป็นต้น สิ่งเหล่านี้ควรจะมีเพื่อให้ทีมมีเวลากลับมาทบทวนระบบงานปัจจุบันเพื่อปรับปรุงให้มันดีขึ้นมากกว่ามุ่งไปแต่การทำงานให้รอบให้มันจบ ๆ ไป


## Platforms

### GitHub Actions (Adopt)
[GitHub Actions](https://docs.github.com/en/actions) กลายเป็น CI/CD platform เริ่มต้นที่ดีหากเราเก็บ code ไว้ใน GitHub มีจุดเด่นคือสามารถเรียก action หลาย ๆ อันมาประกอบกันเป็น workflow ที่ซับซ้อนขึ้นได้ ในด้านของ security ก็มีการ[ป้องกันไม่ให้ secret หลุดออกไปด้วย](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions) นอกจากนั้นยังมี community ที่แข็งแกร่ง หนึ่งในเครื่องมือจาก community คือ [act](https://github.com/nektos/act) ที่สามารถ run GitHub Actions บนเครื่อง local ได้เลย และมี [GitHub Marketplace](https://github.com/marketplace?type=actions) ที่เราสามารถเลือกใช้ actions จาก third-party ได้โดยไม่ต้องออกแรงทำเอง ทั้งนี้ทั้งนั้นเราก็ต้องระวังการที่ action ขอสิทธื์เข้าถึง pipeline ของเรามากเกินความจำเป็นด้วย

### k3s (Adopt)
[k3s](https://k3s.io/) เป็น platform ที่ run Kubernetes มีจุดเด่นคือสามารถ run บน environment ที่มี resource จำกัดได้ เช่น edge computing เนื่องจากเบื้องหลังแล้ว k3s จะเก็บ state ไว้ใน [sqlite3 database](https://docs.python.org/3/library/sqlite3.html) แทนที่จะเป็น [etcd](https://etcd.io/) นอกจากนั้นยังรองรับ [WebAssembly](https://www.thoughtworks.com/radar/languages-and-frameworks/webassembly) ด้วย

### Arm in the cloud (Trial)
ปัจจุบัน cloud provider เจ้าใหญ่ ๆ อย่าง AWS, Azure และ GCP ต่างก็รองรับการ run instance บน cloud ด้วย [Arm](https://www.arm.com/markets/computing-infrastructure/cloud-computing) แล้ว ประโยชน์ที่ได้คือลดค่าใช้จ่ายบน cloud ลงเมื่อเทียบกับพวก x86 ซึ่งเหมาะสำหรับองค์กรที่ run ระบบงานขนาดใหญ่ในระดับ scale ที่ใหญ่

### TypeDB (Trial)
[TypeDB](https://vaticle.com/) เป็น graph database เหมาะสำหรับงานที่ต้องเข้าไปดึงข้อมูลที่เป็น graph มีความเชื่อมโยงที่ซับซ้อน เช่น natural language data หรือ recommendation engine มาพร้อมกับ feature ครบครัน เช่น command-line, [GUI](https://github.com/vaticle/typedb-studio), [documentation](https://docs.vaticle.com/docs/general/introduction) และ community ที่ active พอสมควรเลย (ขณะที่เขียนบทความตอนนี้ใน GitHub repository มี 3400 กว่า stars แล้ว)

### Dapr (Assess)
[Dapr](https://dapr.io/) เป็น API runtime ที่ติดตั้งในรูปแบบของ sidecar pattern ที่ช่วยลดความซับซ้อนในการพัฒนา feature ต่าง ๆ ตามแนวคิดของ distributed architecture เช่น state management, configuration and secret management, publish & subscribe (pub/sub), event notification (bindings), service-to-service communication

### Modal (Assess)
[Modal](https://modal.com/) เป็น platform as a service ที่เราสามารถนำงานที่ใช้ [CPU หรือ GPU สูง ๆ](https://modal.com/examples) อย่าง machine learning model หรือ jobs ที่ run เป็น parallel มีจุดเด่นคือใช้งานง่า ไม่ต้องติดตั้ง Docker หรือ setup Kubernetes cluster ให้วุ่นวาย น่าสนใจที่ทีมพัฒนาเป็นทีมที่เคยทำระบบ recommendation ให้ Spotify มาแล้วด้วย

### Passkeys (Assess)
เมื่อพูดถึงเรื่องของการ login เข้าใช้งานระบบต่าง ๆ การใช้งาน password ไม่ว่าจะเป็นอันเดียวหรือเป็น multi-factor หรือเป็น password manager ก็จะเจอปัญหาเดียวกันคือต้องจดจำให้ได้ และมีโอกาสที่เราไม่สามารถระบุตัวตนว่าใครเป็นคนกรอก password เข้ามาใน website จึงเกิด platform ชื่อ [Passkeys](https://www.passkeys.io/) ที่ใช้ asymmetric cryptography โดยที่ website จะถือ public key และ user ถือ private key ไว้ หมายความว่ามันสามารถระบุตัวตนของคนที่ถือ private key ได้ นอกจากนั้นยัง secure อีกชั้นได้ด้วย biometrics หรือ PIN จุดเด่นอีกอย่างคือมันสามารถ sync ข้าม operating system ได้ผ่าน [Client to Authenticator Protocol](https://en.wikipedia.org/wiki/Client_to_Authenticator_Protocol) หมายความว่าเราสามารถใช้งาน Passkeys เดียวจากหลายอุปกรณ์ได้ ข้อจำกัดที่มีคือต้องอาศัย Bluetooth ในการใช้งานในกรณีที่เรา scan QR code แล้วตัว Passkeys มันจะ scan หาอุปกรณ์รอบ ๆ เพื่อความปลอดภัย


## Tools

### DVC (Adopt)

### Apicurio Registry (Trial)

### EventCatalog (Trial)

### FOSSA (Trial)

### Gitleaks (Trial)

### Helmfile (Trial)

### IBM Equal Access Accessibility Checker (Trial)

### Mozilla SOPS (Trial)

### Ruff (Trial)

### Steampipe (Trial)

<https://medium.com/nontechcompany/query-aws-resource-with-sql-using-steampipe-50f5ab4f5d84>

### Terraform Cloud Operator (Trial)

### Typesense (Trial)

### ChatGPT (Assess)

### GitHub Copilot (Assess)

### iamlive (Assess)

### Kepler (Assess)

### Kubernetes External Secrets Operator (Assess)

### Kubeshark (Assess)


## Languages and Frameworks

### Gradle Kotlin DSL (Adopt)

### Stencil (Trial)

### Vitest (Trial)

### .NET 7 Native AOT (Trial)

### SolidJS (Assess)

### Turborepo (Assess)