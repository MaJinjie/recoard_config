1. 一个在vicmd模式下执行命令的插件

提供了下面这些东西
autoload -Uz read-from-minibuffer regexp-replace ex-command{,-help} _zvm_ex_command

zstyle ':completion:zvm-cmd:*' completer _zvm_ex_command
autoload -Uz zed zed-set-file-name
zle -N ex-command
bindkey -M vicmd : ex-command


zle -N edit   zed
zle -N e      zed
zle -N saveas zed-set-file-name-arg
zle -N sav    zed-set-file-name-arg
