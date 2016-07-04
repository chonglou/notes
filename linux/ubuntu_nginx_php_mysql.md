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
    add-apt-repository ppa:ondrej/php5-5.6
    apt-get -y update
    apt-get -y install php5-fpm php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl 


