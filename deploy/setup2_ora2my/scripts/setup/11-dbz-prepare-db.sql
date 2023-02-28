--- https://debezium.io/documentation/reference/stable/connectors/oracle.html#_preparing_the_database

alter system set db_recovery_file_dest_size = 10G;
alter system set db_recovery_file_dest = '/opt/oracle/oradata/recovery_area' scope=spfile;
shutdown immediate
startup mount
alter database archivelog;
alter database open;
-- Should now "Database log mode: Archive Mode"
archive log list

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

--- NOTE: You will still have to do this for every CDC tables and columns.
---   ALTER TABLE inventory.customers ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
