linux 下ip地址设置
---------------------

### UBUNTU/DEBIAN
#### vi /etc/network/interfaces:
	auto eth0
	iface eth0 inet static
	address 192.168.0.10
	netmask 255.255.255.0
	gateway 192.168.0.1
	dns-nameservers 8.8.8.8 8.8.4.4

### CENTOS
#### vi /etc/sysconfig/network-scripts/ifcfg-eth0 
	DEVICE="eth0"
	NM_CONTROLLED="yes"
	ONBOOT=yes
	HWADDR=A4:BA:DB:37:F1:04
	TYPE=Ethernet
	BOOTPROTO=static
	NAME="System eth0"
	UUID=5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03
	IPADDR=192.168.1.44
	NETMASK=255.255.255.0 
 
#### 网关设置(vi /etc/sysconfig/network)
	NETWORKING=yes
	HOSTNAME=centos6
	GATEWAY=192.168.1.1
 
 
#### 重启网络 
	/etc/init.d/network restart
 
#### DNS Server设置(vi /etc/resolv.conf) 
	nameserver 8.8.8.8 
	nameserver 8.8.4.4 
