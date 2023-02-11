#!/bin/tclsh
# maintainer: Pooja Jain

puts "SETTING CONFIGURATION"
dbset db ora
dbset bm TPC-H

diset connection system_user system
diset connection system_password manager
diset connection instance oracle

diset tpch scale_fact 1
diset tpch num_tpch_threads [ numberOfCPUs ]
diset tpch tpch_user tpch
diset tpch tpch_pass tpch
diset tpch tpch_def_tab users
diset tpch tpch_def_temp temp

puts "SCHEMA BUILD STARTED"
buildschema
puts "SCHEMA BUILD COMPLETED"

