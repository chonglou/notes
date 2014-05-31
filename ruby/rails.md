rails笔记
-----------------
#### 安装
	gem install rails
	apt-get install libsqlite3-dev
	rails --version

#### 新建项目
	rails new myapp

#### 生成文档
	apt-get install nodejs
	rake doc:rails

#### 启动：
	rails server

#### 创建控制器
	rails generate controller Demo hello bye

### 模板
	<%= link_to "label", url_path %>
	<% for %>
		<%= %>
	<% end %>
#### layout位置
	app/views/layouts/application.html.erb
#### 其它
 * cycle 自动切换
 * truncate 80 显示前80个字符 
 * strip_tags 去除字符中的html标签
 * link_to :confirm=>确认弹窗 :method=> :delete
 * 局部模板 前缀加_
 * 分页 will_paginate插件

#### 不创建helpper test框架等
	rails generate controller aaa/ddd index --no-test-framework --no-helper --no-assets

#### 脚手架
	rails generate scaffold Product title:string, description:text
	vi db/migrate/2014....rb
	rake db:migrate
	vi db/seeds.rb
	rake db:seed

#### 其它
 * 数据验证放model层
 * validates :title, :description, :persence=>true 验证不能为空
 * :uniqueness=>true 唯一
:format=>{
:with => %r{\.(git|jpg|png)$}i,
:message =''
}
:greater_than_or_equal_to => 0.01

default_scope :order=>'title'


#### flash用于存储会话数据
	logger.error
	redirect_to store_url, :notice=>"aaa"


#### product_path vs product_url
后者包含协议和域名的完整信息，302需要

### mailer
	config.action_mailer.delivery_method = :smtp | :sendmail | :test
	
	rails generate mailer Notifier o1 o2



### 错误处理
#### Could not find a JavaScript runtime. See https://github.com/sstephenson/execjs for a list of available runtimes.
安装nodejs 或 Gemfile中增加: gem 'therubyracer'

### bin/rails:6: warning: already initialized constant APP_PATH
Exiting
bin/rails:6: warning: already initialized constant APP_PATH
/data/github/chonglou/portal/bin/rails:6: warning: previous definition of APP_PATH was here
Error: Command 'puma' not recognized
Usage: rails COMMAND [ARGS]

    rake rails:update:bin 


