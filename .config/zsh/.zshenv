skip_global_compinit=1

export LANGUAGE="zh_CN.UTF-8"
export LANG="$LANGUAGE"
# export LC_ALL="$LANGUAGE"
# export LC_CTYPE="$LANGUAGE"

export TMP=${TMP:-${TMPDIR:-/tmp}}
export TMPDIR=$TMP

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

export XDG_DESKTOP_DIR="${HOME}/Desktop"
export XDG_DOWNLOAD_DIR="${HOME}/Downloads"
export XDG_TEMPLATES_DIR="${HOME}/Templates"
export XDG_PUBLICSHARE_DIR="${HOME}/Public"
export XDG_DOCUMENTS_DIR="${HOME}/Documents"
export XDG_MUSIC_DIR="${HOME}/Music"
export XDG_PICTURES_DIR="${HOME}/Pictures"
export XDG_VIDEOS_DIR="${HOME}/Videos"

export CUSTOM_HOME="$HOME/.custom"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"    # only one that is actually needed
export ZROOT="$ZDOTDIR"                    # alias for $ZDOTDIR
export ZUSRDIR="${ZROOT}/usr"
export ZRCDIR="${ZROOT}/zsh.d"           # zsh config dir
export ZSRCDIR="${ZROOT}/src"            # zsh config dir
export ZDATADIR="${ZROOT}/data"
export ZCACHEDIR="${ZROOT}/cache"
export ZSH_CACHE_DIR="${ZCACHEDIR}/zinit"

typeset -a Zdirs__FUNC_reg=(lib utils zonly)     # + functions
typeset -a Zdirs__FUNC_zwc=(hooks widgets wrap)  # + completions
typeset -a Zdirs__FUNC=("$Zdirs__FUNC_reg[@]" "$Zdirs__FUNC_zwc[@]")
typeset -a Zdirs__ZWC=(
  $ZROOT/functions/${^Zdirs__FUNC_zwc[@]}
  $ZROOT/completions
  $ZROOT/.zshrc
  $ZROOT/.zshenv
)

declare -gxA Zdirs=(
  ROOT       $ZROOT
  RC         $ZRCDIR
  SRC        $ZSRCDIR
  USR        $ZUSRDIR
  DATA       $ZDATADIR
  CACHE      $ZCACHEDIR
  MAN        $ZDOTDIR/man
  COMPL      $ZDOTDIR/completions
  PATCH      $ZDOTDIR/patches
  THEME      $ZDOTDIR/themes
  PLUG       $ZDOTDIR/plugins
  SNIP       $ZDOTDIR/snippets
  ALIAS      $ZDOTDIR/aliases
  
  FUNC       $ZDOTDIR/functions
  FUNC_D_reg Zdirs__FUNC_reg
  FUNC_D_zwc Zdirs__FUNC_zwc
  FUNC_D     Zdirs__FUNC
  ZWC        Zdirs__ZWC
)

export TERMINAL="alacritty"
export BROWSER="firefox"
export VISUAL="nvim"
export EDITOR="nvim"


export GIT_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"
export SYSTEMD_COLORS=1
export SYSTEMD_LOG_COLOR=1



# 在alacritty中，以tmux作为第一个启动，并不会执行.zshrc,需要提前声明PATH
# typeset -TU PATH path
# path=( 
#   "${path[@]:#}"
#   "$ZDOTDIR/zinit/polaris/bin"
#   "$HOME/.local/bin"
#   "$HOME/.local/bin/fzf"
#   "$HOME/.local/bin/tmux"
#   "$CARGO_HOME/bin"
#   "$RUSTUP_HOME/bin"
# )
#
# [[ -v TMUX_SESSION ]] && {
#   FZF_COLORS="--color=hl:yellow:bold,hl+:yellow:reverse,pointer:032,marker:010"
#   FZF_HISTFILE="$XDG_CACHE_HOME/fzf/history"
#   FZF_FILE_PREVIEW="([[ -f {} ]] && (bkt -- bat --style=numbers --color=always -- {}))"
#   FZF_DIR_PREVIEW="([[ -d {} ]] && (bkt -- eza -T {} | bat --color=always))"
#   FZF_BIN_PREVIEW="([[ \$(file --mime-type -b {}) = *binary* ]] && (echo {} is a binary file))"
#   export FZF_DEFAULT_OPTS=" \
#   --marker='▍' \
#   --scrollbar='█' \
#   --ellipsis='' \
#   --cycle \
#   $FZF_COLORS \
#   --reverse \
#   --info=inline \
#   --ansi \
#   --multi \
#   --height=80% \
#   --tabstop=4 \
#   --history=$FZF_HISTFILE \
#   --jump-labels='abcdefghijklmnopqrstuvwxyz' \
#   --preview-window :hidden \
#   --preview=\"($FZF_FILE_PREVIEW || $FZF_DIR_PREVIEW) 2>/dev/null | head -200\" \
#   --bind='ctrl-/:change-preview-window(up,65%,border-horizontal|right,60%,border-vertical)' \
#   --bind='ctrl-j:ignore' \
#   --bind='ctrl-k:ignore' \
#   --bind='esc:abort' \
#   --bind='ctrl-q:abort' \
#   --bind='ctrl-c:cancel' \
#   --bind='alt-j:down' \
#   --bind='alt-k:up' \
#   --bind='home:beginning-of-line' \
#   --bind='end:end-of-line' \
#   --bind='ctrl-e:end-of-line' \
#   --bind='alt-a:toggle-all' \
#   --bind='ctrl-p:prev-history' \
#   --bind='ctrl-n:next-history' \
#   --bind='ctrl-d:half-page-down' \
#   --bind='ctrl-b:preview-page-up' \
#   --bind='ctrl-f:preview-page-down' \
#   --bind='?:jump' \
#   --bind='ctrl-\:toggle-preview' \
#   --bind='alt-e:become($EDITOR {+})' \
#   --bind='alt-b:become(bat --paging=always -f {+})' \
#   --bind='ctrl-y:execute-silent(wl-copy -n {+})' \
#   --bind 'enter:accept' \
#   --bind='alt-s:become(tmux-fzf-panes)' \
#   --bind='alt-v:become(nvim-tmux -fv {+})' \
#   --bind='alt-t:become(nvim-tmux -bfh {+})' \
#   --bind='alt-h:become(nvim-tmux -bfh {+})' \
#   "
# }


# vim: ft=zsh:et:sw=0:ts=2:sts=2:fdm=marker:fmr=[[[,]]]
