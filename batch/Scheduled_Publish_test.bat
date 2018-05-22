set ANT=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\apache-ant-1.9.4
set ANT_OPTS=%ANT_OPTS% -Xmx512M
set BUILD=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\src\build
set CURL=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\progs\curl-7.59.0-win64-mingw
set GS=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\gs\gs9.19\bin
set IM=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\ImageMagick-7.0.3-Q16
set JAVA=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\jdk1.8.0_40
set MAGICK_CODER_MODULE_PATH=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\ImageMagick-7.0.3-Q16\modules\coders
set MAGICK_CODER_FILTER_PATH=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\ImageMagick-7.0.3-Q16\modules\filters
set MAGICK_CONFIGURE_PATH=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\ImageMagick-7.0.3-Q16\ImageMagick-7.0.3-Q16
set PROPERTIES=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\src\properties
set SYS32=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\Windows\System32;
set XEP=D:\bmj\Editorial\_content_processing\xmlprocessing\bmj\progs\Render\XEP;
set PATH=%JAVA%\bin;%ANT%\bin;%SYS32%;%IM%;%GS%;%CURL%;%XEP%;

path %PATH%

echo Publish to Highwire...

call ant -f %BUILD%\build_publish_to_HW.xml -propertyfile %PROPERTIES%\content_processing_test.properties main
pause