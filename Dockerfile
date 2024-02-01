# Use a base image with PHP 8.2.14, Alpine 3.18
FROM php:8.2.14-alpine3.18

ARG RUNNER_UID=1001

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php"

ENV COMPOSER_VERSION=2.6.6 \
    COMPOSER_HASH_SHA256=72600201c73c7c4b218f1c0511b36d8537963e36aafa244757f52309f885b314 \
    PHP_MEMORY_LIMIT=128M

# Install required packages and extensions
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

# Add user 'runner' with specified UID
RUN adduser -D -h /home/runner -u $RUNNER_UID runner

# Install Node.js and Cypress
USER root
RUN apk add --no-cache nodejs npm \
    && npm install -g cypress@13 \
    && chown -R runner:runner /home/runner

USER runner
