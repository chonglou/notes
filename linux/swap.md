linux swap文件设置
-------
### 很多云主机没有提供交换分区功能,可以通过设置swap文件
	dd if=/dev/zero of=/swap.fs bs=1M count=2048 #创建一个2G的文件
	chmod 600 /swap.fs
	mkswap /swap.fs # 格式化
	swapon /swap.fs # 启用

### fstab设置
	/swap.fs 		none 			swap 	defaults 	0 0


