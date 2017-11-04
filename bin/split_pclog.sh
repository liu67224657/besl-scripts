#!/bin/bash -f

if [ ! -d "/opt/servicelogs/pcaccess" ];then
  mkdir -p /opt/servicelogs/pcaccess
fi

if [ "$#" != "1" ]; then
  echo 'ex split_pclog pcaccess.log'
  exit 2
fi


d=`date -d -"1"hour +%Y%m%d%H`

host=`hostname`
cp /opt/servicelogs/pclog.log /opt/servicelogs/pcaccess/$host.$1.${d}

>/opt/servicelogs/pclog.log

split -l 100000 -d -a 4 /opt/servicelogs/pcaccess/$host.$1.${d} /opt/servicelogs/pcaccess/$host.$1.${d}_
rm -rf /opt/servicelogs/pcaccess/$host.$1.${d}

sudo /etc/init.d/rsyslog restart

echo "restart rsyslog"