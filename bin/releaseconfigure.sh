#!/bin/csh -f

if (! $?BUILD_TOOLS_ROOT) setenv BUILD_TOOLS_ROOT /opt/ops/tools/linux
setenv JAVA_HOME
setenv JDK_HOME $BUILD_TOOLS_ROOT/jdk
setenv JAVA_HOME $JDK_HOME
setenv ANT_HOME $BUILD_TOOLS_ROOT/ant

setenv CLASSPATH $ANT_HOME/lib/ant.jar:$JDK_HOME/lib/tools.jar:$ANT_HOME/lib/ant-launcher.jar
setenv CLASSPATH ${CLASSPATH}:$ANT_HOME/lib/ant-xslp.jar:$ANT_HOME/lib/ant-trax.jar

$JDK_HOME/bin/java -Xmx64m -Dant.home=$ANT_HOME -cp $CLASSPATH org.apache.tools.ant.Main -buildfile /opt/ops/bin/releaseconfigure.xml $*
