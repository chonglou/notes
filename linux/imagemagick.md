imagemagick笔记
--------------

### Linux下的imagemagick包是处理图片常用工具

#### 安装
    pacman -S imagemagick

#### 转图片格式
    convert 旧文件 新文件

#### 压缩/变更大小
    convert -resize 宽度x高度 旧文件 新文件
