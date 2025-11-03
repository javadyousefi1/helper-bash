#!/bin/bash

# ───────────────────────────────
# 1) Input: Project name
# ───────────────────────────────
PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Please provide a project name"
  echo "Example:"
  echo "./backup_and_send.sh dr-asadi"
  exit 1
fi

# ───────────────────────────────
# 2) Backup configuration
# ───────────────────────────────
PG_CONTAINER="postgres"   # PostgreSQL container name
PG_USER="javad"           # PostgreSQL user
BACKUP_DIR="/root/backup"
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_FILE="${BACKUP_DIR}/${PROJECT_NAME}_${DATE}.sql"

# ───────────────────────────────
# 3) Telegram configuration
# ───────────────────────────────
BOT_TOKEN="8209287458:AAEgyTaGwpkDJXWat0AmzD1Iu2g6ex8eoJs"
CHAT_ID="5681533805"

# ───────────────────────────────
# 4) Create backup directory if missing
# ───────────────────────────────
mkdir -p "$BACKUP_DIR"

# ───────────────────────────────
# 5) Take full database backup
# ───────────────────────────────
echo "📦 Creating PostgreSQL backup..."
docker exec -t "$PG_CONTAINER" pg_dumpall -U "$PG_USER" > "$BACKUP_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Backup failed!"
  exit 1
fi

echo "✅ Backup file created: $BACKUP_FILE"

# ───────────────────────────────
# 6) Send backup to Telegram
# ───────────────────────────────
echo "📤 Sending to Telegram..."

CAPTION="🗄 Database Backup%0A%0A📌 Project: ${PROJECT_NAME}%0A📅 Date: ${DATE}"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F chat_id="${CHAT_ID}" \
  -F document=@"${BACKUP_FILE}" \
  -F caption="${CAPTION}"

if [ $? -eq 0 ]; then
  echo "✅ Sent successfully!"
else
  echo "❌ Failed to send file to Telegram."
fi

exit 0
