#!/bin/bash
set -e

# データベースが起動するまで待つ（オプション）
echo "Waiting for database..."
until bundle exec rails db:migrate:status &> /dev/null
do
  echo "Database is unavailable - sleeping"
  sleep 1
done

# マイグレーションを実行
echo "Running database migrations..."
bundle exec rails db:migrate

# データベースにシードデータを投入（必要な場合のみ）
# echo "Seeding database..."
# bundle exec rails db:seed

# アプリケーションを起動
echo "Starting application..."
exec bundle exec puma -C config/puma.rb