#!/bin/env zsh 

while {read file} {
  [[ ! -f "$ZDOTDIR/zsh.d/$file.zsh" ]] && echo "$ZDOTDIR/zsh.d/$file.zsh Not Found" || source "$ZDOTDIR/zsh.d/$file.zsh"
} <<-EOF
env
options
alias
keybindings
widgets
EOF

