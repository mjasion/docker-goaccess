#!/bin/bash

rm /var/files/*.html
for file in `ls /var/log/nginx/*.log`; do
  filename=$(basename "$file")
  docker run -v /var/log/nginx:/logs goaccess:latest goaccess --no-progress -f /logs/$filename -a > /var/files/"$filename".html
done
