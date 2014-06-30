一些有用的小工具
-------------------

#### 查看端口占用
    lsof -i TCP :8080
#### 测试tcp端口是否打开：
	nc -z <host> <port>
#### 根据端口查pid
	lsof -t -i:<port>
