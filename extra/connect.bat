@echo off
setlocal

:Start
echo ----------------------------------------
echo           Tunnel Connection            
echo ----------------------------------------

:inputCluster
set /p cluster="Cluster Address (ec2-xxx-...): "
if "%cluster%"=="" goto :inputCluster

:inputKey
set /p chiave="Drag and drop the key (.pem): "
if not exist "%chiave%" (
    echo File not found!
    goto :inputKey
)

set comando=ssh -N -i "%chiave%" hadoop@%cluster% -L 8088:%cluster%:8088 -L 19888:%cluster%:19888 -L 20888:%cluster%:20888

echo Tunnel starting in new window...

:startTunnel
start /wait cmd.exe /c "%comando%"

if "%ERRORLEVEL%"=="0" (
    echo Connection successful. Waiting for 3 minutes before checking again...
    ping 127.0.0.1 -n 181 > nul
) else (
    echo Connection lost. Retrying instantly...
)

goto :startTunnel
