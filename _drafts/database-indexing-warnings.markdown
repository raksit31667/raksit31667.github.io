---
layout: post
title:  "บันทึกข้อควรระวังในการทำ database indexing"
date:   2021-11-16
tags: [database]
---

ในระบบงานที่เชื่อมต่อกับ database ไม่ว่าจะเป็น relational database หรือ document database ถ้าเราพูดถึงการ optimize query เพื่อปรับปรุง performance ให้ดีขึ้นแล้วนั้น หนึ่งในวิธีที่นิยมใช้กันนอกเหนือจากการ scale คงหนีไม่พ้น indexing แต่ว่าในบางกรณีหลังการทำ indexing กลับไม่ได้ทำให้ performance ดีขึ้นเลย ทั้งที่เราก็ตั้ง index ใน column ที่ถูกต้องแล้วนิ มันเกิดอะไรขึ้น  

## 1. Column ที่ทำ index ของ row ส่วนใหญ่มีค่าเหมือนกัน
ถ้า dataset ส่วนใหญ่มีค่าเป็นค่าใดค่าหนึ่ง การใช้งาน index ก็แทบจะไม่ต่างจาก full table scan ตัวอย่างเช่น เรามี table ชื่อ `author` มีข้อมูลอยู่ 1000 rows 99% มี `age` มีค่าเป็น 18 และอีก 1% มีค่าเป็น 19

<script src="https://gist.github.com/raksit31667/0086835ef66bd12f5d4ae371cdb1d305.js"></script>

## 2. Query case-insensitive บน column ที่ทำ index
ในกรณีที่มีการ query column ที่เป็น String (เช่น `varchar` หรือ `text`) ซึ่งรองรับการค้นหาโดยไม่สนใจตัวใหญ่-ตัวเล็ก (case-insensitive) ด้วยการแปลง input query และ dataset ให้ตรงกันผ่าน `upper` หรือ `lower` function แต่ดันทำ index column ก่อนแปลงข้อมูล ทำให้ index ไม่มีความหมายเพราะไม่ได้ถูกใช้งาน ดังนั้นเราต้องสร้าง index บน column ไปกับการใช้ `upper` หรือ `lower` function ด้วย

<script src="https://gist.github.com/raksit31667/aed4d983e2c2f2c70e4a6540afc94da4.js"></script>

สำหรับการทำ full-text search ต่อให้สร้าง index ข้างต้นก็ไม่ได้ช่วยอะไรนะครับ ต้องหันไปใช้พวก operator อื่นๆ แทน

<script src="https://gist.github.com/raksit31667/92ec812d6f358363eee3ffa566042c81.js"></script>

## 3. Query แค่บาง column ที่ทำ composite index
สมมติว่าทำ composite index ด้วย 2 column แต่ตอน query ดันใช้ `OR` operator หรือใช้แค่ column เดียว เพราะ index จะทำตามลำดับ column ด้านซ้ายไปขวา ดังนั้น index จะถูกใช้แค่ column ด้านซ้าย ส่วน column ด้านขวา จะเป็น full table scan แปลว่า ถ้าเราจะใช้ composite index มันน่าจะเหมาะกับ query ที่ต้องเรียกใช้ทุก column ใน index ในลักษณะ `AND` operator มากกว่า

<script src="https://gist.github.com/raksit31667/1e91820c9dc894a7d32da11396e6cb9a.js"></script>

> จากตัวอย่าง 3 ข้อ น่าจะพอเห็นได้ว่า การใช้งาน index ไม่ได้การันตีว่ามันจะช่วยปรับปรุง performance ให้มันดีขึ้น ดังนั้นก่อนการใช้งาน ควรทำความเข้าใจพฤติกรรมของ index รวมไปถึงรูปแบบของ query ที่ใช้ และ dataset หรือแม้กระทั่งการปรับปรุงด้วยวิธีการอื่นๆ เช่น partitioning หรือ sharding เป็นต้น

<iframe width="560" height="315" src="https://www.youtube.com/embed/oebtXK16WuU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

