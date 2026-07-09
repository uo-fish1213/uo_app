# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# Render が提供する PORT 環境変数を使用
port_number = ENV.fetch("PORT") { 3000 }
port port_number

# すべてのネットワークインターフェースでリクエストを受け付ける
bind "tcp://0.0.0.0:#{port_number}"

# Specifies the `environment` that Puma will run in.
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# ワーカー数の設定（本番環境のみ）
if rails_env == "production"
  # Render の無料プランではワーカー数を 1 に設定することを推奨
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 1 })
  workers worker_count

  # プリロード（メモリ効率が良くなる）
  preload_app!

  # フォーク前の処理
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if rails_env == "development"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart