rbenv可以管理多版本的ruby
--------------------------

### 安装
	apt-get install libssl-dev
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

### add to .bashrc:
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"

### check:
	type rbenv

### list all can install version:
	rbenv install -l

### 安装 ruby:
	rbenv install 2.1.2

### reload:
	rbenv rehash

### set local version:
	rbenv local 2.1.0

### set global version:
	rbenv global 2.1.0

### list all available version:
	rbenv versions

### 更新:
	cd ~/.rbenv 
	git pull
	cd  ~/.rbenv/plugins/ruby-build
	git pull


