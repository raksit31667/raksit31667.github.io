---
layout: post
title:  "เราจะวัด Productivity ของเหล่า Developer ได้อย่างไร"
date:   2024-01-17
tags: [developer-experience, productivity, metrics]
---

ในช่วงหลายปีที่ผ่านมาในวงการ software มีการพูดถึงเรื่อง [Developer Experience (DX)](https://developerexperience.io/articles/good-developer-experience) ขึ้นมาบ่อยมาก นั่นก็รวมถึง [drama ส่งท้ายปีเกี่ยวกับการวัด productivity จาก McKinsey](https://newsletter.pragmaticengineer.com/p/measuring-developer-productivity) ว่ามันไม่ได้มีสูตรตายตัวในการวัดด้วย effort และ output ที่ developer ทำเสมอไปนะ เพราะแต่ละองค์กรก็มีรูปแบบและบริบทที่ต่างกันไป คำถามถัดมาคือ **"ถ้างั้นแล้วแต่ละองค์กรเขาทำกันยังไง"**  

จากบทความ [Measuring Developer Productivity: Real-World Examples](https://newsletter.pragmaticengineer.com/p/measuring-developer-productivity-bae) เราจะเห็นว่าองค์กร software ชั้นแนวหน้าไล่ตั้งแต่ startup, mid-level ไปจนถึงเจ้าใหญ่ ๆ อย่าง Google, LinkedIn, Peloton (เรียงตามจำนวนพนักงาน) เขามีวิธีการวัด productivity อย่างไร แล้วแต่ละที่มีความเหมือนหรือต่างอย่างไร ไปดูกันหน่อย

![Developer productivity in tech companies](/assets/2024-01-17-developer-productivity-in-tech-companies.webp)

จากตารางนี้เราจะเห็นข้อสังเกตชัด ๆ เลยว่า

- ทุกองค์กรจะมีแผนกหรือทีมที่ focus ในเรื่องเหล่านี้โดยเฉพาะ!
- หลายองค์กรวัด Developer Experience ทั้งในเชิงคุณภาพและปริมาณ
- มีการใช้งานรูปแบบ metrics ที่เหมือนกัน เช่น Ease of Delivery (developer ต้องออกแรงในการส่งมอบชิ้นงานใหม่มากน้อยแค่ไหน) และ Focus time (developer มีเวลา focus กับงานตนเองมากน้อยแค่ไหน) และ Quality (change failure rate, จำนวน incident) นอกนั้นก็จะแตกต่างกันไป แต่ก็ยังคงมีการเลือก metrics ยอดนิยม อย่าง [DORA](https://dora.dev/) และ [SPACE](https://newsletter.pragmaticengineer.com/p/developer-productivity-a-new-framework) มาใช้**บ้างแต่ไม่ยกมาทั้งหมด**
- หลายองค์กรใช้ survey ในการวัด metrics ซึ่งก็จะทำทุก quarter แต่ก็มีบางที่อย่าง LinkedIn ที่ทำระบบ track แบบ real-time ขึ้นมาเลย
- หลายองค์กรมี metrics เฉพาะเป็นของตนเองด้วย เช่น
  - [Design docs](https://www.thoughtworks.com/en-th/radar/techniques/lightweight-approach-to-rfcs) generated per Engineer (Uber)
  - Experiment velocity ในแง่ของปริมาณและคุณภาพ (Etsy)
  - Developer Customer Satisfaction (CSAT) สำหรับให้คะแนน tools และ services ที่ developer ใช้ (Chime และ LinkedIn)

## แล้วจะเอามาปรับใช้ในองค์กรของเรายังไง
- วัด Developer Experience โดยเลือก metrics ทั้งในเชิงคุณภาพและปริมาณ
- เลือก metrics จากองค์กรที่มี culture ด้าน engineering คล้าย ๆ กับของเรา
- ถ้าในองค์กรเรามีทีมที่ดูเรื่องเหล่านี้โดยเฉพาะ ในส่วนของ development ให้ focus ที่ ease (ส่งมอบง่าย ออกแรงน้อย), quick (ส่งมอบเร็ว), quality (คุณภาพ) แล้วเลือก metrics ที่สะท้อนถึงสิ่งเหล่านั้น ในส่วนของ operation นั้นให้วัดที่ความพึงพอใจของ developer ต่อ tools, services, adoption rate, workflow เป็นต้น
- ถ้าเราเป็น leader (เช่น CTO, director) เราต้องทำให้เหล่า CEO และ leader ฝั่ง business มั่นใจว่าการลงทุนไปกับ engineering มันคุ้มค่านะ ซึ่งก็แบ่ง metrics เป็น 3 กลุ่มย่อย ๆ
  - Business impact
  - System performance
  - Engineering effectiveness (ก็จะคล้าย ๆ กับหัวข้อก่อนหน้า)

![Engineering metrics for leadership team](/assets/2024-01-17-engineering-metrics-for-leadership-team.webp)
