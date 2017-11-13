hugo 安装

- [Quickstart Guide](https://gohugo.io/overview/quickstart/)
- [Themes](https://themes.gohugo.io/)

#### 安装
* 添加到 ~/.zshrc
```bash
GOPATH=$HOME/go
PATH=$GOPATH/bin:$PATH
export GOPATH PATH
```
* 安装hugo
```bash
go get -u github.com/kardianos/govendor
govendor get github.com/spf13/hugo
cd $GOPATH/src/github.com/spf13/hugo
make install
```
* 创建站点
```bash
hugo new site change-me
cd change-me
git init
git remote add deploy deploy@www.change-me.com:/var/www/www.change-me.com/repo.git
```
* 撰写
```bash
hugo new post/hugo-install.md
git push deploy master
```

* 皮肤
```bash
cd themes
git clone https://github.com/dim0627/hugo_theme_robust.git
```

* 启动
```bash
echo 'theme = "hugo_theme_robust"' >> config.toml
hugo server --buildDrafts
```

#### 部署
* GIT仓库
```
ssh deploy@www.change-me.com
server$ mkdir -pv /var/www/www.change-me.com
server$ cd /var/www/www.change-me.com
server$ git --bare init repo.git
server$ cd repo.git
server$ touch hooks/post-receive
server$ chmod +x hooks/post-receive
```

* hooks/post-receive内容
```
#!/bin/sh
WORK_DIR=/var/www/www.change-me.com
THEME=dim0627/hugo_theme_robust
GIT_REPO=$WORK_DIR/repo.git
TMP_GIT_CLONE=$WORK_DIR/tmp
PUBLIC_WWW=$WORK_DIR/public
git clone $GIT_REPO $TMP_GIT_CLONE
mkdir $TMP_GIT_CLONE/themes
cd $TMP_GIT_CLONE/themes && git clone https://github.com/$THEME.git
$HOME/go/bin/hugo -Ds $TMP_GIT_CLONE -d $PUBLIC_WWW
rm -Rf $TMP_GIT_CLONE
exit
```

* nginx.conf
```
server {
  listen 443;
  ssl on;
  ssl_certificate /etc/ssl/certs/www.change-me.com.crt;
  ssl_certificate_key /etc/ssl/private/www.change-me.com.key;
  server_name www.change-me.com;
  root /var/www/www.change-me.com/public;
  access_log off;
  error_log /var/www/www.change-me.com/logs/error.log;
}
```
