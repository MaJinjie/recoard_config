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

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

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
  BIN        $ZDOTDIR/bin
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


### 1 Custom 
#export C_GIT='https://github.com'
#export C_GIT_HOME='https://github.com/MaJinjie'
#export C_ZSH_DATA=$ZDOTDIR/data
#export FD_DEFAULT_OPTS="--hidden --follow --exclude '.git' --exclude 'node_modules'"
#
### 2 default 
#export TERM='xterm-256color'
##export LS_COLORS="$(vivid generate catppuccin-mocha)"
#export TERMINAL="alacritty"
#export BROWSER="firefox"
#export VISUAL="nvim"
#export EDITOR="nvim"
#
### 3 config path 
#export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/ripgreprc
#
#
### 4 history
#export HISTFILE="$C_ZSH_DATA/history"
## 历史文件的最大条目数
#export HISTSIZE=50000
#export SAVEHIST=$HISTSIZE
## 历史文件的最大大小
#export HISTFILESIZE=10000000
## date-format
##export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
#
### 5 man
#export MANPAGER="sh -c 'col -bx | bat -l man --number'"
#export MANROFFOPT="-c"
#
### 6 gh 
#export GH_CONFIG_DIR=$XDG_CONFIG_HOME/gh
#export GH_BROWSER=firefox
#export GH_EDITOR=nvim 
#export GH_TOKEN='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' 

# vim: ft=zsh:et:sw=0:ts=2:sts=2:fdm=marker:fmr=[[[,]]]
