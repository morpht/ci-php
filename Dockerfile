FROM php:8.2.14-alpine3.18

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php"

ENV COMPOSER_VERSION=2.6.6 \
  COMPOSER_HASH_SHA256=72600201c73c7c4b218f1c0511b36d8537963e36aafa244757f52309f885b314

RUN apk add --no-cache --update git \
        bash \
        openssh-client \
        mysql-client \
        patch \
        rsync \
        libpng libpng-dev libzip-dev \
    && docker-php-ext-install gd pdo pdo_mysql zip \
    && apk del libpng-dev \
    && rm -rf /var/cache/apk/* \
    && curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && echo "$COMPOSER_HASH_SHA256  /usr/local/bin/composer" | sha256sum -c \
    && chmod +x /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1
