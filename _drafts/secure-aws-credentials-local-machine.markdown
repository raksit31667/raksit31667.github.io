---
layout: post
title:  "มา Secure AWS credentials บน local machine ด้วย aws-vault กัน"
date:   2021-05-07
tags: [aws, credentials]
---

## Context
ช่วงนี้มีโอกาสได้มาทำระบบที่ provision อยู่บน **Amazon Web Services (AWS)** แน่นอนว่าเวลาเราได้แตะส่วน Authentication เพื่อเข้าไป operate กับ AWS resource ต่างๆ ผ่าน CLI นั้น เราจะต้องเก็บ credentials และ profile configuration ไว้ด้วย ไม่ว่าจะมี profile เดียวหรือหลายอันก็ตาม 
โดยเราสามารถตั้งค่าเหล่านี้ผ่าน `$HOME/.aws/credentials` และ `$HOME/.aws/config` ได้ตามนี้เลย

<script src="https://gist.github.com/raksit31667/26236784a4b19aaef18beee23c23de73.js"></script>

<script src="https://gist.github.com/raksit31667/0d83896b231487a97d7fbdbaff606702.js"></script>

จังหวะเราจะเรียกใช้ profile ใดๆ ก็สามารถทำได้ผ่าน CLI เลย

```shell
aws s3 ls --profile <your-profile-here>
```

## Problem statements
ซึ่งปัญหาของการเก็บ credentials แบบนี้คือเรื่อง **security** อย่างเดียวเลย ซึ่งตาม[บทความของ 99designs](https://99designs.com.au/blog/engineering/aws-vault/) ระบุว่า access key ของเราสามารถถูกโจมตีได้ไว้ 4 scenario ด้วยกัน

1. ขโมยตรงๆ จากคอมเจ้าของเครื่องเลย
2. ขโมยผ่าน Malware
3. ขโมยจาก credentials ที่เจ้าของเผลอเอาขึ้น public repository ไป (จะเรียกว่า "แจก" เลยก็ได้นะ ฮ่าๆๆ)
4. ขโมยจากคอมของคนที่ลาออกไปแล้ว ซึ่ง credentials ยังไม่ได้ถูกถอนคืน (revoke)

## Possible solutions
จากปัญหาข้างต้น ทาง AWS ได้มี [Best practices สำหรับจัดการ access key](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html) ของเราไว้คร่าวๆ ประมาณนี้

1. แต่ละทีมควรจะมี AWS account แยกกัน ซึ่งมี permission ที่จำกัด เช่น ส่วนของการ access EC2 กับ provision infrastructure
2. มีคนหรือทีมที่ช่วยจัดการ AWS user โดยเฉพาะเลย และควรจะเปลี่ยน key อยู่เรื่อยๆ
3. ควรจะมี Multi-factor authentication สำหรับ credentials ที่ไม่ได้อยู่ในเครื่องเรา
4. ไม่ควรเก็บ credentials ไว้เป็น plain text

## Apply tools
จากวิธีแก้ปัญหา เราสามารถนำ tool ต่างๆ มาใช้ได้ เช่น
-  [Identity and Access Management role (IAM role)](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_identity-management.html)
-  [Multi-factor authentication device (MFA)](https://aws.amazon.com/iam/details/mfa/)
-  [Security Token Service (STS)](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) ทำงานร่วมกับ `AssumeRole` ได้

ในบทความนี้ ผมจะใช้ [aws-vault](https://github.com/99designs/aws-vault) ในการ secure credentials ซึ่งทำงานกับ backend เช่น [macOS Keychain Access](https://support.apple.com/en-au/guide/keychain-access/welcome/mac) หรือ [Windows Credential Manager](https://support.microsoft.com/en-us/windows/accessing-credential-manager-1b5c916a-6a16-889f-8581-fc16e8165ac0) หรือ [KWallet](https://apps.kde.org/kwalletmanager5/) ได้

## Usage
ขั้นแรกเราสร้าง Vault ขึ้นมาจาก `accessKeyId` และ `secretAccessKey` ก่อน

```shell
$ aws-vault add <your-profile-here>
Enter Access Key Id: AKIAXXXXXXXXXXX
Enter Secret Key: $^#!#&@!#*!($)+
```

ซึ่งการใช้งานครั้งแรก มันจะมี prompt ตาม backend ของเราขึ้นมาถามให้ใส่ password อันนี้เราต้องจำให้ได้เพราะตอนเราใช้งานมันจะเรียกถามทุกครั้ง

![aws-vault prompt](/assets/2021-05-07-aws-vault-prompt.png)

จากนั้นลอง list มาดูว่า vault นี้ถูกสร้างหรือยัง

```shell
$ aws-vault list

Profile                     Credentials                 Sessions                        
=======                     ===========                 ========                        
your-profile                -                           -            
```

ถ้ามีแล้วก็เริ่มใช้งานผ่าน CLI ได้เลย ซึ่งตัว `aws-vault` มันจะไป set environment variable ให้เราเองเลย สังเกตว่า `AWS_ACCESS_KEY_ID` กับ  `AWS_SECRET_ACCESS_KEY` ไม่เหมือนกันที่เราตั้งไว้เนื่องจาก `aws-vault` ใช้ STS ในการสร้าง [credentials ชั่วคราว](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html) ด้วย `AssumeRole` API ดังนั้น user ของเราต้องมี permission `sts:GetSessionToken` กับ `sts:AssumeRole` ด้วยนะ

```shell
$ aws-vault exec <your-profile-here>
$ echo $AWS_ACCESS_KEY_ID
AKIAXXXXXXXXXXX
```

ถ้าเราลอง list มาดูอีกที จะสังเกตว่ามีส่วนของ session โผล่มาละ

```shell
$ aws-vault list

Profile                     Credentials                 Sessions                        
=======                     ===========                 ========                        
your-profile                -                           sts.GetSessionToken:51m30s            
```

เราสามารถใช้งาน `aws-vault` กับ AWS CLI ตรงๆ ได้เลย

```shell
$ aws-vault exec <your-profile> -- aws s3 ls
2020-03-11 14:22:15 this-s3
2020-03-11 14:36:53 that-s3
```

หรือจะใช้กับ MFA ก็ได้เหมือนกัน

```shell
$ aws-vault exec <your-profile> --mfa-token=<your-token-here>
```

จาก [Best practices](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html) เราสามารถใช้ `aws-vault` ตาม role ที่ถูกแบ่งไว้ได้ โดยเราสามารถ configure ใน `$HOME/.aws/config` ได้ **ข้อบังคับคือต้องตั้งชื่อ profile ให้เหมือนกับใน aws-vault และไม่ต้องใส่ source_profile แล้วเพราะเราผูก credentials ไว้กับ aws-vault แล้ว**

<script src="https://gist.github.com/raksit31667/992e33ab150aad54de2ac9cbef315119.js"></script>

> ลองนำไปใช้งานดูครับ เพิ่มความปลอดภัยให้ development เราได้เยอะครับ

## References
- [Securing AWS Credentials on Engineer’s Machines](https://99designs.com.au/blog/engineering/aws-vault/)