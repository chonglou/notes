iptables web服务器 demo
-----------------------
<code>
#!/bin/sh
##
# 防火墙规则demo
# 默认规则
# 1: 允许ping
# 2: 禁止所有udp接入
# 3: 只允许tcp 22 80 443端口接入
# 4: 禁止forward
# 5: 允许所有出口
#
# 根据需要自行添加
##
TCP_PORTS="22 80 443"
alias ff=iptables

ff -F
ff -X
ff -t nat -F
ff -t nat -X
ff -t mangle -F
ff -t mangle -X
ff -t raw -F
ff -t raw -X
ff -t security -F
ff -t security -X

ff -P INPUT DROP
ff -P OUTPUT ACCEPT
ff -P FORWARD DROP
ff -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ff -A INPUT -i lo -j ACCEPT

for p in $TCP_PORTS; do
	ff -A INPUT -p tcp --dport $p -j ACCEPT
done

AICMP="0 3 3/4 4 8 11 12 14 16 18"
for tyicmp in $AICMP; do
	ff -A INPUT -p icmp --icmp-type $tyicmp -j ACCEPT
done
</code>
