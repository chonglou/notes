CyanogenMod编译
---


## 安装repo
```
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x !$
export PATH=$HOME/bin:$PATH

```

## 创建工作目录

```
mkdir -p build
cd build
```

## 设置编译环境

### java
```
sudo pacman -S jre8-openjdk
```

### python2

```
sudo pacman -S python2 
virtualenv -p /usr/bin/python2.7 python2
source python2/bin/activate # 加载python2环境，注销用: deactivate
```

### ccache

```
sudo pacman -S ccache
export USE_CCACHE=1
ccache -M 50G
```

## 下载源码

```
mkdir cm
cd cm
repo init -u git://github.com/CyanogenMod/android.git -b cm-13.0 # 初始化仓库及版本信息
repo sync # 下载源码
```

## 编译

```
make clobber
source build/envsetup.sh
make -j8
```


## Documents
- <http://source.android.com/source/initializing.html> 
- <https://github.com/CyanogenMod/android>
- <https://wiki.cyanogenmod.org/w/Development>
