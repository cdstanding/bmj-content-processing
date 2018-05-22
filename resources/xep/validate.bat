@echo off
rem   This batch file encapsulates a standard XEP call. 

set CP=C:\dev\bmj\Render\XEP\lib\xep.jar;C:\dev\bmj\Render\XEP\lib\saxon6.5.5\saxon.jar;C:\dev\bmj\Render\XEP\lib\saxon6.5.5\saxon-xml-apis.jar;C:\dev\bmj\Render\XEP\lib\xt.jar

if x%OS%==xWindows_NT goto WINNT
"C:\Program Files\Java\jdk1.8.0_91\jre\bin\java" -classpath "%CP%" "-Dcom.renderx.xep.CONFIG=C:\dev\bmj\Render\XEP\xep.xml" com.renderx.xep.Validator %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:WINNT
"C:\Program Files\Java\jdk1.8.0_91\jre\bin\java" -classpath "%CP%" "-Dcom.renderx.xep.CONFIG=C:\dev\bmj\Render\XEP\xep.xml" com.renderx.xep.Validator %*

:END

set CP=
