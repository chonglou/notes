diff and patch

# 比较目录差别
diff -uN a b

# 产生补丁
diff -uN from-file to-file > to-file.patch
 
# 打补丁
patch -p0 < to-file.patch
 
# 取消补丁
patch -RE -p0 < to-file.patch

# 产生补丁
diff -uNr  from-docu  to-docu  > to-docu.patch
 
# 打补丁
cd to-docu
patch -p1 < to-docu.patch
 
# 取消补丁
patch -R -p1 <to-docu.patch

