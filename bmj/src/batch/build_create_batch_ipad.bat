SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev-test\bmj

set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=-Xmx512M
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;C:\Windows\System32;Z:\dev-test\bmj\ImageMagick-7.0.3-Q16;Z:\dev\bmj\gs\gs9.19\bin;

rem ImageMagick-7 directory
set PATH=%PATH%;%JAVA_HOME%;%ANT_HOME%;Z:\ImageMagick-7.0.3-Q16;Z:\gs\gs9.20\bin;

rem Imagemagick environment variables
set HOME=Z:\ImageMagick-7.0.3-Q16
set MAGICK_CODER_MODULE_PATH=Z:\ImageMagick-7.0.3-Q16\modules\coders
set MAGICK_CODER_FILTER_PATH=Z:\ImageMagick-7.0.3-Q16\modules\filters
set MAGICK_CONFIGURE_PATH=Z:\ImageMagick-7.0.3-Q16
rem ----------

title CREATE V-ISSUE BATCH %1%
for %%A in (%*) do set LIST=%%A,!LIST!
echo Creating batch for i-Pad...

call ant -e -buildfile Z:\build_create_batch.xml -propertyfile Z:\build_create_batch.properties -Dinputdirlist="%LIST%" -Dprocess="ipad"
NET USE Z: /DELETE
pause