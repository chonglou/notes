esmtp是一款sendmail的轻量级替代品
----------------

### 安装：

	pacman -S esmtp esmtp-mta


### 常见问题
#### sendmail: account default not found: no configuration file available
原因：找不到配置文件

解决办法：

	msmtp -P # 查看配置文件路径
	cp  /usr/share/doc/msmtp/msmtprc-user.example ~/.msmtprc
	chmod 600 ~/.msmtprc

