#!/bin/bash
# Data Criação: 01-08-2022
# @Marcelo Grando
# Script 

mount -t cifs //10.1.0.43/Backup_FortesAC -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_ac
mount -t cifs //10.1.0.43/Backup_FortesPonto -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_ponto
mount -t cifs //10.1.0.43/Backup_FortesRH -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_rh
mount -t cifs //10.1.0.43/Backup_Systemah -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_systemah2005
mount -t cifs //10.1.0.43/Backup_WKSistemas -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_wk_sistemas