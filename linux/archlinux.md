制作archlinux镜像
--------------------------

## 说明
### 启动tftpd：
    systemctl start tftpd.socket tftpd.service
### 文件放：/srv/tftp


### Arch Linux

#### 创建镜像(8G):
    dd if=/dev/zero of=arch.img bs=4M count=2048

#### 分区：
fisk 
o n p a

#### 挂载:
	losetup -f --show arch.img
	kpartx -a /dev/loop0
	mkfs.ext4 /dev/mapper/loop0p1
	mount /dev/mapper/loop0p1 /mnt/arch

#### 安装：
	pacstrap /mnt/arch base

#### fstab：
	UUID=$(blkid -s UUID -o value /dev/mapper/loop0p1)
	echo "UUID=$UUID   /   ext4   defaults   0   1" >> /mnt/arch/etc/fstab

#### 引导:
	extlinux --install /mnt/arch/boot
	dd if=/usr/lib/syslinux/bios/mbr.bin conv=notrunc bs=440 count=1 of=/dev/loop0

#### vi /mnt/arch/boot/extlinux.conf:
	DEFAULT archlinux
	LABEL   archlinux
	SAY     Booting Arch Linux
	LINUX   /boot/vmlinuz-linux
	APPEND  root=/dev/disk/by-uuid/$UUID ro
	INITRD  /boot/initramfs-linux.img


#### 退出：
	umount /mnt/arch
	kpartx -d /dev/loop0
	losetup -d /dev/loop0

#### 设置locale 时区
#### 设置bashrc
#### 设置ssh无密码登录
#### 禁用ipv6
#### 设置iptables清空规则脚本
#### 设置noatimes

#### 依赖的软件包：
 * net-tools dnsutils bind iptables dhcp sysstat tree bash-completion openssh ntp screen acpi acpid


#### 开机启动服务：
 * netctl wan lan
 * dhcp bind9 iptables acpid


#### chroot:
    arch-chroot /mnt/arch /bin/bash


#### /tmp分区禁用tmpfs
    systemctl mask tmp.mount



### 其它

#### 包迁移
	pacman -Qe | awk '{print $1}' > package_list.txt # 列出所有安装的包
	pacman -S `cat package_list.txt` # 安装包
