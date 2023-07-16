---
layout: post
title: "จดวิธีการปิดไม่ให้ Global Protect VPN run เองทุกครั้งที่เปิดเครื่อง macOS"
date: 2023-07-16
tags: [vpn, tools]
---

มีโอกาสได้ไปงานกับลูกค้าหลาย ๆ เจ้า พบว่าแต่ละองค์กรเค้าจะมีการติดตั้ง Virtual private network (VPN) เพื่อป้องกัน hacker เข้ามาโจมตีหรือดึงข้อมูลสำคัญของบริษัทออกไปโดยที่ client ใช้ internet ข้างนอกเชื่อมเข้ามา ถือว่าพัฒนาจากแต่ก่อนที่จะต้องเข้าไป office ลูกค้าเพื่อต่อ Local area network (LAN) หรือ Wi-fi ก็ว่ากันไป  

ทีนี้หนึ่งใน VPN client ก็คือ [Palo Alto Global Protect VPN](https://www.paloaltonetworks.com/sase/globalprotect) ที่มันมีปัญหาอยู่ว่าเวลาเราเปิดเครื่องขึ้นมา มันจะเปิดขึ้นมาอัตโนมัติ (auto startup) บางทีก็เชื่อมต่อ VPN ให้เลยด้วยซ้ำทั้งที่เราไม่ต้องการ ดูเหมือนจะง่ายแต่เวลาเข้าไปดูแล้วคือ

1. ไม่มีปุ่มให้กดออก ต้องไปออกผ่าน Activity monitor
2. ไม่มีตัวเลือกให้ปิด auto startup

เผอิญเราไปเจอวิธีแก้มาจาก <https://www.blackmanticore.com/4b3f8b4ed7f4eca749549d5f520c5a00> แต่เพื่อความขี้เกียจค้นหาแล้ว ก็เลยจดไว้ใน blog นี้อีกทีละกัน  

โดยปกติแล้ว macOS จะใช้ Launch agent ในการควบคุม auto startup ซึ่งจะมี configuration file อยู่ในรูปแบบ XML file ที่มีสกุล `.plist` นั่นหมายความว่าเราต้องเข้าไปแก้ configuration เหล่านี้ได้ โดย file เหล่านี้จะอยู่ใน directory `/Library/LaunchAgents` ดังนั้นเราจะเริ่มกันที่จุดนี้

1. ลอง list file ทั้งหมดใน `/Library/LaunchAgents` เราควรจะเจอ file ที่ชื่อว่า `com.paloaltonetworks.gp.pangpa.plist`
2. จากนั้นให้เข้าไปแก้ไข file `com.paloaltonetworks.gp.pangpa.plist` โดยใช้ root access (`sudo` command)

    ```shell
    $ sudo vi /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plis
    ```

3. พอเข้าไปแล้วให้ค้นหา parameter ส่วน `RunAtLoad` และ `KeepAlive` แล้วให้เปลี่ยนค่าจาก `<true/>` เป็น `<false/>`

    ```xml
    <key>RunAtLoad</key>
    <!--แก้บรรทัดข้างล่างเป็น false-->
    <false/>
    <key>KeepAlive</key>
    <false/>
    ```

4. จากนั้นให้ save file ก็เป็นอันเสร็จ จะพบว่าตัว VPN client จะไม่ auto startup แล้ว