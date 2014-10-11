@ECHO off

REM Added for enabling SET inside IF conditions (use ! instead of %)
SETlocal EnableDelayedExpansion

REM Authorization for admin:admin (base64)
SET Auth=Basic YWRtaW46YWRtaW4=

REM Default Gateway IP
SET DefIP=192.168.1.1

REM Set your SSID to control the AP
SET SSID=TP-LINK

:SOP

REM Check cURL
IF NOT EXIST curl.exe echo ERROR:curl Not Found & PAUSE & EXIT

REM Following ASCII Displays Properly in Window Width >= 80

ECHO "############################################################################"
ECHO "# _____ ____       _     ___ _   _ _  __   ____            _             _ #"
ECHO "#|_   _|  _ \     | |   |_ _| \ | | |/ /  / ___|___  _ __ | |_ _ __ ___ | |#"
ECHO "#  | | | |_) _____| |    | ||  \| | ' /  | |   / _ \| '_ \| __| '__/ _ \| |#"
ECHO "#  | | |  __|_____| |___ | || |\  | . \  | |__| (_) | | | | |_| | | (_) | |#"
ECHO "#  |_| |_|        |_____|___|_| \_|_|\_\  \____\___/|_| |_|\__|_|  \___/|_|#"
ECHO "#								            #"
ECHO "############################################################################"
ECHO.
ECHO.                                                                           

rem Get SessionKey
FOR /f "tokens=2 delims='" %%x IN ('curl "http://%DefIP%/reSETrouter.html" -H "Referer: http://%DefIP%/menu.html" -H "Cookie: Authorization=%Auth%" -s ^| find /n "var sessionKey="') do @SET /a sk=%%x

ECHO [1]Reboot the router
ECHO [2]Disable AP
ECHO [3]Enable  AP
ECHO [4]Renew IP
ECHO | SET /p a=Response:
SET /p a=

rem Reboot Router

IF %a% EQU 1 ( ECHO Rebooting Router...
curl -s "http://%DefIP%/rebootinfo.cgi?sessionKey=%sk%" -H "Referer: http://%DefIP%/reSETrouter.html" -H "Cookie: Authorization=%Auth%" > nul
GOTO EOP:)

rem Disable AP

IF %a% equ 2 ( ECHO Disabling AP...
curl -s "http://%DefIP%/wlcfg.wl?wlSsidIdx=0&wlEnbl=0&wlHide=0&wlAPIsolation=0&wlSsid=%SSID%&wlCountry=US&wlSyncNvram=1&sessionKey=%sk%" -H "Referer: http://%DefIP%/menu.html" -H "Cookie: Authorization=%Auth%" > nul
GOTO EOP:)

rem Enable AP
IF %a% equ 3 ( ECHO Enabling AP...
curl -s "http://%DefIP%/wlcfg.wl?wlSsidIdx=0&wlEnbl=1&wlHide=0&wlAPIsolation=0&wlSsid=%SSID%&wlCountry=US&wlMaxAssoc=50&wlDisableWme=0&wlEnableWmf=1&wlEnbl_wl0v1=0&wlSsid_wl0v1=TP-LINK_GuestA8&wlHide_wl0v1=0&wlAPIsolation_wl0v1=0&wlDisableWme_wl0v1=0&wlEnableWmf_wl0v1=1&wlMaxAssoc_wl0v1=16&wlEnbl_wl0v2=0&wlSsid_wl0v2=wl0_Guest2&wlHide_wl0v2=0&wlAPIsolation_wl0v2=0&wlDisableWme_wl0v2=0&wlEnableWmf_wl0v2=1&wlMaxAssoc_wl0v2=16&wlEnbl_wl0v3=0&wlSsid_wl0v3=wl0_Guest3&wlHide_wl0v3=0&wlAPIsolation_wl0v3=0&wlDisableWme_wl0v3=0&wlEnableWmf_wl0v3=1&wlMaxAssoc_wl0v3=16&wlSyncNvram=1&sessionKey=%sk%" -H "Referer: http://%DefIP%/menu.html" -H "Cookie: Authorization=%Auth%" > nul
GOTO EOP:)

rem Reconnect Interface
IF %a% equ 4 (ECHO Disabling Interface...
curl -s "http://%DefIP%/wancfg.cmd?action=manual&manual=0&IFName=ppp0.1&sessionKey=%sk%" -H "Referer: http://%DefIP%/wancfg.cmd?action=view" -H "Cookie: Authorization=%Auth%" > nul
TIMEOUT 3
ECHO ReEnabling Interface...

rem Getting a new SessionKey
for /f "tokens=2 delims='" %%x in ('curl "http://%DefIP%/reSETrouter.html" -H "Referer: http://%DefIP%/menu.html" -H "Cookie: Authorization=%Auth%" -s ^| find /n "var sessionKey="') do @SET /a sk=%%x

rem Actual Reconnecting 
curl -s "http://%DefIP%/wancfg.cmd?action=manual&manual=1&IFName=ppp0.1&sessionKey=!sk!" -H "Referer: http://%DefIP%/wancfg.cmd?action=view" -H "Cookie: Authorization=%Auth%" > nul

GOTO EOP:)

ECHO Invalid Choice. Try Again.
pause
cls
GOTO SOP:
:EOP