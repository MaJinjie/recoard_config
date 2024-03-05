#!/bin/env zsh
skip_global_compinit=1
# Check if zplug is installed
export ZPLUG_HOME=$ZPLUG_INSTALL_PATH
#export ZPLUG_PROTOCAL="SSH"
export ZPLUG_BIN='/usr/local/bin'
export ZPLUG_USE_CACHE=true
export ZPLUG_CACHE_DIR="$XDG_CACHE_HOME/zplug"

ZPLUG_LOADFILE="$XDG_CONFIG_HOME/zsh/plugins.zsh"



if [[ ! -d ${ZPLUG_HOME} ]] {
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source $ZPLUG_HOME/init.zsh && zplug update --self
}
autoload -U compinit && compinit -u -C -d "$C_ZSH_DATA/zcompdump"
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "tj/git-extras", use:"etc/git-extras-completion.zsh", defer:2, if:"[[ $(command -v git) ]]"
zplug "zsh-users/zsh-completions", depth:1
zplug "zdharma-continuum/fast-syntax-highlighting", defer:3
zplug "zsh-users/zsh-autosuggestions", as:plugin, from:github
zplug "agkozak/zsh-z", as:plugin, use:"*.plugin.zsh", defer:1
zplug "urbainvaes/fzf-marks", as:plugin, use:"init.zsh"

# tool 
zplug "junegunn/fzf", as:command, use:"bin", depth:1, hook-build:"./install --bin"
zplug "sxyazi/yazi", as:command, use:"target/release", hook-build:"cargo build --release", if:"[[ $(command -v cargo) ]]"



if ! zplug check; then
  echo 'you have uninstall package'
fi
zplug load


while {read line} {
  abs_path=$ZDOTDIR/plugins/$line
  if [[ -d $abs_path ]] {
    source $abs_path/init.zsh
  } elif [[ -f $abs_path.zsh ]] {
    source $abs_path.zsh && true || false
  } else {
    print "$abs_path Not Found"
  }
} <<-EOF 
zsh-z
fzf
p10k
EOF
