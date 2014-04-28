FROM ubuntu:12.04

MAINTAINER Jack Tsai "snowild@gmail.com"

# install MariaDB
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y  python-software-properties
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://mirror2.hs-esslingen.de/mariadb/repo/10.0/ubuntu precise main'
RUN apt-get update
RUN apt-get -y install vim lynx lsof wget openssh-server mariadb-server
RUN wget --no-check-certificate -O /etc/mysql/conf.d/docker.cnf https://raw.githubusercontent.com/snowild/docker-nginx-php5/develop/docker.cnf
#RUN echo "[mysqld]"                      >/etc/mysql/conf.d/docker.cnf 
#RUN echo "bind-address  = 0.0.0.0"       >>/etc/mysql/conf.d/docker.cnf 
#RUN echo "innodb_flush_method = O_DSYNC" >>/etc/mysql/conf.d/docker.cnf 
#RUN echo "skip-name-resolve"             >>/etc/mysql/conf.d/docker.cnf 
#RUN echo "init_file = /etc/mysql/init"   >>/etc/mysql/conf.d/docker.cnf 
RUN echo "GRANT ALL ON *.* TO jack@'%' IDENTIFIED BY 'ubic001';" >/etc/mysql/init
RUN echo "ALL:ALL"                       >>/etc/hosts.allow # avoid ERROR 2013 (HY000): Lost connection to MySQL server at 'reading initial communication packet', system error: 0

RUN apt-get -y install vim lynx lsof wget openssh-server

# install Nginx, PHP5
RUN apt-get -y install nginx php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt

# Download Nginx sites-enabled default config
RUN wget --no-check-certificate -O /etc/nginx/sites-enabled/default https://raw.githubusercontent.com/snowild/docker-nginx-php5/develop/config/nginx/sites-enabled/default

# Config Nginx and PHP5
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Config ssh
RUN mkdir /var/run/sshd 
RUN echo 'root:ubic001' |chpasswd

RUN mkdir /var/www
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php

# Config private ports
EXPOSE 9090
EXPOSE 3306
EXPOSE 22

# Download entrypoint shell script
RUN wget --no-check-certificate -O /bin/run.sh https://raw.githubusercontent.com/snowild/docker-nginx-php5/develop/run.sh
#RUN echo "#!/bin/bash" >> /bin/run.sh
#RUN echo "service mysql start" >> /bin/run.sh
#RUN echo "service php5-fpm start" >> /bin/run.sh
#RUN echo "/usr/sbin/sshd" >> /bin/run.sh
#RUN echo "/usr/sbin/nginx" >> /bin/run.sh

RUN chmod 755 /bin/run.sh
ENTRYPOINT ["/bin/run.sh"]
