---
layout: post
title: "บันทึกสิ่งที่น่าสนใจจาก PyCon Thailand 2023"
date: 2023-12-19
tags: [conference, python]
---

![PyCon Thailand 2023](/assets/2023-12-19-pycon-thailand-2023.jpeg)

ปิดท้ายปีนี้ด้วยการไปเข้าร่วมงาน [PyCon Thailand 2023](https://th.pycon.org/) โดยเนื้อหาส่วนมากก็จะเกี่ยวกับเรื่อง data science ครึ่งนึง ละก็จิปาถะอีกครึ่งนึง เหมือนเดิมคือเราก็มีสรุป session ที่น่าสนใจติดไม้ติดมือมาด้วย ไปดูกัน

## When Python Meets Excel for Real
ตอนได้ยินว่าเรา[สามารถ run Python บน Excel ได้แล้ว](https://support.microsoft.com/en-us/office/get-started-with-python-in-excel-a33fbcbe-065b-41d3-82cf-23d05397f53d)ก็ได้แต่คิดว่า "กูจะตกงานแล้วใช่ไหมวะ" ฮ่า ๆๆ คือเพราะว่าหลาย ๆ องค์กรมักจะใช้ Excel เป็นทุกสิ่งทุกอย่างตั้งแต่สากกะเบือยันเรือรบ แต่ไม่ได้แค่ run script ธรรมดาแต่ยังสามารถ

- ทำงานร่วมกัน Power Query ได้
- รองรับ library ยอดนิยมได้
- รองรับ API request ด้วย webservice ได้

แต่ก็ยังมีข้อจำกัดบางอย่างที่ทำให้เรายังคงมีงานทำอยู่ (ณ ตอนนี้) เช่น
- Python script จะ run จากซ้ายไปขวา แล้วบนลงล่างเสมอ ซึ่งก็จะต้องปรับ Excel sheet ให้ตรงกับ format นี้
- ไม่ฟรี!
- ความจุได้แค่ 100MB ซึ่งไม่เหมาะกับงาน data science ระดับ scale ใหญ่ขึ้นมา
- เวลา run ทีนึงก็จะไปทั้ง sheet ซึ่งม๊โอกาสสูงที่เครื่องจะค้างได้ 

## Kick Start Football Analytics Journey in Python
การใช้ football analytics มาช่วยให้เราดูฟุตบอลในมุมมองที่แตกต่างออก ทั้งจากมุมของแทคติก, วิทยาศาสตร์การกีฬา และไปจนถึงมุมมองของธุรกิจฟุตบอล และผู้พูดตั้งใจให้ session นี้เป็นจุดเริ่มต้นในการสร้าง community ด้าน football analytics ซึ่งจุดเริ่มต้นคือปี 2008 ที่ดูข้อมูลได้แค่ shot/goal conversion จนถึงปัจจุบันปี 2023 ที่มี data, hardwares, tools, services, communities มากมาย เช่น

- [TacticAI](https://www.blockdit.com/posts/5e2fe527d596f50cadc78636)
- [Footbonaut](https://www.bundesliga.com/en/news/Bundesliga/borussia-dortmund-and-hoffenheim-use-footbonaut-to-hone-their-passing-skills-464313.jsp)
- [FBRef.com](https://fbref.com/en/)

## Crafting the Cloud in Pythonic Way: AWS CDK & Pulumi Unveiled
Session นี้ก็เป็นการเปรียบเทียบการ provision resource บน AWS cloud ด้วยวิธีต่าง ๆ ซึ่งก็มีข้อดี-เสียต่างกันไป
- **Web console**: มีจุดเด่นคือง่าย มี user experience ดีที่สุด แต่ก็แลกมากับงานอัตโนมือ โอกาสพลาดสูงสุด และ reuse ไม่ได้
- **[AWS CLI ด้วย boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)**: -> จุดเด่นคือเป็นอัตโนมัติลดแรงคน เขียน script ที่มี loops, conditionals ง่าย แต่ก็แลกมากับความซับซ้อนในการทำ error handling
- **[CloudFormation](https://aws.amazon.com/cloudformation/)**: -> แก้จุดอ่อนในการทำ error handling แต่ก็แลกมากับความซับซ้อนในการเขียน loops, conditionals เพราะมันเป็น YAML, JSON
- **[Terraform](https://www.terraform.io/)**: -> จุดเด่นคือมี state management ที่ดี, ใช้ได้กับ provider อื่น ๆ นอกจาก AWS, เขียน loops, conditionals ได้ แต่ก็แลกมากับ learning curve ในการเรียน ecosystem รวมถึง syntax และ plugins เพิ่ม
- **[Pulumi](https://www.pulumi.com/)**: -> มาแก้จุดอ่อนของ learning curve เพราะสามารถใช้ programming language เช่น Python ได้เลย แต่ก็แลกมากับข้อจำกัดที่บาง abstraction ก็ใช้ไม่ได้ ลงเอยด้วยการเขียน CloudFormation อยู่ดี
- **[AWS Cloud Development Kit (CDK)](https://aws.amazon.com/cdk/)**: -> แก้จุดอ่อนเรื่อง abstraction โดย AWS ลงมือทำ abstraction เองซะเลย ผลคือมันครอบคลุมมากกว่า Pulumi เยอะ แต่ก็แลกมากับข้อจำกัดที่มันใช้ได้กับแค่ AWS เท่านั้น

## Architecting Scalable Python micro-services with GraphQL: Valuable Lessons and Best Practices
ผู้พูดเล่าถึงปัญหาในการพัฒนา API ว่าเมื่อมีหลายทีมเข้ามาทำงานกันบน code ชุดเดียวกัน ต่างคนต่างก็มี requirement ใน API ที่ต่างกัน ซึ่งวิธีแก้ปัญหาถ้าไม่อยากกำหนด architecture แบบ REST ก็จะเป็น GraphQL ซึ่งก็คือ query language สำหรับ API

![GraphQL vs REST Burger](/assets/2023-12-19-graphql-rest-burger.jpeg)
<https://apievangelist.com/2018/06/29/rest-api-and-graphql-burger-king/>

ซึ่งใน Python ก็มีเครื่องมือในการพัฒนาระบบด้วย GraphQL แบ่งเป็น 2 แบบคือ code-first ซึ่งก็คือเริ่มจากการเขียน code (resolver function) เพื่อกำหนด schema ในขณะที่ schema-first จะใช้ [Schema Definition Language (SDL)](https://www.howtographql.com/basics/2-core-concepts/) ซึ่งก็เป็น trade-off กันระหว่าง maintainability (code-first) กับ evolvability (schema-first)

- **Code-frst**: [Graphene](https://graphene-python.org/), [Strawberry](https://strawberry.rocks/)
- **Schema-first**: [Ariadne](https://ariadnegraphql.org/), [Tartiflette](https://tartiflette.io/), [Pydantic](https://docs.pydantic.dev/latest/)
- **Caching**: [Stellate](https://stellate.co/)
- **Visualisation**: [GraphQL Voyager](https://graphql-kit.com/graphql-voyager/), [Apollo](https://www.apollographql.com/)

ปัญหาต่อมาคือการทำ aggregation บน GraphQL API หลาย ๆ อันจะซับซ้อนมาก ก็สามารถแก้ปัญหาด้่วยการใช้ [GraphQL Federation](https://www.apollographql.com/docs/federation/)   

นอกจากนี้ก็ยังมี concept ที่น่าไป explore เพิ่มอย่าง batching, dataloaders, directives, file uploads, east-west service inter communication 

## Design Systems, React and a WYSIWYG Python Headless CMS: Adventures Building Government websites

> CMS = UI for non-tech people to write content for websites

Session นี้ก็มาเปรียบเทียบ CMS หลาย ๆ เจ้าบน quadrant ใน 2 มิติ ได้แก่

- User experience ที่ใช้ในระดับทั้งองค์กร
- Developer experience ที่สามารถ customise ด้วย HTML ได้

![CMS quadrant](/assets/2023-12-19-cms-quadrant.jpeg)

## Hacking with Words: Exploiting Vulnerabilities in LLMs
Session นี้จะพูดถึงตัวอย่างของ [OWASP Top 10 สำหรับ Large-language models (LLM)](https://owasp.org/www-project-top-10-for-large-language-model-applications/) รวมถึงการยกตัวอย่างกรณีศึกษาที่นา่สนใจในการเปิดช่องโหว่ด้วย prompt
เพราะว่าระบบเหล่านี้ไม่เข้าใจเจตนาของ user

![Prompt engineering 1](/assets/2023-12-19-prompt-engineering-1.png)
![Prompt engineering 2](/assets/2023-12-19-prompt-engineering-2.png)

แต่ทั้งนี้ทั้งนั้นมันก็มีวิธีป้องกัน เช่น ลด attacking surface, ทำให้ user input ไม่เป็นคำสั่งสุดท้าย, content filtering, regex, Guard LLM เป็นต้น  

ใครอยากลองฝึกเจาะระบบด้วย prompt ก็มีเกมให้ลองไปเล่นกันได้ <https://gandalf.lakera.ai>

## Functional programming in Python

> Function composition is solid foundation of functional programming. In order to do that ideally, methods should be unary (1 argument), but it's not possible without currying

Session สุดท้ายที่ได้เข้า (เพราะไม่ได้ไปวันที่ 2) ก็จะเป้นการลองเขียน Python ด้วย [functional programming](https://naveenkumarmuguda.medium.com/railway-oriented-programming-a-powerful-functional-programming-pattern-ab454e467f31) ก็จะมีการปูฐานมาตั้งแต่ currying, high-order function, function composition ไปจนถึง Monad เลยทีเดียว มี [GitHub repo](https://github.com/roof42/python-monad-pymonad) ที่ลองไปฝึกกันได้ครับ  
