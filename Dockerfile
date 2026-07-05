# syntax = docker/dockerfile:1

# Ruby version
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Install packages needed for production
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
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Copy entrypoint script
COPY bin/docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Expose port (Renderが自動的に設定)
EXPOSE 3000

# Set entrypoint
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

# ImageMagick をインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  imagemagick \
  libmagickwand-dev