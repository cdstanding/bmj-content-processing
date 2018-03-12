SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev-test\bmj

set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=-Xmx512M

set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;Z:\ImageMagick-7.0.3-Q16;Z:\gs\gs9.20\bin;Z:\Render\XEP;C:\Windows\System32;

set LIST=
title Send to Typesetter %1%

for %%A in (%*) do set LIST=%%A,!LIST!
echo Send to Typesetter - loading script...
call ant -e -buildfile Z:\build_SendtoTypesetter.xml -propertyfile Z:\build_SendtoTypesetter.properties -Dinputdirlist="%LIST%" -Dlaunchedby="Send-to-Techset"
NET USE Z: /DELETE
pause