#!/bin/env zsh

function :ff ()
{
  typeset -a directores=('.') 
  # parse directory
  # set -x
  for arg ($*) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  fd -tf --color=always --hidden --follow --max-depth=6 --size=-1M $directores[@] |
    fzf --prompt 'Files> ' \
    --bind='enter:become($EDITOR {+})'

  # set +x
  
}

function :fd ()
{
  typeset -a directores=('.') 
  # parse directory
  # set -x
  for arg ($*) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  fd -td --color=always --hidden --follow --max-depth=6 $directores[@] |
    fzf +m --prompt 'Dirs> ' \
    --bind='alt-e:execute($EDITOR {})' \
    --bind='enter:become($EDITOR {})'

  # set +x
  
}

function :fr ()
{
  typeset -a directores=('.') 
  typeset date='1d'
  # parse directory
  # set -x

  if [[ $#* > 0 && ! -d $1 ]] {
    date=$1
    shift
  } 
  for arg (${*}) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  fd -tf --color=always --hidden --follow --max-depth=8 --changed-after=$date $directores[@] |
    fzf --prompt 'Files> ' \
    --header 'CTRL-T: Switch between Files/Directories' \
    --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Files ]] &&
              echo "change-prompt(Files> )+reload(fd -tf --hidden --follow --max-depth=8 --changed-after='$date' '$directores[@]')" ||
              echo "change-prompt(Dirs> )+reload(fd -td --hidden --follow --max-depth=8 --changed-after='$date' '$directores[@]')"' \
    --bind='enter:become($EDITOR {+})'

  # set +x
  
}
zle -N :ff
zle -N :fd
zle -N :fr
