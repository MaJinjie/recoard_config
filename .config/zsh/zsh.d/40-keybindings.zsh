declare -g VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
declare -g VI_MODE_SET_CURSOR=true


# 向前移动一个单词的距离
bindkey '^[[1;5D' backward-word
# 向后移动一个单词的距离
bindkey '^[[1;5C' forward-word
# 移动到命令开头
bindkey '^b' beginning-of-line
# 移动到命令结尾
bindkey '^e' end-of-line

bindkey -M viins 'jk' vi-cmd-mode
