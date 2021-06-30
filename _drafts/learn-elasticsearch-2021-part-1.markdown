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
- **Term** เป็น "คำ" ที่ถูกแบ่งออกมาจาก text ใน Document
- **Field** ส่วนของ Document ที่เป็น JSON key
- **Type** เป็น metadata ของ Document เช่น index ของ *car* อาจจะมี type เป็นยี่ห้อ
- **Mapping** เป็นวิธีการระบุว่า Document และ Field จะถูกนำไปทำ Index ยังไง
- **Lucene index** หรือ inverted index ซึ่งเก็บข้อมูลเป็น map ระหว่าง Term กับ Document ที่เก็บมันไว้
- **Shard** ส่วนของ Index ที่ถูก distribute ออกไปอยู่ตาม node ต่างๆ อยู่ในรูปแบบของ Lucene index
- **Replica** สำเนาของ shard เพื่อป้องกันเวลา node ใดๆ ล่ม (2 replicas = 1 primary + 2 replicas)
- **Segment** ส่วนของ shard เมื่อทำการ search ตัว Elasticsearch จะรวบรวมผลจากแต่ละ segment ออกมา

| RDBMS    | Elasticsearch |
|----------|---------------|
| Database | Index         |
| Table    | Type          |
| Row      | Document      |
| Column   | Field         |

Inverted index มาจาก [Apache Lucene](https://lucene.apache.org/index.html) ซึ่งมีไว้สำหรับทำ full-text search เวลา Elasticsearch ได้รับ document มา เช่น

| Document | Data                             |
|----------|----------------------------------|
| 1        | The Best Pasta Recipe with Pesto |
| 2        | Delicious Pasta Carbonara Recipe |


Elasticsearch จะเก็บ Document และทำการ index โดยใช้ Lucene สร้าง inverted index ที่มีหน้าตาประมาณนี้

| Term      | Count | Document No. |
|-----------|-------|--------------|
| best      | 1     | 1            |
| carbonara | 1     | 2            |
| delicious | 1     | 2            |
| pasta     | 2     | 1, 2         |
| pesto     | 1     | 1            |
| recipe    | 2     | 1, 2         |
| the       | 1     | 1            |
| with      | 1     | 1            |

แทนที่ Elasticsearch จะหาว่า Document ใดๆ มี term นี้ไหม จะกลายเป็นหาว่า term นี้มันอยู่ใน Document ไหนบ้าง ทำให้ inverted index เหมาะสำหรับการทำ full-text search นั่นเอง  

ในระหว่างที่ Elasticsearch กำลังทำ index มันจะ write ข้อมูล ลงไปใน memory (write-ahead logs) และทุกๆ วินาทีก็จะ write ลงไปใน Segment เมื่อมีการ search แต่ละ shard มันก็จะดึง result จาก segment มารวมๆ กัน  

ปัญหาคือยิ่ง Segment เยอะ ยิ่งต้องใช้เวลารวมเยอะ ดังนั้น Elasticsearch จะจัดการ merge Segment เหล่านี้ให้ เป็นเหตุผลว่าทำไม Segment ไม่สามารถ delete ได้ แต่จะใช้ mark as deleted แทน 

เราสามารถกำหนดจำนวนของ shard ในแต่ละ index ได้ เช่น สมมติเรามี 5 shard ใน node เดียว

```
 ____    ____    ____    ____    ____
| 1  |  | 2  |  | 3  |  | 4  |  | 5  |
|____|  |____|  |____|  |____|  |____|
```

การที่เรามี shard เยอะใน node เดียวช่วยทำงานแบบ parallel ได้เร็วขึ้น พอเราเพิ่มเข้ามาอีก node นึง เพื่อช่วยเรื่อง scalability พวก shard ก็จะถูกกระจายไปอยู่กันคนละ node

**Node 1**
```
 ____    ____    ____ 
| 1  |  | 2  |  | 3  |
|____|  |____|  |____|
```

**Node 2**
```
 ____    ____
| 4  |  | 5  |
|____|  |____|
```

การที่มี replica shard ก็จะช่วยเพิ่ม performance และ failover ก็จะได้หน้าตาประมาณนี้

**Node 1**
```
 ____    ____    ____    ____    ____
| 1  |  | 2  |  | 3  |  | 4R |  | 5R |
|____|  |____|  |____|  |____|  |____|
```

**Node 2**
```
 ____    ____    ____    ____    ____
| 1R |  | 2R |  | 3R |  | 4  |  | 5  |
|____|  |____|  |____|  |____|  |____|
```

ดังนั้นเมื่อ node ล่ม ตัว replica shard ก็จะกลายเป็น primary shard และ node ก็มี index ครบ 
> **ข้อสังเกต**
> - สมมติว่าเราตั้งจำนวนของ replica เป็น 1 จะทำให้ 5 shard ไม่ถูก assign เพราะ replica shard ไม่สามารถอยู่ node เดียวกับ primary shard ได้ (เหมือนทำ backup ไว้ในเครื่อง original อ่ะ เพื่อ!!)
> - แต่ละ index จะมีอย่างน้อย 1 primary shard เสมอ ถ้าสมมติเรามี node เดียวแล้วดูไม่มีวี่แววว่าจะโตนะ ก็มีแค่ shard เดียวพอละ เปลืองเงิน
> - เมื่อ set จำนวน shard แล้ว ไม่สามารถเปลี่ยนได้ ถ้าอยากเปลี่ยนก็ต้องสร้าง index ใหม่ด้วยจำนวน shard ใหม่แล้วค่อยย้าย Document ไปที่ index ใหม่ ผ่าน [Reindex API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html)

## Installation
ผมใช้ Docker ในการติดตั้ง ครับ เข้าไปดูใน repo <https://github.com/raksit31667/elasticsearchtraining> ได้ครับ
(ผมยืม <https://github.com/mrchoke> มาอีกที)

```shell
$ docker compose up -d
```
โดย Elasticsearch จะ expose port 9200 สำหรับใช้ REST API ในการส่ง Query หรือ ดูข้อมูลพวก cluster หรือ nodes
ส่วน port 9300 จะใช้ในการติดต่อกันระหว่าง node ผ่าน Java API  

เข้าไปดู Cluster health ผ่าน <http://localhost:9200/_cluster/health>

<script src="https://gist.github.com/raksit31667/70cfec68bec437282af549f7e6a6ae3a.js"></script>

Status ของ Cluster ดูได้ตามตารางนี้ครับ

| Status | Meaning                                          |
|--------|--------------------------------------------------|
| Green  | All shards are allocated                         |
| Yellow | Primary shard is allocated, but replicas are not |
| Red    | Shard not allocated in the cluster               |

เข้าไปดู Node ผ่าน <http://localhost:9200/_cat/nodes?v>

```txt
ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role  master name
172.22.0.2           59          53  22    2.65    2.25     2.60 cdfhimrstw *      es
```

## Searching / Query
การ search แบ่งเป็น 2 ส่วนคือ query คือ filter ซึ่งจะใช้ Domain specific language ในรูปแบบของ JSON

| Query            | Filter           |
|------------------|------------------|
| Relevance        | Boolean (yes/no) |
| Full text search | Exact values     |
| Not cached       | Cached           |
| Slower           | Faster           |

<script src="https://gist.github.com/raksit31667/00e4c72f5213455883b94943c514b30b.js"></script>

> Rule of thumb: Filter ก่อน แล้วค่อย query documents ที่เหลือ

## Aggregation
- Count
- Range
- Order
- Sort

<script src="https://gist.github.com/raksit31667/0b0796c2f4ad332384ef156ff7e42632.js"></script>

## Mapping
1. Explicit mapping ระบุตรงๆ ไปเลยว่า field ไหน type อะไร
2. Dynamic mapping ให้ Elasticsearch จัดการให้อัตโนมัติ โดยเราสามารถเข้าไปเขียน custom rule ได้

<script src="https://gist.github.com/raksit31667/38c72ffab979d7449157b2bfa1a62198.js"></script>

> ไม่มี data type **array** ใน Elasticsearch ถ้าอยากจะ query แบบแยก object กันไป ให้ใช้ **nested** แทน

<script src="https://gist.github.com/raksit31667/4e88a598b76f2f0be0e577b2754eb21b.js"></script>

> ใช้ data type **text** สำหรับ full-text search และ **keyword** สำหรับ filter (exact values)

## Analyzer
- Analyzer
- Tokenizer
- Filter

<script src="https://gist.github.com/raksit31667/8c54af81dff4b028636b5a72ec1f8790.js"></script>

## Suggestor
- Term
- Autocomplete
- N-gram tokenizer

<script src="https://gist.github.com/raksit31667/29be23de4a2e87b59124e680c25909da.js"></script>

## Profiling
- Explain API
- Profile API

<script src="https://gist.github.com/raksit31667/33e27e33088e1a673f4eb4d9e5e20987.js"></script>

ปิดท้ายด้วยหน้า web e-Commerce ครับ จินตนาการว่าเราสามารถใช้ API อะไรจาก Elasticsearch ได้บ้าง
![Elasticsearch e-Commerce](/assets/2021-06-29-elasticsearch-ecommerce.png)
<https://mageguides.com/install-elasticsearch-magento-2/>

## References
- [Elasticsearch Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Course :: ELK stack](https://github.com/up1/course_elk)
- [Shards and replicas in Elasticsearch](https://stackoverflow.com/questions/15694724/shards-and-replicas-in-elasticsearch)