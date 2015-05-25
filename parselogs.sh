#!/bin/bash

rm /var/files/*.html
for file in `ls /var/log/nginx/*.log /var/log/nginx/*.log.1`; do
  filename=$(basename "$file")
  docker run -v /var/log/nginx:/logs goaccess:latest goaccess --no-progress -f /logs/$filename -a > /var/files/"$filename".html
done

cat /var/log/nginx/*.log > /tmp/all_logs.log
docker run -v /tmp:/logs goaccess:latest goaccess --no-progress -f /logs/all_logs.log -a > /var/files/all_logs.html
cat /var/log/nginx/*.log.1 > /tmp/all_logs.log
docker run -v /tmp:/logs goaccess:latest goaccess --no-progress -f /logs/all_logs.log -a > /var/files/all_logs.1.html
rm /tmp/all_logs.log
