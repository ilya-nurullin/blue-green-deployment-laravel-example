#!/bin/sh

SECONDS=0
while :
do
curl -m 3 -s -o /dev/null -I -w "\n${SECONDS}s - http_status: %{http_code}" http://192.168.0.194.sslip.io
done
