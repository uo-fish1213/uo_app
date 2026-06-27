#!/bin/bash
set -e

echo "=== Docker Entrypoint Script Starting ==="

# データベースが利用可能になるまで待機
echo "Waiting for database to be ready..."

max_attempts=30
attempt=0

until bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" > /dev/null 2>&1; do
  attempt=$((attempt + 1))
  
  if [ $attempt -ge $max_attempts ]; then
    echo "Database connection failed after $max_attempts attempts"
    exit 1
  fi
  
  echo "Database is unavailable - sleeping (attempt $attempt/$max_attempts)"
  sleep 2
done

echo "Database is ready!"

# マイグレーションを実行
echo "Running database migrations..."
bundle exec rails db:migrate

echo "Migrations completed successfully!"

# Puma サーバーを起動
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb