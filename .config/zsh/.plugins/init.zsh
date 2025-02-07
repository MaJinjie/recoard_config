#!/bin/env zsh

# === general settings === [[[
0="${${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}:A}"

umask 022
# limit corefile size 
# ulimit -c 0 阻止生产core 文件
# ulimit -a 查看core 文件选项
limit coredumpsize unlimited

(( $UID == 0 )) && { unset HISTFILE && SAVEHIST=0; }
typeset -gaxU path fpath manpath infopath cdpath mailpath
typeset -fuz zkbd
typeset -ga mylogs
typeset -F4 SECONDS=0

typeset -g  sourcestart
typeset -ga files;   files=($ZRCDIR/*.zsh(N.,@))
typeset -ga sourced; sourced=()

zmodload -i zsh/zprof
zmodload -i zsh/datetime
function zflai-msg()    { mylogs+=( "$1" ); }
function zflai-assert() { mylogs+=( "$4"${${${1:#$2}:+FAIL}:-OK}": $3" ); }
function zflai-log()    { zflai-msg "[$1]: $2: ${(M)$((($EPOCHREALTIME-${3}) * 1000))#*.?}ms ${4:-}" }
function zflai-print()  {
  print -rl -- ${(%)mylogs//(#b)(\[*\]): (*)/"%F{1}$match[1]%f: $match[2]"};
}
# @desc write zprof to $mylogs
function zflai-zprof() {
  local -a arr; arr=( ${(@f)"$(zprof)"} )
  local idx; for idx ({3..7}) {
    zflai-msg "[zprof]: ${arr[$idx]##*)[[:space:]]##}"
  }
}

zflai-msg "[path]: ${${(pj:\n\t:)path}}"
source $ZRCDIR/*-options.zsh
zflai-msg "[file]:   => 00-options.zsh"

## Added by Zinit's installer
if [[ ! -f $XDG_DATA_HOME/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$XDG_DATA_HOME/zinit" && command chmod g-rwX "$XDG_DATA_HOME/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$XDG_DATA_HOME/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
## config var 

declare -A ZINIT
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit 
ZINIT[NO_ALIASES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions


source "$XDG_DATA_HOME/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
#     atpull'%atclone' pick"clrs.zsh" nocompile'!' \
#     atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
# zinit light trapd00r/LS_COLORS

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit load agkozak/zsh-z

zinit as'program' pick="$ZPFX/bin/(fzf|fzf-tmux)" \
    atclone='./install --bin; cp bin/(fzf|fzf-tmux) $ZPFX/bin; cp man/man1/* $ZPFX/man/man1' atpull'%atclone' for junegunn/fzf

zinit as'null' wait'2' from'gh-r' bpick"*linux*" lucid for \
  completions sbin"fd" atclone'cp fd.1 $ZPFX/man/man1' atpull'%atclone' @sharkdp/fd \
  completions sbin"rg" atclone'cp doc/rg.1 $ZPFX/man/man1' atpull'%atclone' BurntSushi/ripgrep \
  sbin"bob" atclone"bob complete zsh > $ZINIT[COMPLETIONS_DIR]/_bob" atpull"%atclone" MordechaiHadad/bob \

zinit light Aloxaf/fzf-tab

echo "${${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}:A}"

while {read line} {
  config_path=$ZDOTDIR/plugins/$line
  if [[ -d $config_path ]] {
    source $config_path/init.zsh
  } elif [[ -f $config_path.zsh ]] {
    source $config_path.zsh && true || false
  } else {
    print "$config_path Not Found"
  }
} <<-EOF 
p10k
fzf
others
EOF
