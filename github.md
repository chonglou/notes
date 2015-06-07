## github

### 同步fork 代码

    git remote -v
    git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
    git remote -v
    git fetch upstream
    git checkout master
    git merge upstream/master
