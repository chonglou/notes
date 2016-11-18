Ubuntu+nginx+mysql+php
---


## Mysql
    wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb
    sudo dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb
    sudo apt-get update
    sudo apt-get install percona-server-server-5.7
    mysql_secure_installation

## Php
    apt-get -y update
    apt-get -y install php-fpm php-mcrypt php-curl php-mysql php-gd php-intl php-xsl 


