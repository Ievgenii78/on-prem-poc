# Introduction 
Archive of near real-time processing project on Trino. Azure, Kafka, Stabust, and TrinoDB are deployed with Kubernetes. In this poc we will see how to query delta tables in presto. We are using trino which is another flavour of presto.

# Pipeline Overview
In this project, we have implemented a data processing pipeline that leverages the following components:
- **Apache Kafka on Kubernetes**: This component acts as a distributed streaming platform for ingesting and processing data in real-time. It provides high-throughput, fault-tolerant messaging capabilities.
- **Trino (formerly known as PrestoSQL)**: Trino is an open-source distributed SQL query engine that enables fast and interactive analysis of data. It allows users to query data from various sources, including Hive Metastore, and retrieve results efficiently.


# Components
[In progress]

# Installation
[In progress]

# Configuration
**Apache Kafka on Kubernetes**
  - Deployment Kafka
  - Verification CDC \
    insight Virtual machine, in worker node, install MySQL: \
    sudo apt install mysql-server

    To get into MySQL: \
    mysql -h sqlf-eus-sccspoc-dev.mysql.database.azure.com -P 3306 -u sccrpocmysql -p
    password:  D4_RR_DQUoE1ir

  - Kafka CLI Installing & Using \
    Command to review kafka inside:  bin/kafka-console-consumer.sh --bootstrap-server 10.136.86.91:9094 --topic sqlf-eus-sccspoc-dev.schema1.table1 --from-beginning
    
 **Trino (formerly known as PrestoSQL)**
   - Trino Deployment \
     For deployment please refer to this helm chart: https://github.com/IvanWoo/trino-on-kubernetes#trino
   - TRINO CLI \
     To use Trino CLI we need to install Trino server
   - CSV query
   - DELTA TABLES query

# Usage
1. Start the Apache Kafka cluster on Kubernetes.
2. Use Trino to query the data stored in the Hive Metastore and retrieve results.

## Steps to execute poc:
1. Do 
   ```shell
   docker-compose up -d
   ```
2. Enter into **mariadb** container by executing: 
   ```shell
   docker exec -it mariadb /bin/bash
   ```
3. Execute the following command to populate data in mysql:
   ```shell
   mysql -uroot -p < /data/mysql/inventory.sql
   ```
   Enter the password: **admin**
    This will create and populate **inventory** database.
4. Open localhost:8082 in browser. This will open kafka-ui.
5. Go to `Kafka Connect` tab using the left hand side menu.
6. Click on `Create Connector` button on upper right corner. Give a name to the connector and fill the config for the connector.</br>
   E.g. 
   ```
   Name: inventory-connector
   Config: 
   {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "mysql",
        "database.port": "3306",
        "database.user": "debezium",
        "database.password": "dbz",
        "database.server.id": "184054",
        "database.server.name":"dbserver1",
        "database.history.kafka.bootstrap.servers":"kafka:9092",
        "database.history.kafka.topic":"dbhistory.inventory",
        "include.schema.changes":"true",
        "database.include.list": "inventory",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-changes.inventory"
    }
   ```
   You can also do:
   ```shell
   curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json
   ```
   This will start streaming cdc data from Mysql to Kafka.
7. Open `localhost:8888` in browser. This will open jupyter notebook. Give the password: `mysecret`. This password is set in docker-compose file.
8. Open terminal in jupyter notebook and execute:
    ```shell
    sudo cp /data/* .
    ```
9.  Open `localhost:9000` in browser for minio. Username: **minio** Password: **minio123**
10. Upload the **new_customers.csv** to **data** bucket.
11. Run the `cdc-poc.ipynb`. This will start streaming the data from kafka to console and to the delta table.
12. Run the `delta_upsert_poc.ipynb`. This will clean the delta table and has upsert example using **new_customers.csv**.
13. Now open **delta_queries** folder in **DBeaver** and execute the **ddl.sql** to create delta tables and query them using trino. 
14. Execute **memory.sql** to test the memory tables.

# Contributing
If you would like to contribute to this project, please follow these guidelines:
- Fork the repository and create a new branch for your contributions.
- Make your changes, ensuring that the code adheres to the project's style guidelines.
- Test your changes thoroughly.
- Submit a pull request, clearly describing the changes you have made and providing any necessary documentation.
