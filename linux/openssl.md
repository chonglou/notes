
### 教程:

	http://www.slideshare.net/clzqwdy/openssl-4472555

### 制作数字证书 

#### 简单

	openssl genrsa -out privkey.pem 2048
	openssl req -new -x509 -key privkey.pem -out cacert.pem -days 3650
	Common Name需要填站点域名:*.aaa.com

#### root ca
 * 创建CA的私钥

	openssl genrsa -out root/root-key.pem 2048

 * 创建证书请求
	
	openssl req -new -key root/root-key.pem -out root/root-req.csr -text

 * 自签名证书
	
	openssl x509 -req -in root/root-req.csr -out root/root-cert.pem -sha512 -signkey root/root-key.pem -days 3650 -text -extfile /etc/ssl/openssl.cnf -extensions v3_ca

 * 导出证书成浏览器支持的.p12格式(pkcs标准)

	openssl pkcs12 -export -cacerts -in root/root-cert.pem -inkey root/root-key.pem -out root/root.p12


#### 创建server的私钥
 * 创建server的私钥
	
	openssl genrsa -out server/server-key.pem 2048

 * 创建server的证书请求

	openssl req -new -key server/server-key.pem -out server/server-req.csr -text

 * 用ca的证书和必要对server的证书请求进行签名

	openssl x509 -req -in server/server-req.csr -CA root/root-cert.pem -CAkey root/root-key.pem -CAcreateserial -days 3650 -out server/server-cert.pem -text

 * 导出证书成浏览器支持的.p12格式(pkcs标准)

	openssl pkcs12 -export -clcerts -in server/server-cert.pem -inkey server/server-key.pem -out server/server.p12


#### 验证证书

	openssl verify -CAfile root/root-cert.pem server/server-cert.pem


### 查看内容
 * 查看key
	
	openssl rsa -noout -text -in server-key.pem

 * 查看csr	
	
	openssl req -noout -text -in server-req.csr

 * 查看cert
	
	openssl x509 -noout -text -in server-cert.pem

