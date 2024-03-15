#!/bin/env zsh

function :rg ()
{
  typeset -a directores
  typeset str=""
  # parse directory
  # set -x
 
  if [[ $#* > 0 && ! -e $1 ]] {
    str=$1
    shift
  } 
  for arg ($*) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="$str"
  : | fzf --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q} $directores" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} $directores || true" \
      --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Rg ]] &&
        echo "rebind(change)+change-prompt(Rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
        echo "unbind(change)+change-prompt(Fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
      --prompt 'Rg> ' \
      --delimiter : \
      --header 'CTRL-T: Switch between ripgrep/fzf' \
      --preview 'bat --style=numbers,header,changes,snip --color=always --highlight-line {2} -- {1}' \
      --preview-window 'default:right:60%:~1:+{2}+3/2:border-left' \
      --bind 'alt-e:become($EDITOR "$(echo {} | hck -d: -f1)")' \
      --bind 'enter:become($EDITOR {1} +{2})'
  # set +x
  
  rm -f /tmp/rg-fzf-{r,f}
  
}

zle -N :rg
