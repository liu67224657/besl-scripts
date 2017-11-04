#!/bin/sh
file=$1
host=www.joyme.beta

while read line
do
#echo $line;
key=`echo $line |awk '{print $3}'`
old=`echo $line |awk '{print $4}'`
new=`echo $line |awk '{print $5}'`

echo "location ~ /(.*)wiki/$key/$old.shtml { rewrite ^/(.*)wiki/.* http://$host/\$1wiki/$key/$new.shtml permanent; }" >> vhost_tempwikiurl


done < $file