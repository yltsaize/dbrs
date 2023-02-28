#!/bin/bash

cd /frp
frps > /tmp/frps.log 2>&1 &
sleep 1
frpc > /tmp/frpc.log 2>&1 &
