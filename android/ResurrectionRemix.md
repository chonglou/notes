Resurrection Remix编译笔记(on ubuntu)
---

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential git zsh 

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/ResurrectionRemix/ResurrectedScripts.git -b marshmallow scripts
cd scripts
./setup.sh
bash build.sh

mkdir ~/bin
echo `export PATH=$HOME/bin:$PATH` >> ~/.zshrc # then re-login

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

```


