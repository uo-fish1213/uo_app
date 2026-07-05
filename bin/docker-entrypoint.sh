#!/bin/bash
set -e

echo "=== Docker Entrypoint Script Starting ==="

# データベースが利用可能になるまで待機
echo "Waiting for database to be ready..."

max_attempts=30
attempt=0

# pg_isready を使用した接続確認
until pg_isready -h "$DATABASE_HOST" -U "$DATABASE_USER" -d "postgres" > /dev/null 2>&1; do
  attempt=$((attempt + 1))
  
  if [ $attempt -ge $max_attempts ]; then
    echo "Database connection failed after $max_attempts attempts"
    exit 1
  fi
  
  echo "Database is unavailable - sleeping (attempt $attempt/$max_attempts)"
  sleep 2
done

echo "Database is ready!"

# server.pid ファイルを削除（前回の起動の残骸を削除）
echo "Removing old server.pid if exists..."
rm -f /rails/tmp/pids/server.pid

# データベースの作成（存在しない場合のみ）
echo "Creating database if it doesn't exist..."
bundle exec rails db:create || true

# マイグレーションを実行
echo "Running database migrations..."
bundle exec rails db:migrate

echo "Migrations completed successfully!"

# Puma サーバーを起動
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb