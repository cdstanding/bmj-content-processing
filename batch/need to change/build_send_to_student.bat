SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev\bmj

set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=-Xmx512M

rem ImageMagick-7 directory
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;Z:\ImageMagick-7.0.3-Q16;Z:\gs\gs9.20\bin;C:\Windows\System32;

rem Imagemagick environment variables
set HOME=Z:\ImageMagick-7.0.3-Q16
set MAGICK_CODER_MODULE_PATH=Z:\ImageMagick-7.0.3-Q16\modules\coders
set MAGICK_CODER_FILTER_PATH=Z:\ImageMagick-7.0.3-Q16\modules\filters
set MAGICK_CONFIGURE_PATH=Z:\ImageMagick-7.0.3-Q16
rem ----------

set LIST=
title Send to Student%1%

for %%A in (%*) do set LIST=%%A,!LIST!
echo Sending to Student...
call ant -e -buildfile Z:\build_send_to_student.xml  -propertyfile Z:\build_send_to_student.properties -Dinputdirlist="%LIST%" -Dlaunchedby="Send_to_Student"

NET USE Z: /DELETE
pause
