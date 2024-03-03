#!/bin/env zsh 

while {read file} {
  [[ ! -f "$ZDOTDIR/plugins/others/$file.zsh" ]] && echo "$ZDOTDIR/plugins/others/$file.zsh Not Found" || source "$ZDOTDIR/plugins/others/$file.zsh"
} <<-EOF
env
keybindings
options
EOF

