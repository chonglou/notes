#!/bin/sh
nginx_version=1.6.0
php_version=5.3.28
mysql_version=5.6.19

nginx_url="http://nginx.org/download/nginx-$nginx_version.tar.gz"
php_url="http://www.php.net/get/php-$php_version.tar.bz2/from/this/mirror"
mysql_url="http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-$mysql_version.tar.gz"

build_root=/tmp/build
cpu_number=6
target_root=/opt/lnmp

if [ -d $target_root ]
then
	echo "Directory [$target_root] exist, please remove it first!"
	exit 1
else
	mkdir -pv $target_root
fi

#--------build tools--------------
yum groupinstall "Development Tools" -y -q
yum install kernel-devel cmake -y -q
#--------download-----------------
if [ ! -d $build_root ]
then
	mkdir -pv $build_root
fi
cd $build_root

if [ ! -f nginx-$nginx_version.tar.gz ]
then
	wget $nginx_url
fi

if [ ! -f mysql-$mysql_version.tar.gz ]
then
	wget $mysql_version
fi

if [ ! -f php-$php_version.tar.bz2 ]
then
	wget $php_version
fi

#--------nginx install------------
yum install pcre pcre-devel openssl openssl-devel libxslt libxslt-devel gd gd-devel GeoIP GeoIP-devel -y -q
cd $build_root
rm -rf nginx-$nginx_version
echo 'Uncmpressing nginx...'
tar xf nginx-$nginx_version.tar.gz
cd nginx-$nginx_version
./configure --prefix=$target_root/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-log-path=/var/log/nginx/access.log --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_mp4_module  --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_spdy_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --user=nobody
make -j $cpu_number
make install

#----------mysql install----------
yum install libaio libaio-devel ncurses ncurses-devel -y -q
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd $build_root
rm -rf mysql-$mysql_version
echo 'Uncmpressing mysql...'
tar xf mysql-$mysql_version.tar.gz
cd mysql-$mysql_version
cmake . -DCMAKE_INSTALL_PREFIX=$target_root/mysql -DMYSQL_DATADIR=/var/lib/mysql
make -j $cpu_number
make install
cd $target_root/mysql
chown -R mysql:mysql .
scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql
chown -R root:mysql .
chown -R mysql data
echo "$target_root/mysql/lib" > /etc/ld.so.conf.d/lnmp.conf
ldconfig
cp $target_root/mysql/support-files/my-default.cnf /etc/my.cnf
cp support-files/mysql.server  /etc/rc.d/init.d/mysqld

#-----------php install-----------
yum install -y -q gmp gmp-devel freetype freetype-devel libpng libpng-devel libxpm libxpm-devel libjpeg libjpeg-devel libxml2 libxml2-devel curl curl-devel libicu libicu-devel openldap openldap-devel libXpm libXpm-devel libc-client-devel
cd $build_root
rm -rf php-$php_version
echo 'Uncmpressing php...'
tar xf php-$php_version.tar.bz2
cd php-$php_version
./configure --prefix=$target_root/php --with-config-file-scan-dir=/etc/php.d --with-config-file-path=/etc --disable-debug --with-pic --disable-rpath --with-pear --with-bz2 --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-curl --with-openssl --with-pcre-regex --with-zlib --with-layout=GNU --enable-exif --enable-ftp --enable-magic-quotes --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-kerberos --enable-ucd-snmp-hack --enable-shmop --enable-calendar --without-sqlite --enable-xml --enable-fpm --with-gd --disable-dom --disable-dba --without-unixODBC --disable-xmlreader --disable-xmlwriter --with-sqlite3 --disable-phar --disable-fileinfo --enable-json --disable-wddx --without-curl --disable-posix --disable-sysvmsg --disable-sysvshm --disable-sysvsem --disable-ipv6 --enable-dba --enable-intl --with-ldap --enable-mbstring --enable-soap --with-xmlrpc --with-mysql=$target_root/mysql --with-freetype-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr --with-jpeg-dir=/usr --with-pcre-regex=/usr --with-libxml-dir=/usr --with-imap --with-imap-ssl
make -j $cpu_number
make install

cp -v php.ini-production /etc/php.ini
cp -v sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm

if [ ! -d /etc/php.d ]
then
	mkdir -pv /etc/php.d
fi
cp -v $target_root/php/etc/pear.conf /etc/php.d/
cp -v $target_root/php/etc/php-fpm.conf.default $target_root/php/etc/php-fpm.conf

#-----setup bash------------------
cat > /etc/profile.d/lnmp.sh <<EOF
LNMP=$target_root
PATH=\$LNMP/nginx/sbin:\$LNMP/mysql/bin:\$LNMP/php/bin:\$PATH
export LNMP PATH
EOF
chmod 755 /etc/profile.d/lnmp.sh
. /etc/profile.d/lnmp.sh


#------install php plugins--------
pecl channel-update pecl.php.net

#install imagemagick
yum install -y -q ImageMagick ImageMagick-devel 
pecl install imagick
echo "extension=imagick.so" > /etc/php.d/imagick.ini

#------build params---------------
echo 'build success'
nginx -V
php -i | grep configure

#-----auto boot-------------------
echo 'setup centos servces'
chkconfig --add mysqld
chkconfig mysqld on
chkconfig --add php-fpm
chkconfig php-fpm on

cat > /etc/init.d/nginx <<EOF
#!/bin/sh
# chkconfig: - 85 15
# description: nginx is a World Wide Web server.

. /etc/rc.d/init.d/functions
. /etc/sysconfig/network

[ "\$NETWORKING" = "no" ] && exit 0


nginx="/opt/lnmp/nginx/sbin/nginx"
temp_dir="/var/lib/nginx"

if [ ! -d \$temp_dir ]
then
	mkdir -pv \$temp_dir
fi

start() {
	\$nginx
}

stop() {
	\$nginx -s quit
}

restart() {
	stop
	sleep 1
	start
}

case "\$1" in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		restart
	;;	
	reload)
		\$nginx -s reload
	;;
	*)
		echo \$"Usage: \$0 {start|stop|restart|reload}"
esac


EOF
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on

#--------done---------------------
date >> $target_root/version
echo "Please RE-LOGIN to make bash env active"
echo "You can run 'service mysqld|nginx|php-fpm start|stop|restart' to manage lnmp services."
echo "Enjoy it, if have any question, please issue at https://github.com/chonglou/notes!"
