# oracle to mysql demo

Scenario: src-orcl (oracledb) => kafka => dwh-mysql => kafka => dst-mysql

## Installing DB

```bash
# require logging into oracle.com
docker pull container-registry.oracle.com/database/enterprise:19.3.0.0
kind load docker-image container-registry.oracle.com/database/enterprise:19.3.0.0
helm install ora2my deploy/setup2_ora2my
```

### Preparing source DB

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

### Prearing MySQL DBs

(TBD) need a way to easily map oracle DDL to mysql DDL.

Tried "AWS Schema Conversion Tool", works good for me.


### Creating dbrs pipelines

(TBD) Provide insomnia scripts for managing pipelines.
