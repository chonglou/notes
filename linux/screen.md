一、最便捷的方法
        1、按下印屏幕键，截取整个桌面；
        2、按下Alt+屏幕键，截取当前窗口；
二、命令行截屏
        1、import screenshot.jpg（你将可以使用鼠标选取一个矩形框。在你放下鼠标左键的那一刻，一个该矩形框的截屏会以import后面
        跟的文件名保存在当前目录下。
        2、scrot -d 4 screenshot.png（对你整个桌面截屏，从执行命令到截下屏幕，中间间隔4秒）
              scrot -c -d 4 screenshot.png（来显示出倒计时数）
              scrot -q 80 -c -d 4 screenshot.jpg（以80%质量保存jpg文件）
              scrot ‘%Y-%m-%d_$wx$h.png’ -e ‘mv $f ~/Desktop/Pictures/’ Linuxren.net（产生一个名为“2010-11-28_2560×1024.png”的图
        像文件，并将它移动至桌面上一个名叫Pictures的文件夹里面）
三、截屏软件：gimp
