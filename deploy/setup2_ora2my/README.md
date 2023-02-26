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

#### Create TPCC dataset with HammerDB CLI.

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

#### Enable archive log with sqlplus.

Reference: https://debezium.io/documentation/reference/stable/connectors/oracle.html#_preparing_the_database

```bash
> kubectl exec -it src-orcl-0 -- bash

# in oracle container
> mkdir -p /opt/oracle/oradata/recovery_area
> ORACLE_SID=ORCLCDB sqlplus /nolog

# in sqlplus
SQL> CONNECT sys/Passw0rd AS SYSDBA
Connected.

SQL> alter system set db_recovery_file_dest_size = 10G;
System altered.

SQL> alter system set db_recovery_file_dest = '/opt/oracle/oradata/recovery_area' scope=spfile;
System altered.

SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.

SQL> startup mount
ORACLE instance started.
Total System Global Area 1610609888 bytes
Fixed Size                  9135328 bytes
Variable Size             486539264 bytes
Database Buffers         1107296256 bytes
Redo Buffers                7639040 bytes
Database mounted.

SQL> alter database archivelog;
Database altered.

SQL> alter database open;
Database altered.

-- Should now "Database log mode: Archive Mode"
SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     20
Next log sequence to archive   22
Current log sequence           22

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0
```

#### Create dbz_user for debezium connector.

Reference: https://debezium.io/documentation/reference/stable/connectors/oracle.html#creating-users-for-the-connector

```bash
# In oracle container
> sqlplus sys/Passw0rd@//localhost:1521/ORCLCDB as sysdba
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

# in sqlplus
SQL> CREATE TABLESPACE logminer_tbs DATAFILE '/opt/oracle/oradata/ORCLCDB/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
Tablespace created.

SQL> exit

> sqlplus sys/Passw0rd@//localhost:1521/ORCLPDB1 as sysdba
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> CREATE TABLESPACE logminer_tbs DATAFILE '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
Tablespace created.

> sqlplus sys/Passw0rd@//localhost:1521/ORCLCDB as sysdba

SQL> CREATE USER c##dbzuser IDENTIFIED BY dbz DEFAULT TABLESPACE logminer_tbs QUOTA UNLIMITED ON logminer_tbs CONTAINER=ALL;
User created.

SQL> --- Copy paste & run following statements one by one, all should show "Grant succeeded."
    GRANT CREATE SESSION TO c##dbzuser CONTAINER=ALL;
    GRANT SET CONTAINER TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$DATABASE to c##dbzuser CONTAINER=ALL;
    GRANT FLASHBACK ANY TABLE TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ANY TABLE TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT_CATALOG_ROLE TO c##dbzuser CONTAINER=ALL;
    GRANT EXECUTE_CATALOG_ROLE TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ANY TRANSACTION TO c##dbzuser CONTAINER=ALL;
    GRANT LOGMINING TO c##dbzuser CONTAINER=ALL;
    GRANT CREATE TABLE TO c##dbzuser CONTAINER=ALL;
    GRANT LOCK ANY TABLE TO c##dbzuser CONTAINER=ALL;
    GRANT CREATE SEQUENCE TO c##dbzuser CONTAINER=ALL;
    GRANT EXECUTE ON DBMS_LOGMNR TO c##dbzuser CONTAINER=ALL;
    GRANT EXECUTE ON DBMS_LOGMNR_D TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOG TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOG_HISTORY TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOGMNR_LOGS TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOGMNR_CONTENTS TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOGMNR_PARAMETERS TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$LOGFILE TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$ARCHIVED_LOG TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$ARCHIVE_DEST_STATUS TO c##dbzuser CONTAINER=ALL;
    GRANT SELECT ON V_$TRANSACTION TO c##dbzuser CONTAINER=ALL;

SQL> exit

```

### Prearing MySQL DBs

(TBD) need a way to easily map oracle DDL to mysql DDL.

Tried "AWS Schema Conversion Tool", works good for me.


### Creating dbrs pipelines

(TBD) Provide insomnia scripts for managing pipelines.
