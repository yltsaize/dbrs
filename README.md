# dbrs

## Pre-requisites

1. [docker desktop](https://www.docker.com/products/docker-desktop/)
2. [kind](https://kind.sigs.k8s.io/), a k8s cluster inside docker.
3. [kubefwd](https://github.com/txn2/kubefwd), a CLI for batch `kubectl port-forward`.
4. [insomnia](https://github.com/Kong/insomnia), a API client for operating dbrs.

## Getting started

First, run up dbrs:

```bash
> cd dbrs

# build container
> cd container-images
> docker-compose build
> kind load container-image debezium-connect:2.2-1
> kind load container-image hammerdb:4.6
> cd ..

# run dbrs
> kind create namespace dbrs
> kind config set-context --current --namespace=dbrs
> cd dbrs
> helm dependency build
> helm install dbrs .
# wait for pods to be "running"
> kubectl get pods -w

# kubefwd all services to local
> sudo cp -R ~/.kube /root/.kube
> sudo kubefwd svc -n dbrs
```

Once everything is up and running, try to see if API works:

1. Launch insomnia client
2. Import `apis/dbrs.yaml`
3. Run `DBRS/cluster/List connector-plugins`, should see:

```json
[
	{
		"class": "io.confluent.connect.jdbc.JdbcSinkConnector",
		"type": "sink",
		"version": "10.6.0"
	},
    ...
	{
		"class": "io.debezium.connector.mysql.MySqlConnector",
		"type": "source",
		"version": "2.2.0.Alpha1"
	},
    ...
]
```

4. Run `DBRs/connectors/List connectors`, should see an empty list `[]`.

## Demo Scenario

dbrs has 3 sets of mysql: `mysql-src` => `mysql-dwh` => `mysql-dst`

### Preparing source DB

```bash

> kubectl exec -it deployments/hammerdb -- ./hammerdbcli py auto ./scripts/python/mysql/tprocc/mysql_tprocc_buildschema.py

HammerDB CLI v4.6
Copyright (C) 2003-2022 Steve Shaw
Type "help()" for a list of commands
hammerdb>>>exec(open('./scripts/python/mysql/tprocc/mysql_tprocc_buildschema.py').read())
SETTING CONFIGURATION
Database set to MySQL
Benchmark set to TPC-C for MySQL
Value dbrs-mysql-src for connection:mysql_host is the same as existing value dbrs-mysql-src, no change made
Value 3306 for connection:mysql_port is the same as existing value 3306, no change made
...
SCHEMA BUILD STARTED
Script cleared
Building 1 Warehouses(s) with 1 Virtual User
Ready to create a 1 Warehouse MySQL TPROC-C schema
...
ALL VIRTUAL USERS COMPLETE
SCHEMA BUILD COMPLETED
```

In case you want to clear up everything:

```bash
> kubectl exec -it deployments/hammerdb -- ./hammerdbcli py auto ./scripts/python/mysql/tprocc/mysql_tprocc_deleteschema.py
```

### Preparing warehouse and destination DB

```bash
# Dump DDL from src
> kubectl exec dbrs-mysql-src-0 -- bash -c "mysqldump --no-data -u root --password=passw0rd tpcc > /tmp/tpcc_ddl.sql"
mysqldump: [Warning] Using a password on the command line interface can be insecure.

# Copy to local
> kubectl cp dbrs-mysql-src-0:tmp/tpcc_ddl.sql ./tpcc_ddl.sql

# Copy and apply on dwh
> kubectl cp ./tpcc_ddl.sql dbrs-mysql-dwh-0:tmp/tpcc_ddl.sql
> kubectl exec dbrs-mysql-dwh-0 -- bash -c "mysql -u root --password=passw0rd tpcc < /tmp/tpcc_ddl.sql"

# Copy and apply on dst
> kubectl cp ./tpcc_ddl.sql dbrs-mysql-dst-0:tmp/tpcc_ddl.sql
> kubectl exec dbrs-mysql-dst-0 -- bash -c "mysql -u root --password=passw0rd tpcc < /tmp/tpcc_ddl.sql"
```

### Creating dbrs pipelines

1. Check kafka-connect logs:

```bash
> kubectl logs -f deployments/dbrs-cp-kafka-connect
```

2. In insomnia, run `DBRS/connectors/Create src-src-topic` to create the src to dwh connector. Observe kafka-connect logs to verify if any error.


3. Run `DBRS/kafka/List topics` and notice per-table topics are being created:

```json
[
	"dbrs.src.tpcc.tpcc.orders",
	"dbrs.src.tpcc.tpcc.history",
	"dbrs-cp-kafka-connect-offset",
	"dbrs.src.tpcc.tpcc.warehouse",
	"dbrs.src.tpcc.tpcc.item",
	"dbrs.history.src.tpcc",
	"dbrs.src.tpcc.tpcc.order_line",
	"dbrs.src.tpcc.tpcc.customer",
	"dbrs-cp-kafka-connect-status",
	"dbrs-cp-kafka-connect-config",
	"dbrs.src.tpcc.tpcc.district",
	"_confluent-metrics",
	"dbrs.src.tpcc.tpcc.stock",
	"dbrs.src.tpcc.tpcc.new_order"
]
```

4. Then, run `DBRS/connectors/Create sink-tpcc.stock-dwh` to create dwh to dst connector. Observe kafka-connect logs to verify if any error.


### Generating volume

 Use hammerdb to generate data to `mysql-src` (details TBD), observe that the same sets of data are replicated to `mysql-dst`


## Future tasks

1. Define the tasks to "start" over on either pipeline.
2. Add oracledb to src-dhw-dst combinations.
