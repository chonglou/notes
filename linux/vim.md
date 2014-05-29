vim编辑器设置
---------------------------
## markdown语法加亮
### 安装
	wget https://github.com/plasticboy/vim-markdown/archive/master.tar.gz
	tar master.tar.gz
	cd vim-markdown-master
	cp -r ftdetect syntax ~/.vim/
### 设置(.vimrc中增加)
	au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
