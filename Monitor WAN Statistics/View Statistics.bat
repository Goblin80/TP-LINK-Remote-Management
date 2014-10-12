@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST Log ECHO ERROR: Log Directory Not Found & PAUSE & EXIT

ECHO x Daily Traffic Consumption:
ECHO====================================================
ECHO.
FOR /F "delims=" %%i IN ('DIR /T:C /B Log') DO (
SET CDATE=%%i
FOR /F "usebackq" %%j IN ("Log\!CDATE!") DO SET TotalBytes=%%j
SET /a MBs= !TotalBytes! / 1024 %% 1024
SET /a GBs= !TotalBytes! / 1048576

IF "%%i" NEQ "Total.txt" (
ECHO * Traffic Consumed on !CDATE:~0,-4!: [!GBs! Gigs and !MBs! Megs]
))
ECHO.
ECHO====================================================
ECHO x Total Traffic Consumption = !GBs! Gigs and !MBs! Megs
ECHO. & ECHO.

PAUSE