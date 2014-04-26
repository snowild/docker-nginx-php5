#!/bin/bash
#/usr/sbin/sshd -D
sleep 3
service mysql restart
sleep 3
service php5-fpm restart
sleep 3
#service nginx restart
