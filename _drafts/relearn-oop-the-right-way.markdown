---
layout: post
title:  "สรุปการเรียน Object-oriented Programming ใหม่ในปี 2022"
date:   2022-11-30
tags: [oop, programming]
---

เดือนนี้ไม่ได้เขียน blog ใหม่เลยเนื่องจากจบ project ที่ทำอยู่พอดี เลยใช้เวลาไปกับการพักผ่อนหย่อนใจ (จะเขียน blog การไป trip เดือนหน้านะ) บวกกับช่วงที่เขียนบทความนี้อยู่เป็นช่วงฟุตบอลโลกพอดี แน่นอนว่าดุเกือบทุกคู่กันไป แต่ก็ไม่ทิ้งการเรียนทั้ง hard skill และ soft skill เช่นกัน หนึ่งในนั้นคือการเรียน Object-oriented Programming (OOP) ใหม่ถึงแม้ว่าจะเคยเรียนและใช้งานมันมาสักพักแล้ว แต่ส่วนตัวเราคิดว่าเรายังไม่สามารถอธิบายแนวคิด OOP ได้ดีเท่าที่ควร เพราะไม่ได้ชี้ให้เห็นว่ามันมีประโยชน์อย่างอื่นนอกจาก code ดูแลรักษาง่าย (?) อีกไหม  

บทความนี้เลยมาสรุปสิ่งที่ได้จากการเรียน [OOP The Right Way](https://www.skooldio.com/courses/oop-the-right-way) กันหน่อย 

## พูดถึงปัญหากันก่อน
ปกติการเขียน program จะมี 2 สิ่งคือ 

- **Procedure**: ส่วนที่ระบุว่า program ทำงานอย่างไร ในภาษา programming ต่าง ๆ จะใช้คำว่า function หรือ method
- **State**: ส่วนที่เก็บข้อมูลไว้ชั่วคราวในหน่วยความจำ (memory) ในภาษา programming ต่าง ๆ จะใช้คำว่า variable

ซึ่งการเขียน program แบบดั้งเดิมมีอีกชื่อที่เรียกว่า [Imperative programming](https://en.wikipedia.org/wiki/Imperative_programming) ทุก procedure สามารถเข้าถึงทุก state ได้ (ทุก method สามารถใช้ / แก้ไข variable ได้หมด) ส่งผลต่อค่าใช้จ่ายการดูแลรักษา เพราะเวลามี bug ต้องไปงมหา code ที่มีปัญหาหมดทุก procedure และปัญหาจะซับซ้อนมากขึ้นถ้าเราทำงานเป็นทีม  

## Object-oriented แก้ปัญหาได้อย่างไร
จากปัญหาข้างต้น ทำให้เกิดแนวคิด **Object-oriented Programming (OOP)** ซึ่งแต่ละส่วนจะอยู่ในสิ่งที่เรียกว่า Object ซึ่งประกอบไปด้วย state กับ procedure แยกกัน โดยแต่จะหากันผ่าน message (เรียก method ผ่าน object นั้น ๆ) ไม่มีใครเข้ามายุ่งได้นอกจากผ่าน procedure ที่เตรียมไว้ให้  

ประโยชน์ที่ได้รับก็คือ เวลามี bug ก็ดูแค่ procedure เดียวใน object ที่เกี่ยวข้องตัวนั้น นอกจากนั้น **OOP หากทำอย่างถูกต้อง จะช่วยให้ทำงานเป็นทีมได้ดีขึ้น** เนื่องจากดูแล code แต่ละส่วนแยกกันโดยที่แต่ละกลุ่มก็มี control แยกกัน ส่งผลให้เมื่อเกิดการเปลี่ยนแปลงจะทำให้เหยียบเท้ากันน้อยลง 

## Code ที่ดีใน OOP หน้าตาเป็นอย่างไร
การที่เราจะบอกว่าเรามี code ที่ดีใน OOP นั้นจะประกอบไปด้วย 3 อย่างได้แก่

- **Testability**: แต่ละ object มี scope ชัดเจน ใช้ค่าใช้จ่ายในการทดสอบน้อย ไม่ต้องมาเตรียมข้อมูลอะไรมากมาย
- **Scalability**: สามารถเพิ่ม code ได้โดยไม่มีผลกระทบกับสิ่งที่มีอยู่แล้ว
- **Maintainability**: สามารถทำความเข้าใจได้ เปลี่ยนแปลงด้วยความมั่นใจเมื่อเทียบกับมุมมองกับ business และคำนิยามต้อง clear กับทุกคนในทีม เช่นถ้าใช้คำว่า *handler* ถามทุกคนก็ต้องเข้าใจตรงกันว่ามันหมายความว่าอะไร

## ส่วนประกอบที่ใช้ในการทำ OOP

### Class and Object
State ภายในจะอยู่แยกจากกันคนละ object การแก้ไขก็จะส่งผ่าน message โดยมีข้อแม้แค่การสร้าง object ต้องทำผ่าน class ซึ่งเป็นตัวกำหนดรูปแบบของ state และ procedure

### Constructor
เป็นเครื่องมือในการ init state ในการสร้าง object เนื่องจากบางครั้ง object ไม่ควรสร้าง ถ้าไม่มีค่าเริ่มต้นบางอย่างมาให้ การมี Constructor ก็ช่วยกันลืมได้

### Access level
เป็นกลไกในการป้องกันไม่ให้ procedure เข้ามายุ่งได้นอกจากผ่าน procedure ที่เตรียมไว้ให้ โดยกฎง่าย ๆ คือคิดอะไรไม่ออกก็เริ่มจาก *private* เสมอ ถ้าไม่ได้ตามด้วย *protected* แล้วเอา *public* เป็นตัวเลือกสุดท้าย

### Extends และ Implement
เป็น keyword ที่ใช้ในการแสดงหนึ่งในเสาหลักของ OOP ก็คือ **Abstraction & Polymorphism** และ **Inheritance** ซึ่งจะขอยกไปขยายความในส่วนถัดไป

### Interface
เป็นการกำหนดความสามารถของ object ว่าจะมีความสามารถตามที่กำหนดไว้ เช่น class `Animal` จะต้องเดินและหายใจได้ (`walk` and `breathe`)

```
interface Animal {
    walk(): void
    breathe(): void
}
```

### Static method
มันคือ procedure ที่ไม่ได้ขึ้นกับ state หรือ procedure ของ object ใด ๆ ในส่วนของภาษา TypeScript มีต้นแบบของ static method มาจาก C# เพื่อทำให้เรียนรู้ง่ายแค่นั้น ซึ่งไม่มีความจำเป็นต้องใช้ในปัจจุบัน (TypeScript และ  พัฒนาด้วยบริษัทเดียวกันคือ Microsoft)

## เสาหลักของ OOP

### Encapsulation
แนวคิดของ Encapsulation คือรวม state กับ procedure หรืออะไรก็ตามที่ยุ่งกับ state ให้อยู่ใน object เพื่อไม่ให้ใครมายุ่งกับ state ได้ นอกจากนั้นเราอยากจะให้ object เป็นคนตีความอะไรก็ตามที่เกี่ยวกับ object นั้น ๆ โดยตรง ไม่ให้คนนอกมาตีความได้ เช่น สมมติเราจะเขียน program เกี่ยวกับเกม Mario สำหรับการกระโดด เราก็อาจจะสร้างเงื่อนไขแบบ 

```
function main() {
    const mario = new Mario()
    const floor = new Floor()

    ...

    if (mario.positionY === floor.positionY) {
        // jump
    }
}
```

หมายความว่า function `main` เป็นคนตีความเกี่ยวกับการกระโดดของ Mario เวลาอยากจะแก้ไขเกี่ยวกับการกระโดด ก็ต้องมางม code ใน function `main` ด้วย กลับกันถ้าเราให้ Mario ตีความ

```
function main() {
    const mario = new Mario()
    const floor = new Floor()

    ...

    if (mario.doMyFeetTouchFloor(floor)) {
        // jump
    }
}
```

เวลาอยากจะแก้ไขเกี่ยวกับการกระโดด ก็ดูที่ `doMyFeetTouchFloor` ก็พอ  

ในส่วนของ operation ที่ยุ่งกับ state เดียวกันก็ควรจะอยู่ใน object เดียวกันถ้าเป็นไปได้ ทั้งนี้ก็แล้วแต่ว่าเราจะให้การเปลี่ยน state มันเกิดที่ object ไหน ให้มันเกิดขึ้นในที่เดียวกันก็พอ  

Encapsulation ไม่ได้บอกว่าจะต้องแบ่งลงไปลึก (จำนวนของ class) เยอะขนาดไหน มันแค่บอกว่าถ้าคิดจะแบ่งก็แบ่ง state กับ procedure หรืออะไรก็ตามที่ยุ่งกับ state ให้อยู่ใน Object แล้วถ้าทุกคนเชื่อว่าการแบ่งแบบนั้นมันดีดูแลง่าย ก็จะทำให้ทุกคนหาของได้ง่ายขึ้น เพราะการสร้าง class ย่อย ๆ มีข้อดีคือเราจะเห็น impact จากการเปลี่ยนแปลง class ใด ๆ ได้เร็วขึ้น และจะดีที่สุดถ้าเราเปิด access level ให้ใช้น้อยที่สุดเท่าที่จะเป็นไปได้

> Encapsulation is just an agreed way to grouping things together

### Abstraction & Polymorphism
ปัญหาที่เวลา logic จาก code มันอยู่รวมกันเยอะ ๆ คือ

- Code ไม่สะท้อนสิ่งที่ business requirement และสิ่งที่ลูกค้าคิด
- อธิบายให้แต่ละส่วนที่ไม่เกี่ยวข้องกันว่า code มันทำงานอย่างไรได้ยากขึ้น
- เวลาจะทำการวิเคราะห์ impact จากการเปลี่ยนแปลง logic ก็จะซับซ้อนมากขึ้น มีโอกาสที่จะเข้าใจผิดมากขึ้นเพราะ code ไม่ได้ตรงไปตรงมา

แนวคิดของ Abstraction และ Polymorphism คือการย้าย statement ที่เป็นเงื่อนไข (conditional statement) ไปไว้ในที่ที่เหมาะสม ประโยชน์ก็คือเราจะได้ code ที่สะท้อนกับ business requirement และสิ่งที่ลูกค้าคิดในแต่ละส่วนที่ไม่เกี่ยวข้องกัน (ถ้าทำได้อย่างถูกต้องนะ ฮ่า ๆๆ)

- **Abstraction** คือแนวคิดที่ procedure ของเราสนใจแค่ interface แต่ไม่สนใจ implementation จริงว่าจะมาจากไหน ทำให้ code เราขยายส่วนต่อได้ง่ายขึ้น เวลามี implementation เพิ่มก็ไม่ต้องมาแก้ไขส่วนที่เอา interface ไปใช้
- **Polymorphism** คือการสลับ implemention class ที่ interface เดียวกันให้คนอื่นใช้งาน

### Inheritance
แนวคิดของ Inheritance คือการสร้างความสัมพันธ์ (relationship) ระหว่าง class ในรูปแบบที่ class นึงสืบทอด (inherit) procedure หรือ state มาจากอีก class นึง (เรียก class ที่ถูก inherit ว่า superclass และ class ที่เป็นผลลัพธ์จากการ inherit ว่า subclass) จุดประสงค์เพื่อลด code ซ้ำซ้อนที่เกิดขึ้นจากการที่หลาย ๆ class มี procedure และ state คล้าย ๆ กัน  

ปัญหาของ Inheritance คือ code ของแต่ละ procedure มันไม่ชัดเจนในตัวของมันเองจนกว่าจะไปอ่านตัว superclass ถึงจะได้รู้ว่ามันมีผลกระทบอะไร การแก้ superclass อาจจะกระทบ subclass เยอะ เพราะไม่รู้ว่ากระทบอะไรบ้าง เกิดเป็นสิ่งที่เรียกว่า fragile class  

สืบเนื่องจากปัญหานี้ จึงเกิดแนวคิดใหม่คือ **Composition over Inheritance** ซึ่งแทนที่เราจะมาออกแบบ relationship เพื่อจับกลุ่มระหว่าง superclass กับ subclass (hierarchy) เราก็นำความสามารถที่แต่ละ class ควรจะมีมารวมกัน (composition)  

ยกตัวอย่าง เราต้องการเขียน code เกี่ยวกับการขอเบิกเงินผ่านเอกสาร (Document) รูปแบบต่าง ๆ ถ้าผ่านการอนุมัติ (approve) เราก็จะเก็บเอกสารไว้ (persist) ในที่เก็บสักที่ใดที่หนึ่ง  

เราก็อาจจะเริ่มจาก superclass `Document` แล้วก็มี subclass `Invoice` เนื่องจากเป็น `Document` ชนิดหนึ่ง ประโยชน์ที่ได้คือถ้ามีเอกสารรูปแบบใหม่ เราก็แค่เพิ่ม subclass ใหม่เท่านั้น จะได้หน้าตา code ประมาณนี้

```
abstract class Document {
    abstract approve(): boolean

    abstract persist(): void
}

class Invoice extends Document {
    approve(): boolean {
        // do something...
    }

    persist(): void {
        // do something...
    }
}
```

ทีนี้เรามี subclass ใหม่ชื่อ `Cash` (เงินสด) แต่ business requirement เปลี่ยนใหม่โดยมีเงื่อนไขว่าเมื่อจ่ายด้วยเงินสด ไม่ต้องขอ approve ก่อน ปัญหาก็จะเกิดเพราะ `Cash` ดันเป็น subclass ของ `Document` ไปแล้ว ทำให้ `Cash` มี procedure ที่ไม่ได้สะท้อนมุมมองของ business ซะทีเดียว

```
abstract class Document {
    abstract approve(): boolean

    abstract persist(): void
}

class Invoice extends Document {
    approve(): boolean {
        // do something...
    }

    persist(): void {
        // do something...
    }
}

class Cash extends Document {
    approve(): boolean {
        // return true ก็ได้ แต่ก็เกิดโอกาสตีความผิด ๆ ขึ้นมา
    }

    persist(): void {
        // do something...
    }
}
```

ถ้าเราใช้หลักการ Composition เราก็นำความสามารถของ Document มาประกอบกัน โดยที่ Document สามารถ approve ได้ (`Approvable`) และ Document สามารถเก็บได้ (`Persistable`) ก็จะได้หน้าตา code ประมาณนี้

```
interface Approvable {
    approve(): boolean
}

interface Persistable {
    persist(): void
}

class Invoice implements Approvable, Persistable {

    approve(): boolean {
        // do something...
    }

    persist(): void {
        // do something...
    }
}

class Cash implements Persistable {

    persist(): void {
        // do something...
    }
}
```

บางคนก็อาจจะตั้งคำถามว่า ถ้าทำ Composition แล้วมันดี เราจะใช้เสาหลักอย่าง Inheritance ไปทำไม คำตอบคือ  

- แน่นอนว่า OOP มีมาเนิ่นนานแล้ว ในสมัยนั้นการทำ Inheritance มันดี แต่เมื่อ OOP แพร่หลายย่อมมีความหลากหลายในการใช้งานกันไปตามเวลา
- ในปัจจุบันก็ยังมีข้อพิสูจน์ว่า ทำ Inheritance แล้วมันดีอยู่เช่นกัน ตัวอย่างเช่น React, Ruby on Rails, Decorator ของ Nest.js เป็นต้น สิ่งที่ตัวอย่างเหล่านี้มีเหมือนกันคือ

  - มี subclass เกิน 100 ขึ้นไป
  - มี documentation ควบคู่การใช้งาน superclass ที่ดี
  - มีความลึกของ superclass-subclass (hierarchy) ที่ต่ำ

ทั้งนี้ข้อเสียของการใช้งาน Inheritance ก็ยังมีอยู่คือ ถ้าเราต้องการจะแก้ไขย้อนกลับ มันมีแนวโน้มที่ยากกว่า Composition นั่นเอง

## ปิดท้ายด้วย Tips ในการออกแบบ OOP
การออกแบบ OOP ที่ดีจะต้องเริ่มจากการระบุว่า data คืออะไร (state) ตามด้วยพฤติกรรม (behavior หรือ procedure) ว่าสิ่งที่ทำมันเกี่ยวข้องอะไรกับ state สุดท้ายเราก็นำ state และ procedure มาจับกลุ่มกัน แน่นอนว่าสิ่งเหล่านี้ไม่ได้ดูครั้งแรกทีเดียวแล้วจะรู้ทุกคน แต่เราสามารถฝึกการสังเกตจากโจทย์ที่พบเจอในการทำงานปัจจุบัน


