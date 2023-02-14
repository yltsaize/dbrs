#!/bin/tclsh
# maintainer: Pooja Jain

print("SETTING CONFIGURATION")
dbset('db','ora')
dbset('bm','TPC-C')

diset('connection','system_user','system')
diset('connection','system_password','Passw0rd')
diset('connection','instance','src-orcl/ORCLCDB')

diset('tpcc','tpcc_user','c##tpcc')
diset('tpcc','tpcc_pass','tpcc')

print("DROP SCHEMA STARTED")
deleteschema()
print("DROP SCHEMA COMPLETED")
exit()

