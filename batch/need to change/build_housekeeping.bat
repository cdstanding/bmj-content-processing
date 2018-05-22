set ANT=C:/Users/la_bmjprod/dev/content_processing/bmj/progs/apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set BUILD=C:/Users/la_bmjprod/dev/content_processing/bmj/src/build
set JAVA=C:/Users/la_bmjprod/dev/content_processing/bmj/progs/jdk1.8.0_40
set PROPERTIES=C:/Users/la_bmjprod/dev/content_processing/bmj/src/properties

set PATH=%JAVA%/bin;%ANT%/bin;

path %PATH%

title Housekeeping

echo Housekeeping...
ant -e -buildfile %BUILD%/build_housekeeping.xml  -propertyfile %PROPERTIES%/content_processing.properties

