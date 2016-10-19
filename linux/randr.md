Linux分辨率设置
---

* 查看分辨率
```
$ xrandr
creen 0: minimum 320 x 200, current 1024 x 768, maximum 16384 x 16384
HDMI-0 disconnected primary (normal left inverted right x axis y axis)
DVI-0 connected 1024x768+0+0 (normal left inverted right x axis y axis) 473mm x 296mm
   1680x1050     59.88 +
   1280x1024     75.02    60.02  
   1152x864      75.00  
   1024x768      75.03*   60.00  
   800x600       75.00    60.32  
   640x480       75.00    59.94  
   720x400       70.08  
VGA-0 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x768      60.00* 
   800x600       60.32    56.25  
   848x480       60.00  
   640x480       59.94
```

* 设置分辨率
```
xrandr --output DVI-0 --mode 1680x1050
```
