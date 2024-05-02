---
layout: post
title: "ทบทวนเรียน Laravel จากการเขียน test"
date: 2024-05-01
tags: [php, laravel, programming, kata, test-driven-development]
---

ช่วงนี้มีโอกาสได้สลับมาเขียนภาษา [PHP](https://www.php.net/) บน [Laravel Framework](https://laravel.com/) พบว่า ecosystem ของเขาไปไกลมากกว่าที่เราเคยรู้มาก่อนหน้านี้เยอะเลย เช่น การขึ้น project ใหม่ด้วย [Composer](https://getcomposer.org/) โดยเฉพาะ [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) ที่มี frontend เป็นรูปแบบ server-side rendering
หรือ managed service เช่น payment, caching, deployment ก็มีมาให้ครบ  

แต่เพื่อความรวดเร็วในการเรียนรู้สิ่งใหม่ ๆ เราเลยลองใช้ technique เดียวกับตอนที่เรียนภาษาอื่น ๆ คือ เรียนจากการแก้ test ให้มันผ่าน อย่างของภาษา Go เขาก็มี [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests) ก็เลยลองแนวคิดนี้มาประยุกค์กับการเรียน PHP + Laravel ไปเลย  

**หมายเหตุ**: เราประยุกต์โจทย์มาจาก blog [[PHP] เรียนรู้การพัฒนา Web Application ด้วย Laravel framework ตามแนวคิด Test Driven](https://www.somkiat.cc/learn-laravel-with-test-driven/) อีกทีนะ

## 1. เริ่มต้นด้วยการขึ้น project ใหม่ก่อน

```shell
$ composer create-project laravel/laravel <your-project-name>
```

## 2. เริ่มเขียน test แรก
โดยโจทย์ของเราคือเราจะมี `User` ที่มี `Account` ได้หลาย ๆ อัน เมื่อมีข้อมูลทั้งสองอยู่ใน database ตอนที่ call API `GET /users/<username>` จะต้องส่งข้อมูลกลับมา ก็จะได้ test หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/b3b50a202a0562d9f2ae8e6a5fad8d9c.js"></script>

พอลองเขียนแล้วลอง run test ปรากฎว่า run ได้ แต่เจอ error ประมาณนี้

```
Error: Class "Tests\Feature\User" not found
```

### สิ่งที่ได้เรียนรู้เพิ่มเติม
- PHP เป็น [interpreted language](https://en.wikipedia.org/wiki/Interpreter_(computing)) (ทำการแปลง code เป็น machine instruction ไปเรื่อย ๆ จนกว่าจะเจอ error) เพราะว่าเรายังไม่ได้สร้าง class `User` แต่ยัง run code ขึ้นมาได้
- การสร้าง record ใหม่จาก model เพื่อ insert ลง database ผ่าน [Eloquent](https://laravel.com/docs/master/eloquent) ซึ่งเป็น ORM ที่ Laravel เพิ่มเข้ามา โดยความต่างของ `create` กับ `make` คือ `create` จะทำการ save ลง database ให้โดยอัตโนมัติ ในขณะที่ `make` จะต้องไปเรียก function `save` ลง database อีกที
- การใช้งาน [assertion](https://docs.phpunit.de/en/9.6/assertions.html) ต่าง ๆ ผ่าน [PHPUnit](https://phpunit.de/index.html) ซึ่งเป็น testing framework ที่ Laravel เพิ่มเข้ามา

## 3. Import User model เข้ามา

<script src="https://gist.github.com/raksit31667/9cc91a86d141081cb02ad4b364deea93.js"></script>

ลอง run test ปรากฎว่า error แต่คราวนี้ message เปลี่ยนไป ถือว่ามีพัฒนาการ ฮ่า ๆๆ

```
Illuminate\Database\QueryException: SQLSTATE[08006] [7] connection to server at "127.0.0.1", port ... failed: Connection refused
```

## 4. เปิดการใช้งาน in-memory database สำหรับการทดสอบ
ตอนนี้เราไม่สามารถเชื่อมต่อ database เพื่อ save `User` ลงไปได้ ซึ่งวิธีแก้ก็คือสร้าง database ขึ้นมาเพื่อทำการทดสอบโดยเฉพาะ ซึ่งตอนแรกเราว่าจะใช้ PostgreSQL ที่สร้างผ่าน Docker แต่นั่นก็หมายความว่าเมื่อต้องการจะทดสอบเราจะต้อง run PostgreSQL โดยเฉพาะถ้า run บน CI จะต้องออกแรงติดตั้งเพิ่มอีก  

โชคดีที่ PHPUnit เขามี in-memory SQLite ให้เลยโดยไม่ต้องไปติดตั้ง database เองโดยไม่จำเป็น เราแค่ต้องไป uncomment configuration ใน `phpunit.xml` ตรง `DB_CONNECTION` กับ `DB_DATABASE` ครับ
 
<script src="https://gist.github.com/raksit31667/5790ae58750e40a6cca6f141d935e249.js"></script>

ลอง run test ปรากฎว่า error แจา message เปลี่ยนไปเช่นเคย

```
Illuminate\Database\QueryException: SQLSTATE[HY000]: General error: 1 no such table: users
```

## 5. ทำการ migrate database schema ลงใน in-memory database
ใน test case ให้เราเพิ่ม `use RefreshDatabase;` เข้าไปเพื่อทำการ migrate และ clean database ทั้งก่อนและหลังการ run test ซึ่งโดยปกติแล้ว Laravel จะเก็บ migration ไว้ที่ `database/migrations` ซึ่งจะมีทั้ง `up` และ `down` สำหรับ forward และ reverse กลัับ

<script src="https://gist.github.com/raksit31667/909393cda43bc72975001bbb1dae5f1e.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
Error: Class "Tests\Feature\Account" not found
```

## 6. สร้าง Account model ขึ้นมา
ให้เราสร้าง model ใหม่ด้วยคำสั่ง

```shell
$ php artisan make:model Account
```

[Artisan](https://laravel.com/docs/master/artisan) ซึ่งเป็น command-line interface ของ Laravel จะไปสร้าง model `Account` ใน directory `app/Models` หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/7929dec87ef5e2e24297585d56a1213c.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
Error: Class "Database\Factories\AccountFactory" not found
```

## 7. สร้าง Factory ขึ้นมา
[Factory](https://laravel.com/docs/master/eloquent-factories) คือสิ่งที่ Eloquent เตรียมไว้ให้เพื่อทำการเพิ่ม record ลงไปใน database สำหรับใช้ในการทดสอบโดยเฉพาะ (seeding) เพื่อแยกส่วนของการเตรียมข้อมูลที่ใช้ในการทดสอบออกจาก test code ทำให้อ่านง่ายขึ้น นอกจากนั้นแล้วยังสามารถ generate attribute แบบสุ่มโดยใช้ [Faker](https://fakerphp.github.io/) ได้ด้วย ทำให้ชุดการทดสอบเราแข็งแรงดัก edge case ได้ดีมากขึ้น ดังนั้นให้เราสร้าง factory ใหม่ด้วยคำสั่ง

```shell
$ php artisan make:factory AccountFactory
```

คำสั่งนี้จะไปสร้าง factory `AccountFactory` ใน directory `database/factories` จากนั้นตรง return statement ของ function `definition` ให้ทำการ return array โดย `Account` ของเราจะมี field ชื่อว่า `account_no` ซึ่งให้ทำการสุ่มชื่อไว้เป็น default

<script src="https://gist.github.com/raksit31667/7a2f6143f7688dbc529542960f25fa56.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
Illuminate\Database\QueryException: SQLSTATE[HY000]: General error: 1 no such table: accounts
```

## 8. สร้าง migration file สำหรับ Account
ถ้าเราเข้าไปดู migration ที่ `database/migrations` จะพบว่ามันมี migration file ติดตั้งไว้ให้พร้อมแล้วสำหรับ `User` แต่ว่าของ `Account` ยังไม่มี จึงต้องไปสร้างใหม่ด้วยคำสั่ง

```shell
$ php artisan make:migration create_accounts_table --create=accounts
```

พอเราเข้าไปที่ migration file ใหม่ใน functiom `up` ให้ทำการกำหนด column ใหม่ 2 อันก็คือ `user_id` เพื่อเชื่อม key ไปหา `User` และ `account_no` ของตัวมันเอง

<script src="https://gist.github.com/raksit31667/9de5b348f733fea852c9becf6cb261e3.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
BadMethodCallException: Call to undefined method App\Models\User::accounts()
```

## 9. ประกาศ relationship ระหว่าง User และ Account
ใน test case ตรง statement `$user->accounts()->save($newAccount);` หมายถึงว่าเราจะทำการเพิ่ม `newAccount` เข้าไปเป็นหนึ่งใน `accounts` ของ `User` แล้วก็ save ลง database จาก error message คือเรายังไม่ได้ประกาศ relationship ว่า `User` มีได้หลาย `Account` ให้เราไปสร้าง function ใหม่ใน `User` ดังนี้

<script src="https://gist.github.com/raksit31667/a30517cf90698351cb19882f3e121746.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
Expected response status code [200] but received 404.
```

## 10. เพิ่ม routing ของ URL path /users/{username}
ในกรณีนี้เราจะรับ `username` เข้ามาเป็น path variable เพื่อที่จะนำไปหาใน database ให้ return ข้อมูล User ที่ `name` ตรงกับ `username`  

ให้ไปที่ `routes/web.php` จากนั้นเพิ่ม route ใหม่ลงไป

<script src="https://gist.github.com/raksit31667/f6423aaddfec2f3eb2584434738dcbe8.js"></script>

ลอง run test ปรากฎว่า error แต่ message เปลี่ยนไปเช่นเคย

```
Expected response status code [200] but received 500.
```

## 11. เพิ่ม UserController แล้วเชื่อมกับ route ที่สร้างไว้ก่อนหน้า
สร้าง controller ใหม่ด้วยคำสั่ง

```shell
$ php artisan make:controller UserController
```

จะได้ file ใหม่อยู่ที่ directory `app/Http/Controllers/` จากนั้นเข้าไปเพิ่ม function `show` 

<script src="https://gist.github.com/raksit31667/db4aea523d3e67d4e81546425a4597a2.js"></script>

จากนั้นกลับไปที่ `routes/web.php` แล้วก็เชื่อม `UserController` เข้ากับ route ใหม่ประมาณนี้

<script src="https://gist.github.com/raksit31667/85b4837f19772e75bc2c58cdabe17715.js"></script>

ลอง run test ปรากฎว่าผ่านแล้ว!

## 12. Refactor
ใน `UserController` เราสามารถหยิบ statement `User::with('accounts')->where('name', $username)->first()` ให้เป็น function ข้างใน `User` model ได้ เช่น `findByName($username)` แทน ให้เราเริ่มต้นจากการสร้าง test ขึ้นมาอีกชุดนึงสำหรับทดสอบ function `findByName` โดยเฉพาะ จะได้หน้าตาประมาณนี้

<script src="https://gist.github.com/raksit31667/770b10987230fa2348831ec7031e2d27.js"></script>

จากนั้นทำการ run test ก็จะพบว่า error

```
BadMethodCallException: Call to undefined method App\Models\User::findByName()
```

ให้เราไปเพิ่ม function ใหม่ใน `User` model ประมาณนี้

<script src="https://gist.github.com/raksit31667/265e832d329931c2ec0604151c6e6c6b.js"></script>

ลอง run test ใหม่ปรากฎว่าผ่านแล้ว! คราวนี้เราก็สามารถ refactor `UserController` ตามที่บอกไปได้

<script src="https://gist.github.com/raksit31667/195bde659ea11d73689227875d0307ea.js"></script>

ลอง run test อันเก่าปรากฎว่ายังผ่านอยู่ เป็นอันจบงาน

## สรุป
จากการนำ technique ในการเรียนรู้ภาษา PHP และ Laravel framework ผ่านการทดสอบทำให้เราเข้าใจจุดประสงค์ของส่วนประกอบแต่ละชื้นใน Laravel ได้ลึกซึ้งมากขึ้น เพราะเราจะเห็นเลยว่าถ้าขาดส่วนไหนไป อะไรจะเกิดขึ้น ไม่ว่าจะเป็น

- Eloquent ORM
- Model
- Factory
- Database migration
- Routing
- Controller
- Testing
- Laravel command line 

> ลองนำ technique นี้ไปใช้ในการเรียนรู้ภาษาใหม่ ๆ กันดูครับ