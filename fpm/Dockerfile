################################################################################
# Base image
################################################################################

FROM ubuntu:14.04
MAINTAINER  Daniel Weiss "mail@weiss-daniel.de"

################################################################################
# Build instructions
################################################################################

# Install packages
RUN apt-get update && apt-get install -my software-properties-common && add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -my --force-yes \
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
RUN sed -i "s/user = www-data/user = root/" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php/7.0/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf
# Get access to FPM_Status page /status
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

# Listen on port 9000
RUN sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php/7.0/fpm/pool.d/www.conf

# Create folder for pid and socket files
RUN mkdir /var/run/php

# Add configuration files
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www"]

################################################################################
# Ports
################################################################################

EXPOSE 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/sbin/php-fpm7.0", "-FR"]
