# url 
https://github.com/jimhester/per-directory-history

# 1 概述

[[ -z $PER_DIRECTORY_HISTORY_BASE ]] && PER_DIRECTORY_HISTORY_BASE="$HOME/.zsh_history_dirs"
[[ -z $PER_DIRECTORY_HISTORY_FILE ]] && PER_DIRECTORY_HISTORY_FILE="zsh-per-directory-history"
[[ -z $PER_DIRECTORY_HISTORY_TOGGLE ]] && PER_DIRECTORY_HISTORY_TOGGLE='^g'

## 1 keybindings 
PER_DIRECTORY_HISTORY_TOGGLE -> ^G(default) -> per-directory-history-toggle-history(function) -> 在全局和局部历史记录之间切换
