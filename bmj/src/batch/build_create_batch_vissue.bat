SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev-test\bmj

set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=-Xmx512M
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;C:\Windows\System32;

title CREATE V-ISSUE BATCH %1%
for %%A in (%*) do set LIST=%%A,!LIST!
echo Creating batch for V-issue...

call ant -e -buildfile Z:\build_create_batch.xml -propertyfile Z:\build_create_batch.properties -Dinputdirlist="%LIST%" -Dprocess="vissue"
NET USE Z: /DELETE
pause