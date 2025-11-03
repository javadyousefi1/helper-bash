#!/bin/bash

# ───────────────────────────────
# 1) ورودی: اسم پروژه
# ───────────────────────────────
PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ لطفاً اسم پروژه را وارد کنید"
  echo "مثال:"
  echo "./backup_and_send.sh dr-asadi"
  exit 1
fi

# ───────────────────────────────
# 2) تنظیمات بکاپ
# ───────────────────────────────
PG_CONTAINER="postgres"  # اسم کانتینر پستگرس
PG_USER="javad"           # یوزر پستگرس
BACKUP_DIR="/root/backup"
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_FILE="${BACKUP_DIR}/${PROJECT_NAME}_${DATE}.sql"

# ───────────────────────────────
# 3) اطلاعات تلگرام
# ───────────────────────────────
BOT_TOKEN="8209287458:AAEgyTaGwpkDJXWat0AmzD1Iu2g6ex8eoJs"
CHAT_ID="5681533805"

# ───────────────────────────────
# 4) ساخت پوشه بکاپ اگر نبود
# ───────────────────────────────
mkdir -p "$BACKUP_DIR"

# ───────────────────────────────
# 5) گرفتن بکاپ کامل از همه دیتابیس‌ها
# ───────────────────────────────
echo "📦 در حال گرفتن بکاپ از PostgreSQL ..."
docker exec -t "$PG_CONTAINER" pg_dumpall -U "$PG_USER" > "$BACKUP_FILE"

if [ $? -ne 0 ]; then
  echo "❌ خطا در گرفتن بکاپ"
  exit 1
fi

echo "✅ فایل بکاپ ساخته شد: $BACKUP_FILE"

# ───────────────────────────────
# 6) ارسال بکاپ به تلگرام
# ───────────────────────────────
echo "📤 در حال ارسال به تلگرام ..."

CAPTION="🗄 بکاپ پایگاه داده\n\n📌 پروژه: ${PROJECT_NAME}\n📅 تاریخ: ${DATE}"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F chat_id="${CHAT_ID}" \
  -F document=@"${BACKUP_FILE}" \
  -F caption="${CAPTION}"

echo "✅ ارسال شد!"

exit 0
