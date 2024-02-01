FROM php:8.2.14-alpine3.18

ARG RUNNER_UID=1001

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php"

ENV COMPOSER_VERSION=2.6.6 \
    COMPOSER_HASH_SHA256=72600201c73c7c4b218f1c0511b36d8537963e36aafa244757f52309f885b314 \
    PHP_MEMORY_LIMIT=128M

RUN apk add --no-cache --update git \
        bash \
        openssh-client \
        mysql-client \
        patch \
        rsync \
        libpng libpng-dev libzip-dev \
        libnotify libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    && docker-php-ext-install gd pdo pdo_mysql zip \
    && apk del libpng-dev \
    && rm -rf /var/cache/apk/* \
    && curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && echo "$COMPOSER_HASH_SHA256  /usr/local/bin/composer" | sha256sum -c \
    && chmod +x /usr/local/bin/composer \
    && echo 'memory_limit = ${PHP_MEMORY_LIMIT}' > /usr/local/etc/php/conf.d/memory-limit.ini

# Remove warning about running as root in composer
ENV COMPOSER_ALLOW_SUPERUSER=1

### Install node

ENV NODE_VERSION=18.19.0 \
    CHECKSUM=10b7b23b6b867a25f060a433b83f5c3ecb3bcf7cdba1c0ce46443065a832fd41

RUN ARCH='x64'; \
    set -eu; \
    apk add --no-cache \
        libstdc++ \
    && curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
    && echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && node --version \
    && npm --version

RUN adduser -D -h /home/runner -u $RUNNER_UID runner

USER runner
