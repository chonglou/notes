graylog2笔记
-----------------
## graylog2-server安装
### 解压缩包
    tar xf graylog2-server-0.20.1.tgz
    cp graylog2.conf.example /etc/graylog2.conf

### 配置 /etc/graylog2.conf
    password_secret # pwgen -s 96
    root_password_sha2 #echo -n yourpassword | shasum -a 256

#### 如果只有一台elasticsearch
    elasticsearch_shards=1
    elasticsearch_replicas=0

#### 关闭发现模式：
    # Disable multicast
    elasticsearch_discovery_zen_ping_multicast_enabled = false
    # List of ElasticSearch nodes to connect to
    elasticsearch_discovery_zen_ping_unicast_hosts = es-node-1.example.org:9300,es-node-2.example.org:9300

#### node设置
touch /etc/graylog2-server-node-id
chown yourname /etc/graylog2-server-node-id


### 安装jdk和mongodb
    apt-get install openjdk-7-jre mongodb

### elasticsearch(注意版本要一致 否则会抱classnotfoundexception)
#### 安装
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.10.deb
    dpkg -i elasticsearch-0.90.10.deb

#### 文件打开数设置(至少：64000) vim /etc/security/limits.conf
    * soft nofile 65000
    * hard nofile 65000

#### vi /etc/elasticsearch/elasticsearch.yml
修改cluster.name与graylog2.conf中elasticsearch_cluster_name一致

#### 检查：
    curl -XGET 'http://localhost:9200/_cluster/health?pretty=true' 

### 启动
    java -jar graylog2-server.jar --debug #调试模式
    ./bin/graylog2ctl start #后台模式


## graylog2 web interface 
### 安装
    tar xf graylog2-web-interface-0.20.1.tgz
    cd graylog2-web-interface-0.20.1
### 配置vi conf/graylog2-web-interface.conf
    graylog2-server.uris="http://127.0.0.1:12900/
    application.secret="" # pwgen -s 96

### 启动
    bin/graylog2-web-interface

## 其它
### 设置日志ttl:
    curl -XPUT 'http://localhost:9200/graylog2/'
    curl -XPUT "http://localhost:9200/graylog2/message/_mapping" -d'{"message": {"_ttl" : { "enabled" : true, "default" : "30d" }}}'


