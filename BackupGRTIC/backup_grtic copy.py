from datetime import datetime
from pathlib import Path
import pyzipper
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
import os, sys

# Variáveis recebem as configurações repassadas via parametros
var_origem_bkp = sys.argv[1]
var_destino_bkp = sys.argv[2]
var_email_to = sys.argv[3]
var_subject_email = sys.argv[4]
var_max_bkp_amount = sys.argv[5]
print(f'Iniciando: {var_subject_email}')

def enviare_mail(send_mail_to,msg_email_body):

    msg = MIMEMultipart()
    message = msg_email_body

    # setup the parameters of the message
    password = "wlhqrpzcfqarjncm" # senha de APP
    msg['From'] = "noreply@saocamilonortenordeste.org.br"
    msg['To'] = send_mail_to
    msg['Subject'] = var_subject_email # Nome do Backup

    # add in the message body
    #msg.attach(MIMEText(message, 'plain')) # mensagem texto puro
    msg.attach(MIMEText(message, 'html')) # mensagem em formato HTML
    
    #create server
    server = smtplib.SMTP('smtp.gmail.com: 587')
    
    server.starttls()
    
    # Login Credentials for sending the mail
    server.login(msg['From'], password)
    
    
    # send the message via the server.
    server.sendmail(msg['From'], msg['To'], msg.as_string())
    
    server.quit()
    
    print(f"successfully sent email to: {send_mail_to}")

try:
   
    OBJECT_TO_BACKUP = var_origem_bkp # O arquivo ou diretório para backup
    BACKUP_DIRECTORY = var_destino_bkp # O local para armazenar os backups
    MAX_BACKUP_AMOUNT = int(var_max_bkp_amount) # 7  # A quantidade máxima de backups a ter em BACKUP_DIRECTORY

    object_to_backup_path = Path(OBJECT_TO_BACKUP)
    backup_directory_path = Path(BACKUP_DIRECTORY)
    assert object_to_backup_path.exists()  # Valide se o objeto que estamos prestes a fazer backup existe antes de continuarmos

    # Valide se o diretório de backup existe e crie, se necessário
    backup_directory_path.mkdir(parents=True, exist_ok=True)

    # Obtenha a quantidade de zips de backup anteriores no diretório de backup já

    existing_backups = [
        x for x in backup_directory_path.iterdir()
        if x.is_file() and x.suffix == '.zip' and x.name.startswith('backup-')
    ]

    # Aplique backups máximos e exclua os mais antigos se houver muitos após o novo backup

    oldest_to_newest_backup_by_name = list(sorted(existing_backups, key=lambda f: f.name))
    while len(oldest_to_newest_backup_by_name) >= MAX_BACKUP_AMOUNT:  # >= because we will have another soon
        backup_to_delete = oldest_to_newest_backup_by_name.pop(0)
        backup_to_delete.unlink()

    # Criar arquivo zip (para opções de arquivo e pasta)
    backup_file_name = f'backup-{datetime.now().strftime("%Y%m%d%H%M%S")}-{object_to_backup_path.name}.zip'
    #zip_file = zipfile.ZipFile(str(backup_directory_path / backup_file_name), mode='w')
    zip_file = pyzipper.AESZipFile(
        str(backup_directory_path / backup_file_name), 
        mode='w', 
        compression=pyzipper.ZIP_LZMA, 
        encryption=pyzipper.WZ_AES)
    zip_file.setpassword(b'B4ckup!@2022##')
    if object_to_backup_path.is_file():
        # Se o objeto a ser escrito for um arquivo, escreva o arquivo
        zip_file.write(
            object_to_backup_path.absolute(),
            arcname=object_to_backup_path.name
        )
    elif object_to_backup_path.is_dir():
        # Se o objeto a ser escrito for um diretório, grave todos os arquivos
        for file in object_to_backup_path.glob('**/*'):
            if file.is_file():
                zip_file.write(
                    file.absolute(),
                    arcname=str(file.relative_to(object_to_backup_path))
                )
    zip_file.close()
    backup_file_size = (os.path.getsize(str(backup_directory_path / backup_file_name)) /1024) / 1024 # Converter em MB
    message_backup_successfull = f'''
    <h2>Backup GRTIC</h2>
    <p>Backup Executado com Sucesso!</p>
    <p>Diretório do backup: <b>{backup_directory_path}</b></p>
    <p>Arquivo: <b>{backup_file_name} </b>criado com sucesso!</p>
    <p>Tamanho arquivo: <b>{backup_file_size:.2f} MB </b>criado com sucesso!</p>
    <br>
    <h5><i>Esse e-mail não deve ser respondido. <br> Equipe GRTIC</i></h5>
    '''
    lista_emails = var_email_to.split(',') # Enviar email para mais de um destinatário
    for email in lista_emails:
        enviare_mail(email,message_backup_successfull)
except Exception as e:
    message_backup_unsuccessful = f'''
    <h2>Backup GRTIC</h2>
    <h1>Backup Executado com Erro :( </h1>
    <p>O erro recebido foi: <b>{e}</b></p>
    <br>
    <p>Em caso de dúvidas entrar em contato com equipe da GRTIC></p>  
    <br>
    <h5><i>Esse e-mail não deve ser respondido. <br> Equipe GRTIC</i></h5>
    '''
    lista_emails = var_email_to.split(',') # Enviar email para mais de um destinatário
    for email in lista_emails:
        enviare_mail(email,message_backup_unsuccessful)