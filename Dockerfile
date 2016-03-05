################################################################################
# Base image
################################################################################

FROM ubuntu:14.04
MAINTAINER  Daniel Weiss "mail@weiss-daniel.de"

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
#RUN apt-get update && apt-get install -my software-properties-common && add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -my --force-yes \
  nginx \
  vim \
  htop \
  curl \
  wget

# Add configuration files
COPY conf/nginx.conf /etc/nginx/

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/sbin/nginx"]
