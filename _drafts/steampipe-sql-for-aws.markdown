---
layout: post
title:  "แนะนำเครื่องมือ Steampipe สำหรับ query AWS resource ด้วย SQL"
date:   2022-09-30
tags: [productivity, aws]
---

## พูดถึงปัญหาที่เจอ

ปีที่ผ่านมาระบบงานที่ใช้จะมี infrastructure ส่วนมากอยู่บน cloud ของ Amazon Web Services (AWS) เป็นเลือกที่จะหลีกเลี่ยงไม่ได้ที่จะต้องเข้าไปดู resource ต่าง ๆ บน AWS ซึ่งสำหรับเราการกดเข้าไปดูผ่าน AWS Console มันก็กินเวลาเยอะ แถมบาง resource พวก UI ก็ไม่ได้ดีสม่ำเสมอกันด้วย (เช่น S3 ที่ไม่สามารถลบ file หลาย ๆ อันพร้อมกันได้ 😤) เลยหนีไปสาย command-line interface (CLI) ซึ่งเราก็พบว่าการใช้งาน AWS CLI มันก็ยาวและเข้าใจไม่ง่ายเหมือนกัน เผอิญไปเจอเครื่องมือที่ช่วยแก้ปัญหานี้

## Steampipe
[Steampipe](https://steampipe.io/) เป็น CLI ที่มี API เชื่อมกับ AWS เพื่อให้เราสามารถดึงข้อมูลของ resource ตามต้องการได้ ทุกครั้งที่เรา run คำสั่ง ข้อมูลจะนำมาเก็บไว้ใน PostgreSQL ซึ่งเป็น relational database ที่ start ขึ้นมา และจะถูกปิดไปหลังจาก query เสร็จ ด้วยการที่มันเป็น relational database ตัว Steampipe มีความสามารถที่จะให้เรา[ดึงข้อมูลในรูปแบบของ SQL](https://wiki.postgresql.org/wiki/Foreign_data_wrappers) ซึ่งมีความยิดหยุ่นในตัวอยู่แล้ว เพราะเราสามารถใช้ operator ต่าง ๆ ที่ SQL มี อย่าง join filter ได้เลย และเราสามารถเข้า Steampipe ผ่าน database GUI tool เช่น pgAdmin ได้ด้วยเช่นกัน  

![Steampipe architecture](/assets/2022-10-03-steampipe-architecture.jpg)

### ข้อดีจากเท่าที่ใช้มา
1. ประหยัดเวลาในการค้นข้อมูล ส่วนตัวมองว่าสะดวกสบายกว่าใช้งาน AWS Console
2. ด้วยความที่คำสั่งเป็น SQL ทำให้มีความคุ้นชิน รองรับได้หลาย use case
3. มี [plugin](https://hub.steampipe.io/plugins) ที่รองรับ use case มากกว่า AWS เช่น Azure หรือ GCP

### ข้อเสียจากเท่าที่ใช้มา
1. Steampipe ไม่ได้ออกแบบมารองรับการ create/update/delete resource
2. สำหรับ Windows จะต้องติดตั้ง Windows Subsytem for Linux (WSL) ก่อน

### มาลองใช้งานดู
1. เริ่มจากการติดตั้ง Steampipe ผ่าน CLI กันก่อนผ่านคำสั่ง

    ```shell
    # สำหรับ Linux
    $ sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"

    # สำหรับ macOS
    $ brew tap turbot/tap
    $ brew install steampipe
    ```

2. จากนั้นให้เราติดตั้ง plugin ในบทความนี้แน่นอนเราต้องติดตั้ง AWS ผ่านคำสั่ง

    ```shell
    $ steampipe plugin install aws
    ```

3. ตั้งค่า AWS credentials ที่ต้องการจะเชื่อมต่อเช่น
    - Configure ตาม AWS credentials file ที่ปกติจะอยู่ใน `$HOME/.aws/credentials` ลักษณะนี้

        ```
        [account_a]
        aws_access_key_id = ...
        aws_secret_access_key = ...
        region = ap-southeast-1

        [account_a_with_sso]
        sso_start_url = ...
        sso_region = ap-southeast-2
        sso_account_id = ...
        sso_role_name =...
        region = ap-southeast-1

        [account_a_without_mfa]
        role_arn = arn:aws:iam::111111111111:role/my_role
        source_profile = account_a
        external_id = xxxxx

        [account_a_with_mfa]
        credential_process = sh -c 'mfa.sh arn:aws:iam::111111111111:role/my_role arn:aws:iam::999999999999:mfa/my_role_mfa cli_user 2> $(tty)'
        ```

    - Configure ผ่าน environment variables

        ```
        export AWS_ACCESS_KEY_ID=...
        export AWS_SECRET_ACCESS_KEY=...
        export AWS_DEFAULT_REGION=ap-southeast-1
        export AWS_SESSION_TOKEN=...
        export AWS_ROLE_SESSION_NAME=...
        ```
    
    - Configure ผ่านเครื่องมือ aws-vault

4. ตั้งค่า Steampipe ผ่าน [configuration file](https://hub.steampipe.io/plugins/turbot/aws#configuration) ของ Steampipe ซึ่งจะอยู่ใน `$HOME/.steampipe/config/aws.spc` จะได้หน้าตาลักษณะประมาณนี้

    ```
    connection "aws_account_a" {
    plugin  = "aws"
    profile = "account_a"
    regions = ["ap-southeast-1"]
    }

    connection "aws_account_b" {
    plugin  = "aws"
    profile = "account_b"
    regions = ["ap-southeast-1", "ap-southeast-2"]
    }
    ```

5. เริ่มใช้งาน Steampipe โดยการเปิด query session ผ่านคำสั่ง

    ```shell
    $ steampipe query
    ```

6. จากนั้นเราก็สามารถ query resource ตามต้องการผ่าน [interactive shell](https://steampipe.io/docs/query/query-shell) ที่มีทั้ง hotkey, autocomplete ได้แล้ว

    <a href="https://asciinema.org/a/pt7bv1rYvavD6tbnGnwR8fZty" target="_blank"><img src="https://asciinema.org/a/pt7bv1rYvavD6tbnGnwR8fZty.svg" /></a>

    - สามารถเขียน SQL command ไว้เป็น file ก่อนแล้วใช้ผ่านคำสั่งนี้ก็ได้เหมือนกัน

        ```shell
        $ steampipe query /path/to/your.sql
        ```

    - โดยปกติแล้ว output จะออกมาเป็นตารางแบบ text แต่เราก็สามารถให้ออกมาเป็น JSON/CSV ก็ได้ผ่านคำสั่ง

        ```shell
        $ steampipe query /path/to/your.sql --output <json/csv> --separator '|'
        ```

### ความสามารถอื่น ๆ

- อย่างที่กล่าวไปในต้นบทความว่าเราสามารถต่อ Steampipe database ผ่าน database GUI tool ได้ โดยเราสามารถไปดึง [database configuration](https://steampipe.io/docs/managing/service) ได้ผ่านคำสั่ง

    ```
    $ steampipe service start --show-password

    Steampipe service is already running:

    Database:

    Host(s):            localhost, 127.0.0.1, 192.168.1.35
    Port:               9193
    Database:           steampipe
    User:               steampipe
    Password:           9bf4_438d_84b2
    Connection string:  postgres://steampipe:9bf4_438d_84b2@localhost:9193/steampipe
    ```

    ![DBeaver Steampipe configuration](/assets/2022-10-03-dbeaver-steampipe-config.png)

    ![DBeaver Steampipe query](/assets/2022-10-03-dbeaver-steampipe-query.png)

- สามารถ download หรือสร้าง [dashboard บน web browser](https://steampipe.io/docs/dashboard/overview) สำหรับดูข้อมูลที่น่าสนใจ ซึ่งเบื้องหลังก็คือใช้ Steampipe query ที่ตั้งไว้แล้วก็นำผลมาแสดงให้เห็น สำหรับ AWS แล้ว use case ตัวอย่างก็จะมี

    - AWS insights สำหรับตรวจสอบ AWS resource เช่น ค่าใช้จ่ายในรอบ 1 ปี
    - AWS compliance สำหรับ run พวก security controls หรือ compliance
    - สำหรับ use case อื่น ๆ ก็เข้าไปดูที่ [Steampipe mods](https://hub.steampipe.io/mods) ได้เลย
    - หรือถ้าอยากจะสร้างเอง ด้วยภาษา Hashicorp configuration language (HCL) ก็ดูตาม [guideline](https://steampipe.io/docs/mods/overview) นี้ได้เลย

    ![Steampipe dashboard](/assets/2022-10-03-steampipe-dashboard.png)

- สามารถ run Steampipe บน Docker container ได้ ดูได้ตาม [guideline](https://steampipe.io/docs/managing/containers) นี้เลยครับ
- Documentation ดีมาก สร้างมาเพื่อ developer โดยเฉพาะจากการที่มี [guideline](https://steampipe.io/docs/develop/overview) สำหรับ developer อย่างชัดเจน

> จากการใช้งานจริงมาสักพัก พบว่าเป็นเครื่องมือที่ใช้งานไม่ยาก ช่วยประหยัดเวลาในการค้นข้อมูลที่สนใจแต่อยู่คนละที่ใน AWS ได้ดีมาก และมี use case ที่ต่อยอดนอกเหนือจาก AWS อีกเยอะเลยครับ ลองเอาไปใช้กันดูนะ