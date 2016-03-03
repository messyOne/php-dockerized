################################################################################
# Base image
################################################################################

FROM ubuntu:latest
MAINTAINER  Daniel Weiss "mail@weiss-daniel.de"

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
RUN apt-get update && apt-get install -my software-properties-common && add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -my --force-yes \
  nginx \
  vim \
  htop \
  supervisor \
  curl \
  wget \
  php7.0-pgsql \
  php7.0-common \
  php7.0-fpm \
  php7.0-mcrypt \
  php7.0-curl \
  php7.0-gd \
  php7.0-json \
  php7.0-cli \
  php-xdebug \
  php-memcached

# Ensure that PHP FPM is run as root.
# TODO move FPM to own image
RUN sed -i "s/user = www-data/user = root/" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php/7.0/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf
# Get access to FPM_Status page /status
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

# Write pid file to /var/run folder
RUN sed -i 's/root/amrood/'
RUN sed -i "s/pid = //run//php//php7.0-fpm.pid/pid = //var//run//php7.0-fpm.pid/" /etc/php/7.0/fpm/php-fpm.conf

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
