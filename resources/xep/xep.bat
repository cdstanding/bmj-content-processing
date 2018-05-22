@echo off
rem   This batch file encapsulates a standard XEP call. 

set CP=Z:\Render\XEP\lib\xep.jar;Z:\Render\XEP\lib\saxon6.5.5\saxon.jar;Z:\Render\XEP\lib\saxon6.5.5\saxon-xml-apis.jar;Z:\Render\XEP\lib\xt.jar

"java" -classpath "%CP%" com.renderx.xep.XSLDriver "-DCONFIG=Z:\Render\XEP\xep.xml" %*

set CP=