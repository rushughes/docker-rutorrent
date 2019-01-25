FROM php:7-fpm

RUN apt-get update && apt-get install -y \
	libcurl4-openssl-dev libc-client-dev libkrb5-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        ssmtp \
	libssl-dev

RUN docker-php-ext-install -j$(nproc) iconv curl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN     mkdir /var/run/php-fpm
RUN     rm /usr/local/etc/php-fpm.d/*
COPY    www.conf /usr/local/etc/php-fpm.d/www.conf
COPY    php.ini /usr/local/etc/php/
RUN     docker-php-ext-install mysqli pdo pdo_mysql
RUN     git clone git@github.com:Novik/ruTorrent.git /var/www/html
RUN	rm -rf /var/www/html/.git

VOLUME ["/var/www/html", "/usr/local/etc/php-fpm.d", "/var/run/php-fpm"]
