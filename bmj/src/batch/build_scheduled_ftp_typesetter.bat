set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=-Xmx512M
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;

title FTP to Highwire%1%

echo FTP to Highwire...
ant -e -buildfile build_scheduled_ftp_typesetter.xml  -propertyfile build_scheduled_ftp_typesetter.properties

