---
layout: post
title:  "สรุปแนวทางการลบ credentials ออกจาก Git (อย่างถาวร) จาก GitGuardian"
date:   2021-09-18
tags: [git, security]
---

เมื่อเราพูดถึง security หนึ่งในประเด็นที่ถูกยกมาคือ "credentials" ซึ่งจะมาในรูปของ password หรือ API key หรือ sensitive information เช่น เลขบัตรประชาชน เลขบัตร credit เป็นต้น ซึ่งมันก็ถูก hack ตามข่าวที่เราเห็นจนเป็นเรื่องชินตา ซึ่งหนึ่งในต้นเหตุง่ายๆ ก็มาจากการที่เราเก็บข้อมูลเหล่านี้ไว้ใน codebase ของเรานั่นแหละ  

ในบางครั้งเราไม่ได้ทำงานเพียงคนเดียว เราจำเป็นต้องใช้เครื่องมือในการบันทึก history หรือ resolve conflict ที่เกิดขึ้นระหว่าง codebase เช่น Git พอเราประมาทบันทึก credentials ลงใน history ด้วย น่าจะเป็นเรื่องที่ดีถ้าเรากลับเข้าไปแก้ไขนะ ดังนั้นเรามาว่ากันด้วยแนวทางการลบ credentials จาก Git history กันหน่อยตามบทความที่น่าสนใจจาก [GitGuardian](https://blog.gitguardian.com/rewriting-git-history-cheatsheet/) 

![GitGuardian cheat sheet](/assets/2021-09-18-git-credentials-cheat-sheet.png)

จากตาม diagram ข้างบนจะแบ่งแนวทางการแก้ปัญหาตามอาการจากเบาไปหนัก ให้เราดูว่าอาการของเราอยู่ที่ระดับไหน แล้วก็ประยุกต์การแก้ไปตามนั้นครับ

## ขั้นที่ 1: Push code ไปหรือยัง
- ถ้ายังก็อย่า push ครับ ฮ่าๆๆ แล้่วก็ไปดูขั้นต่อไปเลย
- ถ้า push ไปแล้ว ถ้าเราไม่ได้ share branch เรากับเพื่อนๆ ก็ไปดูขั้นต่อไปเลย

### อาการหนักสุด
ถ้า push ไปแล้ว แล้วเรา share branch นี้กับเพื่อนๆ หรือ change มันขึ้นไปถึง branch หลัก เช่น `master` หรือ `main` แล้ว สิ่งที่เราต้องทำเลยคือบอกเพื่อนร่วมทีม เพราะถ้าในระหว่างที่เราลบ credentials อยู่ เพื่อนๆ เราอาจจะ commit ทับมาทำให้ credentials กลับมาอีก ตัวอย่างแนวทางการจัดการก็อย่างเช่น

  - บอกให้เพื่อนๆ รีบ merge PR เข้า branch หลัก
  - บอกเพื่อนๆ ให้หยุด commit/push code ก่อน

เพื่อให้ sure ว่าเราลบ credentials ออกจากทุก branch ให้เราลบ codebase ปัจจุบันออกจาก local machine แล้ว clone ลงมาใหม่ทุก branch ทุก tags

```shell
$ git clone <repo-url> && cd <repo-name> && git pull --all --tags
```

สำหรับกรณีที่เพื่อนดัน push ขึ้นมาระหว่างที่เรากำลังลบ credentials แนะนำให้เพื่อน rebase commit ทิ้งไปก่อนเลย

```shell
$ git fetch
$ git rebase -i <branch-name>
```

## ขั้นที่ 2: Commit เราอยู่ตรงไหน

ถ้าเรายังไม่ได้ commit ใช้คำสั่ง `git stash` เพื่อเก็บไว้ใน local machine ของเราก่อน หรือถ้าเป็น file ก็เอาไปใส่ใน `.gitignore` ก่อน commit เพื่อเอา sure ว่าไม่ได้เอา credentials ขึ้น remote server ไปด้วย แต่ถ้า commit ไปแล้ว ก็ต้องมาดูว่ามันอยู่ที่ commit ไหน ถ้าอันล่าสุดก็ไม่ยากมากครับ เราจะใช้คำสั่งเพื่อ drop commit นั้นไปเลยก็ได้ 

```shell
$ git reset --hard HEAD~1
```

- แต่ถ้า commit นั้นมันมี change อื่นๆ ที่ไม่อยากจะ drop ไปด้วย แนะนำให้ลบ credentials แล้ว run คำสั่งเพื่อแก้ไข changeset โดยที่ยังเก็บ commit ไว้อยู่

```shell
$ git add <path-file-ที่เราลบหรือแก้ไป>
$ git commit --amend
```

- ถ้าไม่ได้อยู่ใน commit ล่าสุด การเข้าไป amend commit คงเป็นไปไม่ได้ แต่โชคดีที่เราสามารถใช้เครื่องมือ [git-filter-repo](https://github.com/newren/git-filter-repo) ซึ่ง[ได้รับการแนะนำโดยทีมพัฒนา Git เลย](https://git-scm.com/docs/git-filter-branch#_warning)  

ถ้า credentials เป็น file ทั้งดุ้น ให้ run คำสั่งนี้
```shell
$ git filter-repo --use-base-name --path <path-file-credentials> --invert-paths 
```

ถ้า credentials ไม่ได้อยู่ใน file ทั้งหมด เช่น hardcode ไว้ หรือไว้ใน configuration ถ้าเราจะลบทั้ง file ตามข้างบน code เราอาจจะมีปัญหาตอนเวลา compile หรือ run ได้ โดยขั้นแรกให้เราสร้าง text file ขึ้นมาก่อน แล้วให้เราใส่ว่าจะเปลี่ยน credentials จริงๆ ให้เป็น text ปลอมๆ ในรูปแบบของ `ORIGINAL==>REPLACEMENT` บรรทัดละ credentials เช่น

```text
ilovemyfamily007==>your-password
s13lvfdkvhigjbdp958==>your-api-key
...
```

จากนั้น run คำสั่งในการ replace credentials text โดยชี้ไปหา path ที่เราสร้าง text file ไว้
```shell
$ git filter-repo --replace-text <path-to-text-file> --force
```

หลังจากนั้นให้เรา force push ขึ้นไป **แต่ก่อนอื่น check ด้วยว่าเราไม่ได้ commit text file ที่เราสร้างไปด้วยนะ ฮ่าๆๆ**

```shell
$ git push --all --tags --force 
```

## วิธีป้องกัน
จะเห็นว่าวิธีการแก้ไขมันก็มีความซับซ้อนอยู่พอสมควรตามอาการ ดังนั้นเราน่าจะหาวิธีป้องกันไม่ให้เหตุการณ์มันเกิดขึ้นตั้งแต่แรกน่าจะดีกว่า เพราะถ้าเกิดขึ้นแล้วรู้ตัวช้า มันก็อาจจะสายเกินแก้ไปแล้ว สิ่งที่เราสามารถทำได้ก็อย่างเช่น

- ตรวจสอบ changeset ก่อน commit code ซึ่งก็อาจจะมาจาก peer review หรือ code review ก็ได้
- ติดตั้ง static code analysis เพื่อ scan หา credentials เครื่องมือที่มีก็อย่างเช่น [GitGuardian](https://www.gitguardian.com/) หรือ [truffleHog](https://github.com/trufflesecurity/truffleHog)
- เมื่อรู้ตัวแล้ว บอกเพื่อนร่วมทีมและคนที่เกี่ยวข้องให้เร็วที่สุด เพื่อช่วยกันหางทางแก้ไขต่อไป

> ใน repository ของเรามี credentials อยู่หรือเปล่านะ