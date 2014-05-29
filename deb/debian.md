debian 笔记
------------------

### 常见问题

#### 默认的EDITOR是nano 巨难用 换成vim：
    update-alternatives --config editor

#### 更改jdk路径
    update-alternatives --config editor

#### 编译virtualbox的模块时报错“make[1]: ngcc：命令未找到” 解决办法：
进入kernel源码目录 make menuconfig
把General setup=》Cross-compiler tool prefix改为空

#### lxde用户需要加入的组：powerdev

#### mercurial版本老报“abort: requirement 'dotencode' not supported!”
	add-apt-repository ppa:tortoisehg-ppa/releases
	add-apt-repository ppa:mercurial-ppa/releases
	apt-get update
	apt-get install mercurial

### 编译kernel
	apt-get install fakeroot kernel-package
	cd your_kernel_dir
	make menuconfig
	make-kpkg clean
	fakeroot make-kpkg --initrd --revision=version.1.0 kernel_image


