常用命令
---

### 关掉蜂鸣声
    xset b off


### 检查是否为ssd硬盘
    sudo smartctl -a /dev/sdb

OR

    cat /sys/block/sda/queue/rotational # You should get 1 for hard disks and 0 for a SSD


### 查看硬件信息

    lshw


