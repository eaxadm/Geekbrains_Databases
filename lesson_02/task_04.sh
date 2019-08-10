#!/bin/bash
echo '[client]' > ~/.my.cnf
echo 'user=root' >> ~/.my.cnf
echo 'password=mysql123' >> ~/.my.cnf
mysqldump --where="true limit 100" mysql help_keyword > help_keyword.dump
