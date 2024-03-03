#!/bin/env zsh 

_rg_parse() {
  local rg_str rg_opts_index rg_opts_value rg_opts_arr
  rg_str="${1#$cmd}"
  rg_opts_arr=(${(s: :)rg_str})
  rg_opts_index=1
  rg_opts_value=$rg_opts_arr[$rg_opts_index]
  if [[ $#rg_opts_arr -ge 1 && $rg_opts_value =~ '-[md]?[1-9]' ]] {
    local rg_depth_opt
    rg_depth_opt="--max-depth $rg_opts_value[-1] "
    rg_prefix+=$rg_depth_opt
    rg_opts_index=$((rg_opts_index + 1))
  }


  while (($rg_opts_index <= $#rg_opts_arr)) {
    rg_opts_value=$rg_opts_arr[$rg_opts_index]
    if [[ $rg_opts_value =~ '^-' ]] {
      break
    }
    rg_opts_value=${rg_opts_value/#\~/\/home\/${USER}}
    if [[ ! -d $rg_opts_value ]] {
      print -P "\n%B$rg_opts_value %F{red}not directory!"
      return -1
    }
    search_path+="$rg_opts_value "
    rg_opts_index=$((rg_opts_index + 1))
  }
  rg_prefix+="${rg_opts_arr[$rg_opts_index,$]}"
  return 0
}

_fzf_complete_rg() {
  local rg_prefix search_path sed_suffix 
  rg_prefix="rg $RG_DEFAULT_OPTS"
  sed_suffix="sed -e 's/\.\///' -e 's/\/home\/${USER}/~/'"
  if ! {_rg_parse $lbuf} {
    echo
    return -1
  }
  local _result _failure _rg
  _result=$C_FZF_TMP_RESULT/$$ 
  _failure=$C_FZF_TMP_FAILURE/$$
  _rg=$C_FZF_TMP/rg$$

  FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-}"

  #set -x
  __fzf_comprun "$cmd" --ansi --disabled -q "${(Q)prefix}" \
    --bind "start:reload:$rg_prefix {q} $search_path" \
    --bind "change:reload:sleep 0.1; $rg_prefix {q} $search_path | $sed_suffix || true" \
    --bind 'ctrl-t:transform:pre_query=$(<'$_rg'); echo $FZF_QUERY > '$_rg'; [[ ! $FZF_PROMPT =~ rg ]] &&
      echo "rebind(change)+change-prompt(rg> )+disable-search+transform-query(echo $pre_query)" ||
      echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query(echo $pre_query)"' \
    --bind 'enter:transform:echo {} > '$_result'; echo "accept"' \
    --bind 'ctrl-e:execute('$EDITOR' {1} +{2})' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --delimiter : \
    --prompt 'rg> '

  local rg_ result_ failure_ 
  result_=$(<${_result:-'/dev/null'})
  failure_=$([[ -e $_failure ]] && print true || print false) 
  #rg_=$(<$_rg)

  local path_ directory_ file_ line_

  if [[ $failure_ == 'false' ]] {
    path_=${result_[(ws-:-)1]}
    directory_=${path_:h}
    file_=${path_:t}
    line_=${result_[(ws-:-)2]}

    LBUFFER="$EDITOR +${line_}"
    RBUFFER=" $file_" 
    zle accept-and-hold 
    LBUFFER="cd ${directory_/#\/home\/${USER}/~}"
    RBUFFER=
    zle accept-line
    zle reset-prompt
  }
  _file_clear _result _failure _rg
} 


