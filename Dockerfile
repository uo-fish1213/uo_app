# ベースとなるOSイメージを指定
FROM ruby:3.2.2

# Node.js と Yarn のインストール
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs && \
    npm install -g yarn

# 作業ディレクトリの設定
WORKDIR /app

# Gemfile と Gemfile.lock をコピー
COPY Gemfile Gemfile.lock ./

# Bundler のインストールと gem のインストール
RUN gem install bundler && bundle install