MySQL 笔记
----------------

### 从源码编译安装MariaDB 5.5:
	tar xf mardb-*
	cd mardb
	mkdir build
	cmake .. -LH
	cmake .. -DBUILD_CONFIG=mysql\_release -DCMAKE_INSTALL_PREFIX=/opt/mysql 
	make 
	make install


### CENTOS 6 环境
	yum install cmake libaio-devel gperf libdbi boost-devel rpmdevtools rpm-build openssl-devel libevent-devel
	cmake .. -DBUILD_CONFIG=mysql_release -DRPM=centos6
	make package

#### centos6上cmake版本太老 需要升级到2.8:
	cd cmake-2.8.12.2
	./configure --prefix=/opt/cmake
	make
	make install
#### 在.bashrc中添加：
	CMAKE_ROOT=/opt/cmake
	PATH=$CMAKE_ROOT/bin:$PATH
	export CMAKE_ROOT PATH


#### 如果事先未安装libaio-devel,即便安装后仍会报错：
aio is required on Linux, you need to install the required library
需要删除CMakeCache.txt文件 再重新编译


### 第一次启动:
	chown -R mysql /usr/local/mysql/
	scripts/mysql_install_db --user=mysql
	/usr/local/mysql/bin/mysqld_safe --user=mysql &
	mysql_secure_installation # 安全设置

### 常见问题

#### 忘记root密码处理
启动：mysqld_safe --skip-grant-tables &
	mysql -u root mysql
	mysql> UPDATE user SET password=PASSWORD("new password") WHERE user='root';
	mysql> FLUSH PRIVILEGES;

#### 查询数据库大小
	SELECT
	  table_schema AS 'Db Name',
	    Round( Sum( data_length + index_length ) / 1024 / 1024, 3 ) AS 'Db Size (MB)',
		  Round( Sum( data_free ) / 1024 / 1024, 3 ) AS 'Free Space (MB)'
		  FROM information_schema.tables
		  GROUP BY table_schema ;

#### 小内存优化(my.cnf) 不适合生产环境
	[mysqld]
	basedir		= /usr
	datadir		= /var/lib/mysql
	tmpdir		= /tmp
	default-storage-engine = MyISAM
	max_connections = 75
	skip-bdb
	skip-innodb
	skip-networking
	server-id = 1
	key_buffer = 256K
	max_allowed_packet=1M
	thread_stack = 64K
	table_cache = 4
	sort_buffer_size = 64K
	read_buffer_size = 256K
	read_rnd_buffer_size = 256K
	net_buffer_length = 2K
	thread_stack = 64K
	query_cache_limit=256K
	query_cache_size = 2M 

#### 检查参数
	mysqld --verbose --help # 参数列表
	mysqladmin variables # 当前运行信息

#### 常用命令
 * mysqld_safe 用来启动mysql并监控在它意外停机时重新启动
 * mysqld_multi 同一主机管理多个mysql
 * mysqladmin 系统管理任务
 * mysqldump和mysqlhotcopy 备份或者复制到另一数据库
 * mysqlcheck 数据库检查、分析、优化及对受损数据表进行修复

#### 小信息
 * 不建议使用rm删除数据库目录 innodb数据表会在共享表空间中写入信息

#### 压缩传输问题
 * 通常方法
	gzip -c /backup/db.sql > db.sql.gz # server1运行 server1读和写
	scp db.sql.gz user@host:/backup # server1运行 server1读 server2写
	gunzip /backup/db.sql.gz # server2运行 server2读和写
 * 一步到位(gzip -i更快 bzip2压缩率高 lzo解压缩快)
 	gzip -c /backup/db.sql | ssh user@host "gunzip -c - > /backup/db.sql" # server1运行 server1读 server2写

 
