---
layout: post
title: "สวัสดี Fern สำหรับสร้าง API documentation และ SDK"
date: 2024-03-27
tags: [fern, api, tools]
---

ในการพัฒนา API ในปัจจุบัน การมี documentation ที่ดีจะช่วยให้ user เข้ามาใช้งาน API ได้สะดวกขึ้น เนื่องจาก user สามารถ explore API specfication ดูได้ว่า

- API มี endpoint อะไรบ้าง
- API มีหน้าตา request-response เป็นอย่างไร
- Authentication ที่ต้องใช้คืออะไร มีวิธีการไปเอา API key/credentials มาได้อย่างไร

แต่ว่าปัญหาต่อมาในการมี API documentation คือ

1. API specification ไม่มี standard ณ ตอนนี้ก็มีแล้วคือ [OpenAPI](https://www.openapis.org/)
2. ทำยังไงให้ documentation มัน up-to-date เทียบเท่ากับ API จริงอยู่ตลอด ซึ่งก็มีเครื่องมือที่แก้ปัญหาจุดนี้โดยจะ generate API specification file จาก code ที่มี comment หรือ annotations กำกับ เช่น [Swagger codegen](https://github.com/swagger-api/swagger-codegen), [Springdoc สำหรับ Spring Boot](https://springdoc.org/), [Scribe สำหรับ Laravel framework](https://scribe.knuckles.wtf/laravel/getting-started)
3. User ก็ยังคงต้องออกแรงและเวลาในการพัฒนา logic เชื่อมกับ API อยู่ ซึ่งปัจจุบันทีมพัฒนา API ก็ลงมือทำ SDK ออกมาเพื่อให้ user นำไปใช้ต่อโดยประหยัดแรงพัฒนาไปได้บ้าง แต่สิ่งที่ต้องแลกมาคือทีมที่พัฒนาดูแล API ก็ต้องออกแรงและเวลาในการสร้างและ publish SDK ออกมาเช่นเดียวกัน

จากปัญหาอย่างหลังทำให้เกิด [Fern](https://www.buildwithfern.com/) ขึ้นมาเพื่อรวมการสร้าง API documentation และ SDK เข้าไว้ในที่เดียวกัน

## มารู้จัก Fern กันหน่อย
Fern เป็นเครื่องมือในการสร้าง API documentation, SDK และ Server boilerplate framework จาก specification โดยจุดมุ่งหมายคือเน้นให้ทีมพัฒนา focus กับการออกแบบ API schema ก่อนที่จะเริ่มพัฒนา API (Schema-first API design) ซึ่งมีข้อดีคือ

- เป็นกุศโลบายเพื่อให้ทีมพัฒนาส่วน frontend และ backend มาออกแบบร่วมกัน ลดความเสี่ยงที่จะเกิดปัญหาหลังจากการพัฒนาไปแล้ว
- OpenAPI specification จะถูก update ก่อน API code อยู่ตลอด

โดยการทำงานของ Fern คร่าว ๆ มีดังนี้

![Fern overview](/assets/2024-03-27-fern-overview.png)
<https://docs.buildwithfern.com/overview/welcome/introduction>

1. ออกแบบและเขียน Fern หรือ OpenAPI specification (แนะนำเป็นอย่างหลัง)
2. Configure ว่าจะให้ Fern generate อะไรบ้าง 
   - **API documentation** ที่ค่าตั้งต้นจะถูก publish ไปที่ <your-github-username.buildwithfern.com> และต้องมี GitHub account ก่อนด้วย
   - **SDK** ซึ่ง ณ ตอนที่เขียนบทความจะรองรับภาษา TypeScript, Python, Java, Go
   - **Server boilerplate framework** ซึ่งก็คือส่วนของ code ที่เอาไว้เชื่อมกับ API ณ ตอนที่เขียนบทความจะรองรับ Express.js, FastAPI, Spring
3. Run คำสั่งให้ Fern ไป generate ของผ่าน server (local หรือ remote ก็ได้)
4. Fern publish documentation, SDK, และหรือ Server boilerplate framework ตาม configuration ที่ตั้งไว้ ซึ่งทุกอย่างจะถูกรวมไว้ใน documentation เดียวไม่ต้องกระโดดไปดูจาก source อื่น ๆ อีก

## มาลองใช้งานกันหน่อย
เริ่มจากการติดตั้ง Fern ก่อน (ข้อกำหนดคือต้องมี Node.js version 18 ขึ้นไป)

```shell
$ npm install -g fern-api
```

จากนั้นให้เราไปที่ [Fern Docs Quickstart](https://github.com/fern-api/docs-starter-openapi/) แล้ว clone ลงมา จะได้หน้าตา structure ประมาณนี้

```shell
$ tree fern

fern
├── docs
│   ├── assets
│   │   ├── favicon.png
│   │   ├── fern.png
│   │   ├── logo-dark-mode.png
│   │   └── logo-light-mode.png
│   └── pages
│       ├── concepts.mdx
│       ├── sdks.mdx
│       └── welcome.mdx
├── docs.yml
├── fern.config.json
├── generators.yml
└── openapi
    └── openapi.yml
```

เราก็จะได้ repository ที่ประกอบไปด้วย API specification และ configuration โดยที่ `docs.yml` จะเป็น configuration สำหรับ API ละ `generators.yml` สำหรับ SDK

ทีนี้ให้เราลบ `openapi` directory ออกแล้ว run คำสั่งเพื่อ initialize Fern ขึ้นมาใหม่ด้วย OpenAPI specification ของเรา ในตัวอย่างนี้เราจะใช้ของที่มีอยู่แล้วอย่าง [Petstore](https://petstore3.swagger.io/api/v3/openapi.json) เป็นตัวตั้ง

```shell
$ fern init --openapi https://petstore3.swagger.io/api/v3/openapi.json
Created new API: ./fern

$ tree fern

fern
├── docs
│   ├── assets
│   │   ├── favicon.png
│   │   ├── fern.png
│   │   ├── logo-dark-mode.png
│   │   └── logo-light-mode.png
│   └── pages
│       ├── concepts.mdx
│       ├── sdks.mdx
│       └── welcome.mdx
├── docs.yml
├── fern.config.json
├── generators.yml
└── openapi
    └── openapi.yml
```

สังเกตว่าใน file `generators.yml` เราสามารถที่จะกำหนด [generator ที่ต้องการได้](https://docs.buildwithfern.com/overview/welcome/generators) ซึ่งเริ่มต้นจะมีให้เป็น TypeScript Node.js SDK ซึ่งจะถูก generate ไว้ที่ path `../generated/sdks/typescript`

```yaml
default-group: local
groups:
  local:
    generators:
      - name: fernapi/fern-typescript-node-sdk
        version: 0.9.5
        output:
          location: local-file-system
          path: ../generated/sdks/typescript
```

แต่ถ้าอยากจะให้ publish ไปที่ registry หรือ repository ก็สามารถ configure ได้ประมาณนี้

```yaml
default-group: local
groups:
  local:
    generators:
     - name: fernapi/fern-typescript-node-sdk
       version: 0.9.5
       output:
          location: npm
          token: ${NPM_TOKEN}
          package-name: your-organization
    - name: fernapi/fern-go-sdk
        version: 0.12.0
        github:
          repository: your-organization/your-repository
```

จากนั้่นให้เราตั้ง credentials และหรือ repository ตามที่เรากำหนดไว้ ในส่วนของ repository เราต้องติดตั้ง [Fern API ใน GitHub App เพิ่ม](https://github.com/apps/fern-api) ซึ่งเป็น bots ที่จะ update SDK เมื่อมีการ run คำสั่ง generate ใหม่ให้เราโดยอัตโนมัติ

ในส่วนของ API documentation ให้เราเข้าไป configure ใน `docs.yml` โดยเปลี่ยน instance URL ให้เป็น GitHub username ของเรา

```yml
instances:
  - url: your-organization.docs.buildwithfern.com
```

นอกจากนั้นก็จะมี `docs` directory มาซึ่งประกอบไปด้วย `assets` และ `pages` ที่เราสามารถเข้าไป[ปรับและตกแต่งได้ตามชอบ](https://docs.buildwithfern.com/generate-docs/overview/writing-content)  

หลังจาก configure แล้วให้เรา run คำสั่งเพื่อ generate SDK และ publish API documentation

```shell
$ fern generate # generate SDKs

$ fern generate --docs # publish docs
```

ทีนี้พอเราเข้าไปดูว่า SDK ถูก generate ไว้แล้วไหมก็เป็นอันเสร็จละ ซึ่งของที่ generate มาก็ให้เยอะพอสมควรรวมถึง unit test ในตัวด้วย แจ่มเลย (ลองเข้าไปดูตัวอย่างที่ <https://github.com/raksit31667/fern-go-sdk>)  

ในส่วนของ API documentation ให้เข้าไปดูที่ <https://your-organization.docs.buildwithfern.com> ที่เราเคย configure ไว้ (ลองดูตัวอย่างที่ <https://raksit31667.docs.buildwithfern.com/> ได้เหมือนกันฮะ)

![Fern Petstore docs](/assets/2024-03-27-fern-petstore-docs.png)

## มาดูข้อจำกัดกันบ้าง
จากจุดเด่นที่ได้เกริ่นไปก่อนหน้านี้ พอลองใช้งานดูสักพักก็พบว่ามันมีข้อจำกัดเยอะพอสมควรเลยนะ อาทิเช่น

- จะสังเกตว่า API docs URL จะเป็น <https://your-organization.docs.buildwithfern.com> ถ้าเราอยากได้ custom domain แบบ <https://api.your-organization.com> [จะต้องจ่ายเงินเพื่อซื้อ plan ของเขา](https://docs.buildwithfern.com/generate-docs/configurations/custom-domain)
- CLI `generate` มี feature ให้ run ตัว generator บน Docker container แต่ใช้ได้เฉพาะ Docker Desktop เท่านั้น
- CLI `generate` มีบัคเยอะ บางที run ได้ error message แบบทำอะไรต่อไม่ได้ ต้องไปเปิด debug mode ผ่าน `--log-level debug` เอง
- SDK และ Server boilerplate framework บางภาษามีใน official documentation แต่ติด coming soon 😅

> ไปลองใช้งานกันดูครับ คิดว่าน่าจะช่วยทำให้ user ใช้งาน API ได้ไหลลื่นมากขึ้นเยอะเลย
