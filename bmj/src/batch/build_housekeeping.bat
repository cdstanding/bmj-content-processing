

path apache-ant-1.9.4\bin;jdk1.8.0_40\bin;C:\Windows\System32;
set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set PATH=%PATH%;%JAVA_HOME%\bin;%ANT_HOME%\bin;

title Housekeeping

echo Housekeeping...
ant -e -buildfile build_housekeeping.xml  -propertyfile build_housekeeping.properties

