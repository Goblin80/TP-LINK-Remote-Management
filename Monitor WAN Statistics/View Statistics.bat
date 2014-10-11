@ECHO off

SET TotalTrackFile="Log\Total.txt"
SET TodayTrackFile="Log\%date:~7,2% - %date:~4,2%.txt"

IF NOT EXIST %TotalTrackFile% ECHO Total Track File Not Found & PAUSE & EXIT
IF NOT EXIST %TodayTrackFile% ECHO Today Track File Not Found & PAUSE & EXIT

FOR /F "usebackq" %%i IN (%TotalTrackFile%) DO SET TotalBytes=%%i
FOR /F "usebackq" %%i IN (%TodayTrackFile%) DO SET TodayBytes=%%i

FOR /f "delims=M" %%i IN ('DIR /T:C %TotalTrackFile% ^| find "/"') DO SET CDate=%%iM

ECHO Consumed Quota since %CDate%:
SET /a MBs=(%TotalBytes% / 1024) %% 1024
SET /a GBs=%TotalBytes% / 1048576
ECHO %GBs% Gigs and %MBs% Megas
ECHO.
ECHO=======================================================
ECHO.
ECHO Consumed Quota Today:
SET /a MBs=(%TodayBytes% / 1024) %% 1024
SET /a GBs=%TodayBytes% / 1048576
ECHO %GBs% Gigs and %MBs% Megas
ECHO.
ECHO.
PAUSE