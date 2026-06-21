source "https://rubygems.org"

ruby "3.2.2"

# Rails本体
gem "rails", "~> 7.1.0"

# データベース
gem "pg", "~> 1.1"

# アセットパイプライン
gem "sprockets-rails"

# JavaScriptバンドラー
gem "jsbundling-rails"

# CSSバンドラー
gem "cssbundling-rails"

# Webサーバー
gem "puma", ">= 5.0"

# タイムゾーン情報
gem "tzinfo-data", platforms: %i[ windows jruby ]

# 起動時間短縮
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end