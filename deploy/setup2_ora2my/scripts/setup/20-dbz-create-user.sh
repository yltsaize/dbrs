#!/bin/bash

# https://debezium.io/documentation/reference/stable/connectors/oracle.html#creating-users-for-the-connector

sqlplus -s "sys/Passw0rd@//localhost:1521/ORCLCDB as sysdba" @/opt/oracle/scripts/setup/20-dbz-create-user/01-create-ts-cdb.sql

# sqlplus -s "sys/Passw0rd@//localhost:1521/ORCLPDB1 as sysdba" @/opt/oracle/scripts/setup/20-dbz-create-user/02-create-ts-pdb.sql

sqlplus -s "sys/Passw0rd@//localhost:1521/ORCLCDB as sysdba" @/opt/oracle/scripts/setup/20-dbz-create-user/03-create-user.sql

