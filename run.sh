#!/bin/bash
service mysql start
sleep 3
service php5-fpm start
sleep 3
/usr/sbin/sshd
sleep 3
service nginx start
