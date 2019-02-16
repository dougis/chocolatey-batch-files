@ echo off
REM Check to see if we are an admin user
setlocal EnableDelayedExpansion


REM check to see if the script is running as admin (net file returns an error if not)
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto IsAdmin ) else ( goto MustBeAdmin )
:IsAdmin

:Choice
set /P Update=Would you like to Install or Update[I/U]? (X to exit)
if /I "%Update%" EQU "I" goto :SetInstall
if /I "%Update%" EQU "U" goto :SetUpdate
if /I "%Update%" EQU "X" goto :End

goto :Choice

:SetInstall
set CHOCO_COMMAND=install
set CHOCO_LABEL=Installing
GOTO :Packages

:SetUpdate
set CHOCO_COMMAND=upgrade
set CHOCO_LABEL=Updating
GOTO :Packages

:Packages
REM chocolatey tools
set ChocolateyTools=chocolatey-core.extension chocolateygui

REM Library files etc (runtimes and so on)
set BasePackages=jre8 vcredist2015 vcredist140 vcredist2017 dotnet4.7.1 directx notepadplusplus crystalreports2010runtime inconsolata sourcecodepro droidsansmono oxygenmono

REM Web browsers
set Browsers=googlechrome firefox opera

REM General tools used on my systems
set SystemUtilities=procmon procexp f.lux ditto rainmeter sysmon 7zip paint.net gpg4win classic-shell greenshot nitroreader.install  displayfusion
set AudioVideoTools=vlc spotify audacity-lame audacity


set Items=ChocolateyTools BasePackages Browsers Fonts Browsers SystemUtilities AudioVideoTools


:RunIt

(for %%a in (%Items%) do (
   echo %CHOCO_LABEL% items from %%a
   (for %%b in (!%%a!) do (
        choco %CHOCO_COMMAND% %%b -y
        REM echo would run choco %CHOCO_COMMAND% %%b -y
    ))
))
GOTO Pause

:MustBeAdmin
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:Pause

PAUSE

:End
