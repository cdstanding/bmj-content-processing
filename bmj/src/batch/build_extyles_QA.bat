
set JAVA=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/jdk1.8.0_40/bin
set ANT=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/apache-ant-1.9.4/bin
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set CURL=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/progs/curl/shims
set GS=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/gs/gs9.19/bin
set IM=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/ImageMagick-7.0.3-Q16
set MAGICK_CODER_MODULE_PATH=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/ImageMagick-7.0.3-Q16/modules/coders
set MAGICK_CODER_FILTER_PATH=C:/Users/la_bmjprod/dev/article_processing/bmj/progs/ImageMagick-7.0.3-Q16/modules/filters
set MAGICK_CONFIGURE_PATH=C:/Users/la_bmjprod/dev/article_processing/bmj/progs//ImageMagick-7.0.3-Q16/ImageMagick-7.0.3-Q16
set SYS32=C:/Windows/System32;
set BUILD=C:/Users/la_bmjprod/dev/article_processing/bmj/src/build
Set PROPERTIES=C:/Users/la_bmjprod/dev/article_processing/bmj/src/properties
set PATH=%JAVA%;%ANT%;%SYS32%;%IM%;%GS%;%CURL%;

path %PATH%

set arg2=%username%

call ant -nice=10 -keep-going -f %BUILD%/build_extyles_QA.xml -propertyfile %PROPERTIES%/article_processing.properties main  -Duser=%arg2%
pause