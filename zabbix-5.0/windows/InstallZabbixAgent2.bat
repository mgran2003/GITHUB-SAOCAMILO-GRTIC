@echo off
setlocal enabledelayedexpansion

set /p "serviceUserName=Digite o nome de usuario para o servico: "

set "servicePassword="
set "mask=*"

:inputLoop
set "char="
set /p "char=Digite a senha para o serviço: "

if not defined char goto inputComplete
set "servicePassword=!servicePassword!!char!"
<nul set /p "=!mask!"
goto inputLoop

:inputComplete
echo.

echo "== Ocultar a pasta do Zabbix Agent =="
attrib +s +h "C:\zabbix"

echo "== Instalando Zabbix Agent2 como servico. =="
C:\zabbix\zabbix_agent2.exe -i -c C:\zabbix\zabbix_agent2.conf

echo "== Configurando Servico para Rodar com Usuario Especifico =="
sc.exe config "Zabbix Agent 2" obj= ".\%serviceUserName%" password= "%servicePassword%"

echo "== Iniciando Servico Zabbix Agent2 =="
net start "Zabbix Agent 2"