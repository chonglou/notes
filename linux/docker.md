docket笔记
-----------------

### 安装
#### Archlinux
	pacman -S docker lxc
#### MacOS
下载Docker for OSX Installer: https://github.com/boot2docker/osx-installer/releases
安装后运行：
	boot2docker init
	boot2docker start
	export DOCKER_HOST=tcp://:2375

### 常用命令
	docker run ubuntu echo hello world # 测试
	docker run -t -i ubuntu /bin/bash # 进入系统
	docker ps # 列出实例
	docker stop NAME # 停止实例
	docker log NAME # 查看日志
	docker version # 产看版本信息
	docker images # 列出镜像
	docker pull centos # 下载centos镜像

### 制作镜像(以zsh为例)
	docker run -t -i ubuntu /bin/bash
	hostname # 即为id
	apt-get install zsh
	docker commit -m 'zsh'(YOUR COMMIT) -a='test'(YOUR NAME) 7a34117da04a(HOST_ID) ubuntu/zsh:v1(VERSION) # 提交变更
