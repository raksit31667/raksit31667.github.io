---
layout: post
title: "พัฒนา AWS Lambda บน local environment ด้วย Serverless และ Localstack"
date: 2023-08-15
tags: [aws, lambda, serverless, localstack, gitlab]
---

ในระบบงานที่กำลังทำอยู่ มีการพัฒนา AWS Lambda ที่เชื่อมต่อกับ AWS resource อื่น ๆ ด้วย ปัญหาก็คือ feedback loop ที่ยาวเนื่องจากจะทดสอบทีก็ต้อง deploy ขึ้นไปลองบน AWS จริง ๆ [จากบทความก่อนหน้านี้]({% post_url 2021-10-02-how-to-test-doubles-aws %}) เรามีเครื่องมือที่สามารถจำลอง AWS ขึ้นมาใน docker container ได้ ทำให้เราลด feedback loop ให้สั้นลงได้  

ตัวอย่างในบทความนี้คือเราจะใช้ AWS resource ต่าง ๆ เหล่านี้ในการพัฒนาระบบงาน
- Lambda
- S3
- ElastiCache
- Secrets Manager

![AWS Lambda local development](/assets/2023-08-15-aws-lambda-local-development.png)

ในการพัฒนา Lambda นั้นเราจะใช้ Serverless framework ซึ่งเป็น framework ที่ช่วยเราพัฒนา Lambda บน Node.js และ Python โดย focus ไปที่ส่วนของ application logic และปล่อยให้ framework จัดการส่วน infrastructure ให้ โดยเราสามารถ configure Lambda ให้ไป deploy ในรูปแบบต่าง ๆ ได้เช่น

- HTTP API 
- Scheduled Task 
- SQS Worker 
- Express API 
- Express API with DynamoDB
- Flask API 
- Flask API with DynamoDB

โดยเราสามารถสร้าง project ใหม่ขึ้นมาผ่าน Serverless framework ด้วยคำสั่ง command-line บวกกับ configure AWS และ properties อื่น ๆ

```shell
$ serverless
```

ต่อไปเราก็มาวาง CI/CD pipeline กันหน่อยเพื่อ run คำสั่งอื่น ๆ นอกจากการ deploy อย่างเช่น unit testing หรือ linting เป็นต้น โดยในบทความนี้เราจะลองใช้ GitLab CI ดู แต่เนื่องจากว่า repository ของเรามันอยู่ใน GitHub Actions ก็เลยต้องสร้าง GitHub Actions workflow เพื่อ sync การเปลี่ยนแปลงใน GitHub ไปให้ GitLab ด้วยการสร้าง YAML file ใน directory `.github/workflows`

<script src="https://gist.github.com/raksit31667/f60a82b8a918839a886e8928cbaac9e1.js"></script>

จากนั้นเราไป [generate access token ใน GitLab ที่มี scope `write_repository`](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#create-a-project-access-token) และนำมา[แปะใน GitHub secret variables](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository) เมื่อเรา push commit ใหม่ขึ้นไปบน GitHub ก็จะเห็น commit ใหม่บน GitHub ด้วย

```shell
Run wangchucheng/git-repo-sync@v0.1.0
  with:
    target-url: https://gitlab.com/raksit_m/learn-aws-s3-lambda-elasticache.git
    target-username: raksit_m
    target-token: ***
Run /home/runner/work/_actions/wangchucheng/git-repo-sync/v0.1.0/entrypoint.sh
  /home/runner/work/_actions/wangchucheng/git-repo-sync/v0.1.0/entrypoint.sh
  shell: /usr/bin/bash --noprofile --norc -e -o pipefail {0}
  env:
    INPUT_TARGET_URL: https://gitlab.com/raksit_m/learn-aws-s3-lambda-elasticache.git
    INPUT_TARGET_USERNAME: raksit_m
    INPUT_TARGET_TOKEN: ***
    GITHUB_EVENT_REF: refs/heads/main
To https://gitlab.com/raksit_m/learn-aws-s3-lambda-elasticache.git
   fdfa83c..d2e2a82  main -> main
```

ทีนี้เราก็สร้าง GitLab CI โดยสร้าง file `.gitlab-ci.yml` ใน root directory โดยเริ่มต้นเอาแค่ build และ deploy ก็พอเพื่อความเรียบง่าย

<script src="https://gist.github.com/raksit31667/4c58dfc0bc67b47a3db15dc30139cfba.js"></script>

จากนั้นเราก็ลงมือพัฒนา project ได้เลย จาก diagram ข้างบนเราจะได้ code หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/e7b74ce92213c8bd7b4f7182e1269fc8.js"></script>

<script src="https://gist.github.com/raksit31667/25aee268fe2193e8d1260fbb55fac88b.js"></script>

<script src="https://gist.github.com/raksit31667/b18a1d6bf0fd769b35d8e4709b500a6c.js"></script>

<script src="https://gist.github.com/raksit31667/21df0a901f1fbf84759d1f7d902e1122.js"></script>

<script src="https://gist.github.com/raksit31667/73326ecd8949fab8f49ac6d22a8d4333.js"></script>

ทีนี้เราก็มาติดตั้ง Localstack กัน โดยเราจะติดตั้งผ่าน Serverless framework plugin ชื่อว่า `serverless-localstack` โดยให้เรา run คำสั่ง install dependencies ใน Node.js ก่อน

```shell
$ npm i -D serverless-localstack
```

จากนั้นแก้ไข file `serverless.yml` ให้ใช้งาน plugin ได้ประมาณนี้

<script src="https://gist.github.com/raksit31667/73461115ea725cfd3bf8f2675ed83bc2.js"></script>

ต่อมาคือ run Localstack บน local environment ด้วย Docker Compose โดยสร้าง file `docker-compose.yml` ขึ้นมาหน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/a70c2d3477b25548de1eb3735446cc6d.js"></script>

ทีนี้เราก็เตรียม Shell script ในการสร้าง resource ใน Localstack เมื่อ Docker container ถูก start โดยอัตโนมัติ แนะนำให้ติดตั้ง [awslocal](https://github.com/localstack/awscli-local) เพื่อจะได้ไม่ต้องระบุ `--endpoint` flag

<script src="https://gist.github.com/raksit31667/7c2b59199770742e3bafe16d225a56bc.js"></script>

> สังเกตว่าเราไม่ได้สร้าง AWS ElastiCache ขึ้นมาเนื่องจากมัน[ไม่ได้อยู่ใน free tier](https://docs.localstack.cloud/references/coverage/coverage_elasticache/)

ปิดท้ายด้วยการแก้ไข code เพื่อเชื่อมต่อกับ Localstack โดยเราจะนำ dotenv มาประยุกต์ใช้เพื่อระบุ environment ที่ run อยู่ด้วยคำสั่ง

```shell
$ npm i -D dotenv
```

ต่อมาก็สร้าง file `.env` แต่ไม่ต้องนำขึ้น stage ไปใน Git (อาจจะต้องแก้ไข `.gitignore` ด้วย)

<script src="https://gist.github.com/raksit31667/79b2eda8686992e82204da6b7cb6ac64.js"></script>

<script src="https://gist.github.com/raksit31667/3fdf724e4a7c85c76afdeeaaa0d2c7ea.js"></script>

<script src="https://gist.github.com/raksit31667/7ee9b9c706ef4117bed175fddcfa9712.js"></script>

<script src="https://gist.github.com/raksit31667/41737f2cb55b7e5f3c5bb7c179a2ecc9.js"></script>

เราสามารถ deploy Lambda ขึ้น Localstack ได้ผ่านคำสั่ง

```shell
$ serverless deploy --stage local
```

จากนั้นทำการ run Lambda function ด้วยคำสั่ง

```shell
serverless invoke -f <your-function-name-here> --stage local
```
