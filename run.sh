#!/bin/bash
service mysql restart
sleep 3
service php5-fpm restart
sleep 3
service nginx restart
sleep 3
/usr/sbin/sshd -D
