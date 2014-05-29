postfix+dovecot+mysql搭建邮件系统
---------------------------------------

## DNS设置
    example.com         MX       10      example.com
    example.com         MX       10      12.34.56.78
    mail.example.com    MX       10      12.34.56.78

记得设置DNS反查功能 否则有可能被据信

## 安装依赖的包
    apt-get install postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql mysql-server

## MYSQL设置
### 创建数据库
    CREATE DATABASE mailserver;
    GRANT SELECT ON mailserver.* TO 'mailuser'@'127.0.0.1' IDENTIFIED BY 'mailuserpass';

    FLUSH PRIVILEGES;

### 创建表
    CREATE TABLE `virtual_domains` (
  		`id` int(11) NOT NULL auto_increment,
  		`name` varchar(50) NOT NULL,
  		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `virtual_users` (
  		`id` int(11) NOT NULL auto_increment,
  		`domain_id` int(11) NOT NULL,
  		`password` varchar(106) NOT NULL,
  		`email` varchar(100) NOT NULL,
  		PRIMARY KEY (`id`),
  		UNIQUE KEY `email` (`email`),
  		FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE `virtual_aliases` (
  		`id` int(11) NOT NULL auto_increment,
	  	`domain_id` int(11) NOT NULL,
  		`source` varchar(100) NOT NULL,
  		`destination` varchar(100) NOT NULL,
  		PRIMARY KEY (`id`),
  		FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8;

### 测试数据填充
	INSERT INTO `mailserver`.`virtual_domains` (`id` ,`name`) VALUES ('1', 'example.com'), ('2', 'hostname.example.com'), ('3', 'hostname'), ('4', 'localhost.example.com');
	INSERT INTO `mailserver`.`virtual_users` (`id`, `domain_id`, `password` , `email`) 
VALUES ('1', '1', ENCRYPT('firstpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email1@example.com'),
  ('2', '1', ENCRYPT('secondpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email2@example.com');
	INSERT INTO `mailserver`.`virtual_aliases` (`id`, `domain_id`, `source`, `destination`) VALUES ('1', '1', 'alias@example.com', 'email1@example.com');


#### 测试
	SELECT * FROM mailserver.virtual_domains;
	SELECT * FROM mailserver.virtual_users;
	SELECT * FROM mailserver.virtual_aliases;

### POSTFIX 设置
#### /etc/postfix/main.cf
	cp /etc/postfix/main.cf /etc/postfix/main.cf.orig

#### /etc/postfix/main.cf
	# See /usr/share/postfix/main.cf.dist for a commented, more complete version

	# Debian specific:  Specifying a file name will cause the first
	# line of that file to be used as the name.  The Debian default
	# is /etc/mailname.
	#myorigin = /etc/mailname

	smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
	biff = no

	# appending .domain is the MUA's job.
	append_dot_mydomain = no

	# Uncomment the next line to generate "delayed mail" warnings
	#delay_warning_time = 4h

	readme_directory = no

	# TLS parameters
	#smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
	#smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
	#smtpd_use_tls=yes
	#smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
	#smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

	smtpd_tls_cert_file=/etc/ssl/certs/dovecot.pem
	smtpd_tls_key_file=/etc/ssl/private/dovecot.pem
	smtpd_use_tls=yes
	smtpd_tls_auth_only = yes

	#Enabling SMTP for authenticated users, and handing off authentication to Dovecot
	smtpd_sasl_type = dovecot
	smtpd_sasl_path = private/auth
	smtpd_sasl_auth_enable = yes

	smtpd_recipient_restrictions =
        permit_sasl_authenticated,
        permit_mynetworks,
        reject_unauth_destination

	# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
	# information on enabling SSL in the smtp client.

	myhostname = host.example.com
	alias_maps = hash:/etc/aliases
	alias_database = hash:/etc/aliases
	myorigin = /etc/mailname
	#mydestination = example.com, hostname.example.com, localhost.example.com, localhost
	mydestination = localhost
	relayhost =
	mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
	mailbox_size_limit = 0
	recipient_delimiter = +
	inet_interfaces = all
	
	#Handing off local delivery to Dovecot's LMTP, and telling it where to store mail
	virtual_transport = lmtp:unix:private/dovecot-lmtp

	#Virtual domains, users, and aliases
	virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
	virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf
	virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf

#### /etc/postfix/mysql-virtual-mailbox-domains.cf
	user = mailuser
	password = mailuserpass
	hosts = 127.0.0.1
	dbname = mailserver
	query = SELECT 1 FROM virtual_domains WHERE name='%s'

##### 测试
	service postfix restart
	postmap -q example.com mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf

#### /etc/postfix/mysql-virtual-mailbox-maps.cf
	user = mailuser
	password = mailuserpass
	hosts = 127.0.0.1
	dbname = mailserver
	query = SELECT 1 FROM virtual_users WHERE email='%s'

##### 测试
	service postfix restart
	postmap -q email1@example.com mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf

#### /etc/postfix/mysql-virtual-alias-maps.cf
	user = mailuser
	password = mailuserpass
	hosts = 127.0.0.1
	dbname = mailserver
	query = SELECT destination FROM virtual_aliases WHERE source='%s'

##### 测试
	service postfix restart
	postmap -q alias@example.com mysql:/etc/postfix/mysql-virtual-alias-maps.cf

#### POSTFIX MASTER设置
cp /etc/postfix/master.cf /etc/postfix/master.cf.orig

##### vi /etc/postfix/master.cf
	#
	# Postfix master process configuration file.  For details on the format
	# of the file, see the master(5) manual page (command: "man 5 master").
	#
	# Do not forget to execute "postfix reload" after editing this file.
	#
	# ==========================================================================
	# service type  private unpriv  chroot  wakeup  maxproc command + args
	#               (yes)   (yes)   (yes)   (never) (100)
	# ==========================================================================
	smtp      inet  n       -       -       -       -       smtpd
	#smtp      inet  n       -       -       -       1       postscreen
	#smtpd     pass  -       -       -       -       -       smtpd
	#dnsblog   unix  -       -       -       -       0       dnsblog
	#tlsproxy  unix  -       -       -       -       0       tlsproxy
	submission inet n       -       -       -       -       smtpd
	#  -o syslog_name=postfix/submission
	#  -o smtpd_tls_security_level=encrypt
	#  -o smtpd_sasl_auth_enable=yes
	#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
	#  -o milter_macro_daemon_name=ORIGINATING
	smtps     inet  n       -       -       -       -       smtpd
	#  -o syslog_name=postfix/smtps
	#  -o smtpd_tls_wrappermode=yes
	#  -o smtpd_sasl_auth_enable=yes
	#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
	#  -o milter_macro_daemon_name=ORIGINATING
	

### DOVECOT设置
#### 备份
	cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
	cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
	cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
	cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
	cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
	cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig

#### vi /etc/dovecot/dovecot.conf
	!include conf.d/*.conf
	!include_try /usr/share/dovecot/protocols.d/*.protocol
	protocols = imap pop3 lmtp


#### vi /etc/dovecot/conf.d/10-mail.conf
	mail_location = maildir:/var/mail/vhosts/%d/%n
	mail_privileged_group = mail

#### 创建邮件用户
	mkdir -p /var/mail/vhosts/example.com
	groupadd -g 5000 vmail
	useradd -g vmail -u 5000 vmail -d /var/mail
	chown -R vmail:vmail /var/mail

#### vi /etc/dovecot/conf.d/10-auth.conf
	disable_plaintext_auth = yes
	auth_mechanisms = plain login
	#!include auth-system.conf.ext
	!include auth-sql.conf.ext

#### vi /etc/dovecot/conf.d/auth-sql.conf.ext
	passdb {
	  driver = sql
	  args = /etc/dovecot/dovecot-sql.conf.ext
	}
	userdb {
	  driver = static
	  args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
	}


#### vi /etc/dovecot/dovecot-sql.conf.ext
	driver = mysql
	connect = host=127.0.0.1 dbname=mailserver user=mailuser password=mailuserpass
	default_pass_scheme = SHA512-CRYPT
	password_query = SELECT email as user, password FROM virtual_users WHERE email='%u';

#### 设置权限
	chown -R vmail:dovecot /etc/dovecot
	chmod -R o-rwx /etc/dovecot


#### vi /etc/dovecot/conf.d/10-master.conf
	service imap-login {
  	inet_listener imap {
    	port = 0
  	}
	...
	}

	service pop3-login {
  		inet_listener pop3 {
    	port = 0
  	}
	...
	}

#### lmtp¿¿
	service lmtp {
		unix_listener /var/spool/postfix/private/dovecot-lmtp {
   		mode = 0600
   		user = postfix
   		group = postfix
  	}
  	# Create inet listener only if you can't use the above UNIX socket
  	#inet_listener lmtp {
    	# Avoid making LMTP visible for the entire internet
    	#address =
    	#port =
  	#}
	}


#### 认证设置
	service auth {
  		# auth_socket_path points to this userdb socket by default. It's typically
  		# used by dovecot-lda, doveadm, possibly imap process, etc. Its default
  		# permissions make it readable only by root, but you may need to relax these
  		# permissions. Users that have access to this socket are able to get a list
  		# of all usernames and get results of everyone's userdb lookups.
  		unix_listener /var/spool/postfix/private/auth {
    		mode = 0666
    		user = postfix
		    group = postfix
	  	}

  	unix_listener auth-userdb {
    		mode = 0600
    		user = vmail
    		#group =
  	}

  	# Postfix smtp-auth
  	#unix_listener /var/spool/postfix/private/auth {
  	#  mode = 0666
  	#}

  	# Auth process is run as this user.
  	user = dovecot
	}

	service auth-worker {
  		# Auth worker process is run as root by default, so that it can access
  		# /etc/shadow. If this isn't necessary, the user should be changed to
  		# $default_internal_user.
  		user = vmail
	}

#### SSL 加密链路
	ls /etc/ssl/certs/dovecot.pem
	ls /etc/ssl/private/dovecot.pem
##### vi /etc/dovecot/conf.d/10-ssl.conf
	ssl_cert = </etc/ssl/certs/dovecot.pem
	ssl_key = </etc/ssl/private/dovecot.pem
	ssl = required

