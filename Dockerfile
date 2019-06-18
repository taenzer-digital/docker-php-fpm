FROM php:7.3-fpm

LABEL maintainer="Lars Hörseljau <l.hoerseljau@taenzer.me>"

ENV COMPOSER_VERSION 1.8.6

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    git \
    unzip \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    libpq-dev \
    wget

RUN rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install pdo pdo_pgsql pdo_mysql mysqli

RUN pecl install pecl install xdebug-2.7.2
RUN docker-php-ext-enable xdebug

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

CMD ["php-fpm"]
