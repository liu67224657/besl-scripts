#!/bin/bash

FILEPREFIX=$1
SID=$2

#自己改dir
TOTAL=0
LOG_FILE=/opt/ops/logs/backlog/$FILEPREFIX.log_
start_sec=$(date -d $3 "+%s")

end_sec=$(date -d $4 "+%s")

interval=$[($end_sec-$start_sec)/24/60/60];

for((i=0;i<=$interval;i++));
do

day=$(date -d "-$i day $4" "+%Y-%m-%d")

FILENAME=${LOG_FILE}$day
#echo $FILENAME

#LOG_NUM=`awk '{print $7}' $FILENAME  | grep (sid|pk_campaign)=$SID | wc -l`
PV_LOG_NUM=`awk '{print $1"\t"$7}'  access_joyme.log_2015-07-22 |grep $SID | awk '{print $1}' |wc -l`

UV_LOG_NUM=`awk '{print $1"\t"$7}'  access_joyme.log_2015-07-22 |grep $SID | awk '{print $1}' |sort -u |wc -l`

#echo $LOG_NUM
PV_TOTAL=`expr $PV_TOTAL + $PV_LOG_NUM`
UV_TOTAL=`expr $UV_TOTAL + $UV_LOG_NUM`
echo "SID is "$SID" date is "$day" pv is "$PV_LOG_NUM" pv total is "$PV_TOTAL"  uv is "$UV_LOG_NUM" uv total is "$UV_TOTAL
done