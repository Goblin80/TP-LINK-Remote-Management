@ECHO off

REM Authorization for user:user
SET Auth=Basic dXNlcjp1c2Vy
SET	TotalTrackFile="Log\Total.txt"
SET TodayTrackFile="Log\%date:~7,2% - %date:~4,2%.txt"

REM Check cURL
IF NOT EXIST curl.exe echo ERROR:curl Not Found & PAUSE & EXIT

REM Check Log Directory
IF NOT EXIST Log MKDIR Log

REM To increment 'counter' inside the loop
SETLOCAL ENABLEDELAYEDEXPANSION 
set counter=0

REM Bytes on Line 54, but there are 3 skipped empty lines.
SET LineNo=51

FOR /f %%i IN ('curl.exe -s "http://192.168.1.1/statswan.cmd" -H "Referer: http://192.168.1.1/menu.html" -H "Cookie: Authorization=%Auth%"') DO SET /a counter+=1 & IF !counter! EQU %LineNo% SET rec="%%i"

IF [%rec%] EQU [] ECHO ERROR: Cannot connect to router & timeout 10 & Exit
SET rec=%rec:~5,-6%
SET rec=%rec:,=%

REM Store rec in KBs
SET /a rec/=1024

REM Get total/today bytes
IF NOT EXIST %TotalTrackFile% ECHO 0 > %TotalTrackFile% & ECHO Total Track File Not found, New one created.
IF NOT EXIST %TodayTrackFile% ECHO 0 > %TodayTrackFile% & ECHO Today Track File Not found, New one created.
FOR /f %%i IN (%TotalTrackFile%) DO SET total=%%i
FOR /f %%i IN (%TodayTrackFile%) DO SET today=%%i

REM Set total/today bytes
SET /a total+= %rec%
SET /a today+= %rec%
ECHO %total% > %TotalTrackFile%
ECHO %today% > %TodayTrackFile%

REM Reset Statistics
curl -s "http://192.168.1.1/statswanreset.html" -H "Referer: http://192.168.1.1/statswan.cmd" -H "Cookie: Authorization=%Auth%" > nul

