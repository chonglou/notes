git 笔记
--------------------

 * 中文文件名乱码

    git config --global core.quotepath false

 * 获取远程分支
	git fetch
	git checkout -b local-branchname origin/remote_branchname 

 * 删除远程分支
	git push origin --delete branchName

 * 放弃更改
    git checkout -f

 * 放弃未提交的更改：
	git reset --hard 

 * 放弃最近的merge
	git reset --hard HEAD~

 * 放弃未跟踪的文件及目录：
	git clean -fd

 * 查看单个文件历史
	git log --pretty=oneline 文件名

 * 查看命令历史
	git reflog

 * 查看工作区和版本库里面最新版本
	git diff HEAD -- filename

 * 丢弃工作区的修改 回到最近一次git commit或git add时的状态
	git checkout -- file

 * 暂存区的修改回退到工作区
	git reset HEAD file

 * 版本回退
	git reset --hard commit_id


 * 修改commit记录(push 要force)
	git rebase -i <commit>


 * 添加远程仓库：
	git remote add origin git@hostname:aaa.git

 * 删除远程仓库
	git remote rm origin

 * 修改远程仓库
	git remote set-url origin <URL>

 * 第一次push需要：
	git push -u origin master

 * 比较分支
	git diff topic master     # 将两个分支上最新的提交做diff，相当于diff了两个commit
	git diff topic..master    # 同上
	git diff topic...master   # 输出自topic与master分别开发以来，master分支上的change


 * git checkout命令加上-b参数表示创建并切换

 * 分支的合并情况
	git log --graph --pretty=oneline --abbrev-commit

 * 合并分支时，加上--no-ff参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，而fast forward合并就看不出来曾经做过合并。


 * 当手头工作没有完成时，先把工作现场git stash一下，然后去修复bug，修复后，再git stash pop，回到工作现场。

 * 如果要丢弃一个没有被合并过的分支，可以通过git branch -D name强行删除。


 * git push origin branch-name推送自己的修改

 * 如果本地分支和远程分支的链接关系没有创建，用命令git branch --set-upstream branch-name origin/branch-name

 * 打标签
	git tag tag_name
	git tag tag\_name commit\_id



 * git tag 标签不是按时间顺序列出，而是按字母排序的

 * 用私钥签名一个标签
	git tag -s tag\_name -m "signed version 0.2 released" commit_id

 * 推送标签:git push origin tag_name

 * 标签附注
	git tag -a v1.4 -m 'my version 1.4'
	git show v1.4

 * 推送所有标签
	git push origin --tags

 * 删除远程标签：
	git tag -d v0.9
	git push origin :refs/tags/v0.9


 * 重置分支
    git log
    git reset --hard 7b78c88
    git push -f
    git merge go
    git push


* 重命名分支
    git branch -m old_branch new_branch         # Rename branch locally    
    git push origin :old_branch                 # Delete the old branch    
    git push --set-upstream origin new_branch # Push the new branch, set local branch to track the new remote

* 清理文件(https://rtyley.github.io/bfg-repo-cleaner/)
    java -jar bfg-1.12.12.jar --strip-blobs-bigger-than 100M [仓库目录]
    java -jar bfg-1.12.12.jar --delete-files id_{dsa,rsa} [仓库目录]
   
    git gc --prune=now --aggressive
    


* git拒绝合并无关的历史纪录
    git pull origin master --allow-unrelated-histories


* 删除文件
使用 git filter-branch 替换历史，然后 --force push。

比如把写有密码的Rakefile不小心push到Github上的话，做以下操作即可。

$ git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch Rakefile' --prune-empty --tag-name-filter cat -- --all
$ git push origin master --force

