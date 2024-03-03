skip_global_compinit=1

export LANGUAGE="zh_CN.UTF-8"
export LANG="$LANGUAGE"
# export LC_ALL="$LANGUAGE"
# export LC_CTYPE="$LANGUAGE"

export TMP=${TMP:-${TMPDIR:-/tmp}}
export TMPDIR=$TMP

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

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
# TODO:
# export XDG_STATE_HOME="${HOME}/.local/share/state"

export XDG_DESKTOP_DIR="${HOME}/Desktop"
export XDG_DOWNLOAD_DIR="${HOME}/Downloads"
export XDG_TEMPLATES_DIR="${HOME}/Templates"
export XDG_PUBLICSHARE_DIR="${HOME}/Public"
export XDG_DOCUMENTS_DIR="${HOME}/Documents"
export XDG_MUSIC_DIR="${HOME}/Music"
export XDG_PICTURES_DIR="${HOME}/Pictures"
export XDG_VIDEOS_DIR="${HOME}/Videos"


export TERMINAL="alacritty"
export BROWSER="firefox"
export VISUAL="nvim"
export EDITOR="nvim"


export GIT_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"
export SYSTEMD_COLORS=1
export SYSTEMD_LOG_COLOR=1

# TODO:
# export GOPATH="${XDG_DATA_HOME}/go"
# export GOROOT="${XDG_DATA_HOME}/go"

#
export C_COPY_BIN='wl-copy'
export C_PASTE_BIN='wl-paste'
export C_GIT='https://github.com'
export C_GIT_HOME='https://github.com/MaJinjie'
export C_ZSH_DATA=$ZDOTDIR/data
export C_LOCAL_TOOLS="$HOME/.local/tools"
export C_COMPLETIONS_LOG="$C_ZSH_DATA/completions.log"
export RG_DEFAULT_OPTS="--line-number --no-heading --smart-case --color=always --colors 'path:fg:blue' --colors 'match:fg:Magenta' --colors 'match:style:bold'"
export FD_DEFAULT_OPTS="--hidden --follow --exclude '.git' --exclude 'node_modules'"

## 2 default 
export TERM='xterm-256color'
#export LS_COLORS="$(vivid generate catppuccin-mocha)"
export TERMINAL="alacritty"
export BROWSER="firefox"
export VISUAL="nvim"
export EDITOR="nvim"



## 4 history
export HISTFILE="$C_ZSH_DATA/history"
# 历史文件的最大条目数
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
# 历史文件的最大大小
export HISTFILESIZE=10000000
# date-format
#export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

## 5 man
export MANPAGER="sh -c 'col -bx | bat -l man --number'"
export MANROFFOPT="-c"

## 6 gh 
export GH_CONFIG_DIR=$XDG_CONFIG_HOME/gh
export GH_BROWSER=firefox
export GH_EDITOR=nvim 
export GH_TOKEN='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' 


# rualdi 
export _RAD_ALIASES_DIR="$XDG_CONFIG_HOME/rualdi"
export _RAD_NO_ECHO=0 
export _RAD_RESOLVE_SYMLINKS=0

## path
path=(
  $path
  "${HOME}/.local/bin"
  "${HOME}/.cargo/bin"
)

if [[ -o rcs && ! -o login ]]; then
  # setopt braceexpand
  if (( $+LF_LEVEL )); then
    setopt aliases
    declare -gx LFLOGF="${Zdirs[CACHE]}/lf-zsh.log"
    alias -g LFIO=&>>!"${LFLOGF:=/tmp/lf-zsh.log}"

    typeset -gaxU fpath
    zmodload -F zsh/parameter p:dirstack
    # autoload -Uz chpwd_recent_dirs add-zsh-hook
    # add-zsh-hook chpwd chpwd_recent_dirs
    autoload -Uz chpwd_recent_filehandler chpwd_recent_add zstyle+

    fpath=( ${ZDOTDIR}/functions/{lf_fns,lib} "${fpath[@]}" )
    autoload -Uz $^fpath[1,2]/*(:t)

    zstyle+ ':chpwd:*' recent-dirs-default true \
          + ''         recent-dirs-file    "$LF_DIRSTACK_FILE" \
          + ''         recent-dirs-max     20 \
          + ''         recent-dirs-prune   'pattern:/tmp(|/*)'

    function set-dirstack() {
      [[ -v dirstack ]] || typeset -gaU dirstack
      dirstack=(
        ${(u)^${(@fQ)$(<${$(zstyle -L ':chpwd:*' recent-dirs-file)[4]} 2>/dev/null)}[@]:#(\.|${PWD}|/tmp/*)}(N-/)
      )
    }
    # for func ($chpwd_functions) { $func }

    set-dirstack

    # chpwd_recent_filehandler
    # if [[ $reply[1] != $PWD ]]; then
    #   chpwd_recent_add $PWD && changed=1
    #   # zoxide add "$PWD"
    #
    #   (( changed )) && chpwd_recent_filehandler $reply
    # fi

    # setopt interactive_comments # allow comments in history
    # setopt interactive          # this is an interactive shell
    # setopt shin_stdin           # commands are being read from the standard input

    setopt aliases       # expand aliases
    setopt unset         # don't error out when unset parameters are used
    setopt sh_word_split # field split on unquoted
    setopt err_exit      # if cmd has a non-zero exit status, execute ZERR trap, if set, and exit
    setopt rc_quotes     # allow '' inside '' to indicate a single '
    setopt extended_glob # extension of glob patterns

    # setopt xtrace           # print commands and their arguments as they are executed
    # setopt source_trace     # print an informational message announcing name of each file it loads
    # setopt eval_lineno      # lineno of expr evaled using builtin eval are tracked separately of enclosing environment
    # setopt debug_before_cmd # run DEBUG trap before each command; otherwise it is run after each command
    # setopt err_returns      # if cmd has a non-zero exit status, return immediately from enclosing function
    # setopt traps_async      # while waiting for a program to exit, handle signals and run traps immediately

    # setopt localloops       # break/continue propagate out of function affecting loops in calling funcs
    # setopt localtraps       # global traps are restored when exiting function
    # setopt localoptions     # make options local to function
    # setopt localpatterns    # disable pattern matching

    setopt auto_cd             # if command name is a dir, cd to it
    setopt auto_pushd          # cd pushes old dir onto dirstack
    setopt pushd_ignore_dups   # don't push dupes onto dirstack
    setopt pushd_minus         # inverse meaning of '-' and '+'
    setopt pushd_silent        # don't print dirstack after 'pushd' / 'popd'
    setopt cd_silent           # don't print dirstack after 'cd'
    setopt cdable_vars         # if item isn't a dir, try to expand as if it started with '~'

    setopt rematch_pcre      # when using =~ use PCRE regex
    setopt glob_complete     # generate glob matches as completions
    setopt glob_dots         # do not require leading '.' for dotfiles
    setopt glob_star_short   # ** == **/*      *** == ***/*
    setopt case_paths        # nocaseglob + casepaths treats only path components containing glob chars as insensitive
    setopt numeric_glob_sort # sort globs numerically
    setopt no_nomatch        # don't print an error if pattern doesn't match
    setopt no_case_glob      # case insensitive globbing
    # setopt case_match      # when using =~ make expression sensitive to case
    # setopt csh_null_glob   # don't report if a pattern has no matches unless all do
    # setopt glob_assign     # expand globs on RHS of assignment
    # setopt glob_subst      # results from param exp are eligible for filename generation

    setopt short_loops          # allow short forms of for, repeat, select, if, function
    setopt no_rm_star_silent    # query the user before executing `rm *' or `rm path/*'
    setopt no_bg_nice           # don't run background jobs in lower priority by default
    setopt long_list_jobs       # list jobs in long format by default
    # setopt interactive_comments # allow comments in history
    # setopt notify               # report status of jobs immediately
    # setopt monitor              # enable job control
    # setopt auto_resume         # for single commands, resume matching jobs instead
    # setopt ksh_option_print    # print all options
    # setopt brace_ccl           # expand in braces, which would not otherwise, into a sorted list

    setopt c_bases              # 0xFF instead of 16#FF
    setopt c_precedences        # use precendence of operators found in C
    setopt octal_zeroes         # 077 instead of 8#77
    setopt multios              # perform multiple implicit tees and cats with redirection

    setopt hash_cmds     # save location of command preventing path search
    setopt hash_dirs     # when command is completed hash it and all in the dir
    # setopt hash_list_all # when a completion is attempted, hash it first

    setopt no_clobber      # don't overwrite files without >! >|
    setopt no_flow_control # don't output flow control chars (^S/^Q)
    setopt no_hup          # don't send HUP to jobs when shell exits
    setopt no_beep         # don't beep on error
    setopt no_mail_warning # don't print mail warning

    setopt hist_ignore_space      # don't add if starts with space
    setopt hist_ignore_dups       # do not enter command lines into the history list if they are duplicates
    setopt hist_reduce_blanks     # remove superfluous blanks from each command
    setopt hist_expire_dups_first # if the internal history needs to be trimmed, trim oldest
    setopt hist_fcntl_lock        # use fcntl to lock hist file
    setopt hist_subst_pattern     # allow :s/:& to use patterns instead of strings
    setopt extended_history       # add beginning time, and duration to history
    setopt append_history         # all zsh sessions append to history, not replace
    setopt share_history          # imports commands and appends, can't be used with inc_append_history
    setopt no_hist_no_functions   # don't remove function defs from history
  fi
fi

# vim: ft=zsh:et:sw=0:ts=2:sts=2:fdm=marker:fmr=[[[,]]]
