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
    

