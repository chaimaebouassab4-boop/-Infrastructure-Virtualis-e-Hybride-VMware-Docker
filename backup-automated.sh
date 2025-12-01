#!/bin/bash
# Description : Script d'automatisation des backups Docker vers partage SMB Windows
# [cite_start]Basé sur le rapport page 30 [cite: 1205, 1206]

# Configuration
BACKUP_DIR="/mnt/windows-share/backups" # Point de montage du partage SMB Windows
DATE=$(date +%Y%m%d)
LOG_FILE="/var/log/docker_backup.log"

# Vérification du montage SMB
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Erreur : Le répertoire de backup $BACKUP_DIR n'est pas accessible." >> $LOG_FILE
    exit 1
fi

echo "Début du backup : $(date)" >> $LOG_FILE

# [cite_start]Boucle sur les volumes critiques (WordPress et MySQL) [cite: 1207]
for VOLUME in dockerproject_wordpress_data ubuntu_mysql_data; do
    echo "Sauvegarde du volume : $VOLUME"
    
    # [cite_start]Utilisation d'un conteneur temporaire pour tar l'archive vers le partage Windows [cite: 1212]
    docker run --rm \
        -v $VOLUME:/data \
        -v $BACKUP_DIR:/backup \
        ubuntu tar cvf /backup/${VOLUME}_$DATE.tar /data
        
    if [ $? -eq 0 ]; then
        echo "Succès : Backup de $VOLUME réalisé." >> $LOG_FILE
    else
        echo "Echec : Erreur lors du backup de $VOLUME." >> $LOG_FILE
    fi
done

echo "Fin du backup : $(date)" >> $LOG_FILE
