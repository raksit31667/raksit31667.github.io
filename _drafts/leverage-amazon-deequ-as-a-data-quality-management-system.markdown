---
layout: post
title:  "ทำความรู้จัก Amazon Deequ กับการจัดการ Data quality"
date:   2020-09-02
tags: [big-data, data-quality, deequ]
---

# ว่าด้วยเรื่องของ Business requirement กันก่อน
ปัจจุบันย้ายมาทำงานในส่วนของ big data ซึ่งรับข้อมูลการสั่งซื้อการลูกค้ามาทำ data cleansing เพื่อเตรียมข้อมูลให้ทีมในบริษัทพร้อมสำหรับทำ analytics ต่อไป ดังนั้นทีมต้องมั่นใจว่า

- ไม่มีข้อมูลที่เป็น non-null หายไป เพราะอาจจะทำให้เกิด error ในฝั่ง analytics ถ้าเค้าไม่ได้ดักไว้
- ข้อมูลจะต้องถูกต้องสมบูรณ์ เนื่องจากข้อมูลที่ผิดอาจจะทำให้ analytics วิเคราะห์ผิด ส่งผลให้ business ตัดสินใจผิดไปด้วย

ดังนั้นถ้ามีข้อมูลผิดไหลเข้ามา ระบบจะ reject ข้อมูลเหล่านั้นออกไป พร้อมกับส่ง notification ไปเตือนลูกค้าว่ามีข้อมูลไหนผิดบ้าง  

เมื่อกลับมามองที่ระบบปัจจุบันที่ทำกับทีม พบว่ามีข้อเสียดังนี้
- มี API ที่ทำ structural validation (เช่น null check, numeral check, uniqueness check) คั่นหน้าก่อนทำ semantic validation ผ่าน Apache Spark (เช่น ต้องทำ calculation บางอย่าง) ทำให้ developer ต้อง maintain logic 2 ที่ และลูกค้าต้อง handle error 2 ที่ (จาก API และ notification system)
- หากในอนาคตลูกค้าส่งมาเป็น flat file หรือ CSV แทน ต้องสร้าง service หรือ adapter มาแปลงไฟล์เหล่านั้นให้เป็น API spec ก่อน แล้วก็ไป call API อีกทีเพื่อให้ผ่าน structural validation

ทีมเราจึงวางแผนที่จะย้าย structural validation ให้ไปอยู่กับ semantic validation ก็จะสามารถแก้ปัญหาข้างต้นได้ แต่ก็เป็นงานช้างสำหรับทีมเพราะ structural validation มันเยอะเหลือเกิน การที่ต้องมานั่งเขียน code check null ใน DataFrame ทีละ column นี่แค่คิดก็เหนื่อยละครับ  

## แล้ว Amazon Deequ ช่วยอะไรได้
จากปัญหาดังกล่าว ทำให้เราไปหา tool ที่ช่วยทำให้การทำ data quality มันง่ายขึ้น เลยไปพบกับ [Amazon Deequ](https://aws.amazon.com/blogs/big-data/test-data-quality-at-scale-with-deequ/) 
ซึ่งตอนแรกใช้กันภายในบริษัท Amazon เองเพื่อใช้กับ dataset ขนาดใหญ่

> You generally write unit tests for your code, but do you also test your data?

สิ่งที่ Deequ library เอื้อให้กับทีมเราได้คือ

![Deequ overview components](/assets/2020-09-02-amazon-deequ-overview-components.png)

- built on top of Apache Spark อีกที ดังนั้นแค่ติดตั้งใน package management สบายๆ
- ทำการ verify data ผ่าน constraint ที่เราเลือกจาก Deequ หรือจะ custom เองก็ได้ จากนั้นจะ generate report ที่มี result อยู่
- สามารถเก็บ metrics ของ data ที่เราสนใจได้ เพื่อดู trend ของ data เช่น value distribution เป็นต้น
- สามารถ suggest constraint ที่ควรจะมีได้ (อันนี้ยังไม่ได้ลองใช้นะครับ)

## มาดูตัวอย่าง code กัน
ตัวอย่างจะเป็นการ verify data quality จาก ไฟล์ CSV เขียนด้วยภาษา Scala

#### เริ่มจากการสร้าง CSV ขึ้นมาก่อน
เราจะใช้ [DataHelix](https://github.com/finos/datahelix/blob/master/docs/GettingStarted.md) เพื่อสร้างข้อมูลตัวอย่างขึ้นมา ซึ่งเราจะต้องกำหนดรูปแบบของข้อมูลที่อยากได้ผ่านไฟล์ที่เรียกว่า [Profile](https://github.com/finos/datahelix/blob/master/docs/UserGuide.md#profiles) ในรูปแบบของ JSON แบ่งเป็น 2 ส่วน
- **Fields** สำหรับกำหนดชื่อ field และ data type ที่อยากได้ รวมถึง uniqueness และ nullable
- **Constraints** สำหรับกำหนด constraint อื่นๆ เช่น regex หรือ decimal point เป็นต้น

<script src="https://gist.github.com/raksit31667/adb9ebaf64659769858b2a245e97836c.js"></script>

จากนั้นรันคำสั่งในการสร้าง CSV file จาก DataHelix
```sh
➜ ../datahelix/bin/datahelix --max-rows=10000 --replace --profile-file=<path-to-your-profile.json> --output-path=<path-to-your-output-file.csv>
Generation started at: 18:48:47

Number of rows | Velocity (rows/sec) | Velocity trend
---------------+---------------------+---------------
85             | 85                  | +
438            | 351                 | +
806            | 368                 | +
1291           | 485                 | +
1760           | 469                 | -
2237           | 477                 | +
2719           | 482                 | +
3128           | 409                 | -
3535           | 407                 | -
3924           | 389                 | -
4216           | 292                 | -
4473           | 257                 | -
4877           | 404                 | +
5365           | 488                 | +
5807           | 442                 | -
6187           | 380                 | -
6608           | 421                 | +
6992           | 384                 | -
7393           | 401                 | +
7771           | 378                 | -
8178           | 407                 | +
8581           | 403                 | -
8955           | 374                 | -
9240           | 285                 | -
9618           | 377                 | +
10000          | 390                 | Finished

Generation finished at: 18:49:13
```

> ปล. ถ้าใช้ macOS ให้ download DataHelix ผ่าน [GitHub release](https://github.com/finos/datahelix/releases/tag/v2.3.0) ลงมาเป็น zip แต่ถ้าใช้ Windows สามารถใช้ผ่าน [Chocolatey](https://chocolatey.org/packages/datahelix) ได้เลย

#### ลง Amazon Deequ ใน project กันก่อน
ในตัวอย่างจะใช้เป็น Gradle นะครับ แต่เค้า support ทั้ง Maven และ SBT เลย [ดูตามนี้ได้เลย](https://github.com/awslabs/deequ#requirements-and-installation)
<script src="https://gist.github.com/raksit31667/c417ff8347de0da62895b03008ec49c8.js"></script>

> ใน documentation บอกว่าใช้ได้กับ Java 8 และ Spark 2.2.x ถึง 2.4.x นะครับ ใครใช้ Spark 3.x.x [รอไปก่อนนะครับ](https://github.com/awslabs/deequ/pull/286)

#### ในส่วนของการกำหนด Constraint Verification ของ Deequ
<script src="https://gist.github.com/raksit31667/08b761be79ce2baac74810de4a975533.js"></script>

เราจะกำหนด Constraint ขึ้นมา สามารถกำหนดได้ว่าจะให้เป็นแค่ **Warning** หรือ **Error** มี rule ที่กำหนดอิงตาม [class](https://github.com/awslabs/deequ/blob/master/src/main/scala/com/amazon/deequ/checks/Check.scala) นี้เลย จากนั้นเราก็เช็คได้ว่า data ที่เอามาผ่านไหม ถ้าไม่ผ่านก็สามารถดึง result ได้จาก `verificationResult.checkResults` ซึ่งมาในรูปแบบของ `Map[Check, CheckResult]` ดังนั้นถ้าจะเข้าไป iterate ใน result อาจจะต้องใช้ `flatMap` เข้าไปครับ

```scala
val resultsForAllConstraints = verificationResult.checkResults
        .flatMap { case (_, checkResult) => checkResult.constraintResults }

      resultsForAllConstraints
        .filter { _.status != ConstraintStatus.Success }
        .foreach { result => println(s"${result.constraint}: ${result.message.get}") }
```

ผลลัพธ์จากการรันกับ CSV 10000 rows ก็จะได้ประมาณนี้

```
We found errors in the data:

CompletenessConstraint(Completeness(productName,None)): Value: 0.757 does not meet the constraint requirement!
CompletenessConstraint(Completeness(priority,None)): Value: 0.7526 does not meet the constraint requirement!
Elapsed time: 1.855833635s // อันนี้ผมจับเวลาเอง
```

#### มาลองเล่นในส่วนของ Column profiling กันบ้าง
<script src="https://gist.github.com/raksit31667/85b46c717c5ab1e3830594c5b44fd643.js"></script>
ในตัวอย่างคือเราสนใจ column ชื่อ `priority` ว่ามี value อะไรอยู่เป็นจำนวนเท่าไรบ้าง

```
Value distribution in 'priority':
	NullValue occurred 2474 times (ratio is 0.2474)
	high occurred 3808 times (ratio is 0.3808)
	low occurred 3718 times (ratio is 0.3718)
Elapsed time: 2.009501848s // อันนี้ผมจับเวลาเอง
```

## พูดถึงข้อเสียกันหน่อย
- ไม่สามารถระบุได้ว่าอันไหนเป็น bad record แบบเป็นตัวๆ ไป ซึ่งเป็นเคสที่ทีมเราเจอเต็มๆ ครับ (มี discussion ที่น่าใจจาก [GitHub issue](https://github.com/awslabs/deequ/issues/223) นี้เลย) จึงต้องไปใช้การ verify ผ่าน Row จาก class **RowLevelSchemaValidator** แทน

<script src="https://gist.github.com/raksit31667/d0da079d7b7e35ccae9a48bf1d422ac0.js"></script>

```
+---+-----------+-----------------+--------+--------+
| id|productName|      description|priority|numViews|
+---+-----------+-----------------+--------+--------+
|  9|     Samuel|  Charlotte MASON|    null|     445|
| 13|     Samuel| Taylor PATTERSON|    null|     211|
| 18|     Ashton|             null|    null|     798|
| 22|     Harris|   Leon MACGREGOR|    null|     319|
| 25|       Lexi|             null|    null|     931|
| 28|  Alexander|             null|    null|     386|
| 29|      Arwen|             null|    null|     731|
| 33|      Maria|             null|    null|     888|
| 37|       Lily|             null|    null|     712|
| 43|       null|    Ethan THOMSON|    null|     176|
| 48|       Aron|Callie MACFARLANE|    null|     599|
| 50|      David|      Indie SCOTT|    null|     796|
| 52|       null|   Neve MACKENZIE|    null|     797|
| 53|       null|             null|    null|     932|
| 55|     Amelia|        Sara BAIN|    null|      43|
| 63|        Jan|      Tommy JONES|    null|     948|
| 72|     Olivia|  Lennon MCDONALD|    null|     296|
| 73|  Alexander|   Andrew RITCHIE|    null|     685|
| 84|     Oliver|   Evie MCDOUGALL|    null|     784|
| 87|       Jack|      Albert ROSS|    null|     425|
+---+-----------+-----------------+--------+--------+
only showing top 20 rows

Elapsed time: 0.641779686s // อันนี้ผมจับเวลาเอง
```

> method ที่ใช้หลากหลายน้อยกว่าแบบ column เยอะครับ ละก็ไม่สามารถเขียน custom constraint ได้ (Check ทั้งหลายจะใช้ method ชื่อ [satisfies](https://github.com/awslabs/deequ/blob/master/src/main/scala/com/amazon/deequ/checks/Check.scala#L667))

- อีกเรื่องคือไม่ support Spark Streaming นะครับ อาจจะต้องไปเขียนแบบ micro-batch แก้ขัดไปก่อน เช่น ใช้ `foreachBatch` เป็นต้น

> ดูโค้ดตัวอย่างได้ที่ <https://github.com/raksit31667/example-spark-gradle>



