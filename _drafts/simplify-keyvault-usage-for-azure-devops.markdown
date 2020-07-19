---
layout: post
title:  "ลดความซับซ้อนในการใช้ Azure KeyVault ใน Azure DevOps ด้วย Variable groups"
date:   2020-07-17
tags: [azure-devops, azure-keyvault]
---

product ที่ทำอยู่กับบริษัทใช้บริการ Microsoft Azure เป็นหลัก ก็มีทั้ง cloud resource provider และ CICD (เช่น Version control, CICD pipeline, project management ไรงี้) ด้วย พบว่าการใช้งาน Azure KeyVault ซึ่งเป็น secret management ใน CICD pipeline มันดูซับซ้อนเกินไป เลยจดบันทึกไว้หน่อยว่าทีมทำการลดความซับซ้อนเหล่านี้ลงยังไง

### เริ่มจากตัวอย่างกันก่อน
ตัวอย่างคือต้องการ SQL database password เพื่อไป connect กับ Spark streaming job ซึ่งระบบใช้ Azure Databricks ไม่ได้ provision อยู่บน Kubernetes จีงไม่สามารถใช้ Secrets ได้ครับ  

<script src="https://gist.github.com/raksit31667/468d78e332e6098d8911bc9677519814.js"></script>

Development ที่เข้ามาใหม่เริ่มรู้สึกว่า ทำไมต้องเขียน PowerShell script ด้วย Azure ควรจะมี task ในการเชื่อม Azure KeyVault กับ Azure DevOps นะ  

### ใช้ท่า Azure DevOps task ละกัน

<script src="https://gist.github.com/raksit31667/8d48650e0b886c30a16ff2b172f79493.js"></script>

แต่ก็ยังไม่ดีที่สุดนะเพราะเราไม่ได้ deploy แค่ environment เดียว งี้ก็ต้องสร้าง task คล้ายๆกัน ต่างกันแค่ชื่อ  

### ไปใช้งาน Variable groups แทน
1. ตรงเมนู​ Azure DevOps ไปที่ **Library** จะเจอหน้าตาประมาณนี้
![ADO VarGroups 1](/assets/2020-07-19-azure-devops-variable-groups-1.png)

2. กดเพิ่ม **Variable group** จากนั้นใส่ชื่อและ toggle ตรง **Link secrets from an Azure key vault as variables** เลือก Azure subscription และ KeyVault ที่ต้องการ
![ADO VarGroups 2](/assets/2020-07-19-azure-devops-variable-groups-2.png)

พอ toggle แล้วจะมีส่วนของ **Variables** โผล่ออกมาครับ เราก็กดเพิ่ม **Variable** ที่ต้องการได้เลย
![ADO VarGroups 3](/assets/2020-07-19-azure-devops-variable-groups-3.png)

![ADO VarGroups 4](/assets/2020-07-19-azure-devops-variable-groups-4.png)

3. แล้วเราก็เรียก Variables ผ่าน Azure DevOps pipeline script ได้เลย

<script src="https://gist.github.com/raksit31667/ab44ba0410543532bd68165c9a00d237.js"></script>

ในกรณีที่เรามี Variable groups ใช้ร่วมกับ Variable ปกติ เราจะต้องแยกออกจากกันด้วย syntax ประมาณนี้

<script src="https://gist.github.com/raksit31667/b8cdfa58abf24da2687f34773b424e2c.js"></script>

> ดูเพิ่มเติมได้ที่ <https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml> เลยครับ
