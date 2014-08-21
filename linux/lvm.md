lvm笔记
=====================

### 常用命令

	pvcreate /dev/sda2 # 创建物理卷
	pvdisplay # 查看物理卷
	vgcreate myhost /dev/sda2 # 创建myhost逻辑卷
	vgextend myhost /dev/sdb # 扩展myhost逻辑卷
	vgdisplay # 查看逻辑卷
	lvcreate -L 20G myhost -n home # 创建分区myhost-home 大小20G
	lvcreate -l +100%FREE myhost -n var # 剩下分区给myhost-var
	lvdisplay # 查看分区
	mkfs.ext4 /dev/mapper/myhost-var # 格式化分区myhost-var


### 启用分区

	modprobe dm-mod # 加载dm模块
	vgscan # 扫描逻辑卷
	vgchange -ay # 启用所有逻辑卷

### 扩展分区

	lvextend -L +20G myhost/var # 给myhost-var增加20G	
	lvextend -l +100%FREE myhost/var # 剩下空去全部给myhost-var
	resize2fs /dev/myhost/var # 重新设置myhost-var大小 ext2/ext3/ext4格式 不能挂载
	xfs_growfs /var # 重新设置myhost-var大小 xfs格式 需要先挂载 resize后然后重新挂载

