set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=-Xmx512M
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;

title FTP to PMC%1%

echo FTP to Pubmed Central...
ant -e -buildfile build_scheduled_ftp_pmc.xml  -propertyfile build_scheduled_ftp_pmc.properties

