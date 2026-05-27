#!/bin/bash

# =========================
# CONFIG
# =========================

CONTAINER_NAME="teamspeak"
BACKUP_DIR="$HOME/backups/teamspeak"
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="teamspeak_backup_$DATE.tar.gz"

# Quantos dias manter os backups
RETENTION_DAYS=14

# =========================
# CREATE BACKUP FOLDER
# =========================

mkdir -p "$BACKUP_DIR"

# =========================
# CREATE BACKUP INSIDE CONTAINER
# =========================

echo "[INFO] Criando backup do TeamSpeak..."

docker exec "$CONTAINER_NAME" tar czf "/tmp/$BACKUP_NAME" /var/ts3server

# =========================
# COPY BACKUP TO HOST
# =========================

echo "[INFO] Copiando backup para o host..."

docker cp "$CONTAINER_NAME:/tmp/$BACKUP_NAME" "$BACKUP_DIR/$BACKUP_NAME"

# =========================
# REMOVE TEMP FILE FROM CONTAINER
# =========================

docker exec "$CONTAINER_NAME" rm "/tmp/$BACKUP_NAME"

# =========================
# DELETE OLD BACKUPS
# =========================

echo "[INFO] Limpando backups antigos..."

find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

# =========================
# DONE
# =========================

echo "[OK] Backup concluído:"
echo "$BACKUP_DIR/$BACKUP_NAME"
