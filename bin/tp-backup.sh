#!/bin/csh -f

if ($#argv < 1) then
    echo "deploy shell error. ex tp-backup.sh wikipage ROOT"
endif

set pkg="$2"
set webappname = "$1"
foreach deployDir (`find /usr/local -maxdepth 1 -name "$webappname*"`)
set backupdir="$deployDir/BACKUP"
if (! -e "$backupdir") then
        echo "$backupdir not exists creat...."
        mkdir -p "$backupdir"
endif

echo "clean last backup dir $backupdir/*";
rm -rf $backupdir/*

echo "start mv $deployDir/tomcat7/webapps/$pkg to $backupdir";
cd $deployDir/tomcat7/webapps
mv $pkg $backupdir

echo "end backup $deployDir";

end



