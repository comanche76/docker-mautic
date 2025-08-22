FROM php:8.3-fpm-bookworm AS base

ENV DEBIAN_FRONTEND=noninteractive \
    PHP_CONF_DATE_TIMEZONE=UTC \
    PHP_CONF_MAX_EXECUTION_TIME=60 \
    PHP_CONF_MEMORY_LIMIT=512M \
    PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=0 \
    PHP_CONF_MAX_INPUT_VARS=1000 \
    PHP_CONF_UPLOAD_LIMIT=40M \
    PHP_CONF_MAX_POST_SIZE=40M

RUN apt-get update && apt-get install -y \
        ca-certificates \
        curl \
        wget \
        supervisor \
        imagemagick \
        libmagickcore-6.q16-6-extra \
        ghostscript \
        openssh-client \
        aspell \
        aspell-en aspell-es aspell-de aspell-fr \
        gnupg2 \
        less \
        nano \
        procps

## Mautic required PHP modules: xml mysql imap zip intl curl gd mbstring bcmath
## Additional PHP modules: opcache, memcached
#        libc-client2007e-dev        # IMAP required library
#        libkrb5-dev                     required by IMAP
#        libssl-dev \                  # IMAP required library
#        libcurl4-openssl-dev \        # IMAP required library
#        libxml2-dev \                 # XML and IMAP required library
#        libzip-dev \                  # ZIP required library
#        libpng-dev \                  # PNC required library
#        libmemcached-dev \            # memcached required library
#        zlib1g-dev \                  # memcached required library

RUN apt-get update && apt-get install -y \
        libc-client2007e-dev \
        libkrb5-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libxml2-dev \
        libzip-dev \
        libmemcached-dev \
        zlib1g-dev \
        libonig-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    && docker-php-ext-install xml  \
        pdo_mysql \
        zip \
        intl \
        curl \
        gd \
        mbstring \
        bcmath \
        sockets \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && pecl install memcached-3.2.0 \
    && docker-php-ext-enable memcached \
    && pecl install xdebug-3.4.0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.JS (LTS)
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g npm@latest

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer && \
    mkdir -p /var/www/.composer /var/www/.cache /var/www/.npm

# Set www-data permission to log file
RUN mkdir -p /var/log && \
    touch /var/log/php8.3-fpm.log && \
    chown -R www-data:www-data /var/log/php8.3-fpm.log

## Prepare folder and set permissions
RUN usermod --uid 1000 www-data && groupmod --gid 1000 www-data && \
    mkdir -p /srv/mautic /run/php && \
    chown www-data:www-data /var/www/.composer && \
    chown www-data:www-data /var/www/.cache && \
    chown www-data:www-data /var/www/.npm

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.disabled
COPY toggle-xdebug.sh /usr/local/bin/toggle-xdebug.sh

RUN chmod +x /usr/local/bin/toggle-xdebug.sh

VOLUME /srv/mautic
