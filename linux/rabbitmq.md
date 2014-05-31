rabbitmq笔记
--------------

### 持久化
需要队列（durable = true）和消息（delivery_mode = 2）

### 公平分发
channel.basic_qos(prefetch_count=1)

### 队列
	result = channel.queue_declare(exclusive=True) #临时队列 退出时删除
	channel.queue_bind(exchange='logs', queue=result.method.queue) #绑定到交换器


### 交换器
消息不会直接发送给队列，由交换器进行中转，类型有
 * direct 转发消息到routigKey指定的队列
 * topic 按规则转发消息（最灵活）
 * headers
 * fanout 转发消息到所有绑定队列

### 常用命令
 	rabbitmqctl list_bindings # 列出存在的绑定
 	rabbitmqctl list_exchanges # 列出所有交换器
	rabbitmqctl list_queues # 查看消息队列
	rabbitmqctl list_queues name messages_ready messages_unacknowledged # 检查无ack的消息
