#!/bin/bash
TOTAL=0
LOG_FILE=/opt/ops/logs/nginx/access_joyme.log_
start_sec=$(date -d $1 "+%s")
end_sec=$(date -d $2 "+%s")
interval=$[($end_sec-$start_sec)/24/60/60];

for((i=1;i<=$interval;i++));
do
day=$(date -d "-$i day $2" "+%Y%m%d")
FILENAME=${LOG_FILE}$day
#echo $FILENAME
LOG_NUM=`awk '{print $7}' $FILENAME  | grep 'sgss' | grep -v 'sgssz' | wc -l`
#echo $LOG_NUM
TOTAL=`expr $TOTAL + $LOG_NUM`
echo "date is "$day" num is "$LOG_NUM" total is "$TOTAL
done}