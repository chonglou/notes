Gentoo
---

## 常用命令
```
ntpd -q -g # 更新时间
emerge --sync # 更新Portage ebuild 数据库
eselect news list 
eselect news read
man news.eselect
eselect profile list
dispatch-conf # upgrade config files
```

### network
```
cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
```
 * Update the /etc/conf.d/net file with the correct interface name (like enp3s0 instead of eth0).
 * Create new symbolic link (like /etc/init.d/net.enp3s0).
 * Remove the old symbolic link (rm /etc/init.d/net.eth0).
 * Add the new one to the default runlevel.
 * Remove the old one using rc-update del net.eth0 default.

## Build kernel
```
cd /usr/src/linux
make menuconfig
make && make modules_install
make install
genkernel --install initramfs
```

