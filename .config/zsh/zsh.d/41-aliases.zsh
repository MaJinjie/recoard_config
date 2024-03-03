##-g 

##+g
alias :q=exit
alias nv=neovide 
alias vi=nvim
alias t=tmux
alias y=yazi
alias cat='bat --paging=never'
alias frg="$XDG_CONFIG_HOME/fzf/scripts/rg.zsh"
alias ffd="$XDG_CONFIG_HOME/fzf/scripts/fd.zsh"
alias fps="$XDG_CONFIG_HOME/fzf/scripts/ps.zsh"
alias fkll="$XDG_CONFIG_HOME/fzf/scripts/kill.zsh"
## source 
alias srce='source $ZDOTDIR/.zshenv'
alias srcr='source $ZDOTDIR/.zshrc'
alias nznote="vi $HOME/.note/zsh_plugins"

##================================rustbin^================================##
alias hyf=hyperfine
alias dus=diskus

## rualdi
(( ${+commands[rualdi]} && ${+commands[zoxide]} )) && {
  #alias cd=cd
  alias ci=cdi
  alias cm="rad"
  alias cs="radf -d"
  alias cf="radf"
}

##================================rustbin$================================##
## ls 
(( ${+commands[eza]} )) && {
  autoload -Uz after before
  local LS="eza -F --icons"
  local LL="eza -alHgbF --git --icons --time-style long-iso --octal-permissions"
  local HOURS=4
  
  alias exa="eza"
  alias ls="$LS --group-directories-first"
  alias lsa="ls -a"
  alias lsd="lsa --only-dirs"
  alias lsf="lsa --only-files"
  alias lsi="ls --git-ignore"
  alias ls,="ls -d"
  alias lsx='ls -- *(*)' # executable
  
  #tree
  alias ls1="ls -DT -L1"
  alias ls2="ls -DT -L2"
  alias ls3="ls -DT -L3"
  alias ls4="ls -DT -L4"
  alias ls5="ls -DT -L5"
  alias lsl="ls -DT -L"
  
  alias lsa1="lsa -T -L1"
  alias lsa2="lsa -T -L2"
  alias lsa3="lsa -T -L3"
  alias lsa4="lsa -T -L4"
  alias lsa5="lsa -T -L5"
  alias lsal="lsa -T -L"
  
  
  #sort accessed < modified < changed
  alias lse="lsa --sort=extension"
  alias lss="lsa --sort=accessed --reverse"
  alias lsc="lsa --sort=changed --reverse"
  alias lsm="lsa --sort=modified --reverse"
  #sort 10
  alias lsso="lss -- *(-.DOa[1,10])"
  alias lssn="lss -- *(-.Doa[1,10])"
  alias lsmo="lsm -- *(-.DOa[1,10])"
  alias lsmn="lsm -- *(-.Doa[1,10])"
  alias lsco="lsc -- *(-.DOa[1,10])"
  alias lscn="lsc -- *(-.Doa[1,10])"

  
  alias ll="$LL --group-directories-first"
  alias lla="ll --all"
  alias lln="lla --numeric"
  alias lli="lla --git-ignore"
  alias lld="lla --only-dirs"
  alias llf="lla --only-files"
  alias ll,="lla -d"
  alias llx='lla -- *(*)' # executable
  
  
  #tree
  alias ll1="ll -DT -L1"
  alias ll2="ll -DT -L2"
  alias ll3="ll -DT -L3"
  alias ll4="ll -DT -L4"
  alias ll5="ll -DT -L5"
  alias lll="ll -DT -L"
         
  alias lla1="lla -T -L1"
  alias lla2="lla -T -L2"
  alias lla3="lla -T -L3"
  alias lla4="lla -T -L4"
  alias lla5="lla -T -L5"
  alias llal="lla -T -L"
  
  #sort 
  alias lle="lla --sort=extension"
  alias lls="lla --sort=accessed --reverse"
  alias llc="lla --sort=changed --reverse"
  alias llm="lla --sort=modified --reverse"
  #sort 10
  alias llso="lls -- *(-.DOa[1,10])"
  alias llsn="lls -- *(-.Doa[1,10])"
  alias llco="llc -- *(-.DOa[1,10])"
  alias llcn="llc -- *(-.Doa[1,10])"
  alias llmo="llm -- *(-.DOa[1,10])"
  alias llmn="llm -- *(-.Doa[1,10])"
  
  
  # Altered today
  alias lsat='lsm -d -- *(e-after today-N) .*(e-after today-N)'
  # Altered before today
  alias lsbt='lsm -d -- *(e-before today-N) .*(e-before today-N)'
  # Changed at least 4hrs ago
  alias lsbh="lsm -d -- *(ch+$HOURS) .*(ch+$HOURS)"
  # Changed within last 4hrs
  alias lsah="lsm -d -- *(ch-$HOURS) .*(ch-$HOURS)"
  
  alias llat='llm -d -- *(e-after today-N) .*(e-after today-N)'
  # Altered before today
  alias llbt='llm -d -- *(e-before today-N) .*(e-before today-N)'
  # Changed at least 4hrs ago
  alias llbh="llm -d -- *(ch+$HOURS) .*(ch+$HOURS)"
  # Changed within last 4hrs
  alias llah="llm -d -- *(ch-$HOURS) .*(ch-$HOURS)"
  
  alias lsh='lsah'
  alias llh='llah'
  alias lst='lsat'
  alias llt='llat'
  
  # dotfiles 
  alias ls.="ls -d -- .*"
  alias ls.f="ls -d -- .*(-.N)"
  alias ls.d="ls -d -- .*(-^N.D)"
  alias ll.="ll -d -- .*"
  alias ll.f="ll -d -- .*(-N)"
  alias ll.d="ll -d -- .*(-^N.D)"
}


alias pc=proxychains
alias https='export https_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'
alias http='export http_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'



# alias -s 

# alias -g 
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

