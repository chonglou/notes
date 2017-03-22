Gogs is a painless self-hosted Git service.
---

* Install
```
sudo apt-get install libpam0g-dev
sudo adduser --disabled-login --gecos 'Gogs' git
go get -u -tags "sqlite pam cert" github.com/gogits/gogs
cd $GOPATH/src/github.com/gogits/gogs
go build -tags "sqlite pam cert"
```

* custom/conf/app.ini
```
APP_NAME = GIT SERVER
RUN_MODE = prod
[repository]
ROOT = /home/git/repositories
```

*
```bash
mkdir ~/ssl
cd ~/ssl
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out csr.pem
openssl req -x509 -days 365 -key key.pem -in csr.pem -out cert.pem
chmod 400 key.pem
chmod 444 cert.pem
sudo cp cert.pem /etc/ssl/certs/git.change-me.com.crt
sudo cp key.pem  /etc/ssl/private/git.change-me.com.key
```

* nginx.conf
```
server {
    listen 443;
    server_name git.yuezang.me;
    ssl  on;
    ssl_certificate /etc/ssl/certs/git.yuezang.me.crt;
    ssl_certificate_key /etc/ssl/private/git.yuezang.me.key;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  RC4:HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
    proxy_set_header X-Forwarded-Proto https;		
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_redirect off;
      proxy_pass http://localhost:3000;
    }
}
```

* Start
```
./gogs web
```
