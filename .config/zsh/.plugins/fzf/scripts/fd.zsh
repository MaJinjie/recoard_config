#!/usr/bin/env zsh 

# 解析过程分为两个阶段 shell解析  +  fzf解析    shell解析可能会影响到fzf解析

# 指定目录使用 /，如果不加/，shell脚本不认为他是一个目录
# fd git/ 指定搜索目录
# fd .. 模式匹配
# fd ../ 指定上级目录
# fd git/ -p 完全匹配
# fd ee git/ 指定搜索目录 匹配字符串
set -eu
#set -x

local initial_query="^" # ^ / str
local search_path=() # . / path
local fd_opts=${FD_DEFAULT_OPTS:-}
_fzf_fd() {
  # 1 形式 搜索字符串 + 搜索目录(无搜索文件)
	# 2 零参数默认
	# 3 一参数 搜索字符/搜索目录(加./^)
  # 4 同rg
  # fd git/ -> fd .	git/ 
  # fd git/ -p fd git/ -p
  if (( $# == 0 )) { return }
  
  local i
  for i ({1..$#*}) {
    [[ ${*[$i]} =~ '^-' ]] && break
  }

  if (($# == i)) && [[ ! ${*[-1]} =~ '^-' ]] {((i++))}
  #[[ $1 != '.' && $1 != '..' ]] &&
  if ((i > 1)) && [[ ! "$1" =~ "/$" || ( $i -le $# && ${*[$i]} == '-p') ]] {
    initial_query="$1"
    shift
    ((i--))
  }

  search_path=${*[1,$((i - 1))]} 
  fd_opts+=" ${*[$i,-1]}"

  return 0
}

_fzf_fd $*

#local fd_file_opts="fd $initial_query $search_path -tf $fd_opts"
#local fd_directory_opts="fd $initial_query $search_path -td $fd_opts"
#${(s: :)fd_file_opts} 如何要传递整个，需要将参数变成数组，之后展开

local query=$([[ $initial_query == '^' ]] && print '' || print $initial_query)

eval "fd $fd_opts $initial_query $search_path" |
	fzf --query "$query" \
		--prompt 'Files|Directorys> ' \
		--header 'CTRL-T: Switch between Files/Directories' \
    --height=60% \
		--bind "ctrl-t:transform:[[ ! \$FZF_PROMPT =~ Files ]] &&
              echo 'change-prompt(Files> )+reload(fd $initial_query $search_path -tf $fd_opts)' ||
              echo 'change-prompt(Directories> )+reload(fd $initial_query $search_path -td $fd_opts)'" \
		--bind 'ctrl-e:become(echo {+} | xargs -o $EDITOR)' \
		--bind 'enter:become($EDITOR {})' \
		--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) ||
              ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200' \
     || true
