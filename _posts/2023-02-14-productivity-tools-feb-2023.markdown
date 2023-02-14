---
layout: post
title: "รวบรวมเครื่องมือ Productivity ที่น่าสนใจในเดือนกุมภาพันธ์ 2023"
date: 2023-02-14
tags: [productivity]
---

ช่วงนี้เริ่มต้นเข้า project ใหม่เลยไม่ได้มาเขียน blog ใหม่เพิ่มเลยเนื่องจากกำลังเรียนรู้ context ใหม่ ๆ ที่จะเอามาเขียน blog ในอนาคต หนึ่งในนั้นก็คือเครื่องมือ productivity ใหม่ ๆ ที่จะมาช่วยทำให้กิจวัตรประจำวันของ Developer นั้นสะดวกสบายมากขึ้น มาดูกันว่ามีเครื่องมืออะไรน่าสนใจบ้าง

## git-extras
[git-extras](https://github.com/tj/git-extras) เป็นเครื่องมือที่รวมคำสั่งของ Git ที่ไม่มีในตัวดั้งเดิม ประโยชน์ก็คือลดจำนวนของคำสั่งที่ใช้ทำงานใด ๆ ลงไปเหลือเพียงแค่ 1 คำสั่งเท่านั้น ยกตัวอย่างเช่น การ set up Git repository ใหม่ใน directory ที่มีอยู่แล้วจะต้องใช้อย่างน้อย 3 คำสั่ง

```shell
$ git init
$ git add .
$ git commit --allow-empty -m "Initial commit"
```

แต่ถ้าเราใช้คำสั่งใน `git-extras` ก็จะเหลือแค่คำสั่งเดียว

```shell
$ git setup
```

นอกจากนี้ยังมีอีกหลายคำสั่งที่ถึงแม้จะไม่ได้ใช้ทุกวัน แต่มีไว้ก็ช่วยทุ่นแรงไปได้เยอะเหมือนกัน เช่น

- `git delete-tag`
- `git rename-branch`
- `git ignore-io`

มีข้อจำกัดนิดหน่อยคือบางคำสั่งจะทำมาสำหรับ GitHub โดยเฉพาะ ดังนั้นใครใช้ GitHub ก็จะได้ประโยชน์ในการใช้งานมากที่สุดนั่นเอง

## z
[z](https://github.com/rupa/z) เป็นคำสั่งที่ใช้ในการเปลี่ยน directory เกิดจากปัญหาที่ว่าคำสั่ง `cd` ที่มากับ Linux นั้นจะต้องจำ/หา directory ตั้งแต่ parent ลงไปเลย ยิ่งเราจะเข้าไปที่ directory ที่ลึกหลายชั้นมันมากเท่าไร เราก็อาจจะต้องจำ directory มากขึ้นเท่านั้น `z` สามารถแก้ปัญหานี้ได้โดยการที่มันจะจำ directory ที่เราเคยเข้าไปล่าสุด แล้วเราก็แค่ search โดยจำ keyword ของ directory ไว้ก็พอ เช่น เราจะเข้าไปที่ directory `path/to/work/repo/foobar` จากนั้นก็ไปที่ `path/to/personal/repo/fizzbuzz`

```shell
$ cd path/to/work/repo/foobar

$ pwd
path/to/work/repo/foobar

$ cd ../../personal/repo/fizzbuzz

$ pwd
path/to/personal/repo/fizzbuzz
```

ครั้งถัด ๆ ไปที่เราจะเข้า เราก็แค่ใช้คำสั่งนี้โดยที่ไม่ต้องจำหรือถอยหลังกลับไปที่ root directory เลย

```shell
$ z foobar

$ pwd
path/to/work/repo/foobar

$ z fizzbuzz

$ pwd
path/to/personal/repo/fizzbuzz
```

มีเครื่องมือที่คล้าย ๆ กันคือ [autojump](https://github.com/wting/autojump)

## tldr
[tldr](https://tldr.sh/) เป็นเครื่องมือช่วยแสดง documentation ของ Linux command ต่าง ๆ ที่เรียกว่า [man page](https://en.wikipedia.org/wiki/Man_page) ปัญหาของ man page คือมันอ่านค่อนข้างยากและบางคำสั่งก็ยาวมากกก `tldr` จึงมาแก้ปัญหานี้ด้วยการทำให้มันสั้นลงพร้อมกับมีตัวอย่างประกอบการใช้งานที่ดูเข้าใจง่ายขึ้น เช่นถ้าเราจะใช้คำสั่ง `lsof` (แสดง file ที่เปิดอยู่พร้อมกับ process ที่ใช้ในการเปิด) ก็สามารถเข้าไปอ่าน documentation ผ่านคำสั่ง `man` ตามนี้

```shell
$ man lsof

LSOF(8)                      System Manager's Manual                     LSOF(8)



NAME
       lsof - list open files

SYNOPSIS
       lsof [ -?abChHlnNOPQRtUvVX ] [ -A A ] [ -c c ] [ +c c ] [ +|-d d ] [ +|-D
       D ] [ +|-e s ] [ +|-E ] [ +|-f [cfgGn] ] [ -F [f] ] [ -g [s] ] [ -i [i] ]
       [ -k k ] [ -K k ] [ +|-L [l] ] [ +|-m m ] [ +|-M ] [ -o [o] ] [ -p s ] [
       +|-r [t[m<fmt>]] ] [ -s [p:s] ] [ -S [t] ] [ -T [t] ] [ -u s ] [ +|-w ] [
       -x [fl] ] [ -z [z] ] [ -Z [Z] ] [ -- ] [names]

DESCRIPTION
       Lsof revision 4.98.0 lists on its standard output file information about
       files opened by processes for the following UNIX dialects:

...
```

จะพบว่ามันยาวมาก ลองดูใน [web browser version](https://manned.org/lsof) ได้ว่ามันยาวขนาดไหน กลับกันถ้าใช้ `tldr` ดู

```shell
$ tldr lsof

lsof

Lists open files and the corresponding processes.
Note: Root privileges (or sudo) is required to list files opened by others.
More information: <https://manned.org/lsof>.

- Find the processes that have a given file open:
    lsof path/to/file

- Find the process that opened a local internet port:
    lsof -i :port

- Only output the process ID (PID):
    lsof -t path/to/file

- List files opened by the given user:
    lsof -u username

- List files opened by the given command or process:
    lsof -c process_or_command_name

- List files opened by a specific process, given its PID:
    lsof -p PID

- List open files in a directory:
    lsof +D path/to/directory

- Find the process that is listening on a local IPv6 TCP port and don't convert network or port numbers:
    lsof -i6TCP:port -sTCP:LISTEN -n -P
```

จะเห็นว่ามันสะดวกสบายขึ้นมาก เหมาะสำหรับ Developer ที่พัฒนา shell/bash script

> วิธีการติดตั้งอยู่ใน link ที่แนบไว้แล้ว ลองนำไปปรับใช้กันดูครับ