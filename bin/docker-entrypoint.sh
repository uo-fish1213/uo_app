#!/bin/bash
set -e

echo "=== Docker Entrypoint Script Starting ==="

# DATABASE_URL から接続情報を抽出
if [ -n "$DATABASE_URL" ]; then
  echo "DATABASE_URL is set, extracting connection info..."
  
  # DATABASE_URL の形式: postgres://user:password@host:port/database
  # 正規表現で各要素を抽出
  DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
  DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:\/]*\).*/\1/p')
  DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
  
  echo "Extracted DB_HOST: $DB_HOST"
  echo "Extracted DB_USER: $DB_USER"
  echo "Extracted DB_NAME: $DB_NAME"
  
  # データベースが利用可能になるまで待機
  echo "Waiting for database to be ready..."
  
  max_attempts=30
  attempt=0
  
  until pg_isready -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    
    if [ $attempt -ge $max_attempts ]; then
      echo "Database connection failed after $max_attempts attempts"
      echo "Continuing anyway to start the server..."
      break
    fi
    
    echo "Database is unavailable - sleeping (attempt $attempt/$max_attempts)"
    sleep 2
  done
  
  if [ $attempt -lt $max_attempts ]; then
    echo "Database is ready!"
  fi
else
  echo "DATABASE_URL is not set, skipping database check"
fi

# server.pid ファイルを削除
echo "Removing old server.pid if exists..."
rm -f /rails/tmp/pids/server.pid

# マイグレーションを実行（エラーが出ても続行）
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || echo "Migration skipped or failed, continuing..."

echo "Setup completed!"

# Puma サーバーを起動
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb