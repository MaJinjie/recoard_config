##-g
# alias -g H='--hidden'
# alias -g CA='--changed-after'
# alias -g X='| xargs -o'
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
# alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
##+g
alias :q=exit
alias nv=neovide
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
    fm "$CUSTOM_HOME/scripts/fzf/find-manpagers"
    fo "$CUSTOM_HOME/scripts/fzf/find-oldfiles"
    ff "$CUSTOM_HOME/scripts/fzf/find-files"
    fg "$CUSTOM_HOME/scripts/fzf/find-gitfiles"
    ja "$CUSTOM_HOME/scripts/fzf/directores-actions"
)

rg=(
    ss "$CUSTOM_HOME/scripts/fzf/search-string"
)

git=(
    ga "git add"
    gau "ga -u"
    gaa "ga --all"
    gs "git status -s"
    gc "git commit"
    gca "gc --all"
    gcf "gc --file=.commit.md"
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
alias pc=proxychains
# alias https='export https_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'
# alias http='export http_proxy=socks5://qlyun:qlyun@54.242.216.72:3636'
