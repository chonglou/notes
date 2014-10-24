apt-get install openvpn

### KEY制作

	cp -R /usr/share/doc/openvpn/examples/easy-rsa/ /etc/openvpn
	cd /etc/openvpn/easy-rsa/2.0/
	ln -s openssl-1.0.0.cnf openssl.cnf
	. /etc/openvpn/easy-rsa/2.0/vars
	. /etc/openvpn/easy-rsa/2.0/clean-all
	. /etc/openvpn/easy-rsa/2.0/build-ca
	. /etc/openvpn/easy-rsa/2.0/build-key-server server
	. /etc/openvpn/easy-rsa/2.0/build-key client1

	. /etc/openvpn/easy-rsa/2.0/build-dh

### CLIENT
	cd /etc/openvpn/easy-rsa/2.0/keys
	scp ca.crt client1.crt client1.key your_path

### 撤回
	. /etc/openvpn/easy-rsa/2.0/vars
	. /etc/openvpn/easy-rsa/2.0/revoke-full client1

### SERVER
	cd /etc/openvpn/easy-rsa/2.0/keys
	cp ca.crt ca.key dh1024.pem server.crt server.key /etc/openvpn

### 配置文件
	cd /usr/share/doc/openvpn/examples/sample-config-files
	gunzip -d server.conf.gz
	cp server.conf /etc/openvpn/
	cp client.conf ~/

### vi ~/client.conf
	remote example.com 1194
	ca ca.crt
	cert client1.crt
	key client1.key

### vi /etc/openvpn/server.conf

	push "redirect-gateway def1 bypass-dhcp"
	push "dhcp-option DNS 10.8.0.1" #需要自建dns服务器

### vi /etc/sysctl.conf
	net.ipv4.ip_forward=1

### firewall
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
	iptables -A FORWARD -j REJECT
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
	iptables -A INPUT -i tun+ -j ACCEPT
	iptables -A FORWARD -i tun+ -j ACCEPT
	iptables -A INPUT -i tap+ -j ACCEPT
	iptables -A FORWARD -i tap+ -j ACCEPT

