---
layout: post
title: "ความแตกต่างในการใช้งาน git pull กับ git pull rebase"
date: 2024-06-16
tags: [git, practice, cicd]
---

จากการ[ไปแบ่งปันประสบการณ์](https://medium.com/@msrisawatvichai/go-intensive-workshop-5b62d3f3116b) ว่าด้วยเรื่องของ software engineering practice ผ่านการพัฒนาระบบด้วยภาษา Go หนึ่งในนั้นคือเรื่องของ Git ซึ่งเป็นเครื่องมือที่ช่วยให้การทำงานร่วมกันของ developer ได้ง่ายขึ้น ในขณะเดียวกันหลายคนหลายทีมก็ประสบปัญหากับการใช้งาน Git แทนที่จะมาช่วยแก้ปัญหาดันสร้างปัญหาใหม่ขึ้นมาซะงั้น ถ้าไม่เชื่อลองดูจาก[คำถามใน StackOverflow](https://stackoverflow.com/questions?tab=Votes) พบว่าคำถามที่ถูก vote เยอะ ๆ นั้นมีเกี่ยวกับ Git เยอะมาก ๆ 

![Git StackOverflow](/assets/2024-06-16-git-stackoverflow.png)

ดังนั้นในบทความนี้เป็นการตอบคำถามคนเรียนเรื่องของ Git ซึ่งหนึ่งในความงงงวยคือ

> "ทำไมพี่ ๆ ถึงบอกว่าให้ใช้คำสั่ง `git pull --rebase` แทนที่จะเป็น `git pull` ก็พอในการทำงานแบบ [trunk-based development](https://developers.ascendcorp.com/trunk-based-development-ep1-%E0%B8%97%E0%B8%B3%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%88%E0%B8%B1%E0%B8%81-d65a45766cde)" 

ถ้าจะตอบให้เข้าใจความต่างระหว่าง `git pull` และ `git pull --rebase` คงต้องยกตัวอย่างกันซะหน่อย

## ตัวอย่าง
สมมติเรากำลังจะเริ่มทำงานกับเพื่อนใน project เดียวกันแล้วมี 3 commit ใน branch `main` ข้างบน repository  

    ```
    A -- B -- C (origin/main)
    ```

ใน repository มี text file อันนึงหน้าตาประมาณนี้

    ```plaintext
    Line 1
    Line 2
    Line 3
    ```

ก็เริ่มต้นด้วยการ clone repositry ลงมาแล้วก็สร้าง commit ใหม่ของตนเอง แต่ยังไม่ได้ push ขึ้น

    ```
    A -- B -- C (origin/main)
            \
             D (local/main)
    ```

    ```plaintext
    Line 1
    Line 2 (local change)
    Line 3
    ```

ต่อมาเพื่อนเขาก็สร้าง commit ของเขาเองเหมือนกันแล้วก็ push ขึ้นมาบน repository

    ```
    A -- B -- C -- E (origin/main)
            \
             D (local/main)
    ```

    ```plaintext
    Line 1
    Line 2 (remote change)
    Line 3
    ```

### ถ้าใช้ `git pull`
1. Git จะไปดึง commit จาก repository มาไว้ในเครื่องของเราใน file `FETCH_HEAD` เหมือนกับเรา run คำสั่ง `git fetch`
   ```
   A -- B -- C -- E (origin/main)
           \
            D (local/main, FETCH_HEAD)
   ```

2. Git จะพยายาม merge change จาก `FETCH_HEAD` (ในตัวอย่างคือ commit E) เข้าไปใน branch `main` ของเรา (`local/main`) เหมือนกับเรา run คำสั่ง `git merge FETCH_HEAD`

3. ถ้ามี conflict ระหว่าง change ของเรากับของเพื่อนใน commit E Git จะหยุดการ merge และแสดง conflict ให้เราเห็นเพื่อให้เราแก้ conflict

    ```
    Line 1
    <<<<<<< HEAD
    Line 2 (local change)
    =======
    Line 2 (remote change)
    >>>>>>> origin/main
    Line 3
    ```

    จังหวะนี้เราก็ต้องไปคุยกับเพื่อนเพื่อช่วยกันแก้ conflict (หลีกเลี่ยงการแก้ conflict คนเดียวเพราะโอกาสพลาดสูง!)

    ```
    Line 1
    Line 2 (resolved change)
    Line 3
    ```

    หลังจากนั้นเราต้อง commit change ที่เกิดจากการแก้ conflict ใหม่เป็น commit `M` (merge commit) หน้าตาประมาณนี้

    ```
    A -- B -- C -- E (origin/main)
            \    \
                D -- M (local/main)
    ```

### ถ้าใช้ `git pull --rebase`
1. Git จะไปดึง commit จาก repository มาไว้ในเครื่องของเราใน file `FETCH_HEAD` เหมือนกับเรา run คำสั่ง `git fetch`

   ```
   A -- B -- C -- E (origin/main)
           \
            D (local/main)
   ```

2. Git ดึง change บนเครื่องเราออกไปชั่วคราว (commit D)

   ```
   A -- B -- C -- E (origin/main)
   ```

3. Git เอา change บนเครื่องเรา (commit D) ไปเพิ่มหลัง change ล่าสุด จาก repository (ในตัวอย่างคือ commit E) ถ้ามี conflict ระหว่าง change ของเรากับของเพื่อนใน commit E Git จะหยุดการ rebase และแสดง conflict ให้เราเห็นเพื่อให้เราแก้ conflict เหมือนการ run คำสั่ง `git rebase`

    ```
    Line 1
    <<<<<<< HEAD
    Line 2 (local change)
    =======
    Line 2 (remote change)
    >>>>>>> origin/main
    Line 3
    ```

    ```
    Applying: D
    Using index info to reconstruct a base tree...
    M   file.txt
    Falling back to patching base and 3-way merge...
    Auto-merging file.txt
    CONFLICT (content): Merge conflict in file.txt
    ```

    จังหวะนี้เราก็ต้องไปคุยกับเพื่อนเพื่อช่วยกันแก้ conflict (หลีกเลี่ยงการแก้ conflict คนเดียวเพราะโอกาสพลาดสูง!)

    ```
    Line 1
    Line 2 (resolved change)
    Line 3
    ```

    จากนั้นเราก็ทำการเอา change ของการแก้ conflict เข้าไปแล้ว rebase ต่อด้วยคำสั่ง `git rebase --continue`

    ```sh
    git add file.txt
    git rebase --continue
    ```

    ผลลัพธ์คือเราจะได้ commit D ที่มี change ที่ถูกแก้หลังจาก commit E เราก็จะไม่มี commit ที่เกิดจากการ merge

    ```
    A -- B -- C -- E -- D' (local/main, origin/main)
    ```

## กลับมาที่คำถาม
จากตัวอย่างเราจะเห็นว่าการใช้ `git pull --rebase` เราจะได้ commit history ที่เป็นเส้นเดียวซึ่งเกิดจากการที่ไม่มี merge commit นั่นเอง ทำให้ง่ายต่อการทำความเข้าใจ change ที่เกิดขึ้นใน repository ซึ่งจะมีผลดีมากในการทำ code review และหา commit ที่ก่อให้เกิด bug ผ่าน `git bisect` สอดคล้องกับแนวทาง trunk-based development ที่จะมี branch หลักในการทำงานแค่อันเดียว

### ถ้าใช้ `git pull --rebase`

```
A -- B -- C -- E -- D' (local/main, origin/main)

commit D' (commit ของเราที่ถูก rebase)
commit E (commit ของเพื่อน)
```

### ถ้าใช้ `git pull`

```
A -- B -- C -- E (origin/main)
        \    \
            D -- M (local/main)

commit M (merge commit)
commit D (commit ของเรา)
commit E (commit ของเพื่อน)
```

การใช้ `git pull --rebase` จะเอา change บนเครื่องเรา (commit D) ไปเพิ่มหลัง commit ล่าสุด จาก repository ถ้าเพิ่มไม่ได้เพราะติด conflict เราก็จะทำการแก้ conflict ที่ commit นั้นอันเดียว จากนั้นก็ rebase ต่อแล้วก็แก้ conflict จาก commit ถัดไปเป็นแบบนี้ไปจนจบ ซึ่งต่างจากการใช้ `git pull` ที่เราจะต้องแก้ conflict จากหลาย ๆ commit มารวมกันรอบเดียว ซึ่งเสี่ยงต่อการพลาดเยอะขึ้นนั่นเอง  

> ทั้งนี้ทั้งนั้นไม่ว่าจะใช้วิธีไหน หากเรา merge หรือ rebase นาน ๆ ครั้ง ปัญหาการ conflict ก็ยังคงเกิดอยู่ดี ดังนั้นเราควรจะต้องเอางานของเราไป integrate กับเพื่อนครั้งละเล็ก ๆ บ่อย ๆ (continuous integrate) เสมอ
