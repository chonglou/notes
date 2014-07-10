#!/bin/sh

#共享目录列表 空格隔开 会自动链接到网站目录下
shared_dirs="dir1 dir2"
#共享文件列表 空格隔开 同上
shared_files='file1 file2'

#网站目录
root='/tmp/var/www/change_me'

#GIT设置
git_repo='git@github.com:chonglou/php_demo.git'
git_branch='master'

#最近保留版本数
keep_versions=7

#-----------------------------------------------------

check(){
	for d in $shared_dirs
	do
		d="$root/shared/$d"
		if [ -d $d ]
		then
			echo "check $d: pass!"
		else
			echo "folder $d not exist, please create it first!"
			exit 1
		fi
	done
	for f in $shared_files
	do
		f="$root/shared/$f"
		if [ -f $f ]
		then
			echo "check $f: pass!"
		else
			echo "file $f not exist, please create it first!"
			exit 1
		fi
	done

	logs="${root}/logs"
	if [ ! -d $logs ]
	then
		mkdir -pv logs || exit 1
	fi
	echo "check logs folder ${logs}: pass"
}

deploy(){
	current=$root/`date +%Y%m%d%H%M%S`
	scm=$root/scm
	echo "current version: $current"

	if [ -d $scm ]
	then
		cd $scm 
		git pull || exit 1
	else
		git clone -b $git_branch $git_repo $scm || exit 1
	fi

	mkdir -pv $current
	cd $current
	git archive --format=tar --remote=$scm HEAD | tar xvf - || exit 1

	for f in $shared_files
	do
		ln -sv $root/shared/$f $current/$f
	done
	for d in $shared_dirs
	do
		ln -sv $root/shared/$d $current/$d
	done

	ln -nsvf $current $root/current

}

clean(){
	cd $root
	keep_versions=$(($keep_versions+1))
	ls $root | grep '^2[0-9]\+' | sort -r -n | tail -n +$keep_versions | xargs rm -r

}

echo "CHECKING..."
check
echo "DEPLOYING..."
deploy
echo "CLEAN..."
clean
echo "SUCCESS FINISH..."
echo "Enjoy it, if have any question, please issue at https://github.com/chonglou/notes!"
