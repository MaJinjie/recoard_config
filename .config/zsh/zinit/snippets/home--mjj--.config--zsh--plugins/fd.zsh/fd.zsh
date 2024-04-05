#!/bin/env zsh

typeset -a _args 

_args=(
  "--color=always"
  "--hidden"
  "--follow"
  "--max-depth=8"
)

# cd_directory ()
# {
#   typeset path_=$1
#   if [ -f $path_ ]; then 
#     LBUFFER="$EDITOR ${path_:t}"
#     RBUFFER=
#     zle accept-and-hold 
#     LBUFFER="command cd ${path_:h}"
#     RBUFFER=
#     zle accept-line
#     zle reset-prompt
#   elif [ -d $path_ ]; then
#     BUFFER="command cd ${path_}"
#     zle accept-line
#   else 
#     info "not file or directory"
#   fi
# }

function :ff ()
{
  typeset -a directores args=($_args)
  # parse directory
  for arg ($*) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  args+=("--size=-1M")
  directores=(
    ${directores:+'^'}
    ${directores[@]}
  )
  
  fd -tf $args ${directores:-} |
    fzf --prompt 'Files> ' \
    --bind='alt-e:execute($EDITOR {+})' \
    --bind='enter:become($EDITOR {+})'
}

function :fd ()
{
  typeset -a directores args=($_args) 
  # parse directory
  for arg ($*) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
    }
    directores+=$arg
  }
  directores=(
    ${directores:+'^'}
    ${directores[@]}
  )
  fd -td $args ${directores:-} |
    fzf +m --prompt 'Dirs> ' \
    --bind='alt-e:execute($EDITOR {})' \
    --bind='enter:become($EDITOR {})'
}

function :fr ()
{
  typeset -a directores args=($_args)
  typeset date='1d'
  # parse directory
  if [[ $#* > 0 && ($1 =~ '^[0-9]+(d|h|weeks|min)$' || 
    $1 =~ '^[0-9]{2,4}-[0-9]{2}-[0-9]{2}$' ||
    $1 =~ '^[0-9]{2,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$') ]]; then 
    date=$1
    shift
  fi
  for arg (${*}) {
    if [[ ! -d $arg ]] {
      error "$arg not a directory"
      return -1
    }
    directores+=$arg
  }
  args+=("--changed-after=$date")
  directores=(
    ${directores:+'^'}
    ${directores[@]}
  )
  
  setopt pipefail
  fd -tf $args ${directores:-} |
    fzf --prompt 'Files> ' \
    --header 'CTRL-T: Switch between Files/Directories' \
    --bind="ctrl-t:transform:[[ ! \$FZF_PROMPT =~ Files ]] &&
              echo 'change-prompt(Files> )+reload(fd -tf $args ${directores:-})' ||
              echo 'change-prompt(Dirs> )+reload(fd -td $args ${directores:-})'" \
    --bind='alt-e:execute($EDITOR {+})' \
    --bind='enter:become($EDITOR {+})'
  
}


function :ctrl_findfiles ()
{
  ARGS=(
    $_args
    "--changed-after=30d"
    "--exclude=node_modules"
    "--exclude=.git"
    "--exclude=.github"
  )
  
  FLAG=/tmp/fzf-find$$
  trap "command rm -f $FLAG" EXIT SIGINT SIGTERM
  files=$(
    fd -tf $ARGS '^' ${SEARCH_DIRECTORES:-$HOME} |
      command fzf-tmux -p50%,60% --prompt 'Files> ' \
		  --select-1 \
		  --exit-0 \
		  --delimiter / \
		  --with-nth 4,-2,-1 \
      --bind="alt-e:transform:touch $FLAG; echo accept-non-empty" \
      --bind='enter:accept-non-empty'
  )
  
  [[ -n $files ]] && {
    open_files=()
    while read -r file 
    do 
      [[ -e $file ]] && open_files+=$file
    done < <(echo $files)
    
    [[ -e $FLAG ]] && command fzf-tmux-menu $open_files || ${EDITOR} $open_files
  }

  
}

zle -N :ff
zle -N :fd
zle -N :fr
zle -N :ctrl_findfiles

bindkey -v '^F' :ctrl_findfiles
bindkey -a '^F' :ctrl_findfiles
