---
layout: post
title:  "Experience Using Azure Databricks at ExxonMobil for a month"
date:   2020-06-10
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


## LimitExceededException from writing too large text data into EventLog
Save plain JSON string into DF
```
spark.conf.set("spark.eventLog.unknownRecord.maxSize","16m")
```

### EpochException (TBC)
Duplicated consumer groups in one EventHub entity