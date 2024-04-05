#!/bin/env zsh

# 使用 -- 来在线执行 rg 的--iglob 模式 
# 同样的命令，reload执行和 在终端执行结果不同
# TRANSFORM_IGLOB='
#   if [[ ${FZF_QUERY} =~ "[ ]--" ]]; then
#     setopt extended_glob
#     search_str=${FZF_QUERY% ##--*}
#     glob_arr=(${(s/ /)FZF_QUERY##*--})
#     glob_str=()
#     for glob in $glob_arr
#     do
#       glob_str+="--iglob $glob "
#     done
#   else 
#     search_str=${FZF_QUERY}
#   fi
#   echo "rg --no-heading ${glob_str} ${search_str}" > ~/fzf/1
#   
#   echo "reload:sleep 0.1; rg --no-heading ${glob_str} ${search_str}"
# '
function __parse_params ()
{
  __PARSE_PARAMS__=()
  __DIRTECTORES__=()

  for arg ($*) {
    if [[ $arg =~ '^--' ]]; then
      __PARSE_PARAMS__+="$arg"
      shift
    else 
      __DIRTECTORES__=("$@")
      break
    fi
  }

}

function :s ()
{
  typeset -a DIRECTORES ARGS=(${ARGS:-})
  typeset INITIAL_QUERY=${INITIAL_QUERY:-}
  # parse directory
 
  if [[ -z $INITIAL_QUERY && -n $1 && ! -e $1 && ! $1 =~ '^--' ]]; then 
    INITIAL_QUERY=$1
    shift
  fi

  if [[ $#ARGS == 0 ]] {
    __parse_params "$@"
    DIRECTORES=($__DIRTECTORES__)
    ARGS=($__PARSE_PARAMS__)
  } else {
    DIRECTORES=("$@")
  }
  
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case ""$ARGS"
  fzf --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q} $DIRECTORES" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} $DIRECTORES || true" \
      --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Rg ]] &&
        echo "rebind(change)+change-prompt(Rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
        echo "unbind(change)+change-prompt(Fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
      --prompt 'Rg> ' \
      --delimiter : \
      --header 'CTRL-T: Switch between ripgrep/fzf' \
      --preview 'bat --style=numbers,header,changes,snip --color=always --highlight-line {2} -- {1}' \
      --preview-window 'default:right:60%:~1:+{2}+3/2:border-left' \
      --bind 'alt-e:execute($EDITOR "$(echo {} | hck -d: -f1)")' \
      --bind 'enter:become($EDITOR {1} +{2})' &&
      rm -f /tmp/rg-fzf-{r,f}
}

function :sr ()
{
  # params 共享
  typeset -a DIRECTORES ARGS
  typeset DATE INITIAL_QUERY

  # 解析时间
  if [[ -n $1 && ($1 =~ '^[0-9]+(d|h|weeks|min)$' || 
    $1 =~ '^[0-9]{2,4}-[0-9]{2}-[0-9]{2}$' ||
    $1 =~ '^[0-9]{2,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$') ]]; then 
    DATE=$1
    shift
  fi

  # 解析搜索的字符串
  if [[ -n $1 && ! -e $1 && ! $1 =~ '^--' ]]; then 
    INITIAL_QUERY=$1
    shift
  fi

  # 简单地解析--标志
  __parse_params "$@"
  DIRECTORES=($__DIRTECTORES__)
  ARGS=($__PARSE_PARAMS__)
  
  :s $(echo $(fd -tf --follow --changed-after=${DATE:-1d} $ARGS ${(Q)DIRECTORES:+^} $DIRECTORES) | xargs -o)

}
zle -N :s
zle -N :sr

