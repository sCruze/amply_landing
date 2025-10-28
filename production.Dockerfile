# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim

ENV RAILS_ENV=production \
    RACK_ENV=production \
    LANG=C.UTF-8 \
    RAILS_LOG_TO_STDOUT=1 \
    # Bundler
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_FROZEN=1

# Системные зависимости для gem'ов с native-extensions и окружения Rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      pkg-config \
      git \
      curl \
      libyaml-dev \
      libpq-dev \
      postgresql-client \
      libvips \
      imagemagick \
      file \
      protobuf-compiler libprotobuf-dev cmake \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Свежий bundler (обычно уже есть, но безвредно)
RUN gem update --system && gem install bundler

# Непривилегированный пользователь
ARG DEV_UID=1000
ARG DEV_GID=1000
RUN groupadd --gid ${DEV_GID} app && \
    useradd  --uid ${DEV_UID} --gid ${DEV_GID} --create-home --shell /bin/bash app && \
    mkdir -p /usr/local/bundle && chown -R ${DEV_UID}:${DEV_GID} /usr/local/bundle

WORKDIR /usr/src/app
USER ${DEV_UID}:${DEV_GID}

# ВАЖНО: копируем Gemfile* СРАЗУ с нужными правами
COPY --chown=${DEV_UID}:${DEV_GID} Gemfile Gemfile.lock ./

# Установка зависимостей в deployment+frozen (bundler не трогает lockfile)
RUN bundle config set --local without "${BUNDLE_WITHOUT}" \
 && bundle config set --local path "${BUNDLE_PATH}" \
 && bundle config set --local deployment "true" \
 && bundle config set --local frozen "true" \
 && bundle install \
 && rm -rf ${BUNDLE_PATH}/ruby/*/cache

# Копируем остальной код (тоже с правильными правами)
COPY --chown=${DEV_UID}:${DEV_GID} . .

# Готовим директории, в которые Rails пишет во время работы
RUN install -d -m 0775 -o ${DEV_UID} -g ${DEV_GID} \
      tmp tmp/pids tmp/sockets tmp/cache log storage \
  && chmod -R 0775 tmp log storage

# Передаём секреты как ARG/ENV (используются на build-этапе для задач типа сборки ассетов)
ARG RAILS_MASTER_KEY
ARG SECRET_KEY_BASE
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY} \
    SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Сборка фронтовых ассетов (если SECRET_KEY_BASE не пришёл — подставим временный)
RUN /bin/bash -lc 'SECRET_KEY_BASE="${SECRET_KEY_BASE:-dummy_build_key}" bundle exec rails dartsass:build'

# Экспонируем прод-порт (под твой Nginx upstream)
ENV PORT=3000
EXPOSE 3000

# Грейсфул старт: подготовка БД (идемпотентно) и запуск сервера
ENTRYPOINT ["/bin/bash", "-lc", "bundle exec rails db:prepare || true; exec bundle exec rails server -b 0.0.0.0 -p ${PORT}"]
