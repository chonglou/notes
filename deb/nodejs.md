nodejs在debian下安装
-------------------
### 从源码编译安装
	apt-get install python g++ make checkinstall fakeroot
	src=$(mktemp -d) && cd $src
	wget -N http://nodejs.org/dist/node-latest.tar.gz
	tar xzvf node-latest.tar.gz && cd node-v*
	./configure
	fakeroot checkinstall -y --install=no --pkgversion $(echo $(pwd) | sed -n -re's/.+node-v(.+)$/\1/p') make -j$(($(nproc)+1)) install
	dpkg -i node_*
