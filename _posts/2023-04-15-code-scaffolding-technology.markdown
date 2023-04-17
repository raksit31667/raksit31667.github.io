---
layout: post
title: "เราจะนำ technology อะไรมาใช้ในการทำ code scaffolding"
date: 2023-04-15
tags: [platform, code-scaffolding, tools]
---

> This article is also available in [English](https://medium.com/nontechcompany/the-laypersons-guide-to-code-scaffolding-750aa299e904) version.

ในการพัฒนา software ปัจจุบัน นักพัฒนาในหลายองค์กรยังคงค้นคว้าและตามหาวิธีการส่งมอบงานที่มีคุณค่าต่อลูกค้าให้รวดเร็วที่สุดโดยที่ไม่ต้องมาปวดหัวกับการลงมือสร้างชิ้นงานใหม่ขึ้นมาตั้งแต่ต้น ในขณะเดียวองค์กรก็มีโจทย์ยากในการรักษามาตรฐานของ engineering practice ให้ได้ มาดูกันว่าแนวคิดของ code scaffolding (code generation) ที่เกิดขึ้นในช่วงหลายปีที่ผ่านมาจะแก้ปัญหาได้กับกลุ่มคนทั้งคู่ได้อย่างไร แล้วเราจะนำ technology แบบไหนมาใช้กันดี

## ทำไมถึงต้องมี code scaffolding
ในการสร้างส่วนของ project ขึ้นมาใหม่ เช่น service ใหม่ หรือ application ใหม่มันไม่ได้มีเพียงแค่การเขียน code ไม่กี่บรรทัด แต่มันรวมถึง engineering practice ต่าง ๆ ที่ต้องคำนึงถึงและตกลงร่วมกันในทีม ซึ่งในปัจจุบันบาง library/framework ก็ได้ทำการสอดแทรกเอาไว้อยู่แล้ว เช่น

- รูปแบบและการตั้งค่าระดับของ logging เช่น info, debug, error, trace
- การจัดรูปแบบของการทดสอบต่าง ๆ เช่น unit, integration, end-to-end เป็นต้น
- การจัดรูปแบบโครงสร้างของ file, folder และ package
- การเชื่อมต่อกับ third party services ต่าง ๆ ที่หลาย ๆ service ใช้งานร่วมกัน
- เครื่องมือในการจัดการ coding standards, static code analysis, linting ต่าง ๆ
- การตั้งค่าและเชื่อมต่อกับ CI/CD pipeline
- การตั้งค่าด้าน security, monitoring และ tracing

นั่นแปลว่าเมื่อทุกครั้งที่มีการขึ้น project ใหม่ นักพัฒนาก็จะต้องตัดสินใจกับเรื่องต่าง ๆ เหล่านี้ในเชิงลึก และลงมือในการตั้งค่าสิ่งเหล่านี้ขึ้นมาใหม่ตั้งแต่ต้น ทั้งที่สิ่งเหล่านี้ไม่ได้ส่งผลโดยตรงกับคุณค่าของ business ที่ตามหาอยู่เลย น่าจะดีกว่าไหมหากเราทำให้ขั้นตอนเหล่านี้สั้นลง  

จากปัญหาข้างต้น หลายองค์กรจึงสร้าง platform ขึ้นมาเพื่อลดการปวดหัวจาก pain point ที่มีร่วมกันภายในทีม แต่ว่า platform นี้จะใหญ่ขึ้นในองค์กรที่มีความหลากหลายเพราะแต่ละทีมก็ย่อมมีความคิดเห็นที่ต่างกันไปในการกำหนดมาตรฐานที่สอดคล้องกับตนเอง จึงเป็นหน้าที่ขององค์กรที่จะต้องสอดแทรกมาตรฐานและกฎเกณฑ์เข้าไปผ่านวิธีต่าง ๆ  

หนึ่งในนั้นก็คือ code scaffolding ที่จะเตรียมสิ่งต่าง ๆ ตามข้างบนไว้ให้หมดแล้ว สิ่งที่นักพัฒนาต้องทำคือเพียงแค่เรียกใช้แล้วส่งข้อมูลเฉพาะลงไป เช่น ชื่อ service, third party services ที่จะต้องเชื่อมต่อ เป็นต้นก็จะได้ source code ที่มีข้อมูลครบ ที่เหลือก็แค่ลงมือพัฒนาตามความต้องการของ business ได้ทันที  

## มี Technology แบบไหนบ้าง
ในการเลือก technology ที่จะนำมาใช้ก็ขึ้นอยู่กับความเหมาะสมในแต่ละองค์กร เพราะไม่ใช่ทุกองค์กรจะต้องมี code scaffolding เสมอไป (เดี๋ยวจะขอขยายความทีหลัง) โดยจะเน้นที่ค่าใช้จ่ายในการดูแลรักษา ความสามารถในการต่อยอด ไปดูกันเลย

<https://en.wikipedia.org/wiki/Comparison_of_code_generation_tools>

### Template repository
มันคือการเตรียม source code แล้วเก็บไว้ใน repository ที่นักพัฒนาเข้าถึงได้ เวลาใช้งานก็เพียงแค่ clone หรือ fork repository ออกไปเป็นอันเสร็จ เวลาคนดูแล platform อยากจะ update template ก็แก้ code แล้วก็ push ขึ้นมาบน repository นี้เลย ซึ่งปัจจุบันนี้ ผู้ให้บริการ remote repository อย่าง GitHub หรือ GitLab ต่างก็มี feature ในการทำ template repository แล้ว นอกจากนี้เมื่อมีการ update ยังมีความสามารถในการ sync template repository กับ repository ที่เราสร้างไว้ก่อนหน้าได้ด้วย

### Sub-project ใน monorepo
Monorepo คือ repository ที่เก็บหลาย ๆ project อยู่ เหมาะสำหรับทีมพัฒนาจะดูแลหลาย project ที่มี code บางส่วน share ร่วมกันหรือมีการเรียกใช้ code บางส่วนข้าม project กัน แลกกับขนาดของ project ที่ใหญ่และความซับซ้อนในการจัดการ build, package, test และ deploy ดังนั้นเราสามารถประยุกต์ด้วยการเก็บ template ไว้เป็นหนึ่งใน project ได้ เวลาคนดูแล platform อยากจะ update template ก็แก้ code แล้วก็ push ขึ้นมาบน repository เลย

### Generator
คือการสร้าง application ขึ้นมาสำหรับทำ scaffolding โดยเฉพาะ โดยมากจะมาในรูปแบบ web application ไม่ก็ command-line interface (CLI) ในปัจจุบันเราสามารถใช้ generator จาก platform ตาม community ทั่วโลก หรือจะสร้าง generator ใช้เองได้จาก platform ตามความต้องการและความถนัดในภาษา programming ของเรา

#### Default CLI
ปัจจุบันนี้หลาย ๆ framework ก็ได้เตรียม CLI เอาไว้ให้ใช้ในการขึ้น project ใหม่กันอย่างรวดเร็วได้แล้วโดยไม่ต้องลงมือสร้าง generator เองเลย บางตัวมีจุดเด่นคือสามารถตาม upgrade ได้ด้วยการ run CLI เพียงคำสั่งเดียว ยกตัวอย่างก็จะมี

- [Create React App](https://create-react-app.dev/) สำหรับสร้าง application ที่พัฒนาด้วย React library
- [.NET default templates](https://learn.microsoft.com/en-us/dotnet/core/tools/custom-templates) สำหรับการสร้าง appliaction ที่พัฒนาด้วย .NET framework

#### Spring Initializr
[Spring Initializr](https://start.spring.io/) เป็น web application สำหรับ generate application ที่พัฒนาด้วย Spring Boot framework มีจุดเด่นที่เราสามารถ customise ได้เยอะมาก ๆ เช่น version, package manager, programming language, dependencies, metadata ต่าง ๆ เมื่อ generate แล้วเราจะได้ zip file ออกมา

#### Fresh App Factory
[Fresh App Factory](https://github.com/fresh-app/factory) เป็น web application สำหรับ generate application framework เจ้าดัง ๆ โดยมากก็จะเป็น frontend แบบ single-page application (SPA) แต่ก็มีพวก extension สำหรับ Visual Studio Code เหมือนกัน ด้วยความที่เบื้องหลังจะมี TypeScript CLI เพื่อ update template ที่ run ทุกวัน ทำให้เราได้ project ที่ update อยู่ตลอดอย่างมากก็คือทุกวัน และการเก็บ template repository ไว้ใน GitHub ทำให้เราสามารถใช้งาน template feature ผ่าน GitHub ได้ด้วย

#### Backstage
[Backstage](https://backstage.io/docs/features/software-templates/) เป็น developer portal platform ที่รวมการแก้ปัญหาที่ทั้งองค์กรปวดหัวร่วมกัน ได้แก่

- Lack of discoverability
- Slow to launch new service
- Disparate DevOps workflow

อ่านต่อเพิ่มเติมได้ที่ [Types of developer friction that developer portals solve](https://www.thoughtworks.com/insights/articles/friction-developer-portals-solve)

#### Yeoman
[Yeoman](https://yeoman.io/) เป็น CLI ที่เอาไว้สร้าง generator อีกที พัฒนาด้วยภาษา JavaScript โดยที่เราสามารถ [download generator](https://yeoman.io/generators/) จาก open-source community ที่มีอยู่แล้วลงมาได้ หรือจะ[สร้างเอง](https://yeoman.io/authoring/)ก็ได้เช่นเดียวกัน ตัวที่ได้รับความนิยมสูงสุดก็จะเป็น [JHipster](https://www.jhipster.tech/) ที่เป็น generator สำหรับ web application มีให้ทั้ง client และ server side เลย

#### Cruft
[Cruft](https://cruft.github.io/cruft/) เป็น CLI ที่เอาไว้สร้าง application รูปแบบไหนก็ได้ พัฒนาด้วยภาษา Python ผ่าน [Cookiecutter](https://pypi.org/project/cookiecutter/) มีจุดเด่นคือสามารถ sync กับ template repository ได้โดยไม่ต้องทำผ่าน GitHub หรือ GitLab เลย นอกจากนั้นเรายังสามารถเลือกว่าจะรับ update ส่วนไหนมาก็ได้ด้วย

## หลักการในการพัฒนา code scaffolding
สิ่งที่สำคัญกว่าการเลือก technology คือเราจะพัฒนาอย่างไรให้มีคนใช้งานและเติบโตไปกับองค์กรให้ระยะยาว

### Do you even need code scaffolding?
อย่างที่เกริ่นไปก่อนหน้านี้ว่าไม่ใช่ทุกองค์กรจะต้องมี code scaffolding เสมอไป องค์กรที่เหมาะสมจะต้องดูจากปัจจัยต่อไปนี้

- จำนวนของ product และทีมมีเยอะขึ้นเป็นจำนวนมาก เริ่มไม่สัมพันธ์กับโครงสร้างขององค์กรและ culture ที่เป็นอยู่
- ทีมเริ่มที่จะต้องมาทำงานเดิมที่ไม่ได้เกี่ยวข้องตรง ๆ กับ business ซ้ำ ๆ คล้าย ๆ กัน
- ทีมใช้เวลาในการส่งมอบคุณค่าให้ business จากการสร้าง service ใหม่ ๆ ได้ช้าลงเพราะต้องพึ่งทีมอื่น ๆ
- องค์กรมีความต้องการที่จะกำหนด cross-functional requirement เช่น security, privacy, reliability ให้บังคับใช้ทั้งองค์กร
- ทีมเริ่มนำเครื่องมือและ technology ใหม่ ๆ มาใช้งานได้ยากขึ้นถึงแม้จะรู้ว่ามันดีกว่าของเก่า

ในทางกลับกันองค์กรที่มีลักษณะต่อไปนี้ยังไม่ควรนำ code scaffolding มาใช้งาน

- องค์กรที่มีจำนวนของ product น้อย และทีมเล็ก
- องค์กรมีการใช้งาน technology ที่หลากหลายยิบย่อยมาก
- องค์กรอยู่ในช่วงของการทดลองหรือค้นหาอะไรใหม่ ๆ ยังไม่เป็นรูปเป็นร่าง

นอกจากจะให้คุณค่าของ platform น้อยลงแล้วยังเสียแรงเสียเวลาสร้าง platform อีกด้วย

### Consumer-first
Code scaffolding ที่พัฒนาออกมาควรจะทำโดยคำนึงถึงผู้ใช้งานเป็นหลักเพื่อให้เป็นตัวเลือกที่ดีที่สุดและง่ายที่สุดสำหรับพวกเค้าที่จะขึ้น project ใหม่โดยไม่ต้องไปบังคับขู่เข็ญให้มาใช้ เช่น

- ผู้ใช้งานสามารถนำ code ที่ได้จาก code scaffolding ไปพัฒนาต่อได้โดยที่ไม่ต้องมา configure อะไรเพิ่มอีก
- ผู้ใช้งานไม่ต้องมาขอ approval อะไรมากมายก่อนการใช้งาน code scaffolding
- ผู้ใช้งานสามารถ upgrade code ในกรณีที่ template มีการ upgrade ได้ไม่ยากจนเกินไป

### Convention over configuration
การที่ code scaffolding ให้ผู้ใช้งาน configure ได้หลากหลายมากจนเกินไป แน่นอนย่อมส่งผลดีต่อผู้ใช้งานแต่ค่าใช้จ่ายในการดูแลรักษาก็จะเพิ่มขึ้น ทั้ง ๆ ที่บาง configuration ไม่จำเป็นเพราะอาจจะถูกใช้งานแค่ project เดียวก็ได้ สิ่งที่เราควรจะเน้นคือเน้นไปที่การเอื้อให้องค์กรเกิดมาตรฐานในการพัฒนาโดยที่ยังสอดแทรก engineering practice ที่ดีเข้าไปได้เพื่อคงคุณภาพในการส่งมอบงานได้มากกว่า

### Provide paved road
ถึงแม้ว่า code scaffolding จะมอบเส้นทางที่ง่ายที่สุดในการรักษามาตรฐานต่าง ๆ แต่ก็ไม่ควรจะไปห้ามให้ผู้ใช้งานได้ปรับแก้ไขตาม use case ให้เหมาะสมกับพวกเค้าได้ถ้ามันจำเป็น เพียงแต่ผู้ใช้งานจะต้องระลึกไว้ว่าหาก use case เหล่านั้นไปทับกับสิ่งที่ code scaffolding ได้ให้ไว้แล้ว พวกเค้าจะต้องแบกรับความเสี่ยงและออกแรงลงมือทำให้ใช้งานให้ได้ด้วยตัวเอง
