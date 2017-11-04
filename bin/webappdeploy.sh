#!/bin/csh -f

if ($#argv < 2) then
    echo "deploy shell error. ex webappdeploy wikipage ROOT"
endif
set webappname = "$1"
set pkg="$2"

echo "'==========start deploy $webappname'==========";

#stop tomcat
ps aux | grep "/usr/local/$webappname/tomcat7" | cut -c 9-15 | xargs kill -9

if  $webappname =~ wikipage  then
		echo 'deploy "$webappname" back css '
		cd /usr/local/$webappname/tomcat7/webapps/$pkg
		tar -zcf wikicss_temp.tar.gz ./css/
		mv wikicss_temp.tar.gz /usr/local/
endif

#remove webapps
echo '==========start clean webapps=========='
rm -rf /usr/local/$webappname/tomcat7/webapps/$pkg
echo '==========end clean webapps=========='

#unzip pkg
echo "==========start unzip classes=========="
cp /opt/package/toolsplatform/$webappname/$pkg.zip /usr/local/$webappname/tomcat7/webapps
cd /usr/local/$webappname/tomcat7/webapps
unzip -q $pkg.zip
echo "==========end unzip classes=========="

#copy conf
echo 'start copy conigfiles'
cp  -r /usr/local/$webappname/conf/* /usr/local/$webappname/tomcat7/

#remove pkg.zip
rm -rf $pkg.zip

#remove wikipage css backtemp
if  $webappname =~ wikipage  then
echo '==========deploy wikipage cp css=========='
cd /usr/local/$webappname/tomcat7/webapps/$pkg
mv /usr/local/wikicss_temp.tar.gz /usr/local/$webappname/tomcat7/webapps/ROOT
tar -zxf wikicss_temp.tar.gz ./
rm -rf /usr/local/wikicss_temp.tar.gz
rm -rf /usr/local/$webappname/tomcat7/webapps/ROOT/wikicss_temp.tar.gz
endif

#start tomcat
/usr/local/$webappname/tomcat7/bin/startup.sh

echo "end deploy $webappname please tail -f /usr/lcoal/$webappname/tomcat7/logs/catalina.out';
