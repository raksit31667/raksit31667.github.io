---
layout: post
title: "ว่าด้วยเรื่องของ Platform Engineering Maturity Model"
date: 2025-03-25
tags: [platform, practice]
---

[CNCF (Cloud Native Computing Foundation)](https://www.cncf.io/) ได้ publish [Platform Engineering Maturity Model](https://tag-app-delivery.cncf.io/whitepapers/platform-eng-maturity-model/) เพื่อช่วยให้องค์กรสามารถวัดระดับความก้าวหน้าของ [platform](https://tag-app-delivery.cncf.io/whitepapers/platforms/) โดยแนวคิดนี้ช่วยให้ทีมงานสามารถพัฒนา platform ให้ตอบโจทย์ทั้งฝั่ง **Developers** และฝั่ง **Operations** ได้อย่างสมบูรณ์แบบ เราจะพาไปดูว่า Platform Engineering Maturity Model ของ CNCF มีอะไรบ้าง และองค์กรสามารถนำไปใช้ให้เกิดประโยชน์ได้อย่างไร

## ทำไมต้องมี Maturity Model
ในโลกของการพัฒนา platform หลาย ๆ องค์กรมักเจอปัญหา เช่น
- ระบบงานเริ่มซับซ้อนขึ้นเรื่อย ๆ โดยเฉพาะในฝั่ง infrastructure, CI/CD, compliance และ securtiy ต้องใช้เครื่องมือหลายตัว ทำให้เกิดความสับสน
- Developer ต้องเสียเวลาไปกับงานที่ไม่เกี่ยวกับการ deliver business value เช่น การจัดการ CI/CD, การตั้งค่า Kubernetes, หรือการดูแล infrastructure
- ระบบปัจจุบันไม่รองรับการขยายตัวขององค์กรทั้งด้านคน, process, และ technology

**Platform Engineering Maturity Model** ถูกออกแบบมาเพื่อช่วยให้ทีมสามารถประเมินว่าตัวเองอยู่ในระดับไหน อะไรคือสัญญาณที่ทำให้องค์กรต้องเปลี่ยนแปลงเพื่อตอบโจทย์ business และต้องทำอย่างไรเพื่อให้ platform ของตัวเองเติบโตไปสู่ระดับที่เหมาะสม

## โครงสร้างของ CNCF Platform Engineering Maturity Model
**Platform Engineering Maturity Model** นี้ถูกวัดผ่าน **5 มุมมอง (Aspects)** ได้แก่

1. **Investment** – การลงทุนด้าน platform ทั้งด้านงบประมาณ ทรัพยากร และบุคลากร
2. **Adoption** – การนำ platform ไปใช้จริงในองค์กรและการปรับปรุงตาม feedback ที่ได้รับจาก user
3. **Interfaces** – ความสามารถในการเชื่อมต่อและการใช้งานของ platform
4. **Operations** – การดูแลรักษาและปรับปรุง platform ให้รองรับ workload ได้อย่างมีประสิทธิภาพ
5. **Measurement** – การวัดผลและประเมินความสำเร็จของ platform

| **Aspect**     |                                                                                       | **Provisional (เริ่มต้น)** | **Operational (ใช้งานได้จริง)** | **Scalable (ขยายขนาดได้)** | **Optimizing (ปรับแต่งและพัฒนา)** |
|---------------|--------------------------------------------------------------------------------------|----------------------------|---------------------------------|----------------------------|----------------------------------|
| **Investment** (การลงทุน)  | วิธีจัดสรรบุคลากรและงบประมาณสำหรับ platform | ใช้แรงจูงใจหรือชั่วคราว | มีทีมเฉพาะทาง | พัฒนาเป็น Product | สนับสนุนให้เกิด Ecosystem |
| **Adoption** (การนำไปใช้จริง)  | ผู้ใช้ค้นพบและใช้งาน platform ได้อย่างไร | ไม่แน่นอน | ถูกผลักดันจากปัจจัยภายนอก | ถูกดึงดูดด้วยคุณค่าจากตัว platform เอง | การมีส่วนร่วมจากทุกฝ่าย |
| **Interfaces** (การเชื่อมต่อและการใช้งาน)  | ผู้ใช้โต้ตอบและใช้งาน platform อย่างไร | Custom | มีเครื่องมือมาตรฐาน | ใช้งานแบบ self-service | เชื่อมต่อกันได้อย่างสมบูรณ์ |
| **Operations** (การดูแลและจัดการระบบ)  | วิธีวางแผน พัฒนา และดูแลรักษา platform | ทำตามคำขอ | มีระบบติดตามจากศูนย์กลาง | มีการเปิดใช้งานจากศูนย์กลาง | ใช้แนวทาง Managed Services |
| **Measurement** (การวัดผลและประเมินความสำเร็จ)  | กระบวนการเก็บ feedback และนำมาปรับปรุง platform | ไม่มีรูปแบบชัดเจน | เก็บข้อมูลอย่างต่อเนื่อง | วิเคราะห์ข้อมูลเชิงลึก | ใช้ข้อมูลเชิงปริมาณและคุณภาพร่วมกัน |

## ขยายความแต่ละ Aspect ของ Model

### 1. Investment (การลงทุน)
- ต้องมีการจัดสรรงบประมาณและบุคลากรที่เพียงพอสำหรับการพัฒนา platform
- เริ่มจากการลงทุนด้านเครื่องมือ open-source และค่อย ๆ ขยับไปสู่การพัฒนา platform ภายในองค์กร
- ระดับสูงสุดของ maturity คือมีทีม platform engineering เฉพาะทาง พร้อมงบประมาณที่แน่นอนและการสนับสนุนจากผู้บริหาร

### 2. Adoption (การนำไปใช้จริง)
- ทีมพัฒนาจะต้องมีการนำ platform ไปใช้ และให้ฟีดแบคเพื่อการปรับปรุง
- องค์กรที่อยู่ในระดับสูงของ maturity จะมีการสนับสนุนการเปลี่ยนแปลง culture การทำงาน เช่น DevOps และ GitOps
- มีการพัฒนา platform ให้เป็น **self-service** และลดความซับซ้อนในการใช้งาน

### 3. Interfaces (การเชื่อมต่อและการใช้งาน)
- Platform ต้องมี API, CLI หรือ UI ที่สามารถใช้งานได้ง่าย
- มีการกำหนดมาตรฐานในการเข้าถึง resource เช่น [Role-Based Access Control (RBAC)](https://en.wikipedia.org/wiki/Role-based_access_control)
- ระดับสูงสุดของ maturity คือมี [Unified Developer Portal](https://www.cncf.io/blog/2024/09/30/a-conversation-about-the-future-of-internal-developer-portals-idps/) ที่ developer สามารถใช้งานได้ง่ายและเป็นศูนย์กลางของการเข้าถึง capabilities ของ platform ทั้งหมด

### 4. Operations (การดูแลและจัดการระบบ)
- Platform ต้องสามารถรองรับการปรับขนาด (Scalability) และมีระบบ Monitoring & Observability ที่ดี
- ใช้ **Policy as Code** และ **Automated Remediation** เพื่อลดภาระของทีมปฏิบัติการ
- ระดับสูงสุดของ Maturity คือการใช้ AI/ML ช่วยปรับแต่งและบริหารทรัพยากรโดยอัตโนมัติ

### 5. Measurement (การวัดผลและประเมินความสำเร็จ)
- ต้องมีการกำหนด KPI ที่ชัดเจน เช่น Mean Time to Recovery (MTTR), Deployment Frequency และ Developer Satisfaction
- องค์กรที่อยู่ในระดับสูงของ maturity จะใช้ [FinOps](https://www.finops.org/introduction/what-is-finops/) และการตัดสินใจที่จะปรับปรุงพัฒนา platform ด้วยข้อมูล
- ใช้การวิเคราะห์เชิงลึกเพื่อตรวจสอบ Developer Experience และเพิ่มประสิทธิภาพของ platform อย่างต่อเนื่อง

## ข้อควรระวัง
- **ทุกองค์กรไม่จำเป็นต้องไปถึง maturity ระดับสูงสุด**เพราะการไปถึงตรงนั้น องค์กรจะต้องลงทุนลงแรงสูงมาก ๆ ซึ่งอาจจะไม่คุ้มกับความต้องการ business นั่นเอง
- Model นี้ไม่ใช่เครื่องมือสำหรับเทียบองค์กรตัวเองกับองค์กรอื่น ๆ เพราะบริบทและปัญหาของแต่ละองค์กรไม่เหมือนกัน

## สรุป
**CNCF Platform Engineering Maturity Model** เป็นแนวทางที่ช่วยให้องค์กรเข้าใจว่าตัวเองอยู่ในระดับไหน และต้องทำอะไรบ้างเพื่อพัฒนา platform ให้ดีขึ้น

จะสังเกตว่า model นี้ไม่ได้เน้นแค่ technology เพราะการแก้ปัญหาด้าน platform เป็น *socio-technical problem* ที่ต้องครอบคลุมถึงการบริหารจัดการคน วัฒนธรรมองค์กร และกระบวนการทำงานด้วย
