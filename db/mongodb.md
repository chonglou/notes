mongodb笔记
----------------

#### 显示所有db: 
    show dbs

#### 当前db：
	db

#### 使用db： 
	use dbname

#### 备份：
	mongodump -h dbhost -d dbname -o dbdirectory

#### 恢复：
	mongorestore -h dbhost -d dbname --directoryperdb dbdirectory

#### 压缩数据库文件
默认mongodb生成的文件太大，如果你的文件不多 可以设置:
	storage.smallFiles = true # 不会修改现存数据库
