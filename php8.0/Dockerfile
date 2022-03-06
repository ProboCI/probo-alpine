# Probo Alpine Image
#
# These images are built using Dockerfile inheritance to build the images used for Probo.CI.
#
# Image: proboci/alpine
# Tag: php8.0
# 
# Build the proboci/alpine:php8.0
# docker build . -t proboci/alpine:php8.0
# docker push proboci/alpine:php8.0

FROM alpine:latest

LABEL name="ProboCI PHP 8.0 Image"
LABEL description="ProboCI's PHP 8 image based off Alpine Linux"
LABEL author="Michael R. Bagnall <mbagnall@zivtech.com>"
LABEL vendor="ProboCI, LLC."

RUN apk update && \
  apk add --no-cache \
  openrc nodejs-current mysql mysql-client php8-apache2 postgresql-client postgresql openjdk8-jre wget bash chromium \
  chromium-chromedriver php8 php8-bcmath php8-bz2 php8-curl php8-dba php8-gd php8-intl php8-ldap php8-mbstring php8-mysqli \
  php8-opcache php8-pdo_mysql php8-pdo_pgsql php8-soap php8-xml php8-zip php8-pecl-redis php8-pecl-memcached lsof \
  php8-pecl-imagick php8-pear git vim zip gzip bzip2 pv rsync xvfb varnish curl php8-cgi php8-common nullmailer \
  php8-cli mlocate php8-phar php8-dom php8-tokenizer mariadb-openrc apache2-ctl npm redis memcached 

# RUN apk add --no-cache \
#   make

RUN ln -s /usr/bin/php8 /bin/php

# Install composer and drush.
RUN mkdir -p /usr/local/src/drush9
RUN mkdir -p /usr/local/src/drush8
RUN mkdir -p /usr/local/src/drush-launcher
RUN apk add php8-cli && curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin \
  --filename=composer \
  && composer \
  --working-dir=/usr/local/src/drush9 \
  global \
  require \
  drush/drush:9.* \
  && composer \
  --working-dir=/usr/local/src/drush8 \
  global \
  require \
  drush/drush:8.* \
  && mkdir /etc/drush \
  && mkdir /etc/drush/conf.d
COPY files/drush-environment.php /etc/drush/conf.d/environment.php
COPY files/drushrc.php /etc/drush/drushrc.php
COPY files/versionizer.php /bin/versionizer
RUN wget -O /usr/local/src/drush-launcher/drush https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
RUN chmod +x /usr/local/src/drush-launcher/drush

# Install Proboscis
RUN npm install -g proboscis --unsafe

# Install Terminus Pantheon command line tool, https://pantheon.io/docs/terminus.
RUN mkdir ~/terminus && cd ~/terminus \
  && curl -L https://github.com/pantheon-systems/terminus/releases/download/3.0.6/terminus.phar --output terminus \
  && chmod +x terminus \
  && ln -s ~/terminus/terminus /bin/terminus

# Install WP-CLI Wordpress command line tool, https://wp-cli.org/.
RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /tmp/wp-cli.phar \
  && mv /tmp/wp-cli.phar /bin/wp

RUN curl -OL https://github.com/acquia/cli/releases/latest/download/acli.phar \
  && chmod +x acli.phar \
  && mv acli.phar /bin/acli

RUN cd /root && \
  wget https://github.com/ElusiveMind/bee/archive/refs/heads/bugfix/context-variable.zip && \
  unzip context-variable.zip && \
  mv bee-bugfix-context-variable bee && \
  cd /bin && \
  ln -s /root/bee/bee.php bee && \
  chmod -R 755 /root/bee/bee.php && \
  cd

RUN addgroup mysql mysql && \
  chown -R mysql:mysql /var/lib/mysql && \
  mysql_install_db --user=mysql --ldata=/var/lib/mysql && \
  mkdir -p /run/mysqld && \
  chown -R mysql:mysql /run/mysqld

# Setup Apache SOLR
ENV SOLR_USER root
ENV SOLR_UID 8983
ENV SOLR_VERSION 7.7.3
RUN mkdir -p /opt/solr && \
  wget -nv --output-document=/opt/solr.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz && \
  cd /opt && \
  tar xzf solr.tgz && \
  mv solr-$SOLR_VERSION/* solr/ && \
  rm /opt/solr.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr

COPY files/mysql-setup.sql /mysql-setup.sql
COPY files/probo.cnf .my.cnf
COPY files/probo-mysql.cnf /etc/mysql/mysql.conf.d/probo-mysql.cnf
