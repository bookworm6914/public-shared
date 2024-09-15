@ECHO OFF
SETLOCAL

:: ===================================================================================================
:: quick_config_win10.cmd
::
:: NT shell Script to configure some Windows 10 settings, such as
::  disabling UAC/Windows Defender/firewall/auto update etc.
::
:: ===================================================================================================

SET sErrMessage=

CALL :DisplayLogo

IF /i "%PROCESSOR_ARCHITECTURE%" NEQ "AMD64" (
    SET sErrMessage=This script should run on 64-bit Windows
    GOTO :ErrorHandling
)

@ECHO ----------------------------------------------------------
@ECHO Auto login ...
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
IF %ERRORLEVEL% NEQ 0 (
    SET sErrMessage=BE SURE you run the script as a local admin
    GOTO :ErrorHandling
)
@ECHO.
@ECHO.

@ECHO ----------------------------------------------------------
@ECHO Stop Windows Defender ...
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableRoutinelyTakingAction /t REG_DWORD /d 1 /f
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableRoutinelyTakingAction /t REG_DWORD /d 1 /f

@ECHO ----------------------------------------------------------
@ECHO Enable developer mode ...
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
@ECHO.
@ECHO.

@ECHO ----------------------------------------------------------
@ECHO Disable Cortana ...
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /t REG_DWORD /f /v "AllowCortana" /d "0"
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /t REG_DWORD /f /v "AllowCortana" /d "0"
@ECHO.
@ECHO.

@ECHO ----------------------------------------------------------
@ECHO Disable OneDrive ...
: Please refer to https://answers.microsoft.com/en-us/windows/forum/windows_10-files-winpc/how-to-disable-onedrive-in-windows-10/bb20683e-c38f-4c38-9b22-dfd73eeeb510
@ECHO ^>^>^> TASKKILL /F /IM OneDrive.exe
             TASKKILL /F /IM OneDrive.exe
@ECHO ^>^>^> %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
             %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
@ECHO ^>^>^> REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /f /v "DisableFileSyncNGSC" /d 1
             REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /f /v "DisableFileSyncNGSC" /d 1
@ECHO.
@ECHO.

@ECHO ----------------------------------------------------------
@ECHO Install all the latest updates ...
:: Please be aware that Windows update service is turned on from now on
@ECHO ^>^>^> UsoClient ScanInstallWait
             UsoClient ScanInstallWait
@ECHO.
@ECHO Windows Update Service is turned on now. Let us stop it ...
@ECHO.
@ECHO ^>^>^> NET STOP wuauserv
             NET STOP wuauserv
@ECHO.
@ECHO.

:: TODO --- 

@ECHO ----------------------------------------------------------
@ECHO Press any key to reboot Windows when all updates are done,
@ECHO or press Ctrl-C to break from it.
PAUSE
@ECHO ^>^>^> SHUTDOWN /r /t 0
             SHUTDOWN /r /t 0
@ECHO.
@ECHO.

GOTO :EOF

:: ===================================================================================================
:: Display the logo of the script
:: ===================================================================================================
:DisplayLogo

@ECHO.
@ECHO ###########################################################
@ECHO #
@ECHO # %~n0%~x0
@ECHO # Script to configure some Windows 10 settings, such as
@ECHO #  disabling UAC/Windows Defender/firewall/auto update etc.
@ECHO #
@ECHO # Bugs? Suggestions? Please email me at 
@ECHO #
@ECHO ###########################################################
@ECHO.

GOTO :EOF

:: ===================================================================================================
:: Print out the error message and quit
:: ===================================================================================================
:ErrorHandling
@ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+++++
@ECHO.
@ECHO Error ^>^>^> %sErrMessage%.
@ECHO.
@ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+++++
GOTO :EOF

:EOF
