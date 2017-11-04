#!/bin/bash -f
tomcatArray=(wikipage cmsimage webcache search marticle activity)

for data in  ${tomcatArray[@]}
do
    find /usr/local/${data}/tomcat7/logs/ -maxdepth 1 -mtime +30 -name "*" | xargs rm -f
done

