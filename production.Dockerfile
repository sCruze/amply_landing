# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim

ENV RAILS_ENV=production \
    RACK_ENV=production \
    LANG=C.UTF-8 \
    RAILS_LOG_TO_STDOUT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_FROZEN=1

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

RUN gem update --system && gem install bundler

ARG DEV_UID=1000
ARG DEV_GID=1000
RUN groupadd --gid ${DEV_GID} app && \
    useradd  --uid ${DEV_UID} --gid ${DEV_GID} --create-home --shell /bin/bash app && \
    mkdir -p /usr/local/bundle && chown -R ${DEV_UID}:${DEV_GID} /usr/local/bundle

WORKDIR /usr/src/app
USER ${DEV_UID}:${DEV_GID}

COPY --chown=${DEV_UID}:${DEV_GID} Gemfile Gemfile.lock ./

RUN bundle config set --local without "${BUNDLE_WITHOUT}" \
 && bundle config set --local path "${BUNDLE_PATH}" \
 && bundle config set --local deployment "true" \
 && bundle config set --local frozen "true" \
 && bundle install \
 && rm -rf ${BUNDLE_PATH}/ruby/*/cache

COPY --chown=${DEV_UID}:${DEV_GID} . .

RUN install -d -m 0775 -o ${DEV_UID} -g ${DEV_GID} \
      tmp tmp/pids tmp/sockets tmp/cache log storage \
  && chmod -R 0775 tmp log storage

ARG RAILS_MASTER_KEY
ARG SECRET_KEY_BASE
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY} \
    SECRET_KEY_BASE=${SECRET_KEY_BASE}

RUN /bin/bash -lc 'SECRET_KEY_BASE="${SECRET_KEY_BASE:-dummy_build_key}" bundle exec rails dartsass:build'

ENV PORT=3000
EXPOSE 3000

ENTRYPOINT ["/bin/bash", "-lc", "bundle exec rails db:prepare || true; exec bundle exec rails server -b 0.0.0.0 -p ${PORT}"]
