#!/bin/sh

# When we get here, we are past the start of MySQL. We need to wait for MySQL
# to be started, then swap out the configuration files for Apache. And then
# we need to re-start Apache.

mysql -s -e 'use mysql; select * from db;'
while [ "$?" -ne 0 ]; then
  mysql -s -e 'use mysql; select * from db;'
fi

mv /root/apache-default-host-init.conf /etc/apache2/conf.d/apache-default-host.conf
apachectl restart
