MAC OS笔记
---------------

### 开发环境设置
安装xcode
#### 安装包管理软件：brew
	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

#### 设置环境变量：
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

### 安装gnu终端工具(提供linux风格的ls等)
	brew install coreutils

### 安装其它工具
	brew install binutils
	brew install diffutils
	brew install ed --default-names
	brew install findutils --default-names
	brew install gawk
	brew install gnu-indent --default-names
	brew install gnu-sed --default-names
	brew install gnu-tar --default-names
	brew install gnu-which --default-names
	brew install gnutls --default-names
	brew install grep --default-names
	brew install gzip
	brew install screen
	brew install watch
	brew install wdiff --with-gettext
	brew install wget
	brew install bash
	brew install emacs

	brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
	brew install gpatch
	brew install m4
	brew install make
	brew install nano

	brew install file-formula
	brew install git
	brew install less
	brew install openssh --with-brewed-openssl
	brew install perl518   # must run "brew tap homebrew/versions" first!
	brew install python --with-brewed-openssl
	brew install rsync
	brew install svn
	brew install unzip
	brew install vim --override-system-vi
	brew install macvim --override-system-vim --custom-system-icons



### 快捷键
 * Command-Shift-3: 对整个屏幕截屏，图片会保存的一个文件中（默认保存的桌面上）
 * Command-Ctrl-Shift-3: 对整个屏幕截屏，图片被保存到剪贴板（夹纸板）中。
 * Command-Shift-4: 对选定区域进行截屏，并将图片保存到文件中（默认保存的桌面上）。在触发这个快捷键后，按空格(Space)键，可以对一整个窗口或菜单进行截屏。
 * Command-Ctrl-Shift-4: 对选定区域进行截屏，图片被保存到剪贴板（夹纸板）中。

### 常见问题

#### openssl版本过老
	brew install openssl
	brew link openssl --force
打开新的term窗口后运行
	openssl version

#### 安装老版本的软件包 以bash为例
	cd `brew --prefix`
	brew versions bash #列出所有版本
	git checkout 77993cb Library/Formula/bash.rb # 第一列是bash版本号
	brew install bash

#### "dtrace: failed to compile script probes.d: Preprocessor not found"错误
把dtrace关掉即可
	export CONFIGURE_OPTS='--disable-dtrace'
	rbenv install 2.1.2
或者：
	./configure --diable-dtrace

#### 'brew update'出错
error: Your local changes to the following files would be overwritten by merge: Library/Formula/bash.rb Please, commit your changes or stash them before you can merge. Aborting Error: Failure while executing: git pull -q origin refs/heads/master:refs/remotes/origin/master
解决办法：
	cd `brew --prefix`
	git remote add origin https://github.com/mxcl/homebrew.git
	git fetch origin
	git reset --hard origin/master
