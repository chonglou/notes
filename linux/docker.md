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
	docker run -e HOME=/root -w /root -t -i ubuntu /bin/bash # 进入系统
	docker ps # 列出实例
	docker stop NAME # 停止实例
	docker log NAME # 查看日志
	docker version # 产看版本信息
	docker images # 列出镜像
	docker pull centos # 下载centos镜像
	docker save IMAGENAME | bzip2 -9 -c>img.tar.bz2 # 导出镜像
	bzip2 -d -c <img.tar.bz2 | docker load # 导入镜像

### 制作镜像(以zsh为例)
	docker run -t -i ubuntu /bin/bash
	hostname # 即为id
	apt-get install zsh
	docker commit -m 'zsh'(YOUR COMMIT) -a='test'(YOUR NAME) 7a34117da04a(HOST_ID) ubuntu/zsh:v1(VERSION) # 提交变更

### 封装镜像(用Dockerfile)
	docker build -t img_test . # 制作镜像
	docker run -d -P --name port\_test img_test # 端口映射
	docker port port_test 22 # 查看端口
	docker stop port_test # 停止
	docker rm port_test # 删除快照
	docker rmi img_test # 删除镜像

### 常见问题
#### 使用arch镜像
	docker pull base/arch
#### mac下ssh 会有问题 需要端口映射(2222是你的端口)
	VBoxManage modifyvm "boot2docker-vm" --natpf1 "RULE_NAME,tcp,,2222,,2222" #mac下需要先关闭boot2docker

### archlinux docker file(ssh和zsh)
 * 创建：docker build --rm -t zsh .
 * 启动：docker run -p 2222:22 -d -P --name zsh_t zsh
 * 登录：ssh -p 2222 root@localhost

	FROM base/arch
	MAINTAINER Jitang Zheng jitang.zheng@gmail.com

	RUN pacman -Syu --noconfirm --ignore filesystem
	RUN pacman -S --noconfirm --needed zsh git curl net-tools tree vim openssh base-devel dnsutils

	RUN pacman -R vi --noconfirm

	RUN locale-gen en_US en_US.UTF-8

	RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
	RUN cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc
	RUN chsh -s /bin/zsh

	RUN /usr/bin/ssh-keygen -A
	RUN sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
	RUN echo 'root:123456' | chpasswd
	RUN cp /usr/share/vim/vim74/vimrc_example.vim /root/.vimrc

	EXPOSE 22
	CMD    ["/usr/sbin/sshd", "-D"]




