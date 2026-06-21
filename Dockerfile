# syntax = docker/dockerfile:1

# Ruby version
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION

# Rails app lives here
WORKDIR /rails

# Set development environment (本番環境の設定を削除)
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Install packages needed for development
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    curl \
    postgresql-client \
    nodejs \
    npm && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port
EXPOSE 3001

# Start the server
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3001"]