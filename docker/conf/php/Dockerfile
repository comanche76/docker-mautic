FROM debian:bookworm-slim AS base

ENV DEBIAN_FRONTEND=noninteractive \
    PHP_CONF_DATE_TIMEZONE=UTC \
    PHP_CONF_MAX_EXECUTION_TIME=60 \
    PHP_CONF_MEMORY_LIMIT=512M \
    PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=0 \
    PHP_CONF_MAX_INPUT_VARS=1000 \
    PHP_CONF_UPLOAD_LIMIT=40M \
    PHP_CONF_MAX_POST_SIZE=40M

# Ottimizzazione APT: niente pacchetti suggeriti/raccomandati + esclusione doc/man
RUN echo 'APT::Install-Recommends "0"; APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01-no-recommended && \
    echo 'path-exclude=/usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/doc/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    apt-get update && apt-get install -y \
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
        gnupg2 && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && apt-get install -y \
        php8.3-fpm \
        php8.3-cli \
        php8.3-intl \
        php8.3-opcache \
        php8.3-mysql \
        php8.3-zip \
        php8.3-xml \
        php8.3-gd \
        php8.3-grpc \
        php8.3-curl \
        php8.3-mbstring \
        php8.3-bcmath \
        php8.3-apcu \
        php8.3-exif \
        php8.3-imap \
        php8.3-xdebug \
        php8.3-memcached && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/sbin/php-fpm8.3 /usr/local/sbin/php-fpm && \
    usermod --uid 1000 www-data && groupmod --gid 1000 www-data && \
    mkdir -p /srv/mautic /run/php && \
    sed -i "s#listen = /run/php/php8.3-fpm.sock#listen = 9000#g" /etc/php/8.3/fpm/pool.d/www.conf

# Install Node.JS (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer && \
    mkdir -p /var/www/.composer /var/www/.cache && \
    chown www-data:www-data /var/www/.composer /var/www/.cache

# Set www-data permission to log file
RUN mkdir -p /var/log && \
    touch /var/log/php8.3-fpm.log && \
    chown -R www-data:www-data /var/log/php8.3-fpm.log

COPY xdebug.ini /etc/php/8.3/cli/conf.d/99-akeneo-xdebug.ini
COPY xdebug.ini /etc/php/8.3/fpm/conf.d/99-akeneo-xdebug.ini

VOLUME /srv/mautic
