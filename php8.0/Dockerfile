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

FROM alpine:3.16

LABEL name="ProboCI PHP 8.0 Image"
LABEL description="ProboCI's PHP 8.0 image based off Alpine Linux"
LABEL author="Michael R. Bagnall <mbagnall@flyingflip.com>"
LABEL vendor="FlyingFlip Studios, LLC."

ENV TERM=xterm

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/src/vendor/bin:/src/vendor/drush/drush:/src/docroot/vendor/drush/drush

# Compensate for the removal of iconv
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community/ --allow-untrusted gnu-libiconv=1.15-r2

# Install all of our base packages for making the image work.
RUN apk update && \
  apk add --no-cache \
  openrc nodejs mariadb mariadb-client php8-apache2 wget bash \
  php8 php8-bcmath php8-bz2 php8-curl php8-dba php8-ldap php8-mbstring php8-mysqli \
  php8-opcache php8-fileinfo php8-pdo_mysql php8-pdo_pgsql php8-soap php8-xml php8-zip php8-pecl-redis \
  php8-pecl-memcached openjdk11-jre php8-pear git vim zip gzip bzip2 pv rsync curl php8-cgi \
  php8-common sudo php8-simplexml php8-cli mlocate php8-phar php8-dom php8-tokenizer \
  mariadb-openrc apache2-ctl npm redis memcached ncurses php8-ctype php8-iconv apache2-proxy \
  php8-gd gnu-libiconv apache2-ssl php8-xmlreader php8-xmlwriter \
  php8-pecl-mongodb php8-pecl-imagick nano php8-pdo_sqlite sqlite procps lsof nano patch

# By default, alpine puts PHP in as "php7" or "php8". We need to homogenize it.
RUN ln -s /usr/bin/php8 /bin/php

# Install composer and drush.
RUN apk add php8-cli && curl -sS https://getcomposer.org/installer | php -- \
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
  chown -R mysql:mysql /var/lib/mysql && \
  mysql_install_db --user=mysql --ldata=/var/lib/mysql && \
  mkdir -p /run/mysqld && \
  chown -R mysql:mysql /run/mysqld && \
  chmod 755 /etc/init.d/mysql

# Setup Apache SOLR
ENV SOLR_USER=root
ENV SOLR_UID=8983
ENV SOLR_VERSION=8.11.4
RUN mkdir -p /opt/solr && \
  wget -nv --output-document=/opt/solr.tgz https://proofroom.s3.amazonaws.com/solr-$SOLR_VERSION.tgz && \
  cd /opt && \
  tar xzf solr.tgz && \
  mv solr-$SOLR_VERSION/* solr/ && \
  rm /opt/solr.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr \
  && /opt/solr/bin/solr -force \
  && wget https://ftp.drupal.org/files/projects/search_api_solr-7.x-1.17.tar.gz \
  && tar xzf search_api_solr-7.x-1.17.tar.gz \
  && mv search_api_solr /opt/solr/. \
  && /opt/solr/bin/solr create -c drupal7 -d "/opt/solr/search_api_solr/solr-conf/8.x" -force \
  && wget https://ftp.drupal.org/files/projects/search_api_solr-4.3.10.tar.gz \
  && rm -rf /opt/solr/search_api_solr \
  && tar xzf search_api_solr-4.3.10.tar.gz \
  && mv search_api_solr /opt/solr/. \
  && /opt/solr/bin/solr create -c drupal -d "/opt/solr/search_api_solr/jump-start/solr8/config-set" -force \
  && /opt/solr/bin/solr create -c drupal8 -d "/opt/solr/search_api_solr/jump-start/solr8/config-set" -force \
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

# Fly in our Drush script for sanitizing the database which removes
# a lot of revision, cache, watchdog, and search data.
COPY files/database_sanitize.php /opt/database_sanitize.php

RUN rm /usr/bin/vi
RUN ln -s /usr/bin/vim /usr/bin/vi
