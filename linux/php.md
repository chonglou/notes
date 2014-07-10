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

### Centos下nginx+php+mysql 一键安装脚本(yum版本)
https://github.com/chonglou/notes/blob/master/linux/lnmp_yum.sh

### Centos下nginx+php+mysql一键编译安装脚本(自动下载源码并编译安装)
下载地址：https://github.com/chonglou/notes/blob/master/linux/lnmp_build.sh

### PHP网站一键部署脚本
下载地址：https://github.com/chonglou/notes/blob/master/linux/php_deploy.sh


