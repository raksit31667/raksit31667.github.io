---
layout: post
title:  "สรุปสิ่งที่น่าสนใจจาก session Accessibility APIs in Android"
date:   2022-12-21
tags: [accessibility, android, user-experience]
---

เมื่ออาทิตย์ที่แล้วเราได้มีโอกาสไปเข้า lunch & learn session เกี่ยวกับ **Accessibility APIs in Android** ซึ่งโดยส่วนตัวแล้วตัวเองไม่มีประสบการณ์เกี่ยวกับการพัฒนา Android สักเท่าไร (ตั้งแต่เรียนจบมหาลัย) แต่ก็ได้เรียนรู้ tips & tricks ที่มีประโยชน์เอาไปต่อยอดกับงานแบบ frontend web development ได้เช่นกัน ลองไปดูกันว่าเราจะสามารถปรับปรุง accessibility ใน frontend ได้อย่างไรกันบ้าง

## More margin/padding
Margin และ Padding ก็คือช่องว่างระหว่างแต่ละชิ้น (element) ของ user interface (UI) ในหน้าจอของเราเพื่อไม่ให้แต่ละชิ้นมันอยู่ติดกันมากจนเกินไป ปัญหาก็คือถ้าตัวหนังสือมันอยู่ชิดขอบมากจนเกินไป ก็จะทำให้อ่านตัวหนังสือยากขึ้น หรือถ้าเรามีปุ่มอยู่ใกล้ ๆ กับอีกปุ่มนึง ซึ่งทำหน้าที่ต่างกัน (เช่น confirm/decline) แต่ปุ่มมี padding น้อย ก็มีโอกาสที่เราจะกดไปโดนอีกปุ่มโดยไม่ได้ตั้งใจ การมี margin และ padding ที่เหมาะสมก็จะทำให้แก้ปัญหาที่ว่ามาได้

![Material design padding](/assets/2022-12-30-material-design-padding.png)

<https://m2.material.io/design/usability/accessibility.html#layout-and-typography>

## Don't use only colors as means of communication
สีสามารถสื่อถึงอารมณ์และความหมายได้ ทำให้ผู้ใช้งานเข้าใจถึงแนวทางการใช้งานของระบบเรา เช่น สีปุ่มที่ต่างกันของ Yes/No ปัญหาก็คือหากเลือกสื่อผ่านสีอย่างเดียวรวมไปถึงการเลือกสีที่อาจจะไม่ได้ต่างกันอย่างชัดเจนมาก (contrast ต่ำ) ก็มีโอกาสที่ผู้บกพร่องทางสายตา (เช่น ตาบอดสี) ที่จะเข้าใจผิดได้ ดังนั้นหากเป็น action สำคัญเราควรจะมีรูป icon หรือตัวหนังสือเพื่อสื่อความหมายให้ชัดเจนอีกที  

ลองใช้งาน [Contrast checker](https://webaim.org/resources/contrastchecker/) สำหรับการเลือกใช้สีในระบบเราดูครับ

![Use color only](/assets/2022-12-30-use-only-color.svg)

<https://developer.android.com/guide/topics/ui/accessibility/principles#cues-other-than-color>

## Label images
เกริ่นก่อนว่าโดยปกติแล้วคนพิการทางสายตาจะใช้ screen reader ที่จะทำงานในรูปแบบ (HTML)text-to-speech ลักษณะตาม clip นี้

<iframe width="560" height="315" src="https://www.youtube.com/embed/dEbl5jvLKGQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

ทีนี้ถ้าเราไม่ใส่ label (alt text) ในรูป ตัว screen reader ก็ไม่สามารถอ่านรูปมาเป็นเสียงได้ ซึ่งอาจจะทำให้ผู้ใช้งานเข้าใจผิดหรือเข้าใจไม่ครบถ้วนตามที่เราต้องการจะสื่อ หลาย ๆ website จึงมี feature ในการเพิ่มคำอธิบาย หรือ caption ของรูปลงไปด้วยนั่นเอง

## Skip unnecessary elements for screen reader to navigate faster
ในบางครั้งเรามี element ในหน้าจอเราเยอะมาก ๆ ด้วยความที่เราไม่บกพร่องทางสายตาเราก็เลยไม่รู้สึกอะไรมากมาย แต่ถ้าเราบกพร่องขึ้นมาจะพบว่า element เยอะ ๆ เหล่านี้คืออุปสรรคในการใช้งานอย่างมาก เพราะต้องใช้เวลานานขึ้นกว่า screen reader จะอ่านทุก element ไปถึงอันที่เราต้องการ การที่เราลด element ที่ไม่จำเป็นลงหรือรวมกลุ่มกัน (เช่น element ประเภท Lists) ก็ทำให้การใช้งานง่ายขึ้นตามไปด้วยเพราะไม่ต้องกดบ่อย ๆ ครั้ง

![Screen reader documentation](/assets/2022-12-30-screen-reader-documentation.png)

<https://bbc.github.io/accessibility-news-and-you/guides/screen-reader-ux.html>

## Let accessibility services knows an action can be performed
ในแต่ละ platform จะมีบริการสำหรับ accessibility โดยเฉพาะ (accessibility services) สำหรับ Android ก็จะมี

- **TalkBack**: สำหรับ screen reader
- **BrailleBack**: สำหรับแสดงผลออกมาเป็นตัวอักษร Braille
- **VoiceAccess**: สำหรับสั่งงานด้วยเสียง

จากนั้นดูว่าระบบของเรามี feature ที่สามารถใช้งานผ่าน accessibility services ที่มีอยู่ได้ไหม ถ้ามีให้เราผูกระบบให้ไปเรียก accessibility services นั้น ๆ ได้เลย

## Tell the screen reader about state changed by interaction 
ระบบของเราควรจะบอก screen reader ว่าหลังจากที่ผู้ใช้งานได้ทำ action บางอย่างไป มันเกิดอะไรขึ้นบ้าง ตัวอย่างก็อย่างระบบเราคือ application สำหรับฟัง podcast ที่รองรับสำหรับผู้บกพร่องทางสายตา ทีนี้หลังจากผู้ใช้งานเพิ่ม-ลดเสียง เราก็ให้ screen reader บอกว่าตอนนี้เสียงดังอยู่ที่กี่ percent เช่น 80% เป็นต้น

## Don't reinvent the wheel (e.g. make custom UI element)
Element บางอย่างมันรองรับ accessibility ด้วยของมันเองอยู่แล้ว ดังนั้นหลีกเลี่ยงการทำ element ใหม่เองเพราะมันอาจจะไม่รองรับ accessibility บางตัวก็ได้

![Accessibility custom element](/assets/2022-12-30-accessibility-custom-element.webp)

<https://css-tricks.com/striking-a-balance-between-native-and-custom-select-elements/>

## Don't abuse accessibility announcements
โดยปกติ Android จะมี accessibility ที่แจ้งผู้ใช้งาน ปัญหาคือถ้าระบบเรามีการแจ้งเตือนบ่อย ๆ มันอาจจะไปรบกวนผู้ใช้งานมากจนเกิดความรำคาญหรือแย่กว่านั้นคือพลาดการแจ้งเตือนสำคัญจากที่อื่นไปเลย ยกตัวอย่างคือเรามีระบบ application สำหรับ email แต่ดันไป override ตัว accessibility โดยทำแจ้งเตือนทุกครั้งเมื่อได้รับ email เข้า inbox มา ก็ทำให้เกิดความรำคาญได้หากผู้ใช้งานมี email เข้ามาใหม่เรื่อย ๆ

## Use accessibility scanner to check for best practices
ตรวจสอบว่าระบบของเรานั้นรองรับ acccessibility ได้มากน้อยขนาดไหนผ่านเครื่องมือต่าง ๆ อย่าง Android ก็จะมี [Accessibility Scanner](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en&gl=US) เพื่อปรับปรุงระบบให้ดีขึ้นต่อไป

![Android Accessibility Scanner](/assets/2022-12-30-android-accessibility-scanner.webp)

> Accessibility is an user experience so you have to test it manually by yourself to know it's a good experience
