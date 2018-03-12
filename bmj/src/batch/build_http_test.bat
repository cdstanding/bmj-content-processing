set JAVA_HOME=jdk1.8.0_40
set ANT_HOME=apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M

set PATH=%PATH%;%JAVA_HOME%\bin;%ANT_HOME%\bin;C:\Windows\System32;

call ant -nice=10 -keep-going -f build_http_test.xml -propertyfile build_http_test.properties main
pause

