---
layout: post
title:  "Apply CSS ที่ขึ้นอยู่กับจำนวนของ element อย่างไร"
date:   2021-03-02
tags: [css]
---
เมื่อวานมีโจทย์ที่น่าสนใจเกี่ยวกับ CSS คร่าวๆ คือ

> ให้ลงสีแดง button เมื่อแสดงเพียง 2 ปุ่ม ถ้ามีปุ่มน้อยกว่าหรือมากกว่านั้นให้ลงเป็นสีเขียวแทน

<script src="https://gist.github.com/raksit31667/2cdb73065e6de3d00999feeeec58deef.js"></script>

ซึ่งแนวคิดมันดูไม่ยากนะ แต่พอทำจริงกลับยากเพราะ **CSS ไม่มี style ที่ขึ้นกับจำนวนของ element ใน parent** สิ่งที่ต้องแก้คือเราจะใช้ CSS ในการเลือก element ประเภทเดียวกันที่ติดกันตามจำนวนที่ต้องการได้อย่างไร  

## วิธีทำ
มาดู CSS selector ที่พอจะเป็นไปได้ก่อน

- `X ~ Y` เลือก element `Y` ทุกตัวที่อยู่ใน parent เดียวกับ `X`
- `X + Y` เลือก element `Y` ที่อยู่ข้างๆ `X`
- `X:only-child` เลือก element `X` ก็ต่อเมื่อ `X` เป็น element เดียวที่อยู่ใน parent
- `X:first-child` เลือก element `X` ตัวแรกที่อยู่ใน parent
- `X:last-child` เลือก element `X` ตัวสุดท้ายที่อยู่ใน parent
- `X:nth-child(n)` เลือก element `X` ตัวที่ n
- `X:nth-last-child(n)` เลือก element `X` ตัวที่ n นับจากตัวสุดท้าย

ถ้ามีแค่ `button` เดียว อันนี้ไม่ยาก ใช้ `X:only-child` ก็ได้ละ แต่ถ้ามีมากกว่านั้น เราสามารถใช้ `X:nth-last-child(n)` ได้  

สมมุติว่าเรามี `button` 3 ปุ่มใน parent `button:nth-last-child(3)` ก็คือปุ่มแรก แต่ถ้า `button:nth-last-child(2)` ก็จะได้ปุ่มที่ 2 หรือ `button:nth-last-child(4)` ก็จะหาไม่เจอเลย หมายความว่า

```
button:nth-last-child(n) = button แรกใน n ปุ่ม
```

มาถึงขั้นนี้คือเราสามารถ apply CSS สำหรับปุ่มแรกใน n ปุ่มได้แล้ว ปุ่มที่เหลือเราสามารถใช้ `X ~ Y` เพื่อเลือก `button` ประเภทเดียวกันที่ติดกัน (sibling) เป็นอันเสร็จ

## ตัวอย่าง CodePen

<p class="codepen" data-height="265" data-theme-id="dark" data-default-tab="html,result" data-user="raksit31667" data-slug-hash="bGBKwPP" style="height: 265px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;" data-pen-title="CSS selector n siblings">
  <span>See the Pen <a href="https://codepen.io/raksit31667/pen/bGBKwPP">
  CSS selector n siblings</a> by Raksit Mantanacharu (<a href="https://codepen.io/raksit31667">@raksit31667</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>


## References
- [The 30 CSS Selectors You Must Memorize](https://code.tutsplus.com/en/tutorials/the-30-css-selectors-you-must-memorize--net-16048)
- [Detecting number of siblings with CSS](https://www.growingwiththeweb.com/2014/06/detecting-number-of-siblings-with-css.html)