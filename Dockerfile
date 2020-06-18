FROM php:7.2.5-cli-alpine

ENV DEBIAN_FRONTEND noninteractive
ENV DBUS_SESSION_BUS_ADDRESS /dev/null

RUN apk add --no-cache libzip-dev libxml2-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \

  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-configure bcmath --enable-bcmath && \
  docker-php-ext-configure zip --with-libzip=/usr/include && \
  docker-php-ext-install -j${NPROC} iconv gd opcache mbstring pdo pdo_mysql bcmath zip soap && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# Composer Globals
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

WORKDIR /srv/app