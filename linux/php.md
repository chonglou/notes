Centos下nginx+php安装脚本
------------

### lnp.sh
#!/bin/sh

##
# Centos+Nginx+Php安装脚本
# php mysql xml memcache gd imagemagick mbstring 等常用模块安装 详情见info.php页
##
<code>
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

yum check-update

yum install -y nginx php-fpm php-cli php-common php-dba php-gd php-imap php-intl php-ldap php-mbstring php-mysql php-pdo php-odbc php-pspell php-soap php-xml php-xmlrpc uuid-php php-enchant php-pecl-memcache php-devel php-pear

yum install -y gcc make ImageMagick ImageMagick-devel
pecl channel-update pecl.php.net
pecl install imagick
echo "extension=imagick.so" > /etc/php.d/imagick.ini

/etc/init.d/nginx start
/etc/init.d/php-fpm start
 
</code>
