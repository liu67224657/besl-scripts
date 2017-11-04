@echo off
setlocal
time /T
if not defined BUILD_TOOLS_ROOT set BUILD_TOOLS_ROOT=..\..\..\..\tools\mswindows

set JDK_HOME=%BUILD_TOOLS_ROOT%\jdk1.5.0_06
set ANT_HOME=%BUILD_TOOLS_ROOT%\ant-1.6

set CLASSPATH=%ANT_HOME%\lib\ant.jar;%ANT_HOME%\lib\ant-apache-bcel.jar;%JDK_HOME%\lib\tools.jar;%ANT_HOME%\lib\ant-launcher.jar;%ANT_HOME%\lib\ant-junit.jar

%JDK_HOME%\bin\java -Xmx32m -Dant.home=%ANT_HOME% -cp %CLASSPATH% org.apache.tools.ant.Main -buildfile release.xml %*

time /T
endlocal
