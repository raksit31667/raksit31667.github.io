---
layout: post
title:  "Experience Using Azure Databricks at ExxonMobil for a month"
date:   2020-06-30
tags: [azure, databricks, spark]
---
## Full GC causes driver crashed with an OOM exception

### Problems
One common cause is that the Spark driver is undergoing a memory bottleneck. When this happens, the driver crashes with an out-of-memory (OOM) and gets restarted or becomes unresponsive due to frequent full garbage collection (GC).  

Our system contained 4 jobs running on a single interactive cluster, some of them are 1-minute scheduled jobs, which affected the overall job performance.

### Attempts
- Reduce the interval of periodic GC cleaning by configuring `spark.cleaner.periodicGC.interval, 15mins` (30 minutes by default)
- Clear `sparkContext` after scheduled job finished by configuring `spark.gracefullyShutdown, true`. We found that `sparkContext` still existed by observing cluster memory kept constantly increasing every 1 minute, corresponding to scheduled jobs.
- Upgrade the library used to integrate with Azure EventHub `com.azure:com.microsoft.azure:azure-eventhubs-spark_2.12` to be the latest one.

### Resolutions
- We detached interactive cluster from each running job and replaced with automated cluster, 1 job per cluster. This improved job performance significantly with an exchange of an applied additional infrastructure cost, and slow deployment speed because automated clusters have more overhead than interactive clusters (which can be solved by [Databricks Pools](https://databricks.com/blog/2019/11/11/databricks-pools-speed-up-data-pipelines.html)).
- We also guaranteed `sparkContext` one-time initialization by modifying code as following snippets:

<script src="https://gist.github.com/raksit31667/d35fe9272b8d99d9537ceecef582fa70.js"></script>

### Key Takeaways
- Avoid memory-intensive operations, such as Spark SQL [collect](https://spark.apache.org/docs/latest/api/scala/org/apache/spark/sql/Dataset.html#collect():Array[T]) function, large DataFrame transformation; or scale up cluster memory appropriately.
- Regardless of cluster size, Spark driver functionalities (including logs) cannot be distinguished within a cluster. That is why we found mixed logs from every running jobs.


## Sending Standard output and Standard error from Databricks to Application Insights directly

### Problems
We would like to send logging from all Databricks clusters to Application Insights by configuring custom `log4j` appender.
<script src="https://gist.github.com/raksit31667/35519cc15087b21ef1d7daeb56cdaf9b.js"></script>
<script src="https://gist.github.com/raksit31667/6f349283fe5647969bc24a0d97a5a10f.js"></script>

However, Spark job could not find `TelemetryConfiguration` after the library `com.microsoft.azure:applicationinsights-logging-log4j1_2:2.5.1` is uploaded.

![Telemetry Exception](/assets/2020-06-26-telemetry-exception.png)

### Resolutions
- There is no supported method to send Standard output and Standard error from Databricks to Application Insights directly.
- We saved Spark driver logs to [Databricks File System](https://docs.databricks.com/data/databricks-file-system.html) (DBFS). Still, this is not an idea solution because of poor discoverability.
- There is a repository https://github.com/AdamPaternostro/Azure-Databricks-Log4J-To-AppInsights which shows how to send log4j logs to Application Insights.

![DBFS logging](/assets/2020-06-26-cluster-logging-dbfs.png)


## LimitExceededException from writing too large text data

### Problems
There were some jobs processing large JSON data retrieved from EventHub throwing the following exception:

```
com.databricks.spark.util.LimitedOutputStream$LimitExceededException: Exceeded 2097152 bytes (current = 2099270)

com.fasterxml.jackson.databind.JsonMappingException: Exceeded 2097152 bytes (current = 2099270) (through reference chain: org.apache.spark.sql.execution.ui.SparkListenerSQLExecutionStart['physicalPlanDescription'])
```

### Resolutions
Scale up maximum size of Spark capacity to handle Event Log `spark.conf.set("spark.eventLog.unknownRecord.maxSize","16m")`. 
Strangely, the in-code configuration was ineffective, so we needed to configure via Databricks Job API instead.

<script src="https://gist.github.com/raksit31667/5470694c946b943c8a6e786137a20632.js"></script>

<script src="https://gist.github.com/raksit31667/7c38d2c9a0c69de37c178455f6c48f81.js"></script>


## ReceiverDisconnectedException

### Problems
This exception was thrown if there are more than one Epoch receiver connecting to the same partition with different epoch values.

<script src="https://gist.github.com/raksit31667/6a4ee08031c1464bfb43f380eafee574.js"></script>

According to [Microsoft documentation](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-event-processor-host#epoch), 
by using `com.azure:com.microsoft.azure:azure-eventhubs-spark_2.12` version 2.3.2 and above, the existing epoch receiver will be disconnected if we create a new receiver which consumer from the same consumer group with an **epoch value < existing epoch value**.

Therefore, we have to be assured that our streaming application contain **only one** consumer group per Spark session being run.

### Resolutions
- Limit EventHub stream by storing EventHub messages in DBFS as Parquet format. Then, create an another stream to read from DBFS and continue logging streams.

<script src="https://gist.github.com/raksit31667/9036fe8cadbe11c5da8a47e44360eb11.js"></script>

For the [production grade](https://docs.databricks.com/spark/latest/structured-streaming/production.html#optimize-performance-of-stateful-streaming-queries), it is recommended to replace in-memory DBFS with other persistent storages, such as [RocksDB](https://rocksdb.org/).

![DBFS logging](/assets/2020-06-29-databricks-monitoring.png)

- If we want to write the output of streaming query to multiple streaming data sources (i.e. logging and database) using `foreachBatch` or `foreach`, be mindful that output can be recomputed (and even reread the input) every time we attempt write the output. Leveraging `DataFrame` cache will avoid this issue.