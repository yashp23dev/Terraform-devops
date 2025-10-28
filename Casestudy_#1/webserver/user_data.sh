#!/bin/bash
apt-get update
apt-get -y install net-tools nginx
MYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{print $2}' | cut -d ':' -f2`
echo "<h1>Welcome to the web server!</h1><br><h2>Deployed via Terraform</h2><br><h3>Server IP: ${MYIP}</h3>" > /var/www/html/index.html