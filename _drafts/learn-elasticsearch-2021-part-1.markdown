---
layout: post
title:  "สรุปสิ่งที่ได้เรียนรู้เกี่ยวกับ Elasticsearch ปี 2021 (Part 1)"
date:   2021-06-29
tags: [elasticsearch]
---

## What is Elasticsearch?
Elasticsearch เป็น Open Source, Document-based, Distributed Search Engine สร้างมาเพื่อ 5 อย่าง
1. **Search** รองรับ data หลายรูปแบบ เช่น text, metrics หรือ geolocation
2. **Analytic** มี feature ให้พร้อม เช่น tokenizer (การตัดคำ) หรือ suggestion
3. **Real-time** เร็ว แรง จากการจัดกลุ่ม document ผ่านวิธีการ indexing
4. **Distributed** นอกจากแก้ปัญหาเรื่อง load แล้ว ถ้ามีเครื่องนึงล่มไป ตัวอื่นๆ ก็ยังทำงานได้อยู่
5. **Scalability** มี sharding mechanism ที่ช่วย distribute ข้อมูลเมื่อเพิ่ม หรือ ลด volume ของเครื่อง

## Use cases
- GitHub สำหรับ search source code, repos, users, issues, PRs
- StackOverflow สำหรับทำ full text search + geolocation

## Architecture
เริ่มจาก terminology กันก่อน
- **Node** server ที่ใช้ run Elasticsearch อาจจะมี role ต่างๆ เช่น *master*
- **Cluster** กลุ่มของ Node จัดการการเข้าถึงข้อมูลจาก Node ผ่าน REST API
- **Document** ข้อมูลที่มาในรูปแบบของ JSON object มี ID ที่สามารถกำหนดเองได้
- **Index** กลุ่มของ Document ที่มีข้อมูลคล้ายๆ กัน
- **Token** เป็น "คำ" ที่ถูกแบ่งออกมาจาก text ใน Document
- **Field** ส่วนของ Document ที่เป็น JSON key
- **Type** เป็น metadata ของ Document เช่น index ของ *car* อาจจะมี type เป็นยี่ห้อ
- **Mapping** เป็นวิธีการระบุว่า Document และ Field จะถูกนำไปทำ Index ยังไง
- **Lucene index** หรือ inverted index ซึ่งเก็บข้อมูลเป็น map ระหว่าง Token กับ Document ที่เก็บมันไว้ สำหรับทำ full-text search
- **Shard** ส่วนของ Index ที่ถูก distribute ออกไปอยู่ตาม node ต่างๆ อยู่ในรูปแบบของ Lucene index
- **Replica** สำเนาของ shard เพื่อป้องกันเวลา node ใดๆ ล่ม (2 replicas = 1 primary + 2 replicas)

| RDBMS    | Elasticsearch |
|----------|---------------|
| Database | Index         |
| Table    | Type          |
| Row      | Document      |
| Column   | Field         |

Inverted index
Apache Lucene
Write-once and read-many-times structure Called “Segment”
Can’t be delete (just marked to deleted)

## Installation
https://github.com/raksit31667/elasticsearchtraining

RESTful API with JSON Over HTTP (9200) Java API (9300)

| Status | Meaning                                          |
|--------|--------------------------------------------------|
| Green  | All shards are allocated                         |
| Yellow | Primary shard is allocated, but replicas are not |
| Red    | Shard not allocated in the cluster               |

## Searching / Query

| Query            | Filter           |
|------------------|------------------|
| Relevance        | Boolean (yes/no) |
| Full text search | Exact values     |
| Not cached       | Cached           |
| Slower           | Faster           |

Filter first, then query remaining documents

## Aggregation

![Elasticsearch e-Commerce](/assets/2021-06-29-elasticsearch-ecommerce.png)
<https://mageguides.com/install-elasticsearch-magento-2/>

## Mapping
1. Explicit mapping
2. Custom mapping

- No data type array in Elasticsearch

## Analyzer

## Suggestor
- N-gram tokenizer

## Geo-location
- geoip

## Profiling
- Explain API
- Profile API