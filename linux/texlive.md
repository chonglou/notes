texlive笔记
-------------------

### 编译成HTML(使用hevea工具)
    $ pacman -S hevea
    $ hevea article.hva 文件名.tex # 使用基本style

### 编译成PDF(编译两遍是为了生成索引)
    $ xelatex file.tex
    $ xelatex file.tex 
