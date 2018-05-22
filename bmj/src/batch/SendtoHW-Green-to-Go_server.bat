SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev-test\bmj

set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=-Xmx512M

rem ImageMagick-7 directory
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;Z:\ImageMagick-7.0.3-Q16;Z:\gs\gs9.20\bin;Z:\Render\XEP;C:\Windows\System32;

rem Imagemagick environment variables
set HOME=Z:\ImageMagick-7.0.3-Q16
set MAGICK_CODER_MODULE_PATH=Z:\ImageMagick-7.0.3-Q16\modules\coders
set MAGICK_CODER_FILTER_PATH=Z:\ImageMagick-7.0.3-Q16\modules\filters
set MAGICK_CONFIGURE_PATH=Z:\ImageMagick-7.0.3-Q16
rem ----------

set LIST=
title Publishing GREEN TO GO SERVER %1%
for %%A in (%*) do set LIST=%%A,!LIST!
echo Send to HWX with NO Embargo - loading script...

call ant -e -buildfile Z:\build_UploadtoBMJCMS.xml -propertyfile Z:\build_UploadtoBMJCMS_live.properties -Dinputdirlist="%LIST%" -Dembargo.set=n -Dlaunchedby="Send_to_HW_Green_to_Go" -Dpublishtohwx=true
NET USE Z: /DELETE
pause