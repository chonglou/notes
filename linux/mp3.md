LINUX下CD转MP3
--------------------
### 安装软件：
    
    sudo pacman -S abcde lame

### 设置

    cp /etc/abcde.conf ~/.abcde.conf
    vi ~/.abcde.conf
    LAME=lame
    CDROM=/dev/cdrom
    OUTPUTDIR=~/music/


