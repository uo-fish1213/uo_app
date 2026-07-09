# スレッド数の設定
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# ポート設定（Render が提供する PORT 環境変数を使用）
port ENV.fetch("PORT") { 3000 }

# 環境設定
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# PIDファイルの設定
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# 本番環境のみの設定
if rails_env == "production"
  # ワーカー数を1に設定（Render の無料プランに最適）
  workers ENV.fetch("WEB_CONCURRENCY") { 1 }

  # アプリケーションのプリロード
  preload_app!

  # ワーカー起動時の処理
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

# 開発環境でのワーカータイムアウト
worker_timeout 3600 if rails_env == "development"

# 再起動プラグイン
plugin :tmp_restart