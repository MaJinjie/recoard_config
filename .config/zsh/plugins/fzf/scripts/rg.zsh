#!/usr/bin/env zsh

set -ue
#set -x

local search_path=()
local initial_query
local rg_prefix="rg $RG_DEFAULT_OPTS"
_fzf_rg() {
	# 1 判断第一个参数是否是搜索字符串
  # 2 对后续以-结尾前的字符串进行判断(搜索路径)
  # 3 追加选项，覆盖默认
  if (( $# == 0 )) { return }
  
  local i

  for i ({1..$#*}) {
    [[ ${*[$i]} =~ '^-' ]] && break
  }

  if (($# == i)) && [[ ! ${*[-1]} =~ '^-' ]] {((i++))}
  
  if ((i > 1)) && [[ ! (-f $1 || -d $1) ]] {initial_query=$1; shift; ((i--)) }

  search_path=${*[1,$((i - 1))]} 
  rg_prefix+=" ${*[$i,-1]}"

  return 0
}
echo $rg_prefix

_fzf_rg $* 
[[ ! -d /tmp/fzf ]] && mkdir /tmp/fzf
# Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
: | fzf --ansi --disabled --query "$initial_query" \
	--bind "start:reload:$rg_prefix {q} $search_path || true" \
	--bind "change:reload:sleep 0.1; $rg_prefix {q} $search_path || true" \
	--bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
    echo "rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/fzf/rg-fzf-f; cat /tmp/fzf/rg-fzf-r" ||
    echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/fzf/rg-fzf-r; cat /tmp/fzf/rg-fzf-f"' \
	--prompt 'ripgrep> ' \
	--delimiter : \
	--header 'CTRL-T: Switch between ripgrep/fzf' \
	--preview 'bat --color=always {1} --highlight-line {2}' \
	--bind 'enter:become($EDITOR {1} +{2})' \
	--preview-window 'up,60%,border-bottom,+{2}+3/3,~3'  || true 

rm -f /tmp/fzf/rg-fzf-{r,f}

#    --bind '/:transform:cwd=$(</tmp/fzf/fzf-cd)/; cwd=${cwd/%\/\//\/}; cwd=${cwd}{}; [ -f $cwd ] && echo "execute('$EDITOR' $cwd)" || echo "change-prompt($cwd> )+reload(echo $cwd > /tmp/fzf/fzf-cd; '$fd_prefix'$cwd)"' \
#    --bind "?:transform-prompt(echo \${\$(</tmp/fzf/fzf-cd):h} > /tmp/fzf/fzf-cd;
#      echo \$(</tmp/fzf/fzf-cd)'> ')+transform(echo reload:$fd_prefix\$(</tmp/fzf/fzf-cd))" \
#    --bind 'enter:transform:echo ' \
