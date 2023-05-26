---
layout: post
title:  "Run Git hooks ในหลาย ๆ project ด้วย pre-commit"
date:   2023-05-26
tags: [pre-commit, tools]
---

โดยปกตินักพัฒนาจะทำการติดตั้ง script เพื่อที่จะ run ให้เราตรวจพบความผิดพลาดที่เกิดขึ้นได้รวดเร็วที่สุด หนึ่งในท่าที่ใช้กันคือ [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)  ยกตัวอย่างเช่นในแง่ของ security หนึ่งในเครื่องมือป้องกันไม่ให้เกิดช่องโหว่ที่ระบบปัจจุบันของเราใช้อยู่คือ secret scanning tool เพื่อตรวจสอบว่า code มันมี credentials เช่น API key, password, connection string, private encryption key หลุดออกไปหรือเปล่า ถ้ามีก็จะขึ้นเตือนมาก่อนที่ code จะถูก push ขึ้นไปบน remote repository ซึ่งจะง่ายกว่าการที่มันหลุดออกไปแล้วมาแก้ทีหลัง (เราเคยเขียนบทความเกี่ยวกับเรื่องนี้มาแล้วใน [สรุปแนวทางการลบ credentials ออกจาก Git (อย่างถาวร) จาก GitGuardian]({% post_url 2021-09-18-remove-exposed-credentials-from-git-history %})) สำหรับบทความนี้ก็จะแนะนำ [pre-commit](https://pre-commit.com/) ก็มาดูกันว่ามันดีกว่าเครื่องมือตัวอื่น ๆ อย่างไร  

ปัญหาของ Git hooks คือการ share script เดียวกันกับหลาย ๆ project แบบเรียบง่ายก็ copy-paste เอาทีละ project แต่ถ้าต้อง update script ทีนึงก็ต้องเข้าไปทีละ project เช่นเดียวกัน [pre-commit](https://pre-commit.com/) คือ framework ที่ใช้สร้างและจัดการ script ที่จะ run ก่อน commit ด้วย Git (ต่อไปนี้จะเรียกว่า Git hooks) ให้สามารถ share กันหลาย ๆ project โดยรูปแบบการทำงานของ `pre-commit` จะเป็นดังนี้

![pre-commit flow](/assets/2023-05-26-pre-commit-flow.png)

## ขั้นตอนการใช้งานแบบพื้นฐาน

1. เริ่มจากติดตั้ง `pre-commit` command line ก่อนผ่าน `pip`, `homebrew` หรือ `conda`
2. เราสามารถเลือกที่จะใช้ hooks ที่มีอยู่แล้ว หรือจะลงมือสร้างเองก็ได้ ถ้าสร้างเองเราจะต้องสร้าง repository สำหรับเก็บ hook script ไว้โดยมี structure ประมาณนี้
    
    ```
    ├── .pre-commit-hooks.yaml
    ├── hook_1
    │   ├── Dockerfile
    │   ├── some-hook-script.sh
    └── hook_2
        ├── run.py
        ├── pyproject.toml
    ```

    - `.pre-commit-hooks.yaml` สำหรับกำหนดรูปแบบของ hooks เช่น id, name, executable file path (entrypoint), จะ [run ตอนไหน](https://pre-commit.com/#supported-git-hooks),จะ run เป็น single หรือ parallel process เป็นต้น ดูเพิ่มเติมได้ใน [supported languages](https://pre-commit.com/#pre-commit-configyaml---hooks) เช่น

        ```yaml
        -   id: hook_2
            name: Hook number 2
            description: Some description...
            entry: hook_2
            language: python
            types: [text]
        ```
    -  Hook script ต่าง ๆ ที่เก็บไว้แล้วแต่สะดวก ส่วนตัวแนะนำให้แยก directory ตาม hook ไปเลย
    
3. ก่อนที่เราจะนำ hooks ไปใช้เราสามารถทดสอบ hook ด้วยการใช้คำสั่ง `try-repo` ได้โดยเราสามารถเลือก hook ที่จะทำการทดสอบได้ประมาณนี้

    ```shell
    $ pre-commit try-repo /path/to/hook/repo <your-hook-id> --verbose --all-files

    ===============================================================================
    Using config:
    ===============================================================================
    repos:
    -   repo: .
        rev: <git-commit-SHA>
        hooks:
        -   id: <your-hook-id>
    ===============================================================================
    [INFO] Initializing environment for ..
    <your-hook-id>...........................................................Passed
    - hook id: <your-hook-id>
    - duration: 1s
    ```
4. หลังจากเราทดสอบ hooks เรียบร้อยแล้ว ก็ทำการ publish hooks เพื่อ share ให้กับ project อื่น ๆ ต่อ โดยที่เราก็ push code ขึ้นไปใน remote repository พร้อมกับ Git tag เพื่อระบุ revision ตามต้องการ
5. ทีนี้ project ที่ต้องการจะเอาไปใช้ก็แค่สร้าง `pre-commit` configuration file ขึ้นมาชื่อ `.pre-commit-config.yaml` หน้าตาประมาณนี้

    ```yaml
    repos:
    -   repo: your.hooks.repo.url # custom hooks
        rev: your-hooks-repo-git-tag
        hooks:
        -   id: hook_1
            args: [--arg1=value]
        -   id: hook_2
    -   repo: https://github.com/pre-commit/pre-commit-hooks # community hooks ดูเพิ่มได้ใน https://pre-commit.com/hooks.html
        rev: v2.3.0
        hooks:
        -   id: check-yaml
        -   id: end-of-file-fixer
        -   id: trailing-whitespace
    ```
6. ติดตั้ง Git hook scripts ด้วยคำสั่ง

    ```shell
    $ pre-commit install

    pre-commit installed at .git/hooks/pre-commit
    ```

7. ทีนี้เวลาเราใช้คำสั่ง Git commit ถ้าติดตั้งทุกอย่างถูกต้องมันก็จะ run `pre-commit` ให้อัตโนมัติ

    ```shell
    $ git commit --allow-empty -m 'Hello world!'
    [INFO] Initializing environment for your.hooks.repo.url.
    [INFO] Initializing environment for https://github.com/pre-commit/pre-commit-hooks.
    [INFO] Installing environment for your.hooks.repo.url.
    [INFO] Once installed this environment will be reused.
    [INFO] This may take a few minutes...
    [INFO] Installing environment for https://github.com/pre-commit/pre-commit-hooks.
    [INFO] Once installed this environment will be reused.
    [INFO] This may take a few minutes...
    Hook Number 1............................................................Passed
    Hook Number 2............................................................Passed
    Check Yaml...............................................................Passed
    Fix End of Files.........................................................Passed
    Trim Trailing Whitespace.................................................Failed
    - hook id: trailing-whitespace
    - exit code: 1

    Files were modified by this hook. Additional output:

    Fixing sample.py
    ```
8.  ถ้าไม่มี file ใด ๆ ถูกแก้ไขตาม hooks ที่กำหนดไว้มันก็จะข้ามไปเลย แต่เราสามารถบังคับให้ run ทุก file ได้ผ่านคำสั่ง

    ```shell
    $ pre-commit run --all-files
    ```

## การใช้งานอื่น ๆ ที่น่าสนใจ

- เราสามารถตาม update hooks ให้เป็น version ได้โดยจะทำการ update configuration file ให้ชี้ revision (`rev`) ไปที่ Git tag ล่าสุดใน default branch ของ hook repository 

    ```shell
    $ pre-commit autoupdate
    ```

- ในกรณีที่ update hooks แล้วแต่คำสั่งยังใช้ revision เก่าอยู่ หนึ่งในสาเหตุอาจจะเป็นที่ cache ที่ `pre-commit` เก็บไว้ยังชี้ไม่ได้ชี้ไปที่ revision ใหม่ เราสามารถใช้คำสั่งในการ clear cache ได้ 

    ```shell
    $ pre-commit clean # clear pre-commit file ทิ้ง

    $ pre-commit gc # clear pre-commit repos ที่ไป clone มาเก็บไว้
    ```
    
- เราสามารถเลือกที่จะ run hook อันใดอันนึงได้ผ่านคำสั่ง

    ```shell
    $ pre-commit run [hook-id]
    ```

- เราสามารถเลี่ยงการ run hook บางตัวได้ด้วยการระบุ environment variable ชื่อ `SKIP` ที่มีค่าเป็น hook ID ในรูปแบบ comma-separated value ตามด้วยคำสั่ง

    ```shell
    $ SKIP=hook_1,hook_2 git commit -m "foo"
    ```

- ในกรณีที่ hook มันเจาะจงและผูกติดไปที่ repository อันใดอันนึง เช่น ต้องเรียก script ใน repository นั้น ทำให้เราไม่สามารถใส่ไว้ใน hook repository เพื่อ share ได้ เราสามารถสร้าง hook เพื่อใช้ใน local repository นั้นได้โดยกำหนด configuration file หน้าตาประมาณนี้

    ```yaml
    repos:
    -   repo: local
        hooks:
        -   id: hook_1
            entry: /path/to/local/script.sh
    ```

> โดยรวมแล้ว [pre-commit](https://pre-commit.com/) เป็นเครื่องมือที่ feature ครอบคลุมหลากหลาย use case มี community ที่ใหญ่พอสมควร (10k stars บน GitHub) ลองไปใช้กันตามเหมาะสมครับ
