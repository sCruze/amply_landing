FROM ruby:3.3.1-slim

RUN apt-get update -qq \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    libpq-dev \
    cron \
    nano \
    libvips42 \
    imagemagick \
    file \
    libvips-dev \
    curl \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG RAILS_MASTER_KEY
ARG SECRET_KEY_BASE
ARG APP_VERSION=0.0.0+dev

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_MASTER_KEY=${RAILS_MASTER_KEY} \
    SECRET_KEY_BASE=${SECRET_KEY_BASE} \
    APP_VERSION=${APP_VERSION}

RUN gem update --system \
 && gem install bundler

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle config set without 'development test' \
 && bundle install --jobs $BUNDLE_JOBS --retry $BUNDLE_RETRY

COPY . .

RUN bundle exec rails assets:clobber \
 && bundle exec rails assets:clean \
 && bundle exec rails assets:precompile

EXPOSE 3006

RUN echo -n "${APP_VERSION}" > /usr/src/app/VERSION
LABEL org.opencontainers.image.version="${APP_VERSION}"

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
