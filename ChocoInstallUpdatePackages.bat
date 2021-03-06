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
set DevelopmentRuntimes=jdk8 jdk11 vcredist2005 vcredist2008 vcredist2010 vcredist2012 vcredist2013 vcredist2015 vcredist140 vcredist2017 dotnet4.7.1 directx nodejs-lts yarn

REM Items used for software development
set DevelopmentTools=ctags visualstudiocode sublimetext3 notepadplusplus sqlite winmerge git gitextensions gitkraken sqlitebrowser vagrant hosts.editor postman meld php composer maven
set Work_DevelopmentTools=crystalreports2010runtime tortoisesvn autoit scite4autoit3 androidstudio beyondcompare

REM Font packages to install
set Fonts=inconsolata sourcecodepro droidsansmono oxygenmono

REM Web browsers
set Browsers=googlechrome firefox opera

REM General tools used on my systems
set SystemUtilities=procmon procexp f.lux ditto rainmeter sysmon 7zip winrar vlc paint.net gpg4win classic-shell sysinternals curl wget greenshot freefilesync wizmouse nitroreader.install windirstat treesizefree
set AudioVideoTools=vlc spotify audacity-lame audacity

set WorkSystemUtilities=bginfo slack toggl virtuawin

REM SSH/File Transfer and Passwords
set SSH_Password_TransferTools=putty superputty openssh filezilla lastpass

set Work_SSH_Password_TransferTools=keepass winscp

set RemoteTools=radmin-viewer rdmfree

REM Virtualization Tools
set VMWareTools=vmware-horizon-client

set Games=steam origin goggalaxy uplay
set SharingTools=dropbox

:ChooseMonitors
set /P DualMonitors=Do you have more than 1 monitor[Y/N]? (X to exit)
if /I "%DualMonitors%" EQU "Y" goto :HaveMultipleMonitors
if /I "%DualMonitors%" EQU "N" goto :ChooseVirtualBox
if /I "%DualMonitors%" EQU "X" goto :End

goto :ChooseMonitors

:HaveMultipleMonitors
set SystemUtilities=%SystemUtilities% displayfusion

:ChooseVirtualBox
set /P InstallVirtualBox=Do you want to install Virtual Box[Y/N]? (X to exit)
if /I "%InstallVirtualBox%" EQU "Y" goto :PackageChoice
if /I "%InstallVirtualBox%" EQU "N" goto :PackageChoice
if /I "%InstallVirtualBox%" EQU "X" goto :End

goto :ChooseVirtualBox

:PackageChoice
set /P Machine=Is this for Home or Work[H/W]? (X to exit)
if /I "%Machine%" EQU "H" goto :SetHome
if /I "%Machine%" EQU "W" goto :SetWork
if /I "%Machine%" EQU "X" goto :End

goto :PackageChoice

:SetHome
REM for Home
set Items=ChocolateyTools DevelopmentRuntimes DevelopmentTools Fonts Browsers SystemUtilities AudioVideoTools SSH_Password_TransferTools Games SharingTools

GOTO :RunIt

:SetWork
REM for work
set Items=ChocolateyTools DevelopmentRuntimes DevelopmentTools Work_DevelopmentTools Fonts Browsers SystemUtilities AudioVideoTools WorkSystemUtilities SSH_Password_TransferTools Work_SSH_Password_TransferTools RemoteTools VMWareTools

:ChooseVMWare
set /P NeedVMWare=Do you need VMWare tools[Y/N]? (X to exit)
if /I "%NeedVMWare%" EQU "Y" goto :AddVMWare
if /I "%NeedVMWare%" EQU "N" goto :RunIt
if /I "%NeedVMWare%" EQU "X" goto :End

goto :ChooseVMWare

:AddVMWare
set Items=%Items% %VMWareTools%

:RunIt

(for %%a in (%Items%) do (
   echo %CHOCO_LABEL% items from %%a
   (for %%b in (!%%a!) do (
        choco %CHOCO_COMMAND% %%b -y
        REM echo would run choco %CHOCO_COMMAND% %%b -y
    ))
))
if /I "%InstallVirtualBox%" EQU "N" goto :Pause
choco %CHOCO_COMMAND% virtualbox --params ^"/NoDesktopShortcut /NoExtensionPack^" -y

GOTO Pause

:MustBeAdmin
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:Pause

PAUSE

:End
