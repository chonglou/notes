passenger笔记

### 安装passenger(gem)
	apt-get install ruby 
	apt-get install build-essential libpcre3-dev libssl-dev zlib1g
	gem install passenger

### 安装passenger(deb)
	apt-get install ruby 
	apt-get install build-essential libpcre3-dev libssl-dev zlib1g
	tar xf passenger-4.0.37.tar.gz
	gem install mizuho
	rake debian:source_packages
	rake debian:binary_packages

### 检查
	passenger-config --root #查看安装路径


