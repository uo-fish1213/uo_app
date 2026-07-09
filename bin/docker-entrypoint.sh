#!/bin/bash
set -e

echo "=== Starting application ==="

# DATABASE_URL の確認
if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL is not set"
  exit 1
fi

echo "DATABASE_URL is set"

# 古い server.pid を削除
rm -f tmp/pids/server.pid

# データベース準備
echo "Preparing database..."
bundle exec rails db:prepare

echo "Starting server..."
exec bundle exec puma -C config/puma.rb