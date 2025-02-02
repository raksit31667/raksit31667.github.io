---
layout: post
title: "ว่าด้วยเรื่องของ path traversal attack"
date: 2025-01-28
tags: [path-traversal, security]
---

เมื่อปีที่แล้ว application ที่ run อยู่ใน platform ที่เราพัฒนาเจอช่องโหว่ด้าน security โดยใช้ path traversal attack ทีแรกเราก็เคยได้ยินผ่าน [OWASP](https://owasp.org/www-community/attacks/Path_Traversal) แต่ไม่เคยรู้มาก่อนว่าเขามีวิธีการโจมตีอย่างไร หรือแม้กระทั่งว่าแนวทางการโจมตีมันมีรากฐานมาจาก "**งานด้านการทหารและหน่วยข่าวกรอง**" ด้วย

## Path traversal คืออะไร

Path traversal หรือ Directory traversal เป็นช่องโหว่ของ web application ที่เกิดจากการโจมตีผ่าน HTTP ทำให้ผู้ไม่หวังดีสามารถเข้าถึง file หรือ folder ที่ไม่ได้รับอนุญาต ลองนึกภาพตามแบบง่าย ๆ 

> เหมือนกับอาคารที่มีบางชั้นที่อนุญาตให้พนักงานบางคนเท่านั้นเข้าไปได้ แต่ถ้ามีช่องโหว่ของระบบรักษาความปลอดภัย คนก็อาจใช้ทางออกฉุกเฉินหรือบันไดหนีไฟเพื่อเข้าไปในชั้นนั้น ๆ ได้  

ซึ่งอาจนำไปสู่
  
- การเปิดเผยข้อมูล login
- เข้าถึง file สำคัญ  
- สั่ง run code ที่อันตรายต่อระบบ เช่น Remote Code Execution (RCE)  
- ได้สิทธิ์เป็นผู้ใช้ระดับสูง (privilege escalation)  
- เปิด reverse shell เพื่อควบคุม server

Path traversal นั้นเป็นการโจมตีที่อยู่ได้ในหลาย ๆ stage ของ life cycle ในการโจมตี ไม่ว่าจะเป็น

- Reconnaissance (สำรวจจลาดตระเวนเพื่อเก็บรวบรวมข้อมูล)
- Exploitation (เปิดเผยช่องโหว่)

จากนั้นก็จะนำไปสู่การโจมตีในรูปแบบอื่น ๆ ที่อยู่ใน stage ต่าง ๆ เช่น

- Command & Control (ควบคุมเครื่องผ่าน remote หรือ reverse shell)
- Actions on Objective (โจมตีเป้าหมายด้วยวิธีการต่าง ๆ เช่น privilege escalation หรือ reverse shell)

![Cybersecurity attack life cycle](/assets/2025-01-28-stages-of-cyber-attack-lifecycle.png)
<https://securitytrails.com/blog/privilege-escalation>

## เครื่องมือสำหรับจำลองการโจมตี  
- [FFUF (Fuzz Faster U Fool)](https://github.com/ffuf/ffuf)  
- [gobuster](https://github.com/OJ/gobuster)  
- [dirbuster](https://www.kali.org/tools/dirbuster/)
- [Burp Suite](https://portswigger.net/burp)  

โดยเครื่องมือเหล่านี้ก็จะมาพร้อมกับ mode การโจมตีหลากหลายรูปแบบ อย่างของ Burp Suite ก็จะมี  

- **Sniper**: เล็งเป้าหมายเฉพาะเจาะจง  
- **Battering Ram**: โจมตีซ้ำ ๆ ที่จุดเดิม (brute-force)  
- **Pitchfork**: โจมตีหลายจุดพร้อมกันในเวลาเดียวกัน  
- **Cluster Bomb**: ยิงโจมตีแบบสุ่มหลายจุด  

## Demo จำลองการโจมตี Path traversal  
ในตัวอย่างเราจะมาดูกันว่าการโจมตีด้วย **Path traversal** มันทำงานอย่างไร โดยที่เราจะเตรียม environment ไว้ดังนี้

- Application ที่พัฒนาด้วย [Flask](https://flask.palletsprojects.com/en/stable/) โดยมี API endpoint `GET /read_file`
- FFUF เป็นเครื่องมือสำหรับจำลองการโจมตี
- LFI Wordlist หรือ list ที่รวม path ที่ใช้โจมตีระบบโดย download file จาก server ของ web app ขึ้นมาอ่าน (Local File Inclusion) โดยเราจะเอา list มาจาก [SecLists: LFI Wordlists](https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/LFI/LFI-Jhaddix.txt)  

### เริ่มจากเขียน Flask application ขึ้นมา

<script src="https://gist.github.com/raksit31667/57b84ac791928f0f83df2cc75323b3be.js"></script>

จะเห็นว่า code ตัวอย่างของ Flask มีช่องโหว่ เนื่องจากการนำ input ที่รับมาจาก user (file parameter) มาใช้โดยตรงโดยไม่มีการตรวจสอบและป้องกัน

- `filename` มาจาก `request.args.get("file")` ซึ่งสามารถถูกแก้ไขให้มี `..` หรือ `/` เพื่อออกนอก `BASE_DIR` ได้
- `os.path.join(BASE_DIR, filename)` แค่นำ string มาต่อกันโดยไม่ได้ตรวจสอบว่า path ที่ได้ยังอยู่ใน `BASE_DIR` หรือไม่

### ต่อมาก็ run application server
หลังจากที่เขียน application code เรียบร้อย ก็ติดตั้ง dependencies แล้ว run application server บน local environment ของเรา  

```bash
$ pip install flask

$ python /path/to/app.py
```

### จำลองการโจมตีด้วย FFUF
ติดตั้ง [FFUF](https://github.com/ffuf/ffuf) จากนั้นใช้คำสั่งเพื่อเข้าไป request API ด้วย file path จาก wordlist ที่เรา download มา  ซึ่งจากระบบที่เรา set up ไว้ เราสามารถส่ง API request `GET /read_file` โดยใช้ค่า file ที่ออกนอก folder `BASE_DIR` ได้ เช่น

```bash
# Server อ่าน ./files/test.txt ปกติ ✅
$ curl "http://127.0.0.1:6000/read_file?file=test.txt"

# Server อ่าน /etc/passwd (file ระบบของ Linux) เป็นช่องโหว่ ❌
$ curl "http://127.0.0.1:6000/read_file?file=../../etc/passwd"

# ใช้ URL encoding อ่าน /etc/passwd (file ระบบของ Linux) เป็นช่องโหว่ ❌
$ curl "http://127.0.0.1:6000/read_file?file=..%2F..%2F..%2Fetc%2Fpasswd" 
```

ด้วยความที่ wordlist มันเยอะมาก เราก็ใช้ FFUF เอา wordlist เหล่านี้มา request API แบบสุ่ม ๆ (fuzzing) โดยตัวอย่างนี้เราก็ไม่ต้องสุ่มเยอะแยะ ใช้รูปแบบ **Sniper** เพื่อเล็งเป้าหมายเฉพาะเจาะจงยิงไปทีละ path เลย โดยแต่ละ path จะเข้าไปแทนที่คำว่า `FUZZ` ในคำสั่งนั่นเอง

```console
➜ ffuf -u http://127.0.0.1:6000/read_file\?file\=FUZZ -w path/to/wordlist.txt

        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://127.0.0.1:6000/read_file?file=FUZZ
 :: Wordlist         : FUZZ
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 23ms]
/etc/apache2/httpd.conf [Status: 200, Size: 21648, Words: 2523, Lines: 558, Duration: 20ms]
/etc/group              [Status: 200, Size: 3824, Words: 42, Lines: 168, Duration: 20ms]
/etc/hosts              [Status: 200, Size: 365, Words: 57, Lines: 14, Duration: 24ms]
/etc/hosts.equiv        [Status: 200, Size: 0, Words: 1, Lines: 1, Duration: 22ms]
/./././././././././././etc/passwd [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 22ms]
/../../../../../../../../../../etc/passwd [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 22ms]
/etc/passwd             [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 22ms]
/etc/resolv.conf        [Status: 200, Size: 386, Words: 54, Lines: 18, Duration: 19ms]
/etc/rpc                [Status: 200, Size: 1735, Words: 74, Lines: 74, Duration: 21ms]
/etc/syslog.conf        [Status: 200, Size: 96, Words: 11, Lines: 4, Duration: 18ms]
/etc/ssh/sshd_config    [Status: 200, Size: 3517, Words: 342, Lines: 124, Duration: 19ms]
///////../../../etc/passwd [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 19ms]
:: Progress: [929/929] :: Job [1/1] :: 0 req/sec :: Duration: [0:00:00] :: Errors: 0 ::
```

จาก output จะสังเกตเห็นว่าเราสามารถเปิดช่องโหว่ได้จากหลากหลาย path เลย (HTTP status 200)

### วิธีอุดช่องโหว่
วิธีแก้ไขก็ตามปัญหาที่เกิดขึ้นเลย ก็คือ**ตรวจสอบ path ว่ามันพยายามจะออกนอก folder** (`BASE_DIR`) ที่กำหนดไว้หรือเปล่า

<script src="https://gist.github.com/raksit31667/4d506cee48dbf8b31475c7a91afbb722.js"></script>

ลอง run ใหม่

```console
➜ ffuf -u http://127.0.0.1:6000/read_file\?file\=FUZZ -w path/to/wordlist.txt

        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://127.0.0.1:6000/read_file?file=FUZZ
 :: Wordlist         : FUZZ
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd [Status: 200, Size: 9050, Words: 229, Lines: 139, Duration: 23ms]
/etc/apache2/httpd.conf [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/group              [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/hosts              [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/hosts.equiv        [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/./././././././././././etc/passwd [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/../../../../../../../../../../etc/passwd [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/passwd             [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/resolv.conf        [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/rpc                [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/syslog.conf        [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
/etc/ssh/sshd_config    [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
///////../../../etc/passwd [Status: 403, Size: 13, Words: 2, Lines: 1, Duration: 19ms]
:: Progress: [929/929] :: Job [1/1] :: 0 req/sec :: Duration: [0:00:00] :: Errors: 0 ::
```

จาก output ที่ได้จะสังเกตว่าทุก path ที่ส่ง request ไปจะได้ HTTP response 403 แปลว่าเราสามารถป้องกันระบบจากการโจมตีได้นั่นเอง 

---

## สรุป  
Path traversal เป็นการโจมตีช่องโหว่เพื่อเข้าถึง file สำคัญหรือ run คำสั่งอันตรายได้ โดยมีแนวทางการโจมตีหลากหลายแบบด้วยเครื่องมือหลากหลายตัวอย่าง FFUF การทำความเข้าใจกับมันจะช่วยให้เราสามารถป้องกันและลดความเสี่ยงของระบบได้ดียิ่งขึ้น  

จะสังเกตว่าในบทความนี้เราได้พูดถึงศัพท์เฉพาะหลาย ๆ อันที่อาจจะพบเห็นได้ในหนังสงคราม หรือข่าวการทหาร เพราะจริง ๆ แล้ว เรื่องของ Cybersecurity มีรากฐานมาจากงานด้านการทหารและหน่วยข่าวกรอง ตั้งแต่ยุคแรก ๆ นักพัฒนาและผู้เชี่ยวชาญด้านความปลอดภัยหลายคนก็มีพื้นฐานจากกองทัพหรือหน่วยงานรัฐบาล ทำให้มีการนำแนวคิดทางการทหารมาใช้ รวมถึงคำศัพท์ต่างๆ ที่เกี่ยวข้องนั่นเอง
