EXIM4笔记
-------------------------

### 常见问题

#### 日志报Message is frozen
如果过去八天（timeout_frozen_after）邮件仍然投递不出去，会被标记为forzen

#### 检查forzen队列:
    exim -bp | grep frozen | wc -l

#### 移除forzen邮件：
    exim -bpru | grep frozen | awk '{print $3}' |xargs exim -Mrm

#### 确认结果：
    exim -bpc

### 常用工具
    exiwhat #当前状态
    eximstats #根据日志统计信息
    exiqsumm #邮件队列信息
	exim4 -bV #检查配置文件
    exim -bd -d #调试模式启动

发送邮件的域名在/etc/mailname


### Exim邮件队列的全局管理
    exim -bpc 统计队列邮件数量
    exim -bp #查看exim 队列中的所有邮件信息
    exim -bp | exiqsumm #汇总队列邮件信息


### 邮件管理
 * 删除邮件 exim -Mrm message-id [ message-id ... ]
 * 冻结邮件 exim -Mf message-id [ message-id ... ]
 * 解冻邮件 exim -Mt message-id [ message-id ... ]
 * 强制投递邮件 exim -M message-id [ message-id ... ]
 * 强制退回邮件 exim -Mg message-id [ message-id ... ]
 * 查看邮件头 exim -Mvh message-id
 * 查看邮件内容 exim -Mvb message-id
 * 查看邮件日志 exim -Mvl message-id
 * 新增一个收件人 exim -Mar message-id
 * 编辑发件人信息 exim -Mes message-id

### 队列邮件ID查找命令 exiqgrep
 * 查看来自指定发件人的所有队列邮件 exiqgrep -f [发件人]@domain
 * 查看发给指定收件人的所有队列邮件 exiqgrep -r [收件人]@domain
 * 查看1天前的队列邮件 (以秒为单位) exiqgrep -o 86400
 * 查看1小时内的队列邮件 (以秒为单位) exiqgrep -y 3600
 * 查看700到800字节大小的队列邮件 (支持正则表达式) exiqgrep -s '^7..$'
#### 其他常用参数：
 * -z 只查看被冻结的队列邮件
 * -i 只显示邮件ID
 * -c 只显示查找到的邮件数量

### 队列邮件的批量操作

 * 删除所有被冻结的邮件 exiqgrep -z -i | xargs exim –Mrm
 * 删除所有5天前的队列邮件 exiqgrep -o 432000 -i | xargs exim –Mrm
 * 冻结所有来自某一发件人的邮件 exiqgrep -i -f 发件人@zeknet.com | xargs exim -Mf
 * 清空队列 exim -bpru | awk {'print $3'} | xargs exim -Mrm
