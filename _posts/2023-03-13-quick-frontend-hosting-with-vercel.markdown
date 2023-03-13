---
layout: post
title: "Host frontend แบบไว ๆ ด้วย Vercel"
date: 2023-03-12
tags: [vercel, platform, frontend]
---

วันก่อนมีโอกาสได้ไปงาน Bangkok Open Source Hackathon มา แล้วไปเข้า project ที่เขาต้องการคนมีทักษะด้าน frontend development ด้วยความที่เราไม่ได้ถนัดแต่อยากออกจาก comfort zone เลยลองทำดูก็ได้ ทีนี้พอพูดถึงเรื่อง hackathon เราก็จะเน้นการสร้างระบบด้วยความรวดเร็วไว้ก่อนอยู่แล้ว ความท้าทายคือเราจะนำ frontend application เราขึ้นอย่างรวดเร็วได้ยังไง เราเลยนึกถึง platform ที่ชื่อว่า [Vercel](https://vercel.com/)

## Vercel คืออะไร
Vercel เป็น platform สำหรับการ host website ซึ่งมีข้อดีคือ

- ความง่ายในการ configuration เพื่อนำ application ขึ้น โดยเฉพาะการเชื่อมกับ version control อย่าง [GitHub](https://github.com/) เพียงแต่ไม่กี่ click ก็เสร็จ สิ่งที่ได้คือเวลาเรา push code ขึ้น GitHub มันจะทำการ trigger การ deployment ใหม่ แล้วมี URL ของ Vercel ให้ด้วย นอกจากจะได้ feedback loop ที่สั้นแล้ว ยังลดการปวดหัวกับการ configuration (เช่น environment variables), ทำ [CI/CD pipeline](https://en.wikipedia.org/wiki/CI/CD), หา website hosting ไปได้เยอะ
- Vercel มี [Content Delivery Network (CDN)](https://en.wikipedia.org/wiki/Content_delivery_network) รองรับการ scale สำหรับ production ได้ในระดับนึงเลย
- รองรับ [integration](https://vercel.com/integrations) เยอะมาก เช่น ต่อ database, monitoring, logging, secret manager, security ซึ่งเรื่องเหล่านี้ก็จะสอดคล้องกับแนวคิดของ [JAMstack](https://jamstack.org/) ที่ต้องการจะแยก web layer (JavaScript, Markdown) ออกจาก business logic layer (API) เพื่อความง่ายต่อการดูแลรักษาและ scale
- รองรับ framework/library แบบ modern หลากหลายตัว เช่น [Next.js](https://nextjs.org/), [SvelteKit](https://kit.svelte.dev/), [Create React App](https://reactjs.org/docs/create-a-new-react-app.html), [Vite](https://vitejs.dev/)
- นอกจาก web application แล้ว ยังรองรับ [Serverless](https://en.wikipedia.org/wiki/Serverless_computing) และ [Edge](https://en.wikipedia.org/wiki/Edge_computing) computing, Cron Job ด้วย
- URL ที่ generate ออกมาเผื่อรองรับการทำงานตาม Git branch ด้วย ยกตัวอย่างเช่น
    
    ```
    https://<your-project>-git-<your-branch>-<your-project>.vercel.app
    ```

![Vercel](/assets/2023-03-13-vercel.avif)
<https://vercel.com/docs/concepts/deployments/git>

> เพิ่งจะรู้ว่าหลายคนเค้าใช้ Vercel กันนานแล้วก็ตอนไป Hackathon เนี่ยแหละ สงสัยเราต้องไปงานบ่อยขึ้น เผื่อได้เรียนรู้อะไรใหม่ ๆ
