---
layout: post
title:  "บันทึกการแบ่งปัน Productivity tools สำหรับ macOS ให้กับคนในบริษัท"
date:   2020-11-22
tags: [productivity, iterm2, kubernetes]
---

เมื่ออาทิตย์ที่แล้วมีการจัด session ให้กับคนในบริษัทเกี่ยวกับ Productivity tools จากที่เคยแชร์ไปใน [blog]({% post_url 2020-04-05-intellij-presentation-assistant-plugin %}) ก่อนๆ ว่า การฝึกและเรียนรู้เครื่องมือผ่าน program หรือ shortcut ช่วยประหยัดเวลาให้กับเราเยอะมากๆ 

> เครื่องมือเหล่านี้ไม่จำเป็นจะต้องเป็นของใหม่ๆ เสมอไป ของที่ต้องใช้อยู่ทุกวันเช่น terminal หรือ web browser หรือ text editor หรือ IDE ถ้าฝึกใช้ให้คล่อง ก็มีประโยชน์มากๆ กับเราเช่นเดียวกัน

ในบทความนี้เราจะเน้นไปในส่วนของ terminal เป็นหลัก เพราะทีมที่แชร์มีขั้นตอนการทำงานที่คล้ายๆ กัน เช่น

- รัน Linux-based command (cd, ls, curl, grep, xargs)
- รัน Kubernetes command (get-context, set-context, switch-context)

เนื่องจากเวลาจำกัดที่ 1 ชั่วโมง จึงทำได้แค่แนะนำและช่วยติดตั้งเครื่องมือตาม 2 หัวข้อด้านบน

## เริ่มต้นจาก Terminal กันก่อน
ที่ให้ลองใช้เลยคือ [iTerm2](https://iterm2.com/) + [zsh](https://www.zsh.org/) + [oh-my-zsh](https://ohmyz.sh/) ซึ่งมี feature เจ๋งๆ (ในเว็บของ oh-my-zsh บอกว่าถ้าใช้แล้วจะต้องร้องว่า *"Oh My ZSH!"*) เช่น
- สามารถ customize shortcut และเก็บเป็น preset ของเราเผื่อ export ไปใช้กับเครื่องใหม่ได้
- สามารถ split จอแนวตั้ง-แนวนอนได้
- ลง plugin เช่น shorthand syntax หรือ autosuggestion
- ติดตั้ง alias เพื่อทำ custom shorthand syntax เช่น (`alias gp="git push -u origin master"`) เป็นต้น

![iTerm2 key bindings](/assets/2020-11-22-iterm2-key-bindings.png)

`oh-my-zsh` สามารถเลือก theme มาลงเพิ่มได้ด้วย เลือกตามชอบเลยครับ ผมใช้ของ [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)

## สำหรับ oh-my-zsh plugin ที่ใช้
สามารถเข้าไปเพิ่มใน `.zshrc` ได้ผ่าน editor

```sh
vi ~/.zshrc
```

ตัวที่เราแนะนำไปเบื้องต้นคือ git และ [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) โดยส่วนใหญ่แล้วเวลาลง plugin เราจะ clone repository ของ plugin มาไว้ใน `/Users/<your-username>/.oh-my-zsh/custom` จากนั้นเราก็จะมาเพิ่ม plugins ในไฟล์ `.zshrc` ตามนี้

<script src="https://gist.github.com/raksit31667/897faadf8ce14e7cd957064c6c300a2a.js"></script>

## ในส่วนของ Kubernetes
เบื้องต้นเราให้ลง tool ชื่อ [kubectx + kubens](https://github.com/ahmetb/kubectx) ใช้เพื่อ switch context ง่ายๆ โดยไม่ต้องพิมพ์ `kubectl config set-context my-context --cluster=my-cluster --namespace=my-namespace` ให้เมื่อย โดยมี 2 คำสั่งหลักคือ

- `kubectx` ใช้สำหรับดู context ทั้งหมด
- `kubectx <context-name>` ใช้สำหรับ switch context ไปที่ `<context-name>`

![kubectx](https://github.com/ahmetb/kubectx/raw/master/img/kubectx-demo.gif)  

![kubens](https://github.com/ahmetb/kubectx/raw/master/img/kubens-demo.gif)

ถ้าไม่อยากรัน 2 คำสั่ง maintainer เค้าแนะนำให้ลง `fzf` เป็น fuzzy search แบบ interactive mode
![fzf](https://github.com/ahmetb/kubectx/raw/master/img/kubectx-interactive.gif)

แต่ก็มีความขี้เกียจต่อว่า อยากดู Kubernetes context โดยไม่ต้องรัน `kubectx` เจ้า [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) เค้ามีมาให้ครับ โดยจะต้องเพิ่ม `SPACESHIP_KUBECTL_SHOW=true` ลงไปในไฟล์ `.zshrc` (ดูตาม gist ข้างบนได้) ผลลัพธ์ที่ได้ก็จะมีหน้าตาประมาณนี้

![Spaceship K8S show](/assets/2020-11-22-spaceship-k8s-show.png)

## Productivity tools ตัวอื่นๆ ที่ไม่ได้แชร์ใน session
- [Homebrew](https://brew.sh/) package manager ของ macOS
- [Vimium](https://vimium.github.io/) chrome/firefox extension ที่ใช้ browser ผ่าน keyboard เช่น กด hyperlink หรือ scroll page
- [JSONView](https://jsonview.com/) ดู JSON ที่ beautify ผ่าน browser

> ลองไปใช้กันดูครับ มีประโยชน์มากๆ
