ssh相关笔记
------------------

### SSH端口转发

	ssh -qTfnN -p 22 -D 7070 username@hostname

### 无密码登陆
 * 创建公钥

	ssh-keygen -t rsa #本地

 * 复制公钥到服务器上

	scp id_rsa.pub user@hostname:/tmp #本地
	cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys #服务器

 * 测试

	ssh user@hostname #如果登陆失败 检查.ssh(0700) authorized_keys(400)权限

 * ubuntu下启用root登陆(/etc/ssh/sshd.conf)

	PermitRootLogin yes

 * 禁用ssh登录提示信息

	touch ~/.hushlogin
