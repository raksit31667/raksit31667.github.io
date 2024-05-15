---
layout: post
title: "Syntax ที่ได้เรียนรู้จากการเขียน Makefile เพื่อ run script"
date: 2024-05-11
tags: [make, automation]
---

ช่วงที่ผ่านมาเราได้ลองใช้งาน [Make](https://makefiletutorial.com/) เพื่อ run คำสั่งต่าง ๆ ในการทำงานได้โดยจำแค่คำสั่ง `make` ตามด้วยชื่อคำสั่งย่อยที่ต้องการได้เลย ทีนี้ตอนจะสร้างมันก็จะมี syntax เฉพาะตัว ดังนั้นในบทความนี้จะจดไว้หน่อยว่าแต่ละอย่างมันแปลว่าอะไรเพื่อเพิ่มความเข้าใจในการเขียน Makefile ให้มากขึ้น

## .PHONY
แต่เดิม `Make` มีจุดประสงค์เดิมคือ run ชุดคำสั่งหรือ re-compile ส่วนของ code เมื่อมีการเปลี่ยนแปลงที่ file ที่กำหนดไว้เนื่องจาก code ใน file นั้นมี dependencies กับส่วนอื่น ๆ แต่เมื่อเวลาผ่านไปนักพัฒนาก็เอามาประยุกต์กับการ run ชุดคำสั่งโดยไม่ต้องขึ้นกับ file ใด ๆ จึงมีการกำหนด `.PHONY` หรือ `PHONY` ขึ้นมาเพื่อระบุว่าคำสั่งนี้ไม่ได้ขึ้นอยู่กับ file ใด ๆ ตัวอย่างเช่นเรามี `Makefile` หน้าตาประมาณนี้

```makefile
serve:
	echo "Serving HTTP server at http://localhost:4000" 
```

แล้วเรามี project structure ที่มี file ชื่อว่า `serve` หน้าตาประมาณนี้

```
├── Makefile
└── serve
```

เมื่อเรา run คำสั่ง มันจะขึิ้นมาประมาณนี้

```shell
$ make serve

make: `serve' is up to date.
```

เพราะว่าเรามี file ชื่อว่า `serve` อยู่นั่นเอง แต่ว่าคำสั่งของเราจริง ๆ แล้วมันไม่ได้ขึ้นกับ file ที่ชื่อว่า `serve` เลย ดังนั้นเราก็เลยต้องใส่ `.PHONY` เข้าไปประมาณนี้

```makefile
.PHONY: serve
serve:
	echo "Serving HTTP server at http://localhost:4000"
```

เมื่อเรา run คำสั่งใหม่ มันจะขึิ้นมาประมาณนี้

```shell
$ make serve

echo "Serving HTTP server at http://localhost:4000"
Serving HTTP server at http://localhost:4000
```

## @
จากหัวข้อก่อนหน้าจะสังเกตเห็นว่า output ของ console มันถึงออกมา 2 บรรทัด เพราะโดยปกติแล้ว `Make` จะ print คำสั่งออกมาด้วย แต่เผอิญคำสั่งเราดันเป็น `echo` ไง เพื่อไม่ให้เกิดเหตุการณ์นี้ขึ้นเราก็จะใช้ syntax `@` ในการปิดคำสั่งนั้นไม่ให้ print ออกมา ตัวอย่างเช่น

```makefile
.PHONY: serve
serve:
	@echo "Serving HTTP server at http://localhost:4000"
```

เมื่อเรา run คำสั่งใหม่ มันจะขึิ้นมาแค่บรรทัดเดียวละ

```shell
$ make serve

Serving HTTP server at http://localhost:4000
```

## Argument
ถ้าเราต้องการจะรับ argument เข้ามาจากคำสั่ง `Make` ก็รองรับนะ โดย `Makefile` จะออกมาหน้าตาประมาณนี้

```makefile
.PHONY: serve
serve:
	@echo "Serving HTTP server at http://localhost:${port}"
```

เมื่อเรา run คำสั่งใหม่ ก็จะได้ผลลัพธ์ประมาณนี้

```shell
$ make serve port=9999

Serving HTTP server at http://localhost:9999
```

## Variable
ถ้าเราต้องการจะประกาศ global varible เพื่อใช้ร่วมกันกับหลาย ๆ คำสั่งใน `Make` ก็สามารถทำได้ `Makefile` จะออกมาหน้าตาประมาณนี้

```makefile
DATE := $(shell date +%Y-%m-%d)

.PHONY: serve
serve:
	@echo "Serving HTTP server at http://localhost:4000 at ${DATE}"
```

เมื่อเรา run คำสั่งใหม่ ก็จะได้ผลลัพธ์ประมาณนี้

```shell
$ make serve port=9999

Serving HTTP server at http://localhost:4000 at 2024-05-11
```

ปล. ตัวแปรจะตัวเล็กตัวใหญ่ก็ได้นะ ไม่ได้มีผลอะไร

## Dependencies
ถ้าเรามีคำสั่งที่มี dependency เช่นต้อง run คำสั่งนึงก่อน-หลัง เราสามารถนำแนวคิดจากจุดประสงค์เดิมของ `Make` คือการ run คำสั่งของ file ที่มี dependencies กับอีก file นึงได้ เช่น คำสั่ง `serve` จะต้องรับ `port` argument มา แล้วเราอยากจะ check ว่า `port` มีค่าหรือเปล่า ใน `Makefile` ก็จะเขียนได้ประมาณนี้

```makefile
.PHONY: serve
serve: validate-port
	@echo "Serving HTTP server at http://localhost:${port}"

.PHONY: validate-port
validate-port:
	@if [ -z "$(port)" ]; then \
		echo "Please provide a port for the server"; \
		exit 1; \
	fi
```

ถ้าเราลอง run คำสั่งโดยไม่ส่ง port อะไรไปเลย ก็จะขึ้น error ประมาณนี้
```shell
$ make serve

Please provide a port for the server
make: *** [validate-port] Error 1
```
