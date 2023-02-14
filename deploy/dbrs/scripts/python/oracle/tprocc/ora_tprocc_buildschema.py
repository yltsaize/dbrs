#!/bin/tclsh
# maintainer: Pooja Jain

print("SETTING CONFIGURATION")
dbset('db','ora')
dbset('bm','TPC-C')

diset('connection','system_user','system')
diset('connection','system_password','Passw0rd')
diset('connection','instance','src-orcl/ORCLCDB')

diset('tpcc','count_ware',1)
diset('tpcc','num_vu',1)
diset('tpcc','tpcc_user','c##tpcc')
diset('tpcc','tpcc_pass','tpcc')
diset('tpcc','tpcc_def_tab','users')
diset('tpcc','tpcc_def_temp','temp')
diset('tpcc','partition','false')
diset('tpcc','hash_clusters','false')


print("SCHEMA BUILD STARTED")
buildschema()
print("SCHEMA BUILD COMPLETED")
exit()
