grep命令
---

### 查询文件是否含有unicode字符
    perl -ane '{ if(m/[[:^ascii:]]/) { print  } }' file.txt
