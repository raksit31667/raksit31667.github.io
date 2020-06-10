---
layout: post
title:  "ปัญหาที่พบเจอและวิธีแก้จากการใช้งาน Azure Databricks มา 1 เดือนเต็ม"
date:   2020-06-10
tags: [databricks, spark]
---
## Send Standard output and Standard error from Databricks to application insights directly
- There is no supported method to send Standard output and Standard error from Databricks to application insights directly.
- I have found a document https://github.com/AdamPaternostro/Azure-Databricks-Log4J-To-AppInsights which shows how to send log4j logs to application insights and I have tested for that, it works.

## Driver crashes with an out of memory (OOM) because of sparkContext initialization
- It is not required to use this config if you are running the job in the Databricks cluster.
- Currently, spark.cleaner.periodicGC.interval will trigger every 30 minutes(default). In our use case, job is triggering for every 1 minute So we need to decrease the spark.cleaner.periodicGC.interval config value. Set the below line in the cluster level configuration.

```
spark.cleaner.periodicGC.interval 15min
```

- Some other application is also running in the cluster. Currently, 4 jobs are running in the same cluster which will affect the performance of the jobs. We need to provide a good amount of resources(CPU and memory) for a cluster to get a good performance on the jobs.

- Since we catch a failure of the library installed( Currently using the com.azure:com.microsoft.azure:azure-eventhubs-spark_2.12:2.3.13). Please use the below library. com.azure:com.microsoft.azure:azure-eventhubs-spark_2.12:2.3.15

## LimitExceededException from writing too large text data into EventLog
```
spark.conf.set("spark.eventLog.unknownRecord.maxSize","4m")
```
