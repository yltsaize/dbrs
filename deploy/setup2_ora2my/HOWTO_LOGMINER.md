# Oracle LogMiner Study Notes

Study notes for using Oracle LogMiner.
The commands are run from the oracle container from the setup2_ora2my helm chart in this directory.

## Accessing sqlplus

```bash
kubectl exec -it src-orcl-0 -- bash

# SYSDBA
sqlplus sys/Passw0rd@//localhost:1521/ORCLCDB as SYSDBA

# TPCC (created by HammerDB)
sqlplus C##TPCC/tpcc@//localhost:1521/ORCLCDB

# DBZUSER (created by Debezium)
sqlplus C##DBZUSER/dbz@//localhost:1521/ORCLCDB
```

## Docs about various oracle logs

https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/V-LOG.html#GUID-FCD3B70B-7B98-40D8-98AB-9F6A85E69F57

```sql
SELECT * FROM v$log;

--- Redo logs
COLUMN member FORMAT a50;
COLUMN status FORMAT a10;
SELECT F.MEMBER, R.STATUS FROM V$LOGFILE F, V$LOG R WHERE F.GROUP# = R.GROUP# ORDER BY 2;

--- Archive logs and their size.
COLUMN name format a50;
COLUMN "Size (MB)" format 9999.999;
SELECT sequence#, name, blocks*block_size/1024/1024 "Size (MB)" FROM v$archived_log WHERE status = 'A' AND standby_dest = 'NO' AND completion_time > sysdate-1 ORDER BY sequence# DESC;

```


## Running LogMiner end to end

```sql
--- 0) If you want to benchmark each command
SET TIMING ON;

--- 1) Add log files to be parsed by logminer

--- 1.1) redo log
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/redo01.log', options=>dbms_logmnr.new);
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/redo02.log', options=>dbms_logmnr.addfile);
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/redo03.log', options=>dbms_logmnr.addfile);

--- 1.2) or, archive log
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/archive_logs/1_7_1134783528.dbf', options=>dbms_logmnr.new);
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/archive_logs/1_8_1134783528.dbf', options=>dbms_logmnr.addfile);
EXECUTE dbms_logmnr.add_logfile(logfilename => '/opt/oracle/oradata/ORCLCDB/archive_logs/1_9_1134783528.dbf', options=>dbms_logmnr.addfile);

--- 2) Start logminer session

--- 2.1) Without any option, use online dictionary
EXECUTE DBMS_LOGMNR.START_LOGMNR( OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);

--- 2.2) Filter by scn
EXECUTE DBMS_LOGMNR.START_LOGMNR( startScn => '1', endScn => '5439065', OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);

--- 3) Scan trough log files and get parsed records.
--- if timing is on, can benchmark the time required to scan through records.

--- 3.1) To get everything
SELECT * FROM V$LOGMNR_CONTENTS;

--- 3.2) Just to scan through, skipping all contents - for performance testing.
SELECT * FROM V$LOGMNR_CONTENTS WHERE TABLE_NAME = 'NOT_EXISTS';

--- 3.3) Count records
SELECT COUNT(*) FROM V$LOGMNR_CONTENTS;


--- 4) Close logminer session, free up the locked log files.
EXECUTE DBMS_LOGMNR.END_LOGMNR;
```


## Enable suppl. log for all hammerDB tables

```sql
ALTER TABLE NEW_ORDER ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE ORDER_LINE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE CUSTOMER ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE DISTRICT ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE HISTORY ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE ITEM ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE WAREHOUSE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE STOCK ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE ORDERS ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
```


