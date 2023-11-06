---
layout: post
title: "สวัสดี Approval tests"
date: 2023-11-06
tags: [approval-tests, testing, c-sharp]
---

เมื่ออาทิตย์ที่แล้วระหว่างการฝึกซ้อมเพื่อเตรียมเข้า project ใหม่ได้มีโอกาสทดลองใช้งาน [Approval tests](https://approvaltests.com/) พบว่าเป็น technique ที่น่าสนใจมาก ๆ เพราะมันแก้ปัญหากับการทดสอบกับข้อมูลที่มี properties เยอะ ๆ ได้ มาดูกันว่ามันคืออะไร

## การทดสอบกับข้อมูลที่มี properties เยอะ ๆ
ในบางครั้งการทดสอบในระดับต่าง ๆ ตามแนวคิด [test pyramid](https://martinfowler.com/bliki/TestPyramid.html) ไม่ว่าจะเป็น unit test หรือ integration test จะเจอกรณีที่เราต้องตรวจสอบว่า ข้อมูลที่ return ออกมาจากคำสั่งหรือ method นั้นมันถูกต้องหรือไม่ เช่น การทดสอบ API response เป็นต้น ซึ่งการจะตรวจสอบนั้นเราจะต้องเขียน statement ตามความซับซ้อนของข้อมูลนั้น หมายความว่ายิ่งข้อมูลซับซ้อนมากเท่าไร statement ที่ออกมากจะอ่านยากมากเท่านั้น ยกตัวอย่างเช่น  

เราต้องการจะทดสอบ class `WeatherForecastController` หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/b9807e0715ace35313804c94a87e1a2d.js"></script>

หน้าตาชุดการทดสอบเดิมของเราจะเป็นแบบนี้

<script src="https://gist.github.com/raksit31667/5c950bccb612d7d51478b48316901416.js"></script>

จะสังเกตว่าหาก `WeatherForecast` object มันมีความซับซ้อนมากขึ้น ก็จะทำให้เราต้องเขียน `Assert.Equal` มากขึ้น ไม่งั้นก็ต้องเตรียม object ที่จะเปรียบเทียบกับผลลัพธ์จริงซึ่งก็ซับซ้อนไม่แพ้กัน  

## Enter Approval test

จากปัญหาข้างต้นจึงเกิด Approval tests ขึ้นโดยมองว่า**ข้อมูลที่ได้จากการ run ชุดการทดสอบมันคือรูปถ่ายใบหนึ่ง (snapshot)** ดังนั้นหากเรานำรูปถ่ายมาเทียบกันแล้วมันมีความเหมือนหรือแตกต่างกันตรงไหน ก็น่าจะชี้ให้เห็นถึงผลการทดสอบได้ โดย Approval tests จะมีขั้นตอนดัง flow นี้

![Approval tests flow](/assets/2023-11-06-approval-tests-flow.png)

1. เขียนชุดการทดสอบเริ่มต้นและ run เพื่อให้ได้ snapshot ซึ่งหน้าตาก็จะเป็นข้อมูลของเรา (**received**) ขึ้นมา
2. จะพบว่าในการ run ครั้งแรกผลการทดสอบของเราจะ fail เนื่องจากว่าเรายังไม่มี snapshot หลักมาเทียบนั่นเอง ดังนั้นให้เรา copy **received** snapshot จากข้อ 1 มาเป็น snapshot หลักในการทดสอบต่อ ๆ ไป (**verified**)
3. เมื่อมีการเปลี่ยนแปลงของ code แล้วให้เรา run ชุดการทดสอบอีกครั้งเพื่อให้ได้ received snapshot ใหม่
4. เปรียบเทียบ received snapshot กับ verified snapshot หากเหมือนกันก็ถือว่าผ่านเพราะการแก้ไขของเราไม่ได้มีผลกระทบกับของเดิม แต่ถ้ามีความแตกต่างก็จะ fail พร้อมกับแสดงให้เห็นถึงจุดที่ต่าง (แล้วแต่เครื่องมือที่ใช้)
5. ถ้าความต่างในข้อ 4 เป็นสิ่งที่เราคาดไว้แล้วก็ให้เรา copy received snapshot มาเป็น verified snapshot หลักในการทดสอบต่อ ๆ ไป แต่ถ้่าไม่ได้คาดไว้ก็ทำการแก้ไข code จนกว่าผลการเปรียบเทียบจะเหมือนกัน
6. วนกลับไปทำข้อ 3

## ตัวอย่างการใช้ Approval test
อธิบายเป็นข้อ ๆ แบบด้านบนอาจจะไม่เห็นภาพทั้งหมด ดังนั้นเรามาลงมือทำจริงกันไปเลยดีกว่า โดยเราสามารถใช้ Approval test กับหลาย ๆ programming language ได้ เช่น Java, C#, C++, Go, PHP, Python, JavaScript, Ruby, Objective-C, Swift, Perl, Lua ในตัวอย่างนี้เราจะใช้ [Verify](https://github.com/VerifyTests/Verify) ของภาษา C# ที่ใช้ [.NET Framework](https://dotnet.microsoft.com/en-us/download/dotnet-framework) ควบคู่กับ [Xunit](https://xunit.net/)

1. ติดตั้ง Verify และ package อื่น ๆ ที่เกี่ยวข้อง

    ```shell
    dotnet add package Microsoft.NET.Test.Sdk
    dotnet add package Xunit
    dotnet add package xunit.runner.visualstudio
    dotnet add package Verify.DiffPlex # เอาไว้ดู diff แบบ +,- คล้าย ๆ Git https://github.com/VerifyTests/Verify.DiffPlex
    dotnet add package Verify.Xunit
    ```

2. สร้าง class ใหม่เพื่อทำการเปิดใช้งาน [DiffPlex](https://github.com/mmanela/diffplex) ในการ run ชุดการทดสอบทุกครั้ง โดยเราจะใช้เป็นท่า [ModuleInitializer](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-9.0/module-initializers) ซึ่งก็คือท่าที่ต้องการ run คำสั่งบางอย่างก่อนการ run ชุดการทดสอบ เช่น เตรียมข้อมูลใน database เป็นต้น

    <script src="https://gist.github.com/raksit31667/b308b8239aeb599275ed56a54faf5b91.js"></script>

3. เขียนชุดการทดสอบด้วย Verify ที่มีหน้าตาประมาณนี้ จะเห็นว่า test method จะ return `Task` แทนที่จะเป็น `void`

    <script src="https://gist.github.com/raksit31667/f6dcf73779ccbc1baabc32cad0c6c895.js"></script>

4. Run ชุดการทดสอบครั้งแรก ตัว Verify จะสร้าง file ขึ้นมา 2 อันคือ

    - `<TestClassName>.<TestMethodName>.received.txt`
    - `<TestClassName>.<TestMethodName>.verified.txt`

    สิ่งที่เราต้องการบันทึกลงใน version control คือส่วน verified เพราะนี่คือข้อมูลหลักที่เราใช้ในการเทียบกับข้อมูลล่าสุด ดังนั้นเราแค่ต้อง ignore received file ไป

    <script src="https://gist.github.com/raksit31667/e9936af6dfbed5e7af7480800df1e25d.js"></script>

5. Copy content จาก `<TestClassName>.<TestMethodName>.received.txt` ไปไว้ที่ `<TestClassName>.<TestMethodName>.verified.txt` จะได้หน้าตาประมาณนี้

    <script src="https://gist.github.com/raksit31667/3517da7f4288619dd5ac036b872a2671.js"></script>

6. เปลี่ยนแปลง code ยกตัวอย่างเช่นเปลี่ยนค่าที่ return ออกไปจาก method ที่ต้องการจะทดสอบ

    <script src="https://gist.github.com/raksit31667/bd7f2f32a5276826eff1067ecbfa8ac0.js"></script>

7. Run ชุดการทดสอบอีกครั้ง ตัว Verify จะได้ file ขึ้นมา 2 อันเหมือนเดิมแต่ว่าผลลัพธ์คือ fail เพราะข้อมูลระหว่าง `received` และ `verified` ต่างกันตามการเปลี่ยนแปลงของเรานั่นเอง

    ```shell
    FileContent:

    NotEqual:

    Received: VerifyTest.ShouldReturnWeatherForecastCorrectly.received.txt
    Verified: VerifyTest.ShouldReturnWeatherForecastCorrectly.verified.txt
    Compare Result:
    [
        {
        Date: Date_1,
    -     TemperatureC: -20,
    -     Summary: Freezing
    +     TemperatureC: 45,
    +     Summary: Scorching
        },
        {
        Date: Date_2,
    -     TemperatureC: -20,
    -     Summary: Freezing
    +     TemperatureC: 45,
    +     Summary: Scorching
        },
        {
        Date: Date_3,
    -     TemperatureC: -20,
    -     Summary: Freezing
    +     TemperatureC: 45,
    +     Summary: Scorching
        },
        {
        Date: Date_4,
    -     TemperatureC: -20,
    -     Summary: Freezing
    +     TemperatureC: 45,
    +     Summary: Scorching
        },
        {
        Date: Date_5,
    -     TemperatureC: -20,
    -     Summary: Freezing
    +     TemperatureC: 45,
    +     Summary: Scorching
        }
    ]

    Failed!  - Failed:     1, Passed:     1, Skipped:     0, Total:     2, Duration: 196 ms - Learn.Verify.Xunit.Test.dll (net7.0)
    ```

    <script src="https://gist.github.com/raksit31667/484d25a27d7c453a2e8dc8bdcab7a05e.js"></script>
    <script src="https://gist.github.com/raksit31667/3517da7f4288619dd5ac036b872a2671.js"></script>

    ![VerifyTest difference](/assets/2023-11-06-verify-test-diff.png)

8. ถ้าเราคาดหวังไว้แล้วว่าการเปลี่ยนแปลงเป็นไปตามที่คาดหวัง เราก็ copy content จาก `<TestClassName>.<TestMethodName>.received.txt` ไปไว้ที่ `<TestClassName>.<TestMethodName>.verified.txt` เมื่อเรา run อีกครั้งก็จะพบว่ามันผ่านแล้ว


    ```shell
    Passed!  - Failed:     0, Passed:     2, Skipped:     0, Total:     2, Duration: 55 ms - Learn.Verify.Xunit.Test.dll (net7.0)
    ```

## Use case
จากการได้ลองใช้งาน Approval tests มาพบว่ามันจะเหมาะมากในการทดสอบกับข้อมูลที่มี properties เยอะ ๆ หรือ project ที่เป็น legacy code ที่ไม่มีชุดการทดสอบเลยแล้วเข้าใจยากว่าแต่ละ method มันทำงานยังไง การมี snapshot เริ่มต้นทำให้เราเข้าใจได้ง่ายขึ้นและต่อยอดการ refactoring ได้รวดเร็วขึ้น  

แต่ในขณะเดียวกัน Approval tests ไม่สามารถแทนการทดสอบแบบดั้งเดิมได้ทั้งหมด เช่น การทดสอบ class พวกเกี่ยวกับวันเวลา หรือ ทดสอบว่า method throw `Exception` อะไร รวมถึงการแก้ merge conflict ใน verfied file เป็นต้น ดังนั้นเราควรใช้เป็นตัวเสริมที่ตรงกับสิ่งที่มันออกแบบมาน่าจะดีกว่า
