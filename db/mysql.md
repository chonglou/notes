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

#### 备份与恢复
	mysqldump -u 用户名 -p 数据库名 > 文件名
	mysql -u 用户名 -p 数据库名 < 文件名
	# 带压缩 
	mysqldump -u 用户名 -p 数据库名 | gzip > 文件名
	gunzip < 文件名 | mysql -u 用户名 -p 数据库名

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

### 小信息
 * cpu居高不下 一般都是索引问题
 * 不建议使用rm删除数据库目录 innodb数据表会在共享表空间中写入信息
 * 如果join表数N小于等于7，则optimizer_search_depth=N+1，否则选N
 * 内存要占到数据的15-25%的比例 热数据需要数据库的80%大小
 * MySQL每个query只能运行在一个CPU上
 * 使用新的内存分配算法jemalloc 或 tcmalloc
 * raid卡cache：使用带电的Raid，启用WriteBack，　对于加速redo log ,binary log, data file都有好处
 * 连接超过200的场景使用thread pool
 * 60-80%的内存分给innodb_buffer_pool_size 超80%会用到swap
 * redo log 一般一个小时的量即可

#### 磁盘io
 * innodb_io_capactiy 在sas 15000转的下配置800就可以了，在ssd下面配置2000以上。
 * 在MySQL 5.6:
	innodb_lru_scan\_depth =  innodb_io\_capacity / innodb_buffer_pool_instances
	innodb_io_capacity\_max  =  min(2000, 2 * innodb\_io_capacity)

#### 并发设置
	innodb_thread_concurrency = 0 #使用thread pool
	innodb_thread_concurrency =16 – 32 # 5.5
	innodb_thread_concurrency =36 # 5.6

#### log刷新机制
	innodb_flush_log_at_trx_commit  = 1 // 最安全
	innodb_flush_log_at_trx_commit  = 2 // 　较好性能
	innodb_flush_log_at_trx_commit  = 0 // 　最好的情能
	binlog\_sync = 1  // 需要group commit支持，如果没这个功能可以考虑0来获得较佳性能。
	innodb_flush\_method = O\_DIRECT # 数据文件
#### 系统限制更改
	ulimit -n # 更改文件句柄
	ulimit -u # 进程数限制
	numctl –interleave=all # 禁掉NUMA
#### 合适的io调度
	echo dealine >/sys/block/{DEV-NAME}/queue/scheduler #默认是noop
#### 优化文件系统
	(rw, noatime,nodiratime,nobarrier) # xfs参数
	(rw,noatime,nodiratime,nobarrier,data=ordered) # ext4参数
#### SSD或固态硬盘
	innodb_page_size = 4K
	Innodb_flush_neighbors = 0


#### 压缩传输问题
 * 通常方法
	gzip -c /backup/db.sql \> db.sql.gz # server1运行 server1读和写
	scp db.sql.gz user@host:/backup # server1运行 server1读 server2写
	gunzip /backup/db.sql.gz # server2运行 server2读和写
 * 一步到位(gzip -i更快 bzip2压缩率高 lzo解压缩快)
 	gzip -c /backup/db.sql | ssh user@host "gunzip -c - > /backup/db.sql" # server1运行 server1读 server2写

 
