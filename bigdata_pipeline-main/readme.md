# PRESTO POC

In this poc we will see how to query delta tables in presto. We are using trino which is another flavour of presto.

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
