# Probo Alpine Image
#
# These images are built using Dockerfile inheritance to build the images used for Probo.CI.
#
# Image: proboci/alpine
# Tag: php8.2
# 
# Build the proboci/alpine:php8.2
# docker build . -t proboci/alpine:php8.2
# docker push proboci/alpine:php8.2

FROM alpine:3.19

LABEL name="ProboCI PHP 8.2 Image"
LABEL description="ProboCI's PHP 8.2 image based off Alpine Linux"
LABEL author="Michael R. Bagnall <mbagnall@zivtech.com>"
LABEL vendor="ProboCI, LLC."

ENV TERM xterm

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/src/vendor/bin:/src/vendor/drush/drush:/src/docroot/vendor/drush/drush

# Copy our Alpine compiled iconv library
COPY files/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

# Install all of our base packages for making the image work.
RUN apk update && \
  apk add --no-cache \
  openrc nodejs mariadb mariadb-client php82-apache2 wget bash \
  php82 php82-bcmath php82-bz2 php82-curl php82-dba php82-ldap php82-mbstring php82-mysqli \
  php82-opcache php82-fileinfo php82-pdo_mysql php82-pdo_pgsql php82-soap php82-xml php82-zip php82-pecl-redis \
  php82-pecl-memcached openjdk11-jre php82-pear git vim zip gzip bzip2 pv rsync curl php82-cgi \
  php82-common sudo php82-simplexml php82-cli mlocate php82-phar php82-dom php82-tokenizer \
  mariadb-openrc apache2-ctl npm redis memcached ncurses php82-ctype php82-iconv apache2-proxy \
  php82-gd gnu-libiconv apache2-ssl php82-xmlreader php82-xmlwriter imagemagick-pdf \
  php82-pecl-mongodb php82-pecl-imagick nano php82-pdo_sqlite sqlite procps lsof patch nano

# Run freshclam to get our clam database
# RUN apk add clamav clamav-db
# COPY files/clamd.conf /etc/clamav/clamd.conf
# RUN mkdir -p /run/clamav/ && freshclam && clamd

RUN ln -s /usr/bin/php82 /bin/php

# Attempt to resolve our iconv problems
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Install composer and drush.
RUN apk add php82-cli && curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin \
  --filename=composer
COPY files/versionizer.php /bin/versionizer
COPY files/bashrc /root/.bashrc

# Install Proboscis
RUN npm install -g proboscis --unsafe

# Install gulp
RUN npm install -g gulp

# Install Terminus Pantheon command line tool, https://pantheon.io/docs/terminus.
RUN mkdir ~/terminus && cd ~/terminus \
  && curl -L https://github.com/pantheon-systems/terminus/releases/download/3.5.2/terminus.phar --output terminus \
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

COPY files/mysql /etc/init.d/mysql
RUN addgroup mysql mysql && \
  mysql_install_db --user=mysql --ldata=/var/lib/mysql && \
  chown -R mysql:mysql /var/lib/mysql && \
  mkdir -p /run/mysqld && \
  chown -R mysql:mysql /run/mysqld && \
  chmod 755 /etc/init.d/mysql

# Setup Apache SOLR
ENV SOLR_USER=root
ENV SOLR_UID=8983
ENV SOLR_VERSION=9.6.1
RUN mkdir -p /opt/solr && \
  wget -nv --output-document=/opt/solr.tgz https://proofroom.s3.amazonaws.com/solr-$SOLR_VERSION.tgz && \
  cd /opt && \
  tar xzf solr.tgz && \
  mv solr-$SOLR_VERSION/* solr/ && \
  rm /opt/solr.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr \
  && /opt/solr/bin/solr -force \
  && wget https://ftp.drupal.org/files/projects/search_api_solr-4.3.5.tar.gz \
  && rm -rf /opt/solr/search_api_solr \
  && tar xzf search_api_solr-4.3.5.tar.gz \
  && mv search_api_solr /opt/solr/. \
  && /opt/solr/bin/solr create -c drupal -d "/opt/solr/search_api_solr/jump-start/solr9/config-set" -force \
  && /opt/solr/bin/solr create -c drupal8 -d "/opt/solr/search_api_solr/jump-start/solr9/config-set" -force \
  && /opt/solr/bin/solr stop -all

COPY files/mysql-setup.sql /mysql-setup.sql
COPY files/mycnf.txt /root/.my.cnf
COPY files/probo-mysql.cnf /etc/my.cnf.d/probo-mysql.cnf

COPY files/apache-default-host.conf /etc/apache2/conf.d/apache-default-host.conf
COPY files/ssl_environment_variable.conf /etc/apache2/conf.d/ssl_environment_variable.conf
COPY files/httpd.conf /etc/apache2/httpd.conf
COPY files/listen_8080.conf /etc/apache2/conf.d/listen_8080.conf
RUN mkdir -p /var/www/html

COPY files/valid-user.sh /bin/valid
RUN chmod 755 /bin/versionizer /bin/valid

# Fly in our Drush script for sanitizing the database which removes
# a lot of revision, cache, watchdog, and search data.
COPY files/database_sanitize.php /opt/database_sanitize.php

RUN rm /usr/bin/vi
RUN ln -s /usr/bin/vim /usr/bin/vi
