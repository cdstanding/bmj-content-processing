SETLOCAL ENABLEDELAYEDEXPANSION
NET USE Z: /DELETE
NET USE Z: \\bmjprod1\users\la_bmjprod\dev-test\bmj
:setup

path Z:\apache-ant-1.9.4\bin;Z:\jdk1.8.0_40\bin;C:\Windows\System32;
set JAVA_HOME=Z:\jdk1.8.0_40
set ANT_HOME=Z:\apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set PATH=%PATH%;%JAVA_HOME%\bin;%ANT_HOME%\bin;

rem ImageMagick-7 directory
set PATH=%PATH%;%JAVA_HOME%;%ANT_HOME%;Z:\ImageMagick-7.0.3-Q16;Z:\gs\gs9.20\bin;

rem Imagemagick environment variables
set HOME=Z:\ImageMagick-7.0.3-Q16
set MAGICK_CODER_MODULE_PATH=Z:\ImageMagick-7.0.3-Q16\modules\coders
set MAGICK_CODER_FILTER_PATH=Z:\ImageMagick-7.0.3-Q16\modules\filters
set MAGICK_CONFIGURE_PATH=Z:\ImageMagick-7.0.3-Q16
rem ----------

set LIST=
title Make PDF %1%

for %%A in (%*) do set LIST=%%A,!LIST!
echo Making PDF...
call ant -e -buildfile Z:\build_process_article.xml -propertyfile Z:\build_makePDF.properties -Dinputdirlist="%LIST%" -Dmain-build="build_makePDF.xml" -Dlaunchedby="makePDF" -Dsupp-files-in-process="false" -Dgraphic-files-in-process="true" -Dpdf-in-process="true"
NET USE Z: /DELETE
pause