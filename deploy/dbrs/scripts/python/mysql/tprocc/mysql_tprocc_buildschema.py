#!/bin/tclsh
# maintainer: Pooja Jain

print("SETTING CONFIGURATION")
dbset('db','mysql')
dbset('bm','TPC-C')

diset('connection','mysql_host','dbrs-mysql-src')
diset('connection','mysql_port','3306')
# diset('connection','mysql_socket','/tmp/mysql.sock')

diset('tpcc','mysql_count_ware',1)
diset('tpcc','mysql_num_vu',1)
diset('tpcc','mysql_user','root')
diset('tpcc','mysql_pass','passw0rd')
diset('tpcc','mysql_dbase','tpcc')
diset('tpcc','mysql_storage_engine','innodb')
diset('tpcc','mysql_partition','false')

print("SCHEMA BUILD STARTED")
buildschema()
print("SCHEMA BUILD COMPLETED")
exit()
