#!/bin/env zsh 

# 将所需要的最新的补全文件移动到completions中

typeset -a list


list=(
  rg
  fd
  delta
  yazi
  grc
  nvim
)


for cmd ($list[@]) {
  local file_path="$Zdirs[DATA]/completions/_$cmd"
  [[ -f $file_path ]] && mv $file_path $Zdirs[COMPL]
}
