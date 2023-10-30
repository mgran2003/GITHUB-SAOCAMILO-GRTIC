#!/bin/bash
# Data Criação: 20-09-2023
# @Marcelo Grando
# Script config_backup_monitor Balsas

echo '##### Iniciando configuração #####'

DIR="/etc/zabbix/script-python"
 
if [ ! -d "$DIR" ]; then
  mkdir -p $DIR && cd $DIR
fi

chmod 777 -R $DIR

echo '##### Download do arquivo criar_diretorios_backups.sh #####'

wget -O /tmp/criar_diretorios_backups.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/criar_diretorios_backups.sh

sh /tmp/criar_diretorios_backups.sh

echo '##### Download do arquivos script-python #####'

wget -O /etc/zabbix/script-python/info_last_file_bkp.py https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/info_last_file_bkp.py
wget -O /etc/zabbix/script-python/last_file_date.py https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_date.py
wget -O /etc/zabbix/script-python/last_file_name.py https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_name.py
wget -O /etc/zabbix/script-python/last_file_size.py https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_size.py
wget -O /etc/zabbix/script-python/mount_storage.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/CTO-mount_storage.sh

echo '##### Download do arquivos zabbix_agentd.d userparameter #####'

wget -O /etc/zabbix/zabbix_agentd.d/userparameter_info_last_file_bkp.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/CTO-userparameter_info_last_file_bkp.conf
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf

sleep 3s
sh /etc/zabbix/script-python/mount_storage.sh

echo '##### Finalizado #####'