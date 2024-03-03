alias q=exit
alias nv=neovide 
alias v=nvim
alias t=tmux
alias y=yazi
alias ls='ls --color=auto --sort=time --group-directories-first'
alias ll='ls --color=auto --sort=time --group-directories-first -l'
alias fd="fd ${FD_DEFAULT_OPTS}"
alias cat='bat --paging=never'
alias frg="$XDG_CONFIG_HOME/fzf/scripts/rg.zsh"
alias ffd="$XDG_CONFIG_HOME/fzf/scripts/fd.zsh"
alias fps="$XDG_CONFIG_HOME/fzf/scripts/ps.zsh"
alias fkll="$XDG_CONFIG_HOME/fzf/scripts/kill.zsh"



# fzf-marks 
alias zm=fzm 
alias cm=mark

alias pc=proxychains
alias https='export https_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'
alias http='export http_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'



# alias -s 

# alias -g 
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

