---
layout: post
title: "แก้ปัญหา Go not found ใน Visual Studio Code"
date: 2024-04-15
tags: [go, visual-studio-code]
---

ช่วงนี้เป็นมือใหม่หัด(กลับมา)เขียนภาษา [Go](https://go.dev/) อีกครั้งจากการป้ายยาขนาดหนักของเพื่อน ๆ ที่บริษัทและคนใกล้ตัว รวมถึงงาน conference อย่าง [DevClub Tech Meetup - Programming Roadmap](https://www.youtube.com/watch?v=PrnT8sM4jts) ซึ่งก็พบว่าเดี๋ยวนี้เราสามารถเขียน Go บน [Visual Studio Code](https://code.visualstudio.com/) ได้สะดวกสบายเพียงแค่ติดตั้ง [extension ตัวเดียวจบ](https://marketplace.visualstudio.com/items?itemName=golang.Go)  

แต่ปรากฎว่ามันไม่จบน่ะสิ เนื่องจากว่าพอปิดแล้วเปิด editor ขึ้นมาใหม่ปรากฎว่ามันเกิด error ขึ้นมาประมาณนี้

![GOROOT missing](/assets/2024-04-15-goroot-missing.png)

ซึ่งสาเหตุหลักมันเกิดจากการ extension ไม่สามารถหา Go เจอใน path ซึ่งถ้าติดตั้งท่าปกติผ่าน [official website](https://go.dev/dl/) มันจะอยู่ใน `/usr/local/go` แต่เผอิญเราไปติดตั้งโดยใช้ Homebrew ทำให้ path มันไปอยู่ที่ `/opt/homebrew/bin/go` แทน ก็เลยเกิด error ดังกล่าวขึ้น  

วิธีแก้ก็คือไป configure `settings.json` ของ VSCode ด้วยการเพิ่ม `go.alternateTools` เข้าไปดังนี้

```json
    "go.alternateTools": {
        "go": "/opt/homebrew/bin/go"
    }
```

ซึ่งมันคือการ configure ให้ extension ไปใช้ Go executable file จาก Homebrew แทน เป็นอันจบ

> Alternate tools or alternate paths for the same tools used by the Go extension. Provide either absolute path or the name of the binary in GOPATH/bin, GOROOT/bin or PATH. Useful when you want to use wrapper script for the Go tools.

## References
- <https://github.com/golang/vscode-go/issues/971>