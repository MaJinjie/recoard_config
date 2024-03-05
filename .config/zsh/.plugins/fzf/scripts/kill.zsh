#!/bin/env zsh

# 
#set -x
set -u
set -e
local signal
local signals=(HUP INT QUIT ILL TRAP IOT BUS FPE KILL USR1 SEGV USR2 PIPE ALRM TERM STKFLT CHLD CONT STOP TSTP TTIN TTOU URG XCPU XFSZ VTALRM PROF WINCH POLL PWR SYS)

function _fzf_kill() {
  if (($# > 2)) {print -P 'params' '%B%F{red}count > 2' 2> /dev/tty; exit 1}
  if (($+1)) && [[ $1 =~ '^-' || $1 =~ '^\w+$' ]] {
    signal=${1#-}
    if {expr $signal '+' 0 &>/dev/null} {
      (($signal >=1 && $signal <= 31)) || {print -P '%B%F{red}数字超过范围' 2>/dev/tty; exit 1}
    } else {
    (($#signal == 1 || ${signals[(I)${(U)signal}]})) || {print -P '%B%F{red}信号字符串错误'2>/dev/tty; exit 1}
    (($#signal == 1)) && {kill -$signal; exit 1}
    } 
    shift
  }
  signal=${(U)${signal:-9}}
  if (($+1)) {
    kill -$signal $1
    exit $?
  }
  return 0
}

_fzf_kill $*



_fzf_kill_command="ps -eo user,pid,ppid,pgid,stat,tname,cmd" 


[[ ! -d /tmp/fzf/ ]] && mkdir /tmp/fzf


local fzf_preview_cmd="ps -o pcpu,pmem,vsz,rss,thcount,start_time,time -p {2}"

{date +"%T"; ps -eo user,pid,ppid,pgid,stat,tname,cmd} \
	  | fzf --bind='ctrl-r:reload(date +"%T"; ps -eo user,pid,ppid,pgid,stat,tname,cmd)' \
			--prompt 'search> ' \
			--header=$'Press CTRL-R to reload\nPress ctrl-e send signal\n\n' --header-lines=2 \
			--bind "ctrl-e:execute(
      kill -$signal {2} &>/dev/null && echo ✓ {} >>/tmp/fzf/kill-fzf || echo X {} >>/tmp/fzf/kill-fzf
		)+reload(date; ps -ef)" \
      --height=50% --min-height=15 --tac \
			--preview=$fzf_preview_cmd --preview-window=down,2,wrap \
    || true

if [[ -e /tmp/fzf/kill-fzf ]] {
 		ps -eo user,pid,ppid,pgid,stat,tname,cmd | head -1 | sed '1 s/^/         /g'
		bat -n --style numbers,grid /tmp/fzf/kill-fzf
		rm -f /tmp/fzf/kill-fzf
}

