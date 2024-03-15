# === Variables ========================================================== [[[
# LS_COLORS defined before zstyle
typeset -gx LS_COLORS="$(vivid -d $Zdirs[THEME]/vivid/filetypes.yml generate $Zdirs[THEME]/vivid/kimbie.yml)"
typeset -gx {ZLS_COLORS,TREE_COLORS}="$LS_COLORS"

# ]]]

# === Zsh Plugin Variables =============================================== [[[

##pre-directory-history
export PER_DIRECTORY_HISTORY_BASE="$Zdirs[DATA]/.zsh_history_dirs"
export PER_DIRECTORY_HISTORY_TOGGLE="^G"
## forgit 
export FORGIT_COPY_CMD="$COPY_CMD_CLIP"

## zsh-you-should-use
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=BESTMATCH #ALL 
export YSU_HARDCORE=1
export YSU_IGNORED_ALIASES=()

## rualdi
export _RAD_ALIASES_DIR="$XDG_CONFIG_HOME/rualdi"
export _RAD_NO_ECHO=1
export _RAD_RESOLVE_SYMLINKS=1

## bkt 
export BKT_TTL='1m'
export BKT_CACHE_DIR=".bkt"
export BKT_TMPDIR="$XDG_DATA_HOME/bkt"

typeset -gx ZSH_AUTOSUGGEST_USE_ASYNC=
typeset -gx ZSH_AUTOSUGGEST_MANUAL_REBIND=set
typeset -gx ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1E624E,bold"
typeset -gx ZSH_AUTOSUGGEST_HISTORY_IGNORE=$'(*\n*|?(#c100,))' # no 100+ char
typeset -gx ZSH_AUTOSUGGEST_COMPLETION_IGNORE="[[:space:]]*" # no leading space
typeset -gx ZSH_AUTOSUGGEST_STRATEGY=(
  dir_history
  custom_history    match_prev_cmd
  completion
)

# typeset -gx ZSH_AUTOSUGGEST_STRATEGY=(
#   history
#   completion
# )
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( \
  vi-end-of-line \
  end-of-line \
)
  # vi-forward-char \
  # vi-forward-word vi-forward-word-end \
  # vi-forward-blank-word vi-forward-blank-word-end \
export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=( \
  forward-char \
  forward-word \
)

# typeset -gx HISTORY_SUBSTRING_SEARCH_FUZZY=set
# typeset -gx HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=set
# typeset -gx AUTOPAIR_CTRL_BKSPC_WIDGET=".backward-kill-word"
# typeset -ga chpwd_dir_history_funcs=( "_dircycle_update_cycled" ".zinit-cd" )
# typeset -g  PER_DIRECTORY_HISTORY_BASE="${ZPFX}/share/per-directory-history"
# ]]]

# return
# === Fzf ================================================================ [[[

FZF_COLORS="--color=hl:yellow:bold,hl+:yellow:reverse,pointer:032,marker:010"
FZF_HISTFILE="$XDG_CACHE_HOME/fzf/history"
FZF_FILE_PREVIEW="([[ -f {} ]] && (bkt -- bat --style=numbers --color=always -- {}))"
FZF_DIR_PREVIEW="([[ -d {} ]] && (bkt -- eza -T {} | bat --color=always))"
FZF_BIN_PREVIEW="([[ \$(file --mime-type -b {}) = *binary* ]] && (echo {} is a binary file))"

export FZF_COLORS FZF_HISTFILE FZF_FILE_PREVIEW FZF_DIR_PREVIEW FZF_BIN_PREVIEW

[[ ! -d $XDG_CACHE_HOME/fzf ]] && mkdir $XDG_CACHE_HOME/fzf 

# return
export FZF_DEFAULT_OPTS=" \
--marker='▍' \
--scrollbar='█' \
--ellipsis='' \
--cycle \
$FZF_COLORS \
--reverse \
--info=inline \
--ansi \
--multi \
--border=horizontal \
--height=80% \
--tabstop=4 \
--history=$FZF_HISTFILE \
--jump-labels='abcdefghijklmnopqrstuvwxyz' \
--preview-window :hidden \
--preview=\"($FZF_FILE_PREVIEW || $FZF_DIR_PREVIEW) 2>/dev/null | head -200\" \
--bind='ctrl-/:change-preview-window(right,60%,border-vertical|up,60%,border-horizontal)' \
--bind='esc:abort' \
--bind='ctrl-q:abort' \
--bind='ctrl-c:cancel' \
--bind='ctrl-j:down' \
--bind='ctrl-k:up' \
--bind='alt-j:prev-selected' \
--bind='alt-k:next-selected' \
--bind='home:beginning-of-line' \
--bind='end:end-of-line' \
--bind='ctrl-e:end-of-line' \
--bind='alt-a:toggle-all' \
--bind='ctrl-p:prev-history' \
--bind='ctrl-n:next-history' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-b:preview-page-up' \
--bind='ctrl-f:preview-page-down' \
--bind='ctrl-\:jump' \
--bind='ctrl-g:toggle-preview' \
--bind='alt-e:execute($EDITOR {+})' \
--bind='alt-b:execute(bat --paging=always -f {+})' \
--bind='ctrl-y:execute-silent(wl-copy -n {+})' \
--bind 'enter:accept' \
"

export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_COMMAND="fd --color=always"

return
export FZF_TMUX=1
#export TMUX_PANE 
#export FZF_TMUX_HEIGHT
#export FZF_COMPLETION_OPTS
#export FZF_LAYOUT_RIGHT="--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' -r 60%" 
#export FZF_LAYOUT_UP="-u 60% --preview-window 'right,60%,border-left,+{2}+3/3,~3'"

export FZF_TMUX_OPTS='-p -w 60% -h 50% -m'
export FZF_COMPLETION_TRIGGER='\'








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
