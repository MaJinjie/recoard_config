#!/bin/env zsh

# prefix \前的内容 lbuf 非prefix部分 cmd 命令
_file_clear() {
  local file_var file
  for file_var ($*) {
    file=${(P)file_var}
    [[ -e ${file} ]] && rm -f $file
  }
}
_fzf_complete_z() {
  local z_time_file z_freq_file 
  z_time_file=$C_FZF_TMP/ztime$$ 
  z_freq_file=$C_FZF_TMP/zfreq$$  
  
  sort -n -r -t '|' -k 3 $ZSHZ_DATA > $z_time_file 
  sort -n -r -t '|' -k 2 $ZSHZ_DATA > $z_freq_file 

  _fzf_complete +m --prompt='j> ' \
    --bind 'ctrl-g:execute(nvim {})' \
    -- "$@" < <(
    paste -d '\n' $z_time_file $z_freq_file | awk -F '|' '!x[$0]++ {sub(/\/home\/'${USER}'/,"~"); print $1}'
  )
  
  local _result _failure 
  _result=$C_FZF_TMP_RESULT/$$ 
  _failure=$C_FZF_TMP_FAILURE/$$

  [[ ! -e $_failure ]] && zle accept-line

  _file_clear _result _failure z_time_file z_freq_file
}

# convert abs path  and replace ~
_cd_convert() {
  local cd_path=$1
  cd_path=${cd_path#$cmd ##}
  cd_path=${cd_path% ##}
  
  if [[ -z $cd_path || $cd_path =~ '^\.\.?$' ]] {
    [[ $cd_path == '..' ]] && cd_path=${PWD:h} || cd_path=$PWD
  } elif [[ $cd_path =~ '^~' ]] {
    cd_path=${cd_path/\~/$HOME}
  } elif [[ $cd_path =~ '^[^/]' ]] {
    cd_path="$(pwd)/$cd_path" 
  }
  [[ ! -d $cd_path ]] && {print 'not directory' >> $COMPLETIONS_LOG; exit 1}

  cd_path+=/
  cd_path=${cd_path//\/##/\/}
  print ${cd_path}
}

_fzf_complete_cd() {
  setopt EXTENDED_GLOB

  local abs_path fd_prefix home_replace
  
  # 获取绝对路径和验证路径
  abs_path=$(_cd_convert ${lbuf})
  fd_prefix="fd --max-depth=2 -td $FD_DEFAULT_OPTS --base-directory="

  # 定义结果 失败标志 以及 cd所处目录
  local _result _failure _cd 
  _result=$C_FZF_TMP_RESULT/$$ 
  _failure=$C_FZF_TMP_FAILURE/$$
  _cd=$C_FZF_TMP/cd$$

  local transform1='
    if [ {} = '' ]; then 
      echo "" 
    fi
    parse_path=$(<'$_cd'){}
    if [ -d $parse_path ]; then 
      echo $parse_path > '$_cd'
      echo "change-prompt(${parse_path/#\/home\/${USER}/~}> )+clear-query+reload('$fd_prefix'$parse_path)"
    else 
      echo ""
    fi
  '
  local transform2='
    jump_path=${$(<'$_cd'):h}/
    jump_path=${jump_path/%\/\//\/}
    echo $jump_path > '$_cd'
    echo "change-prompt(${jump_path/#\/home\/${USER}/~}> )+reload('$fd_prefix'$jump_path)"
  '

  _fzf_complete +m  \
    --bind "start:reload:echo $abs_path > $_cd; $fd_prefix$abs_path" \
    --bind '/:transform:'$transform1'' \
    --bind '?:transform:'$transform2'' \
    --bind 'ctrl-g:execute(nvim {})' \
    --bind ctrl-w:transform:'
      if [ -z $FZF_QUERY ]; then 
      '$transform2' 
      else 
        echo "unix-word-rubout"
      fi' \
    --bind enter:accept \
    --prompt="${abs_path/#\/home\/${USER}/~}> " \
    -- "$@" 

  local reuslt_ failure_ cd_ path_
  result_=$(<$_result) 
  failure_=$([[ -e $_failure ]] && print true || print false) 
  cd_=$(<$_cd)

  if [ $failure_ = false ]; then 
    path_=$cd_$result_
    path_=${path_% ##}

    if [ -f $path_ ]; then 
      LBUFFER="$EDITOR"
      RBUFFER=" $result_" 
      zle accept-and-hold 
      LBUFFER="cd ${cd_/#\/home\/${USER}/~}"
      RBUFFER=
      zle accept-line
      zle reset-prompt
    elif [ -d $path_ ]; then
      LBUFFER="$cmd ${path_/#\/home\/${USER}/~}" 
      zle accept-line
    else 
      LBUFFER="$cmd ${cd_/#\/home\/${USER}/~}"
      zle accept-line
    fi
  fi
  _file_clear _result _failure _cd
}
