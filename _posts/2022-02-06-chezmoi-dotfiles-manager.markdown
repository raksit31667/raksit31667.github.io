---
layout: post
title:  "ลดเวลาการ setup บนคอมใหม่ด้วย Chezmoi"
date:   2022-02-06
tags: [productivity, chezmoi]
---

## ปัญหาที่เกิดขึ้น
หนึ่งในข้อเสียในการทำงานบริษัทคือ อุปกรณ์ที่เราได้มาเป็นของบริษัททั้งหมด แน่นอนว่าเราคงหนีไม่พ้นการเปลี่ยนเครื่องไปมา หรือต้อง reset ใหม่ ซึ่งเป็นงานที่เหนื่อยหน่ายมาก โดยเฉพาะ developer เพราะต้องมาจดจำว่า

- ลง application อะไรไปบ้าง
- ลง dependency, plugins อะไรไปบ้าง
- ทำการ configure script อะไรไว้บ้าง

นั่นหมายความว่า เราจะต้องมาทำสิ่งเหล่านี้ซ้ำซาก บางทีลืมไปอย่างนึงปุ๊บ เครื่องใหม่เราก็ run ไม่ได้เหมือนอย่างเก่า ไม่ใช่แค่การย้ายเครื่องของเราคนเดียว ยังรวมถึงการที่ developer คนใหม่เข้ามาร่วมทีม การที่พวกเค้าจะต้องมาติดตั้งที่มีขั้นตอนเยอะแยะซ้ำซากก็บั่นทอน productivity ได้เหมือนกัน  

ถึงแม้ต้นเหตุมันก็เป็นที่ตัวเราที่ลืม การหาวิธีแก้หรือเครื่องมือที่มาช่วยแก้ลืมให้เรามันก็เป็นเรื่องที่ดีนะ  

## วิธีแก้
- จดไว้ในเอกสาร หรือทำ `README.md` ไว้บน internet (เช่น Git หรือ Cloud) -> update บ่อยแค่ไหน เชื่อถือได้หรือไม่
- เตรียม shell script ไว้ติดตั้ง -> update บ่อยแค่ไหน shell script ทำงานถูกต้องหรือไม่
- ใช้เครื่องมือช่วยติดตั้ง

ในบทความนี้ เราจะมาว่าด้วยเรื่องของเครื่องมือกัน

## ทำความรู้จักกับ dotfiles
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) ก็คือ file ที่มี `.` นำหน้า เช่น `.bash_profile` `.zshsrc` `.gitconfig`  ซึ่งเราจะหาผ่าน Finder ไม่เจอ โดยที่ file พวกนี้แหละ ที่เราต้องการที่จะ upload ขึ้นไป เช่นบน Git จากนั้นในอีกเครื่องนึง เราก็จะทำการ download file พวกนี้ลงมาติดตั้งใน `$HOME` directory  

ซึ่ง dotfiles ก็ช่วยแก้ปัญหาข้างบนได้หมด สิ่งที่ยังเป็นปัญหาอยู่คือ ถ้าเราต้องการที่จะเก็บ credentials ก็ไม่ปลอดภัยบน Git นอกจากนั้นถ้าเรามี configuration ที่ต่างกันในแต่ละเครื่อง เราก็ต้องมาเตรียม file แยก แม้ว่าจะต่างกันแค่บรรทัดเดียว

## จัดการ dotfiles ด้วย Chezmoi
Chezmoi เป็นเครื่องมือที่จัดการ dotfiles ซึ่งมีจุดขายคือ
- รองรับการทำงานกับหลาย operating system เช่น Linux, macOS, Windows
- มีความปลอดภัย เพราะสามารถทำงานร่วมกับ password manager ได้
- สามารถตรวจสอบการเปลี่ยนแปลงก่อน apply dotfiles ลงไป
- สามารถใช้งานกับ file และ directory และ symlink ได้

ตัวอย่างเช่น เราใช้ macOS ซึ่งต้องการจะย้ายไป setup อีกเครื่องนึง โดยสิ่งที่ต้องย้ายไปคือ
- Oh My Zsh plugins & theme ก็จะเก็บไว้ใน `.oh-my-zsh` และ `.zshrc`
- Homebrew formula & casks

### Upload dotfiles จากเครื่องเดิม
สิ่งที่เราต้องติดตั้งไว้ก่อนในเครื่องเดิม ได้แก่
- Homebrew ซึ่งจากตัวอย่างคือมีอยู่แล้ว
- Git ซึ่งสามารถใช้คำสั่ง

```shell
$ xcode-select --install
```

ติดตั้ง Chezmoi ผ่าน Homebrew

```shell
$ brew install chezmoi
```

จากนั้นทำการตั้ง repository สำหรับเก็บ dotfiles ด้วยคำสั่ง

```shell
$ chezmoi init
```

ซึ่ง repository ใหม่จะถูกสร้างไว้ใน `~/.local/share/chezmoi/` เราสามารถเข้าไป directory โดยตรงผ่านคำสั่ง

```shell
$ chezmoi cd
```

สมมติเราจะเพิ่ม file ใหม่เข้าไป เช่น `.zshrc` ก็สามารถทำได้เลยผ่านคำสั่ง

```shell
$ chezmoi add ~/.zshrc
```

โดย Chezmoi จะทำการ copy `~/.zshrc` ไปไว้ใน `~/.local/share/chezmoi/dot_zshrc` (สังเกตว่าชื่อ file จะเปลี่ยนไป)

จากนั้นเราสามารถแก้ไข file นี้ได้่ผ่านคำสั่ง

```shell
$ chezmoi edit ~/.zshrc
```

สำหรับตัว Oh My Zsh รวมถึง plugin และ theme นั้น จะถูกเก็บไว้ใน `~/.oh-my-zsh` directory เราสามารถ export Oh My Zsh ออกมาได้ผ่านคำสั่ง

```shell
$ chezmoi add -r --exact ~/.oh-my-zsh
```

โดย Chezmoi จะทำการ copy `~/.zshrc` ไปไว้ใน `~/.local/share/chezmoi/exact_dot_oh-my-zsh`

สำหรับ Homebrew เราจะต้องสร้าง `Brewfile` ซึ่งประกอบไปด้วยชื่อของ formula และ casks เราสามารถ generate ได้ผ่านคำสั่ง

```shell
$ chezmoi cd
$ brew bundle dump
```

ดู change ของ file เมื่อเทียบของเดิมผ่านคำสั่ง

```shell
$ chezmoi diff
```

เมื่อเราโอเคกับ change แล้วเราก็ run คำสั่งเพื่อบันทึกและเอาขึ้น Git repository เช่น GitHub เป็นอันเสร็จสิ้น

```shell
$ chezmoi -v apply

$ chezmoi cd

$ git add .
$ git commit -m "Initial commit"
$ git remote add origin https://github.com/username/dotfiles.git
$ git branch -M main
$ git push -u origin main
```

### Download dotfiles จากเครื่องใหม่

สิ่งที่เราต้องติดตั้งไว้ก่อนในเครื่องใหม่ ได้แก่
- Homebrew
- Git ซึ่งสามารถใช้คำสั่ง

```shell
$ xcode-select --install
```

ติดตั้ง Chezmoi ผ่าน Homebrew

```shell
$ brew install chezmoi
```

จากนั้น download dotfiles ที่เครื่องเก่าของเราเอาขึ้นไปไว้ผ่านคำสั่ง

```shell
$ chezmoi init https://github.com/username/dotfiles.git
```

ดู change ของ file เมื่อเทียบของเดิมผ่านคำสั่ง

```shell
$ chezmoi diff
```

เมื่อเราโอเคกับ change แล้วเราก็ run คำสั่งเพื่อบันทึก จากนั่นเข้าไปดู file ที่ apply ลงไป ก็เป็นอันเสร็จสิ้น

```shell
$ chezmoi apply -v

$ cat ~/.zshrc
$ ls ~/.oh-my-zsh
```

แต่ถ้าเราอยากแก้ไข file ก่อนที่จะ apply เราก็สามารถทำได้ ผ่านคำสั่ง

```shell
$ chezmoi edit <file>
```

ทีนี้ถ้า dotfiles repository มีการ update เราก็สามารถ update เข้าเครื่องเราได้ผ่านคำสั่ง

```shell
$ chezmoi update -v
```

### จัดการ config ที่ต่างกันด้วย template file
ยกตัวอย่างเช่น เรามี file `.gitconfig` ซึ่งในเครื่องแต่ละคนก็จะมีค่าต่างกัน เช่น developer และ QA

```properties
[user]
    email = "developer@example.com"
```

```properties
[user]
    email = "qa@example.com"
```

สิ่งที่ต้องเตรียมในแต่ละเครื่องคือ ให้สร้าง file `~/.config/chezmoi/chezmoi.toml` ผ่านคำสั่ง

```shell
$ chezmoi edit-config
```

จากนั้นเพิ่ม properties ชื่อ `email` ลงไป ซึ่ง value ของแต่ละเครื่องก็จะมีค่าต่างกัน อย่างเช่นในเครื่อง developer

```properties
[data]
    email = "developer@example.com"
```

ปิดท้ายด้วยการเพิ่ม `~/.gitconfig` ลงไปให้กลายเป็น template file ผ่านคำสั่ง

```shell
$ chezmoi add --autotemplate ~/.gitconfig
```

Chezmoi จะทำการสร้าง `~/.local/share/chezmoi/dot_gitconfig.tmpl` ไว้ ทีนี้ถ้าคนอื่นอยากใช้ template file นี้ก็เพียงแค่เตรียม 
`~/.config/chezmoi/chezmoi.toml` ไว้ แล้วก็ download dotfiles repository มา apply เป็นอันเสร็จสิ้น  

นอกจากนั้นยังสามารถสร้าง template ที่มี condition ขึ้นอยู่กับ operating system ได้ด้วย สามารถดูได้เพิ่มเติมที่ <https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/>

### การใช้งานกับ password manager
Chezmoi รองรับการทำงานร่วมกับ password manager ต่างๆ เช่น 1Password หรือ Bitwarden เพื่อใช้จัดการกับการเก็บ credentials เช่น เรามี template file ที่ระบุ UUID ของ 1Password item ไว้ เพียงแค่เราเชื่อมต่อ 1Password CLI ตอนเรา download dotfiles repo ลงมา มันก็จะ apply ให้เลย สามารถดูเพิ่มเติมได้ที่ <https://www.chezmoi.io/user-guide/password-managers/>

> Chezmoi มี use case ต่างๆ อีกมากมายที่เรายังไม่ได้ลองอีกมากมาย จากการใช้งานเบื้องต้นแค่นี้ โดยรวมแล้วก็ถือเป็นเครื่องมือที่ช่วยลดเวลาการ setup บนคอมใหม่ไปได้เยอะครับ