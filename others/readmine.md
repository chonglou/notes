redmine是一款不错的项目管理软件
===============

#### 下载之后解压缩 进入目录复制database.yml.example文件为database.yml,并编辑数据库设置（默认是mysql，我这里用的是sqlite3）： 

<pre><code>
production:
  adapter: sqlite3
  database: db/redmine.db
</code></pre>

####安装bundler工具，并设置PATH 

	export GEM_HOME=$HOME/.gems
	export $PATH=$GEM_HOME/1.9.1/bin:$PATH
	gem install bundler

#### 安装依赖的库 

	bundle install --without development test

#### 创建session密钥 

	rake generate_secret_token

#### 初始化数据库结构 

	RAILS_ENV=production rake db:migrate

#### 插入默认数据（会提示语言选项） 

	RAILS_ENV=production rake redmine:load_default_data

#### 启动： 

	ruby script/rails server webrick -e production
