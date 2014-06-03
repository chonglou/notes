gnupg（非对称加密工具） 笔记
-----------------

 * 创建：gpg --gen-key
 * 查看：gpg --fingerprint your_email # gpg key id是那个八位16进制数
 * 列出所有key：gpg -K

### 自动启动agent（添加到~/.bashrc）：
	eval "$(gpg-agent --daemon)"


 
