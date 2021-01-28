---
layout: post
title:  "บันทึกการติดตั้ง Angular 11 testing ด้วย Karma และ PhantomJS"
date:   2021-01-27
tags: [angular, karma, phantomjs, testing]
---

ใครที่เคยทำเขียนการทดสอบใน Angular ผ่าน Karma test runner ก็คงจะว่าบทความนี้โคตรบาป เพราะว่า[เค้าเลิกใช้ PhantomJS เปลี่ยนไปเป็น Chrome headless กันไปหมดแล้ว](https://github.com/ariya/phantomjs/issues/15344) ฮ่าๆๆ แต่เครื่องผมติดปัญหาว่าไม่สามารถเรียก Chrome ผ่าน WSL version 1 ได้ และก็ไม่สามารถ upgrade เป็น version 2 ได้ [เนื่องจากเปลี่ยน architecture เป็น Managed VM ไปเลย ดังนั้นการ configure proxy จะไม่สามารถทำผ่าน VPN ของบริษัทได้]({% post_url 2021-01-06-mimic-macos-setup-to-windows %}) แทนที่เปลี่ยนไปใช้ `npm` ผ่าน Windows ก็ใช้ PhantomJS แทนละกัน เพราะชินกับ Linux command มากกว่า

## ติดตั้ง Dependencies ให้เรียบร้อย
- **Angular** v11.0.7
- **Karma** v5.1.0
- **karma-phantomjs-launcher** v1.0.4

## ปัญหาของ PhantomJS คือ ECMAScript
เพราะ PhantomJS มันไม่รู้จัก ECMAScript ครับ ดังนั้นถ้า run ไปเจอ syntax อย่าง `const` ก็จะขึ้น `SyntaxError: Unexpected token 'const'` ทันที ดังนั้น Web จึงมี code ที่เรียกว่า *polyfill ที่ช่วยให้ code ของเราสามารถทำงานได้กับ browser ที่ไม่ support ได้*  

> polyfill ใช้แนวคิดแบบเดียวกับ shim ซึ่งเป็น code ที่ช่วยให้ API อันใหม่ทำงานใน environment เก่าได้ ดังนั้นเราจะมองว่า polyfill คือ shim ของ browser API ก็ได้ครับ

ให้เราไปแก้ file ที่ชื่อว่า `polyfills.ts` โดยการเพิ่ม `core-js` ลงไป ไม่จำเป็นต้องลง `core-js` แยกนะครับ เนื่องจาก [Angular เค้าใช้ v3 อยู่แล้ว](https://github.com/angular/angular-cli/blob/master/package.json#L144)

<script src="https://gist.github.com/raksit31667/bc1798ca4265894090b6b8707e23e88f.js"></script>

ต่อไปให้เราแก้ส่วนของการ compile TypeScript ผ่าน file `tsconfig.json` ให้ใช้ module เป็น [CommonJS](https://en.wikipedia.org/wiki/CommonJS)

<script src="https://gist.github.com/raksit31667/965c58d354d9b0ace277366657e04532.js"></script>

## จบด้วยการ configure Karma
เพิ่ม plugin `karma-phantomjs-launcher` ที่เราเพิ่งติดตั้งไป และเปลี่ยน browser เป็น `PhantomJS` (จริงๆ อันนี้เปลี่ยนจาก `angular.json` ก็ได้นะเผื่อใครจะเรียกใช้ขึ้นกับ environment)

<script src="https://gist.github.com/raksit31667/8ed2fa4b9d3bf91fdb7fe525336583c9.js"></script>

