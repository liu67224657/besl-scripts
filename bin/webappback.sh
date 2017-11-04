#!/bin/csh -f
 
if ($#argv < 2) then
    echo "deploy shell error. ex webappback wikipage ROOT"
endif
 
set webappname = "$1"
set pkg="$2"
set backname="$2_back.tar.gz"
 
echo "start backup $webappname";

rm -rf /usr/local/$webappname/$backname

cd /usr/local/$webappname/tomcat7/webapps
tar -zcf $backname $pkg
cp -R $backname /usr/local/$webappname/
 
echo "end back $webappname  /usr/local/$webappname/$backname";

