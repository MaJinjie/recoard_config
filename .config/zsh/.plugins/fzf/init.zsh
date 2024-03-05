#!/bin/env zsh
# fzf env
export FZF_TMUX=1
#export TMUX_PANE 
#export FZF_TMUX_HEIGHT
#export FZF_COMPLETION_OPTS
#export FZF_LAYOUT_RIGHT="--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' -r 60%" 
#export FZF_LAYOUT_UP="-u 60% --preview-window 'right,60%,border-left,+{2}+3/3,~3'"

export FZF_TMUX_OPTS='-p -w 60% -h 50% -m'
export FZF_COMPLETION_TRIGGER='\'

export FZF_DEFAULT_COMMAND="fd $FD_DEFAULT_OPTS"
export FZF_DEFAULT_OPTS=" \
--color='hl:yellow:bold,hl+:yellow:reverse,pointer:032,marker:010' \
--marker='✓' \
--bind 'ctrl-z:jump-accept' \
--bind '\:toggle-preview' \
--bind 'ctrl-a:toggle-all' \
--bind 'ctrl-\:change-preview-window(right|up)' \
--bind 'enter:accept' \
--bind 'ctrl-e:execute('$EDITOR' {})' \
--layout=reverse \
--info=inline \
--height=60% \
--multi \
--preview-window :hidden \
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200' \
"

# export FZF_DEFAULT_OPTS=" \
# --color='hl:yellow:bold,hl+:yellow:reverse,pointer:032,marker:010,bg+:237,gutter:008' \
# --color=query:51,info:43:bold,border:33,separator:51,scrollbar:51 \
# --color=label:27,preview-label:27 \
# --pointer='▶' --marker='✓' \
# --bind 'ctrl-z:jump-accept' \
# --bind '\:toggle-preview' \
# --bind 'ctrl-a:toggle-all' \
# --bind 'ctrl-\:change-preview-window(right|up)' \
# --bind 'enter:accept' \
# --layout=reverse \
# --info=inline \
# --border \
# --height=60% \
# --multi \
# --preview-window :hidden \
# --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200' \
# "
# custom path
export C_FZF_TMP_RESULT="/tmp/fzf/result"
export C_FZF_TMP_FIFO="/tmp/fzf/fifo"
export C_FZF_TMP="/tmp/fzf"
export C_FZF_TMP_FAILURE="/tmp/fzf/failure"


# Auto-completion
if [[ -f $ZDOTDIR/plugins/fzf/default/completion.zsh ]] {
  source $ZDOTDIR/plugins/fzf/default/completion.zsh 
} else {
  source "$FZF_INSTALL_PATH/shell/completion.zsh"
}

# Key bindings
if [[ -f $ZDOTDIR/plugins/fzf/default/key-bindings.zsh ]] {
  source $ZDOTDIR/plugins/fzf/default/key-bindings.zsh 
} else {
  source "$FZF_INSTALL_PATH/shell/key-bindings.zsh"
} 


# custom completion
for file ($(print $ZDOTDIR/plugins/fzf/completions/* )) {
  [[ $file =~ ".+\.zsh" ]] && source $file
}


[[ ! -d $C_FZF_TMP ]] && mkdir $C_FZF_TMP || true
[[ ! -d $C_FZF_TMP_RESULT ]] && mkdir $C_FZF_TMP_RESULT || true
[[ ! -d $C_FZF_TMP_FIFO ]] && mkdir $C_FZF_TMP_FIFO || true
[[ ! -d $C_FZF_TMP_FAILURE ]] && mkdir $C_FZF_TMP_FAILURE || true
