ruby 笔记
-------------

###常见问题

#### "dtrace: failed to compile script probes.d: Preprocessor not found"错误
错误原因： ruby(2.1.0 2.1.1 2.1.2)默认打开了dtrace选项，1.9.3无影响
把dtrace关掉即可

	export CONFIGURE_OPTS='--disable-dtrace'
	rbenv install 2.1.2
或者：

	./configure --diable-dtrace
