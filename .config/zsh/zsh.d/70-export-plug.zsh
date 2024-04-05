# === Variables ========================================================== [[[
# LS_COLORS defined before zstyle
typeset -gx LS_COLORS="$(vivid -d $Zdirs[THEME]/vivid/filetypes.yml generate $Zdirs[THEME]/vivid/kimbie.yml)"
typeset -gx {ZLS_COLORS,TREE_COLORS}="$LS_COLORS"

# ]]]

# === custom ============================================================= [[[


# ]]]


# === Fzf ================================================================ [[[

FZF_COLORS="--color=hl:yellow:bold,hl+:yellow:reverse,pointer:032,marker:010,bg+:-1,border:#808080"
FZF_HISTFILE="$XDG_CACHE_HOME/fzf/history"
FZF_FILE_PREVIEW="([[ -f {} ]] && (bkt --ttl 1m -- bat --style=numbers --color=always -- {}))"
FZF_DIR_PREVIEW="([[ -d {} ]] && (bkt --ttl 1m -- eza --color=always -TL4  {} | bat --color=always))"
FZF_BIN_PREVIEW="([[ \$(file --mime-type -b {}) = *binary* ]] && (echo {} is a binary file))"

export FZF_COLORS FZF_HISTFILE FZF_FILE_PREVIEW FZF_DIR_PREVIEW FZF_BIN_PREVIEW


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
--height=80% \
--tabstop=4 \
--scroll-off=2 \
--keep-right \
--history=$FZF_HISTFILE \
--jump-labels='abcdefghijklmnopqrstuvwxyz' \
--preview-window :hidden \
--preview=\"($FZF_FILE_PREVIEW || $FZF_DIR_PREVIEW) 2>/dev/null | head -300\" \
--bind='home:beginning-of-line' \
--bind='end:end-of-line' \
--bind='tab:toggle+down' \
--bind='btab:up+toggle' \
--bind='esc:abort' \
--bind='ctrl-u:unix-line-discard' \
--bind='ctrl-w:backward-kill-word' \
--bind='ctrl-y:execute-silent(wl-copy -n {+})' \
--bind='ctrl-/:change-preview-window(up,60%,border-down|right,60%,border-left)' \
--bind='ctrl-\:toggle-preview' \
--bind='ctrl-q:abort' \
--bind='ctrl-l:clear-selection+first' \
--bind='ctrl-j:down' \
--bind='ctrl-k:up' \
--bind='ctrl-p:prev-history' \
--bind='ctrl-n:next-history' \
--bind='ctrl-d:half-page-down' \
--bind='ctrl-x:replace-query' \
--bind='alt-j:preview-down' \
--bind='alt-k:preview-up' \
--bind='ctrl-b:beginning-of-line' \
--bind='ctrl-e:end-of-line' \
--bind='alt-a:toggle-all' \
--bind='alt-s:toggle-sort'
--bind='alt-w:toggle-preview-wrap'
--bind='alt-b:preview-page-up' \
--bind='alt-f:preview-page-down' \
--bind='alt-enter:print-query' \
--bind='?:jump' \
--bind='enter:accept' \
"

export FZF_TMUX_OPTS="-p70%,80%"

export FZF_COMPLETION_TRIGGER='\'
export FZF_DEFAULT_COMMAND="fd --color=always"


[[ ! -d $XDG_CACHE_HOME/fzf ]] && mkdir $XDG_CACHE_HOME/fzf 

if [[ -n $TMUX_PANE ]] && (( $+commands[tmux] )) && (( $+commands[fzfp] )); then
    # fallback to normal fzf if current session name is `floating`
    # export TMUX_POPUP_NESTED_FB='test $(tmux display -pF "#{==:#S,floating}") == 1'
    export TMUX_POPUP_WIDTH=60%
    export TMUX_POPUP_HEIGHT=75%
fi

# === Zsh Plugin Variables =============================================== [[[

## zsh-z 
export ZSHZ_DATA="$XDG_CACHE_HOME/zshz/z"
export ZSHZ_TILDE=1
export ZSHZ_TRAILING_SLASH=1
export ZSHZ_CASE=smart

##pre-directory-history
export PER_DIRECTORY_HISTORY_BASE="$Zdirs[DATA]/.zsh_history_dirs"
export PER_DIRECTORY_HISTORY_TOGGLE="^G"
## forgit 
export forgit_add=:ga
export forgit_log=:gl
export forgit_diff=:gd
export forgit_reset_head=grh
export forgit_ignore=gi
export forgit_checkout_file=gcf
export forgit_checkout_branch=gcb
export forgit_branch_delete=gbd
export forgit_checkout_tag=gct
export forgit_checkout_commit=gco
export forgit_revert_commit=grc
export forgit_clean=gclean
export forgit_stash_show=gss
export forgit_stash_push=gsp
export forgit_cherry_pick=gcp
export forgit_rebase=grb
export forgit_blame=gbl
export forgit_fixup=gfu
export FORGIT_COPY_CMD="wl-copy"
export FORGIT_FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS}


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
typeset -gx ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=25
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1E624E,bold"
# typeset -gx ZSH_AUTOSUGGEST_HISTORY_IGNORE=("cd *")
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
