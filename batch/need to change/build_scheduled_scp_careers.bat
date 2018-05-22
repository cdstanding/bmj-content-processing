path apache-ant-1.9.4\bin;jdk1.8.0_40\bin;
set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set PATH=%PATH%;%JAVA_HOME%\bin;%ANT_HOME%\bin;

title SCP to Careers%1%

echo SCP and send to Careers site...
ant -e -buildfile build_scheduled_scp_careers.xml  -propertyfile build_scheduled_scp_careers.properties

