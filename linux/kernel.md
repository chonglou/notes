编译kernel笔记
-------------------------

### DEBIAN UBUNTU发行版
	apt-get install fakeroot kernel-package libncurses5-dev
	cd linux
	make clean && make mrproper
	make localmodconfig
	make menuconfig
	fakeroot make-kpkg --initrd --revision=`date "+%Y%m%d%H%M%S"` kernel_image
	cd ..
	dpkg -i kernel-image-*.deb

### CENTOS
	yum groupinstall "Development Tools"
	yum install ncurses-devel
	yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
	yum install xz bc
	cd linux
	make clean && make mrproper
	make localmodconfig
	make menuconfig
	make rpm
	cd ~/rpmbuild/RPMS/x86_64
	rpm -ivh kernel-*.rpm

