---
layout: post
title:  "สิ่งที่น่าสนใจจาก Thoughtworks Tech Radar ฉบับที่ 27"
date:   2022-10-29
tags: [technology-radar]
---

จากรายงานเรื่อง [Technology Radar Vol. 27](https://www.thoughtworks.com/radar) ของ ThoughtWorks ซึ่งทำการสรุปเรื่องของ technique เครื่องมือ language และ framework ต่าง ๆ สำหรับการพัฒนา software ออกมา จึงนำมาสรุปสิ่งที่ (เรา) สนใจมา  

## Technique

### Path-to-production mapping (Adopt)
โดยปกติแต่ละทีมก็จะมีเส้นทางส่งมอบชิ้นงานขึ้นให้ผู้ใช้งานแตกต่างกันไป แต่ไม่ได้ถูกนำมาแสดงเป็นรูปเป็นร่าง ไม่ว่าจะเป็น

- ขั้นตอน พร้อมงานที่ต้องทำก่อน-หลัง
- คนที่มีส่วนเกี่ยวข้อง
- เครื่องมือที่ใช้
- ผลลัพธ์ที่ได้

Technique นี้ก็คือนำสิ่งที่กล่าวมาข้างต้นมาแสดงให้ดูในรูปแบบต่าง ๆ เช่น [value-stream mapping](https://en.wikipedia.org/wiki/Value-stream_mapping) เพื่อให้ทุกคนเกิดความเข้าใจตรงกันและแสดงให้เห็นถึงความเสี่ยงและจุดบกพร่องที่มี  

[รูป path to production]()

### Team cognitive load (Adopt)
จากกฎที่ชื่อว่า [Conway’s law](https://en.wikipedia.org/wiki/Conway%27s_law) ซึ่งกล่าวถึง architecture **รวมถึงแนวทางการส่งมอบงาน แบบอัตโนมัติ** มันจะเป็นรูปเป็นร่างได้มันก็ต้องมาจากรูปแบบขององค์กรที่ตอบโจทย์ด้วย เมื่อสภาพองค์กรเปลี่ยนไปแล้วเราควรจะสามารถตรวจสอบได้ว่าแนวทางการส่งมอบมันเปลี่ยนตามไปด้วยหรือไม่ผ่าน Team cognitive load assessment เช่น ในรูปแบบของ [form](https://docs.google.com/forms/d/e/1FAIpQLSfDjBs3KRdLp524ipvhrOIVeqqhBiR2CFDspvvhfWCphjV7XQ/viewform) ประกอบไปด้วยคำถามต่าง ๆ เช่น ความยากในการทดสอบ การ build deploy และดูแลระบบงาน เป็นต้น  

ในส่วนของสภาพองค์กร ดูเพิ่มได้ที่หนังสือ [Team Topologies](https://teamtopologies.com/book)

### Threat modeling (Adopt)
ทีมพัฒนาควรมีการทำ [threat modeling](https://wiki.owasp.org/index.php/Category:Threat_Modeling) อย่างสม่ำเสมอ ไม่ใช่เพียงแค่ก่อน-หลังส่งมอบระบบงานไปแล้วเท่านั้น นอกจากระบบงานมีการเปลี่ยนแปลงไปอย่างต่อเนื่องแล้วเรามีโอกาสตรวจพบความเสี่ยงหรือปัญหาก่อนที่จะเกิดความเสียหายขึ้นได้ด้วย

### Component visual regression testing (Trial)
ปัญหาในการพัฒนา frontend ในรูปแบบของ web คือตรวจสอบยากว่ามีส่วนไหนถูกแก้ไขหรือเปล่า แต่เดิมคือจะต้องดูด้วยตาตัวเอง การมาของ Visual regression testing ใน library ที่พัฒนา web ด้วยแนวคิดการนำชิ้นส่วนเล็ก ๆ (component) มาประกอบกันอย่าง React หรือ Vue ประกอบไปกับเครื่องมือในการ build และ reload web เมื่อมีการแก้ไข code อย่าง [Vite](https://github.com/vitejs/vite) ก็ทำให้การพัฒนาและตรวจสอบระบบง่ายขึ้น เครื่องมือที่น่าสนใจที่แนะนำใน Radar ฉบับนี้ก็อย่างเช่น [Cypress Component Testing](https://docs.cypress.io/guides/component-testing/writing-your-first-component-test) ซึ่งมีข้อดีคือสามารถเขียนในรูปแบบคล้าย ๆ กับ end-to-end test ที่เป็น use case หลักของ Cypress ได้เลย

### Design tokens (Trial)
ปัญหาในการทำงานร่วมกันระหว่าง designer และ developer คือการทำความเข้าใจกับ design ร่วมกันเมื่อมีการเปลี่ยนแปลงส่วนต่าง ๆ เช่น สี ช่องว่าง ขนาด font เป็นต้น จึงเกิดแนวคิดของ [Design tokens](https://amzn.github.io/style-dictionary/#/tokens) ที่รวมข้อมูลของ design ไว้ในที่เดียว โดย designer จะสร้าง file เช่น JSON ผ่านเครื่องมือต่าง ๆ เช่น Figma แล้วส่งให้ developer ไปใช้ใน code ได้ทันที ปัจจุบันมีเครื่องมืออื่น ๆ ที่น่าสนใจอย่าง [Tailwind CSS](https://tailwindcss.com/) ก็ช่วยให้การใช้ technique นี้ง่ายขึ้น

### Fake SMTP server to test mail-sending (Trial)
ปัญหาในการทดสอบระบบที่เชื่อมกับการส่ง email ก็คือการใช้ server จริงในการทดสอบ ซึ่งมีความเสี่ยงที่เราจะส่ง test email ให้กับ ผู้ใช้งานบนระบบจริงได้ การใช้งาน email server ที่ fake ขึ้นมาด้วยเครื่องมืออย่าง [fake-stmp-server](https://github.com/gessnerfl/fake-smtp-server) หรือ [mountebank](http://www.mbtest.org/docs/protocols/smtp) ก็จะช่วยป้องกันไม่ให้เกิดปัญหาดังกล่าวได้

### Incremental developer platform (Trial)
ปัญหาของการพัฒนา platform ออกมาเพื่อปรับปรุง [developer experience](https://developerexperience.io/) คือถ้าไม่ตอบโจทย์ developer อาจจะมีค่าใช้จ่ายคือ ไม่มีคนใช้ สิบเนื่องจากหลายสาเหตุ เช่น 
- Platform ไม่มีขอบเขต ทำทุกอย่างได้แต่ใช้ยาก
- Focus ที่ quality มากจนเกินไป ไม่มี business value

การพัฒนา platform ที่ยั่งยืนคือจะต้องมีขั้นตอนการ Discover → Define → Deliver ที่ดี นั่นหมายความว่าเราต้องเริ่มจากจุดเล็ก ๆ ก่อน เช่น เริ่มจาก Checklist แล้วค่อยไป Tickets → Collaboration → Self-service จากนั้นเราต้องวัดผลของ developer experience ออกมาได้ เพื่อนำไปปรับปรุงต่อไป

### Observability for CI/CD pipelines (Trial)
น่าจะเป็นเรื่องปกติกันแล้วที่เราจะมีสิ่งที่คอยตรวจสอบ เรียกดูและแจ้งเตือน (observability)เพื่อทำความเข้าใจปัญหาที่อาจจะเกิดขึ้นบนระบบงาน เช่น ระบบมี traffic เข้ามาพร้อมกันเยอะๆ หรือ ระบบอาจจะล่ม แต่เราไม่ค่อยมีสิ่งตรวจสอบเมื่อการ build หรือ deploy ช้าลงบน Continuous integration/delivery (CICD) pipeline สักเท่าไร จึงมีเครื่องมือ observability อย่าง [buildevents](https://github.com/honeycombio/buildevents) ของ [Honeycomb](https://www.honeycomb.io/) ที่แสดงข้อมูลของแต่ละขั้นตอนใน pipeline ให้เป็นในรูปแบบ flame graph ที่เข้าใจได้ไม่ยาก

### GitHub push protection (Assess)
หลายองค์กรมีวิธีหรือเครื่องมือเพื่อป้องกันไม่ให้ developer นำ code ที่เป็นความลับอย่าง password, API key, access token ขึ้นไปบน repository กลาง สำหรับองค์กรที่ใช้ [GitHub](https://docs.github.com/en/enterprise-cloud@latest/code-security/secret-scanning/protecting-pushes-with-secret-scanning) ก็รองรับการ scan โดยไม่ต้องติดตั้งเครื่องมืออื่น ๆ เพิ่มเติม มีข้อจำกัดที่ feature นี้ใช้ได้เพียงแค่คนที่ถือ GitHub Enterprise Cloud ซึ่งไม่ฟรี

### SLIs and SLOs as code (Assess)
การมาของ site reliability engineering (SRE) เพื่อช่วยให้ระบบทำงานได้อย่างมีประสิทธิภาพและน่าเชื่อถือ จะมีการกำหนดค่าเพื่อใช้เป็นมาตรฐานปรับปรุงระบบอย่าง service-level indicators (SLIs) และ service-level objectives (SLOs) ปัญหาคือการกำหนดเหล่านี้ต้องอาศัยเครื่องมือ observability มากพอสมควร จึงมีแนวคิดในการกำหนดมาตรฐานขึ้นมาอย่าง [OpenSLO](https://github.com/OpenSLO/OpenSLO) ซึ่งรองรับ format ที่ไม่ได้ขึ้นกับ vendor ต่าง ๆ อย่าง Kubernetes ในรูปแบบของ YAML format ซึ่ง [Keptn อ่านออกเสียงเหมือน Captain](https://keptn.sh/) เป็น platform ที่ใช้แนวคิดนี้อยู่เบื้องหลัง

### Superficial cloud native (Hold)
ปัจจุบันการย้ายระบบงานขึ้นไปบน cloud เพื่อเลือกใช้บริการต่าง ๆ (cloud native) เป็นเรื่องปกติ แต่มักจะมีความเข้าใจผิดว่าการใช้งาน cloud จะช่วยแก้ปัญหาด้านการดูแลรักษาของ application ที่ย้ายขึ้นไปแบบ 100% ทำให้หลายคนเลือกใช้บริการบน cloud กับ application โดยที่ไม่ได้ปรับปรุงเรื่องของการออกแบบ application นั้น ๆ ส่งผลให้ประโยชน์ที่ได้รับกลับมาไม่คุ้มทุนที่ใช้ไป

## Platforms

### Backstage (Adopt)
[Backstage](https://backstage.io/) เป็น platform ปรับปรุง developer experience แบบ open-source ของ Spotify จากปัญหาที่มีร่วมกัน ได้แก่

- มีงานที่ต้องมาทำซ้ำ ๆ กัน เช่น เอกสารอ้างอิงไปถึง source code คู่การ deployment
- การค้นหาระบบที่ซับซ้อน เช่น ในองค์กรมีระบบอะไรบ้าง ใครเป็นเจ้าของ ต้องติดต่อใคร
- ตรวจสอบพวก third-party software ต่าง ๆ ในองค์กร

### AWS Database Migration Service (Trial)
[AWS Database Migration Service](https://aws.amazon.com/dms/) เป็น platform ที่ช่วย migrate ข้อมูลจาก [database ต่าง ๆ](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html) มาไว้บน [AWS resource](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.html) มีข้อดีคือมีระบบดูแล deployment และ monitoring ให้พร้อม

### Teleport (Trial)
ปัญหาของการทำ [zero-trust architecture](https://www.thoughtworks.com/radar/techniques/zero-trust-architecture) ซึ่งแต่ละส่วนย่อยของระบบจะต้องมีการป้องกันแยกกันคือ การติดตั้งที่ซับซ้อนเมื่อระบบใช้งาน platform หลากหลายผ่าน jump server, Kubernetes, database, cloud เป็นต้น [Teleport](https://goteleport.com/) เป็นเครื่องมือที่น่าสนใจเนื่องจาก Teleport ประกอบไปด้วย

- **Proxy Service** ให้ client ส่งข้อมูลให้ resource ที่อยู่ใน privaate network จาก public network
- **Auth Service** เก็บ certification เพื่อส่งให้ client ทำการส่งข้อมูลให้ proxy service นอกจากนั้นยังเป็นที่เก็บ audit log ด้วย
- **Agents** นำข้อมูลของ client ไปหา resource ที่ต้องการอย่าง SSH, Kubernetes API, HTTPS, PostgreSQL, MySQL

[รูป Teleport]()

### Bun (Assess)
[Bun](https://bun.sh/) เป็น runtime สำหรับ JavaScript คล้าย ๆ Node.js และ Deno มีข้อดีคือ 

- รวมการ bundle พวก JavaScript และ CSS file และ transpile อย่างการใช้ TypeScript ไว้ด้วยกัน
- Start application เร็วมาก มี performance ที่ดีขึ้น แต่ว่า Bun ยังอยู่ในสถานะ beta เท่านั้น การใช้งานบน production ก็คงต้องพิจารณากันหน่อย

### Dragonfly (Assess)
[Dragonfly](https://dragonflydb.io/) เป็น in-memory data store ที่รองรับการใช้งานคล้ายตัวอื่น ๆ อย่าง Redis และ Memcache มีจุดขายคือ performance ที่ดีกว่าทั้ง 2 ตัวที่กล่าวมาหลายเท่า ซึ่งทาง Redis ก็ออกมาบอกว่า Dragonfly วัดระหว่าง Redis instance เดียวเทียบกับ Dragonfly แบบ multithread ซึ่งไม่ถูกต้องสักเท่าไร เชิญไปเสพกันต่อได้ตาม link ข้างล่าง https://redis.com/blog/redis-architecture-13-years-later/

### IAM Roles Anywhere (Assess)
[IAM Roles Anywhere](https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html) รองรับการใช้งาน IAM บน application นอก AWS เหมาะสำหรับการพัฒนาแบบ hybrid cloud ที่ประกอบไปด้วย resource ของ AWS และที่ไม่ใช่ของ AWS 

### OpenMetadata (Assess)
หนึ่งในโจทย์ของการทำ data platform คือต้องมี model ที่ตอบโจทย์ในการป้องกันการเหลื่อมกันของ context ระหว่าง product หลายๆ ก้อน จึงต้องมี [OpenMetadata](https://open-metadata.org/) เป็น platform ที่ช่วยกำหนดมาตรฐานในการออกแบบ format และ metadata เพื่อให้เป็นมาตรฐานเดียวกันให้แต่ละ domain team 

## Tools

### Great Expectations (Adopt)
[Great Expectations](https://docs.greatexpectations.io/docs/) เป็นเครื่องมือที่ช่วยตรวจสอบคุณภาพของ data ใน data pipeline มีข้อดีคือใช้งานไม่ยาก สามารถกำหนดรูปแบบการตรวจสอบผ่าน JSON format และช่วยสร้าง report หลังจากการตรวจสอบด้วย มีเครื่องมือ data quality คล้าย ๆ กันอีกตัวนึงคือ [Soda Core](https://www.soda.io/core) อยู่ใน Tech Radar ฉบับนี้ในสถานะ Assess

### k6 (Adopt)
[k6](https://k6.io/) เป็นเครื่องมือที่ใช้ทำ performance testing มีข้อดีคือสามารถเขียน script ด้วยภาษา JavaScript หรือง่ายกว่านั้นคือเขียนด้วย [low-code แต่ต้องมี k6 Cloud account ก่อนนะ](https://k6.io/docs/test-authoring/test-builder/) นอกจากนั้น k6 ยังสามารถเชื่อมกับ[หลาย ๆ CICD pipeline หลาย ๆ เจ้า](https://k6.io/docs/integrations/#continuous-integration-and-continuous-delivery)ได้ด้วย

### Apache Superset (Trial)
[Apache Superset](https://superset.apache.org/) เป็นเครื่องมือ Business intelligence ซึ่งช่วยแสดงข้อมูลออกมาในรูปแบบของ graph หรือแผนภูมิต่าง ๆ [รองรับ data source](https://superset.apache.org/docs/databases/installing-database-drivers/) เยอะมากจนไปถึง data warehouse หรือ data lake หรือแม้กระทั่ง Postgres นั่นหมายความว่ามันมี use case ที่ใช้มากกว่า data engineering

### AWS Backup Vault Lock (Trial)
[AWS Backup Vault Lock](https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html) เป็นเครื่องมือที่ช่วยป้องกันไม่ให้ข้อมูลที่ backup ไว้ผ่าน AWS Backup นั้นถูกลบทิ้งก่อนที่จะหมดอายุ

### AWS Control Tower (Trial)
[AWS Control Tower](https://aws.amazon.com/controltower/) เป็นเครื่องมือที่ช่วยกำหนดการเข้าถึง resource ของ AWS เหมาะสำหรับองค์กรที่มี AWS account หลาย ๆ อันสำหรับหลาย ๆ ทีม

### Cruft (Trial)
จากการที่หลายองค์กรเริ่มหันมาพัฒนาระบบงานด้วย microservices กันมากขึ้น เพื่อความสะดวกสบายของ developer จึงมีการสร้าง service ที่มีการเตรียมเรื่องของการ build, deploy และ operate ที่คล้าย ๆ กันทั้งองค์กรผ่าน template ที่เตรียมเอาไว้ (อาจจะมาในรูปแบบของ repository หรือ template generator ต่าง ๆ) ปัญหาที่ตามมาคือเมื่อ template มีการเปลี่ยนแปลง ตัว service ที่อิงจาก template ก่อนหน้านี้กลับไม่ได้รับการ update ตามไปด้วย การตามแก้ให้เหมือนกับ template ทีละจุดก็ถือเป็นงานหนักพอสมควร จีงมี platform อย่าง [Cruft](https://cruft.github.io/cruft/) ที่ช่วยตรวจสอบความแตกต่างระหว่าง project repository ที่มีอยู่กับ repository ของ template และ update code ตามได้ด้วย สิ่งที่เราต้องระบุก็คือ Git hash ของ repository ของ template เท่านั้น

### Hadolint (Trial)
[Hadolint](https://github.com/hadolint/hadolint) เป็นเครื่องมือที่ช่วยทำ linting สำหรับ Dockerfile มีข้อดีคือสามารถตรวจสอบ inline bash/shell script ใน Dockerfile ได้ด้วย

### Kaniko (Trial)
[Kaniko](https://github.com/GoogleContainerTools/kaniko) เป็นตัวเลือกเสริมนอกจาก Docker สำหรับการ build container มีข้อดีคือไม่ต้องใช้ Docker daemon ดังนั้นเราจึงไม่ต้องกังวลเกี่ยวกับ[ปัญหาด้าน security จากการใช้งาน Docker บน privileged mode](https://learn.snyk.io/lessons/container-runs-in-privileged-mode/kubernetes/)

### Spectral (Trial)
Spectral เป็นเครื่องที่ช่วยทำ linting สำหรับ OpenAPI และ AsyncAPI มีข้อดีคือสามารถใช้งานบน local และ CICD pipeline และมี [use case จากหลาย ๆ บริษัทให้ดูด้วย](https://github.com/stoplightio/spectral#-real-world-rulesets)

### xbar for build monitoring (Trial)
ในการทำงานลักษณะ remote working ของทีมเรา สิ่งหนึ่งที่หายไปคือการมี monitoring dashboard เปิดไว้ให้ทุกคนในทีมเห็น หนึ่งใน dashboard ที่สำคัญคือสถานะของ continuous integration (CI) จาก server เพื่อที่ทีมจะได้รู้ว่าระบบล่าสุดมันมีข้อผิดพลาดตามขั้นตอนที่ได้ระบุไว้ไหม จึงมีการนำเครื่องมืออย่าง [xbar](https://github.com/matryer/xbar) หรือ [Rumps](https://github.com/jaredks/rumps) มาใช้งานโดยเขียน script เพื่อเรียกดูสถานะของ CI แล้วนำไปแสดงบน menu bar ของ macOS เป็นต้น หรือถ้าเราใช้ CI ที่รองรับ [CCTray](https://cctray.org/v1/) เครื่องมือ [CCMenu](http://ccmenu.org/) ก็เป็นตัวเลือกที่น่าสนใจ

### Karpenter (Assess)
ปกติ Kubernetes สามารถ scale ด้วยการเพิ่ม-ลดจำนวน pod ตามการใช้งานผ่าน Horizontal Pod Autoscaling (HPA) แต่ปัญหาของ HPA คือจะต้องมี Node มา host pod ก่อนถึงจะ scale ถึงแม้ Kubernetes ก็มี [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) แต่มีข้อจำกัดในการ scale เพิ่มว่าจะต้องเกิด error เมื่อ resource ที่ใช้ในการ scale สำหรับ Node ที่มีอยู่ไม่เพียงพอซะก่อน การมาของ [Karpenter](https://karpenter.sh/) ที่เป็น Kubernetes Operator แบบ open-source ที่นอกจากจะช่วยคำนวนการ scale แล้วยังสามารถเลือกรูปแบบของ instance ตามการใช้งานได้ด้วย ปัจจุบัน AWS EKS [รองรับ Karpenter เป็นหนึ่งในตัวเลือกในการ scale อีกด้วย](https://aws.amazon.com/th/blogs/thailand/%E0%B9%81%E0%B8%99%E0%B8%B0%E0%B8%99%E0%B8%B3%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B9%83%E0%B8%8A%E0%B9%89%E0%B8%87%E0%B8%B2%E0%B8%99-karpenter/)

### Mizu (Assess)
[Mizu](https://getmizu.io/) เป็นเครื่องมือที่ใช้ดู traffic ใน Kubernetes จากหลากหลาย protocol ไม่ว่าจะเป็น REST, gRPC, Kafka, AMQP, Redis แบบ real-time มีข้อดีคือ run เป็น DaemonSet ดังนั้นแต่ละทีมที่ดูแล Kubernetes ติดตั้งให้ก็พอ

### Teller (Assess)
[Teller](https://tlr.dev/) เป็นเครื่องมือ command-line interface (CLI) ที่ใช้ดึง credentials จาก provider ต่าง ๆ เช่น AWS Secrets Manager, HashiCorp Vault, 1Password มาไว้ใน local environment แทนที่การ hard-code ไว้ใน configuration file ลดความเสี่ยงในการที่ credentials ถูกขโมยโดยตรงจาก source code นอกจากนั้นยังมี feature อื่น ๆ อย่างการ scan หา hard-code credentials, ขีดทับ credentials ไม่ให้เห็นผ่าน log, sync credentials ระหว่าง provider กันเอง

### Online services for formatting or parsing code (Hold)
การ format หรือ parse code เป็นงานทั่ว ๆ ไปของ Developer หลาย ๆ คน แต่หลายคนเช่นกันเลือกที่จะใช้เครื่องมือ online เช่น JSON/YAML formatter, Base64 encoder สิ่งที่เกิดขึ้นคือความเสี่ยงที่ข้อมูลที่เราเอาไปใส่นั้นมันมี credentials สำคัญ เครื่องมือ online เหล่านั้นสามารถเก็บไปเพื่อนำไปใช้ในทางที่ไม่ดีได้ ไม่ได้หมายความว่าเราใช้เครื่องมือไม่ได้นะ แต่ต้องระวังข้อมูลที่เราจะเอาไปใส่สักหน่อยก็ดี

## Languages and Frameworks

### io-ts (Adopt)
ในการพัฒนาบนภาษา TypeScript ในส่วนของการใช้งาน API นั้น การกำหนด type ที่จะรับ response มาจากอีกฝั่งในช่วง runtime นั้น มีความเสี่ยงที่อาจจะเกิด error ในกรณีที่ข้อมูลที่ส่งกลับมามี type ที่ไม่ส่งกับที่ระบุไว้ ดังนั้นเราควรจะรับมาใน type ที่เป็น unknown ก่อน จากนั้นค่อยใช้ [io-ts](https://gcanti.github.io/io-ts/) ในการตรวจสอบข้อมูลอีกที โดย io-ts จะให้เรากำหนดรูปแบบของข้อมูลที่ถูกต้อง และส่ง error เมื่อไม่ผ่านการตรวจสอบ

https://www.babelcoder.com/blog/articles/runtime-type-checking-in-typescript

### NestJS (Adopt)
[NestJS](https://nestjs.com/) เป็น Node.js framework สำหรับสร้าง backend application มีข้อดีึคือดูแลรักษาง่าย และง่ายขึ้นมากหากเคยเขียน TypeScript และ Angular มาก่อน

### React Query (Adopt)
ปัญหาของการพัฒนา frontend application ด้วย React สำหรับการ ดึงข้อมูล/cache เพื่อ update ข้อมูลจากฝั่ง server คือทำให้ถูกต้องได้ยาก ถึงแม้ว่าจะมี library อย่าง fetch, axios หรือ GraphQL แต่ก็ถูกพัฒนาด้วยแนวคิด Promise ทั้งหมด การมาของ [React Query](https://react-query-v3.tanstack.com/) ช่วยให้การพัฒนาง่ายขึ้นเนื่องจากใช้แนวคิดใหม่ของ React คือ Hook เพียงแค่ส่ง function ที่ใช้ในการ resolve data ลงไปแค่นั้น 

### Yjs (Adopt)
ปัจจุบันในการทำระบบที่ให้ผู้ใช้งานหลาย ๆ คนแก้ไขข้อมูลเดียวกันในเวลาเดียวกันอย่างเช่น Google Doc, Trello, Figma, Calendar หากเราพัฒนาระบบลักษณะนี้โดยอิงจาก CAP theorem จะพบว่า 

- **ถ้าเลือก consistency และ availability** จะต้องมี server กลางที่คอยประมวลผลว่าจะต้องรวมการแก้ไข ซึ่งมีผลทำให้ performance ของระบบช้าลง และผู้ใช้งานไม่สามารถแก้ข้อมูลได้ตอนที่ไม่ได้เชื่อมกับ server กลาง (partial tolerance) 
- **ถ้าเลือก availability และ partial tolerance** ผู้ใช้งานสามารถแก้ไขข้อมูลได้ถึงแม้ว่าจะไม่ได้เชื่อมต่อกับ server กลาง แต่ก็ต้องแลกกับข้อมูลที่มี conflict เมื่อผู้ใช้งานหลาย ๆ คนแก้ไขข้อมูลเดียวกัน ดังนั้นผู้ใช้คนนั้นต้องแก้ไข conflict ก่อนที่จะส่งข้อมูลให้กับผู้ใช้คนอื่น (consistency) จีงมีการคิด algorithm สำหรับการแก้ conflict เหล่านี้โดยมีชื่อว่า [Conflict-free Replicated Data Types (CRDTs)](https://crdt.tech/) ที่จะช่วยรวมข้อมูลให้โดยไม่มี conflict

[Yjs](https://yjs.dev/) เป็น framework ที่พัฒนาจาก CRDT algorithm รวมถึงใช้ความสามารถอื่น ๆ อย่างเช่น รองรับการแก้ไขข้อมูลผ่าน decentralised server อีกด้วย น่าจะทำให้การพัฒนาระบบลักษณะนี้มีค่าใช้จ่ายน้อยลงไปเยอะ

### Azure Bicep (Trial)
ปัญหาของการพัฒนา Infrastructure-as-a-Code สำหรับ Microsoft Azure ด้วย Azure Resource Manager (ARM) templates คือรูปแบบของ JSON ที่อ่านค่อนข้างยาก จีงมีเครื่องมืออย่าง [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) ที่มาในรูปแบบของ domain-specific language (DSL) ที่อ่านง่ายขึ้น

### Svelte (Trial)
[Svelte](https://svelte.dev/) เป็น framework สำหรับพัฒนา web application ในขณะที่ library/framework ตัวอื่น ๆ เช่น React จะนำ code ไปแปลงใน browser ตอน runtime อาจจะทำให้เกิด overhead ในการส่งข้อมูลกลับไปบน browser ตัว Svelte จะ compile code ก่อนแล้วก็นำไป update ให้ browser ใช้ต่อแทน ข้อดีคือ JavaScript file ที่ browser ใช้ก็มีขนาดน้อยลง และทำงานได้เร็วขึ้นด้วยการที่มันเป็น JavaScript แบบล้วน ๆ ในส่วนของเครื่องมือช่วยพัฒนา web application ก็สามารถดู [SvelteKit](https://kit.svelte.dev/) ได้

[แผนภาพอธิบายความแตกต่างระหว่าง Svelte กับ React จากบล็อก Bits and Pieces โดย Keshav Kumaresan]()

### Aleph.js และ Astro (Assess)
ยังคงมาอย่างต่อเนื่องสำหรับ JavaScript framework ใหม่ ๆ ในปีนี้มี 2 ตัวได้แก่

- [Aleph.js](https://alephjs.org/docs) สำหรับพัฒนา web application บน Deno ซึ่งเป็น server-side runtime ว่าที่ตัวที่จะมาแทน Node.js
- [Astro](https://astro.build/) สำหรับพัฒนาพวก static web เป็นหลัก โดยมีแนวคิดลดจำนวนของ JavaScript ที่ส่งให้ browser โดยไม่จำเป็นลง

### Synthetic Data Vault (Assess)
[Synthetic Data Vault (SDV)](https://sdv.dev/SDV/) เป็นเครื่องมือที่ช่วยสร้างข้อมูลที่ใช้สำหรับทดสอบที่มีความล้ายกับข้อมูลบน production จริง ๆ ทั้งในด้านความถูกต้องและ format รองรับในรูปแบบ table, relational และ time series

### Carbon (Hold)
จากการที่ Google ทำการแนะนำภาษา [Carbon](https://github.com/carbon-language/carbon-lang) ซึ่งเป็นอีกภาษาที่มีเป้าหมายเพื่อมาแทนที่ภาษา C++ จากการปรับปรุงปัญหาที่พบในภาษา C++ นั้น เพียงแต่ว่า Carbon ยังอยู่ในช่วงทดลองเท่านั้น ดังนั้นตอนนี้ถ้าอยากจะ migrate ระบบงานจาก C++ แนะนำว่าให้ลองดูภาษาอื่นอย่าง Rust หรือ Go แทนที่จะรอให้ Carbon เสร็จสมบูรณ์
