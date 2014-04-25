FROM ubuntu:12.04

RUN apt-get update
RUN apt-get -y install vim lynx lsof wget
RUN apt-get -y install nginx php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt

RUN mkdir /var/www
