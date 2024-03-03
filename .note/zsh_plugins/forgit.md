# url 
https://github.com/wfxr/forgit
# 1 概述

1. 定义了一些git命令别名以及对应的与fzf的集成
2. 允许通过环境变量， 自定义每一个命令的git选项 fzf选项

# 2 使用

## 1 aliases 
ga     ->  git add 
glo    ->  git log 
gd     ->  git diff
gi     ->  .gitignore 生成器 gi -> .gitignore 
grh    ->  git reset HEAD [file] 
gcf    ->  git checkout [file] 
gbd    ->  git branch -D [branch] 
gct    ->  git checkout [tag] 
gco    ->  git checkout [commit] 
gcb    ->  git checkout [branch]
gro    ->  git revert [commit] 
gss    ->  git stash 
gsp    ->  git stash push 
gclean ->  git clean 
gcp    ->  git cherry-pick 
grb    ->  git rebase -i 
gbl    ->  git blame 
gfu    ->  git commit --fixup && git rebase -i --autosquash

## 2 keybindings 

Enter	Confirm
Tab	Toggle mark and move down
Shift - Tab	Toggle mark and move up
?	Toggle preview window
Alt - W	Toggle preview wrap
Ctrl - S	Toggle sort
Ctrl - R	Toggle selection
Ctrl - Y	Copy commit hash/stash ID*
Ctrl - K / P	Selection move up
Ctrl - J / N	Selection move down
Alt - K / P	Preview move up
Alt - J / N	Preview move down
Alt - E	Open file in default editor (when possible)



