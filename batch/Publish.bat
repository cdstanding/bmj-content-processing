SETLOCAL ENABLEDELAYEDEXPANSION
@echo off
set in-pub=\\bmjprod1\bmj\Editorial\_content_processing\xmlprocessing\bmj\proc\in_pub
set prodtracker=\\bmjprod1\bmj\Editorial\_content_processing\xmlprocessing\bmj\proc\prodtracker

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"

set article-directory=%1
echo This is the path to the article folder %article-directory%
echo This is the article to be published %~nx1
set article-file-path=%1\jats-xml\%~nx1.xml
echo This is the path to the file %article-file-path%
echo This is the path to the prodtracker info file %prodtracker%
echo This is the path to the prodtracker info file %prodtracker%\info_files

rem Check to see if info file exists before processing
if exist %prodtracker%\info_files\%~nx1.info.xml (
    echo Info file exists. Continuing process...
) else (
		goto :exit
)

rem Check whether article is for embargo and if not just send for Green to Go without embargo information.
:choice
echo %embargo-choice% 
set /p embargo-choice=Is this article for embargo? y/n

if "%embargo-choice%"=="y" (
	set embargo-set=y
	set launched-by=send-to-hw-embargo
	set publish-to-hwx=true
	goto yes
		) else (
		if "%embargo-choice%"=="n" (
		set embargo-set=n
		set launched-by=send-to-hw-green-to-go
		set publish-to-hwx=true
		goto no
		) else (
		echo Please enter y or n
		goto choice)
		)

rem Ask user to enter date and time information for embargo and check format against a pattern. 
:yes
:date
set /p embargo-date=Enter the embargo date:DD/MM/YYYY: 
echo Embargo date is %embargo-date%
echo %embargo-date%|findstr /r "^[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]$" >nul 2>&1
if errorlevel 1 (
	echo Date format is incorrect
	goto :date
	) else (
		echo Date entered correctly
	)

:time
set /p embargo-time=Enter the embargo time:HH:MM 
echo Embargo time is %embargo-time%
echo %embargo-time%|findstr /r "^[0-9][0-9]:[0-9][0-9]$" >nul 2>&1
if errorlevel 1 (
	echo Time format is incorrect
	goto :time
	) else (
		echo Time entered correctly
	)
	

:no
rem Create an info file for the article to store the embargo information.
@echo off
set logfile=%in-pub%\pub_info\%~nx1.txt
@echo article-file-path=%article-file-path%>%logfile%
@echo embargo-date=%embargo-date%>>%logfile%
@echo embargo-time=%embargo-time%>>%logfile%
@echo launched-by=%launched-by%>>%logfile%

rem Copy the XML file to the xml-in folder to be processed.
echo Publishing %~nx1 to HWX...
copy %article-file-path% %in-pub%\xml

rem Check for a failure in the copy and warn of no XML file if so.
if %errorlevel% neq 0 (
echo ------------------------------------------------------------------------------------
echo COULD NOT FIND XML FILE TO COPY. PLEASE CHECK THE JATS-XML FOLDER. ENDING PROCESS...
echo ------------------------------------------------------------------------------------
del %in-pub%\pub_info\%~nx1.txt
)

goto :end

:exit
echo --------------------------------------------------------------------------------------------------------
echo COULD NOT FIND INFO FILE. PLEASE CHECK THIS ARTICLE HAS BEEN PROCESSED FROM EXTYLES BEFORE PUBLISHING...
echo --------------------------------------------------------------------------------------------------------

:end
pause