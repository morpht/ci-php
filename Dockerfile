FROM php:8.2.22-alpine3.19

ARG RUNNER_UID=1001

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php"

ENV COMPOSER_VERSION=2.7.1 \
  COMPOSER_HASH_SHA256=1ffd0be3f27e237b1ae47f9e8f29f96ac7f50a0bd9eef4f88cdbe94dd04bfff0

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
    && chmod +x /usr/local/bin/composer \
    && echo 'memory_limit = ${PHP_MEMORY_LIMIT}' > /usr/local/etc/php/conf.d/memory-limit.ini

#RUN adduser -D -h /home/runner -u $RUNNER_UID runner

#USER runner
