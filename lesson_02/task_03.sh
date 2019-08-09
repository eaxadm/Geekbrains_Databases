#!/bin/bash
echo '[client]' > ~/.my.cnf
echo 'user=root' >> ~/.my.cnf
echo 'password=mysql123' >> ~/.my.cnf
mysqldump example > example.dump
mysql -e "CREATE DATABASE IF NOT EXISTS sample;"
mysql sample < example.dump
