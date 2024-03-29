CREATE USER c##dbzuser IDENTIFIED BY dbz
  DEFAULT TABLESPACE logminer_tbs
  QUOTA UNLIMITED ON logminer_tbs
  CONTAINER=ALL;

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


--- signal table
CREATE TABLE C##DBZUSER.DEBEZIUM_SIGNAL (id VARCHAR(42) PRIMARY KEY, type VARCHAR(32) NOt NULL, data VARCHAR(2048) NULL);
ALTER TABLE C##DBZUSER.DEBEZIUM_SIGNAL ADD SUPPLEMENTAL LOG data(all) columns;
exit;
