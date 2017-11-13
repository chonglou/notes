imagemagick笔记
--------------

### Linux下的imagemagick包是处理图片常用工具

#### 安装
    pacman -S imagemagick

#### 转图片格式
    convert 旧文件 新文件

#### 压缩/变更大小
    convert -resize 宽度x高度 旧文件 新文件 # 等比
    convert -resize 宽度x高度! 旧文件 新文件 # 固定宽高
		convert orig.png -resize 200x200 -gravity center -extent 200x200 dest.png # 缩放并填充

#### 裁减图片
    convert old.jpg -crop 687x856+51+43 new.jpg

#### 查看图片信息
    identify new.jpg



#### 限定大小
    convert -resize 800x800 -quality 50 1405407568-633.jpg 800.jpg
    find ./ -regex '.*\(jpg\|JPG\|png\|jpeg\)' -size +500k -exec convert -resize 50%x50% {} {} \;


