#!/bin/bash
# Data Criação: 06-12-2023
# @Marcelo Grando
# dir = /tmp/install_version_fortesrh.sh
# Script instalar e configurar leitura da versão do FortesRH.

# Verifica se foi fornecido o parâmetro com as iniciais do nome do arquivo
if [ $# -eq 0 ]; then
  echo "Por favor, informe o IP do servidor do Fortes RH"
  exit 1
fi

ip_server_fortesrh=$1

echo "## ATENÇÃO ## O IP: $ip_server_fortesrh é o do servidor do FortesRH está correto?"
read -p "Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '2' ]
then
    echo '## Execute o script novamente informando como parametro o IP Correto ##'
    exit 1
fi


#Verificar se o psql está instalado
if command -v psql &> /dev/null
then
    echo "## psql já está instalado. ##"
else
    # Instalar o psql
    echo "## Instalando psql... ##"
    sudo apt update
    sudo apt install postgresql-client -y

    # Verificar se a instalação foi bem-sucedida
    if command -v psql &> /dev/null
    then
        echo "## psql instalado com sucesso. ##"
    else
        echo "## Falha ao instalar psql. Verifique o processo de instalação. ##"
        exit 1
    fi
fi

# Configurações do banco de dados
DB_HOST=$ip_server_fortesrh
DB_PORT="5432"
DB_NAME="fortesrh"
DB_USER="postgres"
DB_PASSWORD=""

# Comando SQL SELECT
SQL_QUERY1="CREATE ROLE saocamilo LOGIN ENCRYPTED PASSWORD 'md595238e0009cafda70223e6760c42f87d' NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

SQL_QUERY2="GRANT SELECT ON TABLE public.parametrosdosistema to saocamilo;"

# Executa o comando psql
#psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -W $DB_PASSWORD -c "$SQL_QUERY"

# Executa a consulta e armazena o resultado na variável
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY1"
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY2"
