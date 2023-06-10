---
layout: post
title: "สวัสดี Poetry สำหรับจัดการ dependency บน Python project"
date: 2023-06-10
tags: [python, poetry]
---

![Poetry](/assets/2023-06-10-poetry-python.png)

ช่วงนี้กำลังทำ project แล้วเริ่มเปลี่ยน script language จาก Bash เป็น Python แทน ทำให้เราต้องเริ่มการติดตั้งพวก dependency ต่าง ๆ ได้รับคำแนะนำมาว่าให้ลองใช้ [Poetry](https://python-poetry.org/) ดู ก็มาดูกันว่ามันมีจุดเด่นอะไรบ้าง

## ปัญหาของ dependency management บน Python
- การทดสอบว่า code ของเรา work กับ Python 3 หลาย ๆ version ยากเนื่องจากต้องมาติดตั้ง [virtual environments](https://virtualenv.pypa.io/en/latest/) ใหม่
- การ build, package application รวมไปกับ dependency ต่าง ๆ เพื่อ publish ไปบน Python package อย่าง [PyPI](https://pypi.org/) มีขั้นตอนเยอะ เช่น ติดตั้ง PyPI, สร้าง file `setup.py`, `setup.cfg`, `LICENSE.txt`
- Dependency ที่ใช้บน production และ local environment (testing, development tool) ปนกัน ทำให้ application size ใหญ่โดยไม่จำเป็น

จึงต้องมีการติดตั้งเครื่องมือเพื่อเข้ามาแก้ปัญหาเหล่านี้ เช่น

- **pyenv** สำหรับติดตั้ง Python หลาย ๆ version
- **venv** สำหรับติดตั้ง virtual environments หลาย ๆ version
- **pip** สำหรับจัดการ dependency และ packaging

แต่ `pip` ก็ยังคงมีปัญหาบางอย่างที่เป็นอุปสรรคต่อนักพัฒนา คือการ upgrade dependency ทั้งหมดต้องทำเองโดยเข้าไปแก้ไข `requirements.txt` ปัจจุบันเลยมีการนำเครื่องมือในการจัดการ dependency มาใช้ หนึ่งในนั้นก็คือ [Poetry](https://python-poetry.org/)

## จุดเด่นของ Poetry
- จัดการ dependency และ packaging ด้วย configuration file เพียงอันเดียวคือ `pyproject.toml` ซึ่งดูแลรักษาง่ายกว่าเมื่อเทียบกับเครื่องมือคล้าย ๆ กันอย่าง [pipenv](https://pipenv.pypa.io/en/latest/) ที่ต้องมีทั้ง `pyproject.toml` และ `Pipfile`
- Dependency ที่ติดตั้งปลอดภัยด้วยการระบุเลข version ผ่าน file `poetry.lock` เพื่อป้องกันไม่ให้เกิดการ upgrade dependency อันใดอันนึงไปแล้วไปกระทบกับการทำงานของ dependencies อื่น ๆ ที่มาเรียกใช้ dependency version ใหม่อีกที (มีใน `pipenv` เหมือนกันชื่อว่า `Pipfile.lock`)
- แยก dependency ออกเป็นหมวดหมู่ได้
- สร้าง virtual environment ให้อัตโนมัติทำให้เราสามารถสลับใช้ Poetry กับ Python หลาย ๆ version ได้
- Command-line interface แบบ interactive ใช้งานง่ายสำหรับขึ้น project ใหม่

## มาลองใช้งานกัน
0. ติดตั้ง Python version 3.7 ขึ้นไป
1. ติดตั้ง Poetry ผ่านคำสั่ง

    ```shell
    $ curl -sSL https://install.python-poetry.org | python3 -
    ```

2. เริ่มใช้งาน Poetry ถ้าเพิ่งขึ้น project ใหม่ให้ใช้คำสั่ง

    ```shell
    $ poetry new your-project
    ```

    ก็จะได้ file structure หน้าตาประมาณนี้

    ```
    your-project
    ├── pyproject.toml
    ├── README.md
    ├── your-project
    │   └── __init__.py
    └── tests
        └── __init__.py
    ```

    แต่ถ้ามี project อยู่แล้วก็ให้ใช้อีกคำสั่งนึง

    ```shell
    $ cd your-project
    $ poetry init
    ```

    ใน `pyproject.toml` ก็จะประกอบไปด้วย configuration สำหรับ dependencies และ packaging หน้าตาประมาณนี้

    ```ini
    [tool.poetry]
    name = "your-project"
    version = "0.1.0"
    description = "Your project description"
    authors = ["Your Name <you@example.com>"]
    readme = "README.md"

    [tool.poetry.dependencies]
    python = "^3.9"
    pytest = "^7.3.1"
    autopep8 = "^2.0.2"


    [build-system]
    requires = ["poetry-core"]
    build-backend = "poetry.core.masonry.api"
    ```

    สามารถเข้าไปดูรายละเอียดของ `pyproject.toml` ได้ใน <https://python-poetry.org/docs/pyproject/>

3. ติดตั้ง dependency ด้วยคำสั่ง

    ```shell
    $ poetry add your-dependency
    ```

4. run คำสั่งในdependency อีกทีด้วยคำสั่ง

    ```shell
    $ poetry run python your_script.py
    ```

5. ถ้า clone project ที่ใช้ `Poetry` อยู่แล้วก็ติดตั้งด้วยคำสั่ง

    ```shell
    $ poetry install
    ```

6. ใช้งาน virtual environment ด้วยการสร้าง shell ขึ้นมาเนื่องจาก `Poetry` run บน process ย่อย ดังนั้น state ต่าง ๆ จะหายไปเมื่อ process มีการ exit ไป จึงต้องมี sub-shell เพื่อ run คำสั่งถัด ๆ ไปผ่าน virtual environment ที่ activate ขึ้นมานั่นเอง

    ```shell
    $ poetry shell
    ```

> จากการใช้งานมาพบว่าทำให้ชีวิตการพัฒนา application บน Python สะดวกขึ้น แนวคิดก็เข้าใจไม่ยากถ้าเคยใช้งานพวก [npm](https://www.npmjs.com/) ของ Node.js มาแล้ว ลองเอาไปใช้กันดูฮะ