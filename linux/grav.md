grav
---

* Install
```
git clone https://github.com/getgrav/grav.git
cd grav
bin/grav install
bin/gpm index
bin/gpm install <plugin/theme>
```

* 权限
```
chgrp -R www-data .
find . -type f | xargs chmod 664
find . -type d | xargs chmod 775
find . -type d | xargs chmod +s
umask 0002
```


* 常见插件
```
bin/gpm install admin
```

* 升级
```
bin/gpm selfupgrade -f
```

- [nginx.conf](https://raw.githubusercontent.com/getgrav/grav/master/webserver-configs/nginx.conf)
