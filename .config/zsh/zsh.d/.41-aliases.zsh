##-g
alias -g H='--hidden' 
alias -g CA='--changed-after' 
alias -g X='| xargs -o'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
##+g
alias :q=exit
alias nv=neovide
alias t=tmux
## source
alias srce='source $ZDOTDIR/.zshenv'
alias srcr='source $ZDOTDIR/.zshrc'
alias nznote="vi $HOME/.note/zsh_plugins"

## nvim 
alias v='NVIM_APPNAME=nvim nvim'
alias vi='NVIM_APPNAME=nvim nvim'

typeset -A fd rg git nvim eza 
exec_aliases() {
  for exec_name ("$@") {
    if [[ ${+commands[$exec_name]} ]] {
      for k v (${(kvP)exec_name}) {
        aliases[${k}]=$v
      }
    }
  }
}

fd=(
  fd "fd --hidden"
  fm "$HOME/.local/bin/nvim/man"
  ff "$HOME/.local/bin/nvim/fd-files"
  fr "$HOME/.local/bin/nvim/fd-recent-all"
  fo "$HOME/.local/bin/nvim/fd-recent-nvim"
  fdd "$HOME/.local/bin/nvim/fd-directores"
)

rg=(
  ss "$HOME/.local/bin/nvim/rg"
  sr "$HOME/.local/bin/nvim/rg-recent-all"
  so "$HOME/.local/bin/nvim/rg-recent-nvim"

)

git=(
  ga "git add"
  gau "ga -u"
  gaa "ga --all"
  gs "git status"
  gss "gs -s"
  gc "git commit"
  gcm "git commit -m"
  gcr "gc --amend"
  gca "gc --all"
)

nvim=(
  vh "nvim-tmux-split -bfh"
  vl "nvim-tmux-split -fh"
  vj "nvim-tmux-split -fv"
  vk "nvim-tmux-split -bfv"
)


autoload -Uz after before
eza=(
  ls "eza -F --icons --group-directories-first"
  la "ls -a"
  lf "ls --only-files"
  lsi "ls --git-ignore"
  lsx 'ls -- *(*)' # executable
  lsl "ls -DT -L3"
  ls. "ls -d -- .*"

  #sort  modified < accessed < changed
  lse "la --sort=extension"
  lsc "la --sort=changed --reverse"
  lsa "la --sort=accessed --reverse"
  lsm "la --sort=modified --reverse"
  #sort 15
  lso "lsa -- *(-.DOa[1,15])"
  lsn "lsa -- *(-.Doa[1,15])"

  # Altered today
  lst 'lsm -d -- *(e-after today-N) .*(e-after today-N)'
  # Changed within last 8hrs
  lsh "lsm -d -- *(ch-8) .*(ch-8)"

  # ll
  ll "eza -alHgbF --git --icons --time-style long-iso --octal-permissions --group-directories-first"
  lli "ll --git-ignore"
  llf "ll --only-files"
  lld "ll -d"
  llx 'll -- *(*)' # executable
  lll "ll -DT -L3"
  #sort     
  lle "ll --sort=extension"
  llc "ll --sort=changed --reverse"
  lla "ll --sort=accessed --reverse"
  llm "ll --sort=modified --reverse"
  #sort 15
  llso "lla -- *(-.DOa[1,10])"
  llsn "lla -- *(-.Doa[1,10])"


  
  llt 'llm -d -- *(e-after today-N) .*(e-after today-N)'
  # Changed within last 4hrs
  llh "llm -d -- *(ch-8) .*(ch-8)"
  # dotfiles
  ll. "ll -d -- .*"
)

exec_aliases "fd" "rg" "git" "nvim" "eza"


##================================git^================================##
##================================git$================================##


##================================rustbin^================================##

## rualdi
(( ${+commands[rualdi]} && ${+commands[zoxide]} )) && {
  #alias cd=cd
  alias ci=cdi
  alias cm="rad"
  alias cs="radf -d"
  alias cf="radf"
}

##================================rustbin$================================##
##================================fd^================================##
(( ${+commands[fd]} )) && {
  # alias f='fd --follow'
  # alias ff='fd --follow -tf'
  # alias fd='fd --follow -td'
}

##================================fd$================================##
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
# alias https='export https_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'
# alias http='export http_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'



# alias -s

# alias -g
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
