#!/bin/bash -f
host=$HOSTNAME
currdate=$(date +%Y%m%d)

#服务日志/opt/servicelogs
#以alyweb00x.prod开头超过30天直接删除,查找/opt/servicelogs当前目录
find /opt/servicelogs/ -maxdepth 1 -mtime +30 -name "$host*" | xargs rm -f


#处理tomcat日志,超过30天直接删除
for i in {1..8}
do
  find /opt/servicelogs/tomcat$i/ -maxdepth 1 -mtime +30 -name "manager*" -o -name "localhost*" -o -name "catalina*" -o -name "host*" |xargs rm -f
done


#目录下/opt/ops/services/alert01文件all.txt| bug.txt| noise.txt，先拷贝至当前目录下 ，再清空
#再删除30天以前文件备份的文件
if [ -d /opt/ops/services/alert01 ];then

find /opt/ops/services/alert01/ -name "all.txt" | xargs -i  cp {} /opt/ops/services/alert01/all.txt__$currdate
echo "" > /opt/ops/services/alert01/all.txt

find /opt/ops/services/alert01/ -name "bug.txt" | xargs -i  cp {} /opt/ops/services/alert01/bug.txt__$currdate
echo "" > /opt/ops/services/alert01/bug.txt

find /opt/ops/services/alert01/ -name "noise.txt" | xargs -i  cp {} /opt/ops/services/alert01/noise.txt__$currdate
echo "" > /opt/ops/services/alert01/noise.txt


find /opt/ops/services/alert01/ -maxdepth 1 -mtime +30 -name "all.txt__*" | xargs rm -f
find /opt/ops/services/alert01/ -maxdepth 1 -mtime +30 -name "bug.txt__*" | xargs rm -f
find /opt/ops/services/alert01/ -maxdepth 1 -mtime +30 -name "noise.txt__*" | xargs rm -f

fi


