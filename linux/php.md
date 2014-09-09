Centos下nginx+php设置
------------

### nginx配置文件中增加
    location ~ \.php$ {
        root   /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
	fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

### 常见错误

#### Centos 6.5下无php-mcrypt包解决办法

	wget https://downloads.php.net/johannes/php-5.3.3.tar.bz2
	tar xf php-5.3.3.tar.bz2
	cd php-5.3.3/ext/mcrypt
	phpize
	./configure
	make
	make test
	make install

mcrypt.so现在会安装在 /usr/lib64/php/modules/然后在php.ini中启用:

	extension=mcrypt.so


#### Unable to open primary script
原因 php没有操作权限 解决办法 在php.ini的open_basedir中增加路径

#### 调试模式（修改php.ini）
	display_errors = On
	error_reporting = E_ALL | E_STRICT


### Centos下nginx+php+mysql 一键安装脚本(yum版本)
https://github.com/chonglou/notes/blob/master/linux/lnmp_yum.sh

### Centos下nginx+php+mysql一键编译安装脚本(自动下载源码并编译安装)
下载地址：https://github.com/chonglou/notes/blob/master/linux/lnmp_build.sh

### PHP网站一键部署脚本
下载地址：https://github.com/chonglou/notes/blob/master/linux/php_deploy.sh
用法：
 * 上传到服务器上执行
 * 本地 ssh user@host < php_deploy.sh


