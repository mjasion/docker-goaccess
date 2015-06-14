#!/bin/bash

cd /var/log/nginx
HTML_PATH="/var/files/"
rm $HTML_PATH/*.html

function pase_all_logs() {
  for file in `find *.log -size +0`; do
    docker run -v /var/log/nginx:/logs goaccess:latest goaccess --no-progress -f /logs/$file -a > $HTML_PATH/"$file".html
  done
}

function cat_all() {
  for file in $1; do
    cat $file
  done
}

function zcat_all() {
  for file in $1; do
    zcat $file
  done
}

function goacces() {
  docker run -v /tmp:/logs goaccess:latest goaccess --no-progress -f /logs/$1 -a
}

function parse_today_production() {
  FILE_NAME="today"
  cat_all "`ls *.log | grep -vi staging`" | grep "`date +"%d/%b/%Y" --date="today"`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_today_staging() {
  FILE_NAME="staging_today"
  cat_all "`ls *.log | grep -i staging`" | grep "`date +"%d/%b/%Y" --date="today"`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_yesterday_production() {
  FILE_NAME="yesterday"
  cat_all "`ls *.log *.log.1 | grep -vi staging`" | grep "`date +"%d/%b/%Y" --date="yesterday"`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_yesterday_staging() {
  FILE_NAME="staging_yesterday"
  cat_all "`ls *.log *.log.1 | grep -i staging`" | grep "`date +"%d/%b/%Y" --date="yesterday"`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_thisweek_production() {
  FILE_NAME="thisweek"
  cat_all "`ls *.log | grep -vi staging`"  >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_thisweek_staging() {
  FILE_NAME="staging_thisweek"
  cat_all "`ls *.log | grep -i staging`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_lastweek_production() {
  FILE_NAME="lastweek"
  cat_all "`ls *.log.1 | grep -vi staging`"  >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function parse_lastweek_staging() {
  FILE_NAME="staging_lastweek"
  cat_all "`ls *.log.1 | grep -i staging`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function total_production() {
  FILE_NAME="total"
  cat_all "`ls *.log *.log.1 | grep -vi staging`" >> /tmp/$FILE_NAME.log
  zcat_all "`ls *.gz | grep -vi staging`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}

function total_staging() {
  FILE_NAME="staging_total"
  cat_all "`ls *.log *.log.1 | grep -i staging`" >> /tmp/$FILE_NAME.log
  zcat_all "`ls *.gz | grep -i staging`" >> /tmp/$FILE_NAME.log
  goacces "$FILE_NAME.log" >> $HTML_PATH/$FILE_NAME.html
  rm /tmp/$FILE_NAME.log
}


pase_all_logs

parse_today_production
parse_today_staging

parse_yesterday_production
parse_yesterday_staging

parse_thisweek_production
parse_thisweek_staging

total_production
total_staging
