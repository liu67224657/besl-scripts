#!/bin/csh

if ($#argv < 3) then
    echo "deploy shell error. ex deploy-tp.sh wikipage ROOT 1.0.0.0"
endif

set webappname = "$1"
set pkg="$2"
set version="$3"

foreach deployDir (`find /usr/local -maxdepth 1 -name "$webappname*"`)
echo "=======start deploy $deployDir========"
 if (! -e "$deployDir") then
         echo "FATAL ERROR: "\""$deployDir"\"" DOES NOT EXIST"
         exit 2
 endif

if ( -e /opt/package/toolsplatform/$webappname/$version.tar ) then
    echo "/opt/package/toolsplatform/$webappname/$version.tar exists"
else
    echo "$version not exists.exists"
    exit
endif


echo "==========start deploy '$webappname' to ==========";
#stop tomcat
ps aux | grep "$deployDir/tomcat7" | cut -c 9-15 | xargs kill -9

if  $webappname =~ wikipage  then
                echo 'deploy "$webappname" back css '
                cd $deployDir/tomcat7/webapps/$pkg
                tar -zcf wikicss_temp.tar.gz ./css/
                mv wikicss_temp.tar.gz /usr/local/wikipage
endif

#remove webapps
echo '==========start clean webapps=========='
rm -rf $deployDir/tomcat7/webapps/$pkg
echo '==========end clean webapps=========='

#deploy and untar
echo '==========start deploy and untar webapps=========='
cd $deployDir/tomcat7/webapps/
mkdir $pkg
cd $pkg
cp /opt/package/toolsplatform/$webappname/$version.tar ./
tar -xf $version.tar

mkdir -p wiki/_node/
hostname >> wiki/_node/node-info.txt
echo '==========end deploy and untar webapps=========='

#copy conf
echo 'start copy conigfiles'
cp  -r $deployDir/conf/* $deployDir/tomcat7/
echo '==========end copy conigfiles=========='

#remove tar
echo 'start remove tar'
rm -rf $deployDir/tomcat7/webapps/$pkg/$version.tar
echo '==========end remove tar=========='

#remove wikipage css backtemp
if  $webappname =~ wikipage  then
echo '==========deploy wikipage cp css=========='
cd $deployDir/tomcat7/webapps/$pkg
mv /usr/local/wikipage/wikicss_temp.tar.gz $deployDir/tomcat7/webapps/ROOT
tar -zxf wikicss_temp.tar.gz ./
rm -rf $deployDir/wikicss_temp.tar.gz
rm -rf $deployDir/tomcat7/webapps/ROOT/wikicss_temp.tar.gz
endif
echo "=======end deploy $deployDir========"
end
