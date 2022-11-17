# Probo Alpine Image
#
# These images are built using Dockerfile inheritance to build the images used for Probo.CI.
#
# Image: proboci/alpine
# Tag: php7.4
# 
# Build the proboci/alpine:php7.4
# docker build . -t proboci/alpine:php7.4
# docker push proboci/alpine:php7.4

FROM alpine:3.15

LABEL name="ProboCI PHP 7.4 Image"
LABEL description="ProboCI's PHP 7.4 image based off Alpine Linux"
LABEL author="Michael R. Bagnall <mbagnall@zivtech.com>"
LABEL vendor="ProboCI, LLC."

ENV TERM xterm

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/src/vendor/bin

# Copy our Alpine compiled iconv library
# COPY files/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

# Install all of our base packages for making the image work.
RUN apk update && \
  apk add --no-cache \
  openrc nodejs mariadb mariadb-client php7-apache2 postgresql-client postgresql openjdk8-jre wget bash chromium \
  chromium-chromedriver php7 php7-bcmath php7-bz2 php7-curl php7-dba php7-gd php7-intl php7-ldap php7-mbstring php7-mysqli \
  php7-opcache php7-pdo_mysql php7-pdo_pgsql php7-soap php7-xml php7-zip php7-pecl-redis php7-pecl-memcached lsof \
  php7-pecl-imagick php7-pear git vim zip gzip bzip2 pv rsync varnish curl php7-cgi php7-common sudo php7-simplexml \
  php7-cli mlocate php7-phar php7-dom php7-tokenizer mariadb-openrc apache2-ctl npm redis memcached ncurses php7-ctype \
  php7-xmlwriter patch xvfb-run xvfb apache2-proxy php7-iconv gnu-libiconv apache2-ssl php7-xmlreader

# By default, alpine puts PHP in as "php7" or "php7". We need to homogenize it.
RUN ln -s /usr/bin/php7 /bin/php

# Attempt to resolve our iconv problems
# ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# For compatibility with Ubuntu, create a symlink to chromedriver from the Ubuntu location.
RUN ln -s /usr/bin/chromedriver /usr/local/bin/chromedriver

# Install composer and drush.
RUN mkdir -p /usr/local/src/drush9
RUN mkdir -p /usr/local/src/drush8
RUN mkdir -p /usr/local/src/drush-launcher
RUN apk add php7-cli && curl -sS https://getcomposer.org/installer | php -- \
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
COPY files/bashrc /root/.bashrc
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

# Install the Acquia Command Line Tools
RUN curl -OL https://github.com/acquia/cli/releases/latest/download/acli.phar \
  && chmod +x acli.phar \
  && mv acli.phar /bin/acli

# Install the Backdrop CMS tool Bee
RUN cd /root && \
  wget https://github.com/ElusiveMind/bee/archive/refs/heads/bugfix/default-context-value.zip && \
  unzip default-context-value.zip && \
  mv bee-bugfix-default-context-value bee && \
  cd /usr/local/bin && \
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
  wget -nv --output-document=/opt/solr.tgz https://proofroom.s3.amazonaws.com/solr-$SOLR_VERSION.tgz && \
  cd /opt && \
  tar xzf solr.tgz && \
  mv solr-$SOLR_VERSION/* solr/ && \
  rm /opt/solr.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr \
  && /opt/solr/bin/solr -force \
  && wget https://ftp.drupal.org/files/projects/search_api_solr-7.x-1.15.tar.gz \
  && tar xzf search_api_solr-7.x-1.15.tar.gz \
  && mv search_api_solr /opt/solr/. \
  && /opt/solr/bin/solr create -c drupal7 -d "/opt/solr/search_api_solr/solr-conf/7.x" -force \
  && wget https://ftp.drupal.org/files/projects/search_api_solr-4.2.8.tar.gz \
  && rm -rf /opt/solr/search_api_solr \
  && tar xzf search_api_solr-4.2.8.tar.gz \
  && mv search_api_solr /opt/solr/. \
  && /opt/solr/bin/solr create -c drupal8 -d "/opt/solr/search_api_solr/jump-start/solr7/config-set" -force \
  && /opt/solr/bin/solr stop -all

COPY files/mysql-setup.sql /mysql-setup.sql
COPY files/mycnf.txt /root/.my.cnf
COPY files/probo-mysql.cnf /etc/my.cnf.d/probo-mysql.cnf

COPY files/apache-default-host.conf /etc/apache2/conf.d/apache-default-host.conf
COPY files/ssl_environment_variable.conf /etc/apache2/conf.d/ssl_environment_variable.conf
COPY files/httpd.conf /etc/apache2/httpd.conf
#COPY files/apache-default-varnish-host.conf /etc/apache2/sites-available/000-default-varnish.conf
COPY files/listen_8080.conf /etc/apache2/conf.d/listen_8080.conf
RUN mkdir -p /var/www/html

COPY files/valid-user.sh /bin/valid
RUN chmod 755 /bin/versionizer /bin/valid

RUN rm /usr/bin/vi
RUN ln -s /usr/bin/vim /usr/bin/vi
