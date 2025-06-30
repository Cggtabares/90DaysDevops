#!/bin/bash

#Conf
LOG_DIR="/var/log"
BACKUP_DIR="/home/vagrant/backups_ejercicio"
RETENTION_DAYS=1
DATE=$(date +%F_%T)

#Crear carpeta backups
#if [ -d $BACKUP_DIR ]; then
#        mkdir $backups_ejercicio
#       echo "El directorio ha sido creado"
#else
#        echo "El directorio existe"
#fi

mkdir -p "$BACKUP_DIR"

#Comprimir logs en tar el nombre sera en timestamp
backup_file="$BACKUP_DIR/logs_$DATE.tar"
sudo tar -czf "$backup_file" -C "$LOG_DIR" .

#Eliminar archivos despues de 7 dias
find /home/vagrant/backups_ejercicio -type f -mtime +$RETENTION_DAYS -exec rm {} \;


# #Otra forma de hacer
# Create daily backups of log files.
# Compress older backups.
# Maintain a defined number of backup copies.
# Manage disk space efficiently.

# #!/bin/bash

# # Configuration
# LOG_DIR="/path/to/log_directory"
# BACKUP_DIR="/path/to/backup_directory"
# RETENTION_DAYS=7
# DATE=$(date +'%Y-%m-%d')

# # Ensure backup directory exists
# mkdir -p "$BACKUP_DIR"

# # Create a daily backup
# backup_logs() {
#     local backup_file="$BACKUP_DIR/logs_$DATE.tar.gz"
#     tar -czf "$backup_file" -C "$LOG_DIR" .
#     if [ $? -eq 0 ]; then
#         echo "$(date +'%Y-%m-%d %H:%M:%S'): Successfully created backup $backup_file"
#     else
#         echo "$(date +'%Y-%m-%d %H:%M:%S'): Failed to create backup $backup_file" >&2
#         exit 1
#     fi
# }

# # Remove backups older than RETENTION_DAYS
# cleanup_old_backups() {
#     find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
#     if [ $? -eq 0 ]; then
#         echo "$(date +'%Y-%m-%d %H:%M:%S'): Successfully cleaned up old backups"
#     else
#         echo "$(date +'%Y-%m-%d %H:%M:%S'): Failed to clean up old backups" >&2
#     fi
# }

# # Main script execution
# backup_logs
# cleanup_old_backups