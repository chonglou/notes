deb包制作(以nginx为例)
-------------------------------

### 工具安装
    apt-get install dh-make

### 编译
    wget nginx-1.4.6.tar.gz
    tar xf nginx-1.4.6.tar.gz
    cd nginx-1.4.6
    dh_make -s -e your-email -f ../nginx-1.4.6.tar.gz
    dpkg-buildpackage -rfakeroot

#### 查看结果
    dpkg -x nginx_1.4.6-1_amd64.deb . #解压缩

### 定制
 * 编辑debian/control debian/rules debian/changelog文件
 * 如果需要覆盖默认的configure,增加make任务:
    override_dh_auto_configure
 * 修改源码之后 需要dpkg-source --commit提交补丁


### 文件安装说明
 * debian/package.upstart => etc/init/package.conf 
 * debian/package.init => etc/init.d/package
 * debian/package.default => etc/default/package
 * 其它文件放:debian/package.install 源路径（文件）和目的地（目录）都用相对路径
