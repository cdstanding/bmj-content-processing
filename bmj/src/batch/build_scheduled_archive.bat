set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=-Xmx512M
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;

title Archive to data drive%1%

echo Archiving to data drive on BMJPROD1...
ant -e -buildfile build_scheduled_archive.xml  -propertyfile build_scheduled_archive.properties

