FROM php:8.3.13-alpine3.19

# ARG RUNNER_UID=1001

LABEL maintainer="marji@morpht.com"
LABEL org.opencontainers.image.source="https://github.com/morpht/ci-php"

ENV COMPOSER_VERSION=2.7.7 \
  COMPOSER_HASH_SHA256=aab940cd53d285a54c50465820a2080fcb7182a4ba1e5f795abfb10414a4b4be

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

# RUN adduser -D -h /home/runner -u $RUNNER_UID runner

# USER runner
