# oracle to mysql demo

Scenario: src-orcl (oracledb) => kafka => dwh-mysql => kafka => dst-mysql

## Pre-requisite

You'll need access to oracle's container registry:

1. Sign up an oracle account in https://profile.oracle.com using your personal email
2. Go to https://container-registry.oracle.com and sign in with your oracle account
3. Browse to `Database` -> `enterprise`, read and agree the `Oracle Standard Terms and Restrictions`
4. Verify you can do `docker login container-registry.oracle.com` with your oracle account


## Installing DB

```bash
# login with your oracle account
> docker login container-registry.oracle.com

# verify auth context is saved in $HOME/.docker/config.json
> cat $HOME/.docker/config.json
{
  "auths": {
    "container-registry.oracle.com": {
      "auth": "***"
    }
  }
}

# create secret, the name `docker-config` is hard-coded in deployment templates.
> kubectl create secret generic docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson

> helm install ora2my deploy/setup2_ora2my

# wait unti you see following messages
> kubectl logs -f src-orcl-0
...
#########################
DATABASE IS READY TO USE!
#########################
...
```

## Prepare DB for debezium

The steps to [prepare oracle for debezium](https://debezium.io/documentation/reference/stable/connectors/oracle.html) are implemented via oracle setup scripts in `scripts/setup`, and will be executed the first time oracleDB is launched.

Verify these outputs in the console logs of src-orcl-0:


**Outputs of dbz-prepare-db**

```bash

Connected.

System altered.
System altered.

Database closed.
Database dismounted.
ORACLE instance shut down.

ORACLE instance started.
Total System Global Area 1610609888 bytes
Fixed Size                  9135328 bytes
Variable Size             486539264 bytes
Database Buffers         1107296256 bytes
Redo Buffers                7639040 bytes
Database mounted.

Database altered.

Database altered.

Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     20
Next log sequence to archive   22
Current log sequence           22

Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0
```

**Outputs of dbz-create-user**

```bash
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

Tablespace created.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

Tablespace created.

User created.

# Should see a bunch of this.
Grant succeeded.

```

Note that supplemental logging have to be done for tables and columns that need CDC, and is not covered by setup script:

```bash
> sqlplus c##tpcc/tpcc@//localhost:1521/ORCLCDB

--- For demo, only enable orders table.
SQL> ALTER TABLE orders ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
Table altered.

SQL> exit
```


## Create TPCC dataset with HammerDB CLI.

```bash
> kubectl exec -it deployments/hammerdb -- bash
/home/hammerdb/HammerDB-4.6> ./hammerdbcli py auto ./scripts/python/oracle/tprocc/ora_tprocc_buildschema.py

# example output which removed a lot of details
HammerDB CLI v4.6
SETTING CONFIGURATION
Database set to Oracle
Benchmark set to TPC-C for Oracle
SCHEMA BUILD STARTED
Building 1 Warehouses(s) with 1 Virtual User
Ready to create a 1 Warehouse Oracle TPROC-C schema
Vuser 1 created - WAIT IDLE
Vuser 1:RUNNING
Vuser 1:CREATING C##TPCC SCHEMA
Vuser 1:CREATING USER c##tpcc
Vuser 1:CREATING TPCC TABLES
Vuser 1:Loading Item
Vuser 1:Item done
Vuser 1:Start:Tue Feb 14 16:02:19 +0000 2023
Vuser 1:Loading Warehouse
Vuser 1:Stock done
Vuser 1:Loading District
Vuser 1:District done
Vuser 1:Customer Done
Vuser 1:Orders Done
Vuser 1:End:Tue Feb 14 16:02:31 +0000 2023
Vuser 1:CREATING TPCC INDEXES
Vuser 1:CREATING TPCC STORED PROCEDURES
Vuser 1:GATHERING SCHEMA STATISTICS
Vuser 1:C##TPCC SCHEMA COMPLETE
Vuser 1:FINISHED SUCCESS
ALL VIRTUAL USERS COMPLETE
SCHEMA BUILD COMPLETED
```

In case you want to clear up everything:

```bash
> kubectl exec -it deployments/hammerdb -- bash
./hammerdbcli py auto ./scripts/python/oracle/tprocc/ora_tprocc_deleteschema.py
```


## Prearing MySQL DBs

(TBD) need a way to easily map oracle DDL to mysql DDL.

Tried "AWS Schema Conversion Tool", works good for me.


## Creating dbrs pipelines

1. Launch insomnia, import `apis/dbrs.yaml`, and run `DBRS/setup2_ora2my/Create src connector`.
2. Check connector console logs and make sure no error.

## Generating traffic

```bash
> kubectl exec -it deployments/hammerdb -- bash
/home/hammerdb/HammerDB-4.6> ./hammerdbcli py auto ./scripts/python/oracle/tprocc/ora_tprocc_run.py
```
