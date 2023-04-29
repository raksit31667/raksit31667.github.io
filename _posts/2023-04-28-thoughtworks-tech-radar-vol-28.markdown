---
layout: post
title:  "สิ่งที่น่าสนใจจาก Thoughtworks Tech Radar ฉบับที่ 87"
date:   2022-04-28
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
[Data Version Control - DVC](https://dvc.org/) เป็นเครื่องมือในการทำ version control สำหรับ data science project มีรูปแบบการทำงานคล้าย ๆ กับ Git ใน code version control เลย แต่สิ่งที่ track จะเป็น machine learning model และ data sets แทน นั่นหมายความว่าเราสามารถ track ย้อนกลับไปดู model เก่า ๆ ได้ แม้กระทั่งแตก branch เพื่อแยกงาน และจะเก็บข้อมูลไว้ใน Amazon S3, Azure Blob Storage, Google Drive, Google Cloud Storage ก็ได้ นับว่าเป็นจุดเริ่มต้นที่จะนำ engineering practice ดี ๆ มาใช้กับงานสาย data science ด้วย

### Akeyless (Trial)
ปัญหาของการเชื่อมระบบงานที่อยู่ข้ามหลาย ๆ cloud provider คือการจัดการ credentials และ access control ที่ซับซ้อนเพราะเมื่อมีการ update ก็ต้องทำข้ามทุก provider เครื่องมือ [Akeyless](https://www.akeyless.io/) ใช้แนวคิดในการเก็บ credentials แล้ว sync ข้ามหลาย ๆ provider เอา นอกจากนั้นยังมี user interface และ monitoring ให้ ส่งผลให้การจัดการง่ายขึ้นเนื่องจากเราก็ update credentials แค่ที่เดียวพอ

### EventCatalog (Trial)
สิ่งที่ควรทำเมื่อมีการพัฒนาระบบในรูปแบบของ event-driven architecture กับ microservcies คือการกำหนดและทำ documentation ของ event schema ซึ่งท่าส่วนใหญ่ที่ไปกันคือบันทึก[ลงไปใน schema registry](https://learn.microsoft.com/en-us/azure/event-hubs/create-schema-registry) ขึ้นอยู่กับว่าใช้ event streaming เจ้าไหน [EventCatalog](https://www.eventcatalog.dev/) เป็นเครื่องมือใหม่ที่เราสามารถเขียนและจัดเก็บ documentation ที่เกี่ยวกับ events และ schemas สำหรับ event-driven architecture ที่มีมากกว่าแค่ event schema definition เพราะเราสามารถระบุได้เลยว่า service ไหนเป็นคน publish หรือ subscribe event นั้น ๆ ด้วย

### FOSSA (Trial)
[FOSSA](https://fossa.com/product/open-source-license-compliance) เป็นเครื่องมือที่ใช้ตรวจสอบว่า dependencies ที่เป็น open-source นั้นใช้บน license อะไรอยู่ มี automation ที่เชื่อมเข้ากับ CI เพื่อตรวจสอบแบบ real-time ได้ด้วย ช่วยให้เราตรวจสอบความเสี่ยงทางด้าน security ได้รวดเร็วขึ้น 

### IBM Equal Access Accessibility Checker (Trial)
[IBM Equal Access Accessibility Checker](https://www.ibm.com/able/toolkit/verify/overview/) เป็นเครื่องมือที่ตรวจสอบ accessibility ของระบบงาน เช่น web application ที่จะมาในรูปแบบ manual หรือ browser extension หรือ screen reader ก็ได้ คำแนะนำคือให้ใช้เครื่องมือนี้เป็นส่วนเสริมในการทดสอบโดยที่ยังไม่ต้องไปลบการทดสอบแบบอัตโนมัติอื่น ๆ ที่เรามีอยู่แล้ว

### Mozilla SOPS (Trial)
[Mozilla SOPS](https://github.com/mozilla/sops) เป็นเครื่องมือในการ encrypt Kubernetes secret รองรับ YAML, JSON, ENV, INI และ BINARY format สามารถ encrypt ด้วย secret manager ของ cloud provider หลาย ๆ เจ้าอย่าง AWS KMS, GCP KMS, Azure Key Vault เป็นต้น ช่วยให้เราสามารถเก็บ secret ไว้ในรูปแบบ source code ได้ ในขณะเดียวกันมันก็ปลอดภัยในระดับนึงเนื่องจากมันต้องเข้าถึง secret manager ถึงจะ decrypt ได้

### Steampipe (Trial)

<https://medium.com/nontechcompany/query-aws-resource-with-sql-using-steampipe-50f5ab4f5d84>

### Terraform Cloud Operator (Trial)


### Typesense (Trial)
[Typesense](https://github.com/typesense/typesense) เป็น open-source search engine มีจุดเด่นที่เขาโฆษณาคือเร็ว แรง และฉลาดที่จะ search ต่อจาก keyword ที่สะกดผิด (typo-tolerant) เหมาะสำหรับระบบที่ต้องการ search ที่เน้นเร็วมากกว่าจำนวนข้อมูล (แต่จาก [demo กับข้อมูล 30 กว่าล้าน record](https://songs-search.typesense.org/) ก็จัดว่าเร็วแล้ว) ในขณะที่คู่แข่งอย่าง Elasticsearch จะเน้นจำนวนข้อมูลเยอะ ๆ ได้เนื่องจาก scale ได้ดีกว่า

### ChatGPT (Assess)
หลายคนคงไม่แปลกใจที่จะได้เห็น [ChatGPT](https://openai.com/blog/chatgpt) ใน Tech Radar ฉบับนี้ เนื่องจากมันเป็น large language model (LLM) ที่ทรงพลังมากและมี use case นับไม่ถ้วนไล่ตั้งแต่ออก idea ไปจนถึงเขียน code และ test ให้ครบ โดยเฉพาะตัวใหม่ล่าสุดที่เพิ่งออกมาอย่าง GPT4 ที่สามารถเชื่อมกับ web search ได้แล้ว แต่สาเหตุที่ ChatGPT ยังอยู่ใน Assess เนื่องจากหลายคนกังวลว่ามันจะเอาข้อมูลของเราไปทำอะไร (data privacy) เนื่องจากเราสามารถใส่ข้อมูลที่อาจจะเป็นความลับขององค์กรเข้าไปส่งผลให้มีโอกาสหลุดออกไปได้ ดังนั้นก่อนที่องค์กรจะนำมาใช้งานในการพัฒนา software แบบจริงจัง Thoughtworks แนะนำให้ปรึกษากับทีมกฎหมายก่อน

### GitHub Copilot (Assess)
จากหัวข้อ ChatGPT ข้างบน หากองค์กรมีความกังวลด้าน data privacy เราก็แนะนำให้รอใช้ [GitHub Copilot](https://github.com/features/copilot) ไปก่อนได้ ซึ่งจะต่างจาก ChatGPT ตรงที่มันเป็นเครื่องมือสำหรับช่วยเขียน code เท่านั้น มีจุดเด่นคือสามารถเสนอแนะ code ที่เจาะจงไปตาม context ของ code เราโดยเฉพาะได้ ด้วยข้อจำกัดที่มันทำเพื่อช่วยเขียน code อย่างเดียวเลยอาจจะไม่ได้เพิ่ม productivity มากเท่าไร เนื่องจากการพัฒนา software มันมีอะไรต้องทำมากกว่าเขียน code นั่นเอง 

### iamlive (Assess)
[iamlive](https://github.com/iann0036/iamlive) เป็นเครื่องมือที่ช่วยทุ่นแรงในการเขียน AWS IAM policy โดยมันจะ track ตามคำสั่งที่เรา run ผ่าน AWS CLI แล้วออกมาเป็น policy ที่จำเป็นต้องใช้ในการ run คำสั่งนั้นให้ผ่าน

### Kubernetes External Secrets Operator (Assess)
[external-secrets](https://github.com/external-secrets/external-secrets) เป็นเครื่องมือที่ใช้เชื่อม Kubernetes กับ secret manager โดยผลลัพธ์คือมันจะสร้าง Kubernetes Secrets resource ขึ้นมาตาม secret ที่เก็บไว้ข้างนอกเลย


## Languages and Frameworks

### Gradle Kotlin DSL (Adopt)
ถ้าเราใช้ [Gradle](https://docs.gradle.org/current/userguide/userguide.html) เป็น package manager แล้วเราสามารถเขียนได้ 2 แบบคือ [Groovy และ Kotlin DSL](https://docs.gradle.org/current/userguide/migrating_from_groovy_to_kotlin_dsl.html) ทาง Thoughtworks แนะนำให้เป็นอย่างหลังเนื่องจากมันสามารถใช้ความสามารถของ IDE อย่างการทำ autocompleting หรือ refactoring ได้

### Stencil (Trial)
[Stencil](https://stenciljs.com/) เป็น library สำหรับทำ web component ด้วย TypeScript, JSX และ JSDoc ซึ่งสามารถ share ใช้งานร่วมกับ platform ไหนก็ได้จึงเหมาะสำหรับการสร้าง design system เดียวแล้วต้องรองรับ platform หรือ framework หลาย ๆ ตัวเป็นอย่างมาก (หรือจะไม่ใช้ framework อะไรเลยก็ได้เหมือนกัน) นอกจากนั้นยังสามารถทำ polyfilling ในกรณีที่ browser ไม่รองรับด้วย 

### Qwik และ SolidJS (Assess)
ยังคงมาอย่างต่อเนื่องสำหรับ JavaScript framework ใหม่ ๆ ในฉบับนี้มี 2 ตัวได้แก่

- [Qwik](https://qwik.builder.io/) แก้ปัญหาในการ load web ครั้งแรกแล้วมันช้าซึ่งเกิดหลังจาก server-side rendering เช่น ผูก event listeners, สร้าง DOM tree, ดึง application state (เรียกรวม ๆ กันว่า hydration)
- [SolidJS](https://www.solidjs.com/) ช่วยให้เราเขียน React ด้วย performance ที่เร็วขึ้น มี bundle size ที่เล็กลง และรองรับ web component ด้วย

### Turborepo (Assess)
ปัญหาของการใช้แนวคิด monorepo คือขนาดของ project ที่ใหญ่และความซับซ้อนในการจัดการ build, package, test และ deploy ดังนั้นถ้าเราสามารถลดเวลาที่ใช้ในขั้นตอนดังกล่าวได้ชีวิตก็จะดีขึ้นไปด้วย การมาของ [Turborepo](https://turbo.build/repo) ที่เป็นตัวจัดการ monorepo สำหรับ JavaScript project เนื่องจากมันถูกพัฒนาด้วยภาษา Rust ดังนั้นมันจึงเร็วมาก ๆ ทำให้เราสามารถ build ได้หลาย project พร้อม ๆ กันเลย หรือจะเลือก run ตามลำดับก็ได้ไม่ว่ากัน น่าจะเป็นตัวเลือกที่น่าสนใจไม่แพ้ nx หรือ Lerna เลยนะ