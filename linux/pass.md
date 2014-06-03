pass是一个linux下密码管理工具
--------------------------------

#### 常用命令
 * 初始化密码存储:pass init 1F616EDB #'1F616EDB'是你的GPG key id 通过gpg --gen-key生成
 * 可以通过git管理密码：pass git init
 * 生成密码：pass generate aaa/bbb 12 # 为aaa类下的bbb生成12位随机密码
 * 添加密码：pass insert aaa/bbb 
 * 编辑密码：pass edit aaa/bbb
 * 删除密码：pass rm aaa/bbb
 * 查看密码：pass show -c aaa/bbb #带上-c表示复制到粘贴板 45秒后失效 不带-c直接显示
 * 查看目录：pass

#### 其它
 firefox可以用passff插件
