# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim

ENV RAILS_ENV=development \
    RACK_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    LANG=C.UTF-8 \
    RAILS_LOG_TO_STDOUT=1

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential pkg-config git curl less nano \
      libyaml-dev libpq-dev postgresql-client libvips imagemagick file \
      protobuf-compiler libprotobuf-dev cmake \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

RUN gem update --system && gem install bundler

ARG DEV_UID=1000
ARG DEV_GID=1000
RUN groupadd --gid ${DEV_GID} app && \
    useradd --uid ${DEV_UID} --gid ${DEV_GID} --create-home --shell /bin/bash app
RUN mkdir -p /usr/local/bundle && chown -R ${DEV_UID}:${DEV_GID} /usr/local/bundle

WORKDIR /usr/src/app

# Копируем с нужным владельцем!
COPY --chown=${DEV_UID}:${DEV_GID} Gemfile Gemfile.lock ./

USER ${DEV_UID}:${DEV_GID}

# Теперь у пользователя есть права на Gemfile.lock
RUN bundle install && rm -rf ${BUNDLE_PATH}/ruby/*/cache

USER root
RUN set -eux; \
  echo '#!/usr/bin/env bash'                                   >  /usr/local/bin/dev-entrypoint; \
  echo 'set -euo pipefail'                                     >> /usr/local/bin/dev-entrypoint; \
  echo 'cd /usr/src/app'                                       >> /usr/local/bin/dev-entrypoint; \
  echo 'echo "🔧 Bundler check…"'                               >> /usr/local/bin/dev-entrypoint; \
  echo 'bundle check || bundle install'                        >> /usr/local/bin/dev-entrypoint; \
  echo 'if [ -f "bin/rails" ]; then'                           >> /usr/local/bin/dev-entrypoint; \
  echo '  echo "🗄  rails db:prepare (dev)";'                  >> /usr/local/bin/dev-entrypoint; \
  echo '  bundle exec rails db:prepare || true'                >> /usr/local/bin/dev-entrypoint; \
  echo 'fi'                                                    >> /usr/local/bin/dev-entrypoint; \
  echo 'exec "$@"'                                             >> /usr/local/bin/dev-entrypoint; \
  chmod +x /usr/local/bin/dev-entrypoint
USER ${DEV_UID}:${DEV_GID}

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/dev-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
