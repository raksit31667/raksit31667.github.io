---
layout: post
title: "ว่าด้วยการเลือกแนวทางในการจัดการกับ exception ในระบบ"
date: 2024-02-13
tags: [programming]
---

ในการพัฒนา software ปัจจุบัน การจัดการ exception ในระบบเป็นส่วนสำคัญที่กำหนดการตอบสนองของระบบต่อเหตุการณ์ที่ไม่คาดคิดหรือข้อผิดพลาด ซึ่งมันก็มีด้วยกันหลากหลายท่าขึ้นอยู่กับภาษา, library, framework และระบบที่พัฒนา เช่น

- **Optional**: ถ้าเกิด exception ให้ return ค่าเปล่า (Empty หรือ None แล้วแต่ภาษา) ออกไป ทำให้ consumer ที่เรียก function/method นั้นต้องจัดการกรณีที่ออกมาเป็นค่าเปล่าด้วย ข้อควรระวังคือบางที consumer อาจจะสับสนว่าค่าเปล่าแปลว่า error หรือว่า ไม่มีค่าในข้อมูลของเรากันแน่ และไม่สามารถดักเฉพาะ exception ได้

    <script src="https://gist.github.com/raksit31667/703b592b50eb8db2a43f994f6af87f5d.js"></script>

- **try-catch**: สามารถดัก exception ได้หลากหลายตัวแตกต่างกัน ตัวไหนที่ดักได้ใน low-level ก็สามารถส่งกลับขึ้นไป (propagate) บน high-level ที่สูงกว่าได้ ข้อควรระวังคือหากมี code ที่ต้อง handle คล้าย ๆ กันก็จะเกิด duplication ได้

    <script src="https://gist.github.com/raksit31667/1448eb6c25adccdd9e9e730851b8d03d.js"></script>

- **Monad**: รวมข้อดีของ 2 วิธีข้างบนเข้าด้วยกัน ข้อควรระวังคือบางภาษาไม่มีมาให้ ต้องลง dependencies แยก

    <script src="https://gist.github.com/raksit31667/7b6ef31506df00504135c181afbd75e1.js"></script>

- **Non-exception approaches**: ในบางภาษาอย่าง C จะไม่มี exception จึงต้องใช้วิธีอื่นอย่างเช่น error code หรือ global variable เป็นต้น

    <script src="https://gist.github.com/raksit31667/ba503956fa5372323eb1f973518f16b4.js"></script>

- **Global exception handler**: บาง framework อย่าง Spring Boot มีการสร้าง exception handler ที่สามารถเขียนแยกกันกับ business logic code และทำงานกับทุกส่วนของ code เราได้ ป้องกันในกรณีที่เกิด exception ที่ไม่ได้คาดเดาไว้ทำให้ระบบยังคง run ต่อไปได้

    <script src="https://gist.github.com/raksit31667/09f81e3e267997f6a07f76b76dfc3280.js"></script>

โดยส่วนตัวแล้วเราว่าการจัดการกับ exception ที่ดีไม่ได้มีสูตรตายตัวแน่นอน เพียงแค่เราต้อง balance ระหว่าง exception ที่เป็น global และที่เป็นตัวเฉพาะเจาะจงให้เหมาะสม ดังนี้

- **Explicit exception handling**: พัฒนาวิธีจัดการ exception ทุกตัวที่คาดคิดไว้ว่ามันอาจจะเกิดแยกกันให้ได้มากที่สุด เจาะจง customise เป็นกรณี ๆ ไปเลย หลีกเลี่ยงการพัฒนา global try-catch และหรือ exception handler ที่ return response แบบ generic มาก ๆ เมื่อระบบเกิดปัญหาเราจะทราบต้นเหตุได้เร็วขึ้น นอกจากนั้นยังเป็นกุศโลบายให้ระบบที่มาเชื่อมกับมันมีการจัดการ exception ที่ดีและ ป้องกันไม่ให้ response มีข้อมูลลับที่เราไม่อยากให้ user รู้ได้อีกด้วย
- **Avoid hard crashes**: หากมีกรณี (ที่จำเป็นจริง ๆ) ที่ exception ในระบบเราไม่สมควรจะจัดการหรือไม่ได้ทำให้ระบบเรากลับมาเหมือนเดิมได้ ก็ค่อยถึงเวลาที่จะต้องปล่อย crash แต่ควรทำเมื่อจำเป็นเท่านั้น เช่น mobile app แต่ไม่ใช่ใน API services เพราะมีผลกระทบโดยตรงต่อ availability ของระบบ
