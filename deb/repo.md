搭建debian/ubuntu源
--------------------

### 需要的软件包
    apt-get install reprepro nginx rng-tools dpkg-sig
### 创建目录
    mkdir -p /srv/reprepro/ubuntu/{conf,dists,incoming,indices,logs,pool,project,tmp}

### 编辑/srv/reprepro/ubuntu/conf/distributions:
    Origin: Your Name
    Label: Your repository name
    Codename: brahma
    Architectures: i386 amd64 source
    Components: main
    Description: Description of repository you are creating
    SignWith: YOUR-KEY-ID

### 编辑/srv/reprepro/ubuntu/conf/options
    verbose
    basedir .
    ask-passphrase

### KEY管理
#### 生成key：
    gpg --gen-key
    gpg --armor --output whatever.gpg.key --export <key-id>

##### 如果报“Not enough random bytes available.  Please do some other work to give the OS a chance to collect more entropy!”错误，运行
    rngd -r /dev/urandom

#### 列出key:
    gpg --list-keys


#### 对deb包进行签名:
    dpkg-sig -k keyid --sign builder your_packages_<version>_<architecture>.deb



==============nginx配置文件=========================
    server {
  		listen 80;
  		server_name packages.internal;

  		access_log /var/log/nginx/packages-access.log;
	  	error_log /var/log/nginx/packages-error.log;

  		location / {
    		root /srv/reprepro;
    		index index.html;
  		}

  		location ~ /(.*)/conf {
    		deny all;
  		}

  		location ~ /(.*)/db {
    		deny all;
  		}
    }

### 客户端设置
    wget -O - http://www.domain.com/repos/apt/conf/<whatever>.gpg.key|apt-key add -
然后就可以添加源到sources.list了

### 常见错误
 * “WARNING: The following packages cannot be authenticated!”错误, 原因：包需要签名

	
