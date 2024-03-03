#!/bin/env zsh 

_fd_parse() {
  local fd_str fd_opts_index fd_opts_value fd_opts_arr
  fd_str="${1#$cmd}"
  fd_opts_arr=(${(s: :)fd_str})
  fd_opts_index=1
  fd_opts_value=$fd_opts_arr[$fd_opts_index]
  if [[ $#fd_opts_arr -ge 1 && $fd_opts_value =~ '-[md]?[1-9]' ]] {
    local fd_depth_opt
    [[ $fd_opts_value == *m* ]] && fd_depth_opt="--max-depth $fd_opts_value[-1] " || fd_depth_opt="--exact-depth $fd_opts_value[-1] "
    fd_prefix+=$fd_depth_opt
    fd_opts_index=$((fd_opts_index + 1))
  }

  fd_prefix+='^ '
  while (($fd_opts_index <= $#fd_opts_arr)) {
    fd_opts_value=$fd_opts_arr[$fd_opts_index]
    if [[ $fd_opts_value =~ '^-' ]] {
      break
    }
    fd_opts_value=${fd_opts_value/#\~/\/home\/${USER}}
    if [[ ! -d $fd_opts_value ]] {
      print -P "\n%B$fd_opts_value %F{red}not directory!"
      return -1
    }
    fd_prefix+="$fd_opts_value "
    fd_opts_index=$((fd_opts_index + 1))
  }

  if [[ $fd_prefix =~ '\^ $' ]] {
    fd_prefix+='. '
  } 

  fd_prefix+="${fd_opts_arr[$fd_opts_index,$]}"
  return 0
}

_fzf_complete_fd() {
  local fd_prefix sed_suffix
  fd_prefix="fd $FD_DEFAULT_OPTS "
  sed_suffix="sed -e 's/\.\///' -e 's/\/home\/${USER}/~/'"
  if ! {_fd_parse $lbuf} {
    echo
    return -1
  }

  local _result _failure _fd
  _result=$C_FZF_TMP_RESULT/$$ 
  _failure=$C_FZF_TMP_FAILURE/$$
  _fd=$C_FZF_TMP/fd$$

  FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-}"
  __fzf_comprun "$cmd"  -q "${(Q)prefix}" \
    --bind "start:reload($fd_prefix | $sed_suffix)" \
    --bind 'ctrl-r:transform:[[ ! $FZF_PROMPT =~ "F\|D" ]] && echo "change-prompt(F|D> )+reload('$fd_prefix' | '$sed_suffix')"' \
    --bind 'ctrl-f:transform:[[ $FZF_PROMPT =~ "D" ]] && echo "change-prompt(F> )+reload('$fd_prefix' -tf | '$sed_suffix')"' \
    --bind 'ctrl-d:transform:[[ $FZF_PROMPT =~ "F" ]] && echo "change-prompt(D> )+reload('$fd_prefix' -td | '$sed_suffix')"' \
    --bind 'enter:transform:echo {} > '$_result'; echo "accept"' \
    --bind 'ctrl-e:execute(echo {+} | xargs -o '$EDITOR')' \
    --prompt='F|D> ' \

  local fd_ result_ failure_ 
  result_=${$(<$_result)/#\~/'/home/'$USER''}
  failure_=$([[ -e $_failure ]] && print true || print false) 
  #fd_=$(<$_fd)

  local parent_dir_ file_

  if [[ $failure_ == 'false' ]] {
    parent_dir_=${result_:h}
    file_=${result_:t}

    if [ -f $result_ ]; then 
      LBUFFER="$EDITOR"
      RBUFFER=" $file_" 
      zle accept-and-hold 
      LBUFFER="cd ${parent_dir_/#\/home\/${USER}/~}"
      RBUFFER=
      zle accept-line
      zle reset-prompt
    elif [ -d $result_ ]; then
      LBUFFER="cd ${result_/#\/home\/${USER}/~}" 
      zle accept-line
    else 
      LBUFFER="cd ${parent_dir_/#\/home\/${USER}/~}"
      zle accept-line
    fi
  }
  _file_clear _result _failure
}


