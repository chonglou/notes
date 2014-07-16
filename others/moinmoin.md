moinmoin是一块基于python开发的非常好用的wiki网站系统
==============================
### 安装
安装到 /opt/www/moin目录下
#### 系统依赖

	apt-get install python2.7 virtualenv uwsgi uwsgi-plugin-python

#### 创建python安全沙盒

	mkdir -p /opt/www/moin
	virtualenv /opt/www/moin/python2
	source /opt/www/moin/python2/bin/activate

#### 安装moin

	cd /tmp
	wget http://static.moinmo.in/files/moin-1.9.7.tar.gz
	tar zxvf moin-1.9.7.tar.gz
	cd moin-1.9.7
	python setup.py install
	deactivate # 清除python环境变量
	cp -r ./wiki /opt/www/moin/ # 复制静态资源文件

	# 复制配置文件
	cd /opt/www/moin/wiki/
	cp config/wikiconfig.py ./
	cp server/moin.wsgi ./

### wsgi配置(vi /opt/www/moin/wiki/moin.wsgi)

	sys.path.insert(0, '/opt/www/moin/python2/lib/python2.7/site-packages/')
	sys.path.insert(0, '/opt/www/moin/wiki/')

	#设置文件权限
	chown www-data:www-data -R /opt/www/moin
	chmod o-rwx -R /opt/www/moin

### uwsgi配置(vi /opt/www/moin/wiki/uwsgi.xml)
<pre><code>
<uwsgi>
    <uid>www-data</uid>
    <gid>www-data</gid>
    <plugin>python</plugin>
    <socket>/opt/www/moin/moin.sock</socket>
    <wsgi-file>/opt/www/moin/wiki/moin.wsgi</wsgi-file>
    <limit-as>256</limit-as>
    <processes>8</processes>
    <logto>/var/log/uwsgi/uwsgi.log</logto>
    <memory-report/>
    <vhost/>
    <no-site/>
</uwsgi>
</code></pre>

#### 启动

	exec uwsgi -x /opt/www/moin/wiki/uwsgi.xml &

### nginx配置

<pre><code>
server {
    server_name 你的域名;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location ^~ /moin_static193/ {
            alias /opt/www/moin/python2/lib/python2.7/site-packages/MoinMoin/web/static/htdocs/;
            add_header Cache-Control public;
            expires 1M;
    }

    location / {
        include uwsgi_params;
        uwsgi_pass unix:///opt/www/moin/moin.sock;
        uwsgi_modifier1 30;
    }
}
</code></pre>

### 编辑技巧

* 显示目录

	<<TableOfContents(3)>>

* 图片内嵌展示

	{{attachment:graphics.png}}

* robots.txt和favicon.ico

nginx配置文件中增加(文件放/opt/www/moin/wiki/htdocs下)
<pre><code>

    location ^~ /robots.txt {
            alias /opt/www/moin/wiki/htdocs/robots.txt;
    }
    location ^~ /favicon.ico {
            alias /opt/www/moin/wiki/htdocs/favicon.ico;
    }
</code></pre>

* 显示章节号 配置文件中增加

	show_section_numbers = 1

* 包含页面

	<<Include(SomePage)>>

* 编辑中隐藏

	#acl All: 

* 允许公开评论的页面

	#acl All:read,write 

* Google 网站验证 修改wikiconfig.py文件，添加

	html_head = '<meta name="google-site-verification" content="替换成你的" />'

* sitemap.xml

Sitemap 可方便网站管理员通知搜索引擎他们网站上有哪些可供抓取的网页。Moin对此的支持是非常简单的，只需要在任何页面链接（最好是主页）之后加上?action=sitemap即可

* 扩展模板 修改配置文件

	page_header1=u''
	page_header2=u''
	page_footer1=u''
	page_footer2=u''
