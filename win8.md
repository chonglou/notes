###制作windowns8安装U盘
    mount -t udf -o loop,ro,unhide win8.iso /mnt/iso
    fdisk /dev/sdb
    1：删除所有分区
    2：创建一个新的分区
    3：设置boot标志
    4：设置分区类型为(HPFS/NTFS/ExFAT)
    mkfs.vfat /dev/sdb1
    mount /dev/sdb1 /mnt/usb
    cp -rv /mnt/iso/* /mnt/usb
    sync
    umount /mnt/iso
    umount /mnt/usb
    
### 输入激活码
    Win+x+a # 打开cmd窗口
    slmgr/upk # 删除当前激活码

打开控制面板 输入新的激活码


### 连接上无线路由器之后，过一阵子就会受限，断开重新连接，过了一阵子又受限。
    在桌面右键单击网络，选择属性
    在网络共享中心选择你已连接的wifi
    在网络连接框中选择无线属性按钮
    在无线属性页面选择安全选项卡
    在安全选项页面，点击下方的高级设置按钮
    在高级设置页面，将为此网络启用联邦信息标准。。。。勾选，然后点击确定按钮

 * 参照[http://jingyan.baidu.com/article/39810a23e52b83b636fda601.html]
