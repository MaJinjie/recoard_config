if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] {
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
}
# === general settings === [[[
0="${${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}:A}"
umask 022
# limit corefile size 
# ulimit -c 0 阻止生产core 文件
# ulimit -a 查看core 文件选项
limit coredumpsize unlimited
(( $UID == 0 )) && { unset HISTFILE && SAVEHIST=0; }

typeset -gaxU fpath
typeset -ga mylogs
typeset -ga files;  files=($ZRCDIR/*.zsh(N.,@));  files=(${(@)files:t})
typeset -ga sourced
typeset -g  sourcestart
typeset -F4 SECONDS=0

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


function extractf () {
  # set -x
  sourcestart=$EPOCHREALTIME
  sourced=()
  local filename file
  for filename ($@) {
    file=${files[${files[(i)*$filename*]}]}
    [[ ! -z $file ]] && {
      sourced+=$file
      zflai-msg "[file]:   => $file"
    } || {
      zflai-msg "[nofile]:   => $file"
    }
  }
  files=(${files[@]:|sourced})
  # set +x
  
}
function sourcef() {
  # set -x
  for file ($sourced[@]) {
    source $ZRCDIR/$file
  }
  # set +x
}

extractf options export; sourcef

# echo "[files]:${${(pj:\n\t:)files}}"

local null="zdharma-continuum/null"
declare -gx ZINIT_HOME="${0:h}/zinit"
declare -gA ZINIT=(
  HOME_DIR        ${0:h}/zinit
  BIN_DIR         ${0:h}/zinit/bin
  PLUGINS_DIR     ${0:h}/zinit/plugins
  SNIPPETS_DIR    ${0:h}/zinit/snippets
  COMPLETIONS_DIR ${0:h}/zinit/completions
  MODULE_DIR      ${0:h}/zinit/module
  # MAN_DIR         $ZPFX/share/man
  ZCOMPDUMP_PATH  ${ZSH_CACHE_DIR:-$XDG_CACHE_HOME}/zcompdump-${HOST/.*/}-${ZSH_VERSION}
  COMPINIT_OPTS   -C
  LIST_COMMAND    'eza --color=always --tree --icons -L3'
)

fpath=(
  ${0:h}/functions/${(P)^Zdirs[FUNC_D_reg]}
  ${0:h}/functions
  "${fpath[@]}"
)
autoload -Uz $^fpath[1,4]/*(:t.)


fpath=(
  ${0:h}/functions/${(P)^Zdirs[FUNC_D_zwc]}
  ${0:h}/completions
  "${fpath[@]}"
)
autoload -Uz $^fpath[1,4]/*(:t.)
# autoload -Uwz ${0:h}/completions.zwc
# fpath+=( ${0:h}/completions.zwc)

functions -Ms _zerr
functions -Ms _zerrf
# ]]]

# === zinit === [[[
# ========================== zinit-functions ========================== [[[
# Shorten zinit command 
zt()       { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"${1}"} "${@:2}"; }
# Zinit wait if command is already installed
has()      { print -lr -- ${(j: && :):-"[[ ! -v commands[${^@}] ]]"}; }
# Print command to be executed by zinit
# mv_clean() { print -lr -- "command mv -f tar*/rel*/${1:-%PLUGIN%} . && cargo clean"; }
mv_clean() {}
# Shorten url with `dl` annex
grman() {
  local graw="https://raw.githubusercontent.com"; local -A opts
  zparseopts -D -E -A opts -- r: e:
  print -r "${graw}/%USER%/%PLUGIN%/master/${@:1}${opts[-r]:-%PLUGIN%}${opts[-e]:-.1}";
}
# Show the url <owner/repo>
id_as() {
  print -rl \
    -- ${${(S)${(M)${(@f)"$(cargo show $1)"}:#repository: *}/repository: https:\/\/*\//}//(#m)*/<$MATCH>}
}

# ]]] ========================== zinit-functions ==========================
{
  if [[ ! -f $ZINIT[BIN_DIR]/zinit.zsh ]]; then
      print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
      command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
      command git clone https://github.com/zdharma-continuum/zinit "$ZINIT[BIN_DIR]" && \
          print -P "%F{33} %F{34}Installation successful.%f%b" || \
          print -P "%F{160} The clone has failed.%f%b"
  fi
} always {
  builtin source "$ZINIT[BIN_DIR]/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
}

# An empty stub to fill the help handler fields
:za-desc-null-handler() { :; }

# Register desc hook that does nothing
@zinit-register-annex "z-a-desc" \
    hook:\!atclone-0 \
    :za-desc-null-handler \
    :za-desc-null-handler \
    "desc''"

local zstart=$EPOCHREALTIME

# Unsure if all of this defer here does anything with turbo
zt light-mode for \
  atinit'
  function defer() {
    { [[ -v functions[zsh-defer] ]] && zsh-defer -a "$@"; } || return 0;
  }' \
      romkatv/zsh-defer

  
extractf completion history keybindings
zt 0a light-mode null id-as nocd for multisrc="$ZRCDIR/${^sourced[@]}" $null
zflai-log "srcf" "---------- Time" $sourcestart "----------"

# === annex, prompt === [[[
zt light-mode for \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-submods \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-binary-symlink \
  NICHOLAS85/z-a-linkman \
  NICHOLAS85/z-a-eval \
    atinit'Z_A_USECOMP=1' \
  lmburns/z-a-check

# zdharma-continuum/zinit-annex-rust
# zdharma-continuum/zinit-annex-as-monitor
# zdharma-continuum/zinit-annex-readurl

local ztmp=$EPOCHREALTIME
(){
  [[ -f "${Zdirs[THEME]}/${1}-pre.zsh" || -f "${Zdirs[THEME]}/${1}-post.zsh" ]] && {
    zt light-mode for \
        romkatv/powerlevel10k \
      id-as"${1}-theme" \
      atinit"[[ -f ${Zdirs[THEME]}/${1}-pre.zsh ]] && source ${Zdirs[THEME]}/${1}-pre.zsh" \
      atload"[[ -f ${Zdirs[THEME]}/${1}-post.zsh ]] && source ${Zdirs[THEME]}/${1}-post.zsh" \
      atload'alias ntheme="$EDITOR ${Zdirs[THEME]}/${MYPROMPT}-post.zsh"' \
        $null
  } || {
    [[ -f "${Zdirs[THEME]}/${1}.toml" ]] && {
      export STARSHIP_CONFIG="${Zdirs[THEME]}/${MYPROMPT}.toml"
      export STARSHIP_CACHE="${XDG_CACHE_HOME}/${MYPROMPT}"
      eval "$(starship init zsh)"
      zt 0a light-mode for \
        lbin atclone'cargo br --features=notify-rust' atpull'%atclone' atclone"$(mv_clean)" \
        atclone'./starship completions zsh > _starship' atload'alias ntheme="$EDITOR $STARSHIP_CONFIG"' \
        starship/starship
    }
  } || print -P "%F{4}Theme ${1} not found%f"
} "${MYPROMPT=p10k}"

zflai-log "zinit" "Theme" $ztmp

add-zsh-hook chpwd @chpwd_ls
# ]]] === annex, prompt ===

##================================0a^===============================##
##================================0a$===============================##

##================================0a^===============================##
# === trigger-load block ===[[[
ztmp=$EPOCHREALTIME
zt 0a light-mode for \
  atinit'forgit_revert_commit=gro' \
  trigger-load'!ga;!gi;!grh;!grb;!glo;!gd;!gcf;!gco;!gclean;!gss;!gcp;!gcb;!gbl;!gbd;!gct;!gro;!gsp;!gfu' \
  lbin'git-forgit'                   desc'many git commands with fzf' \
    wfxr/forgit \
  trigger-load'!ugit' lbin'git-undo' desc'undo various git commands' \
    Bhupesh-V/ugit \
  trigger-load'!zhooks'              desc'show code of all zshhooks' \
    agkozak/zhooks \
  trigger-load'!hist'                desc'#edit zsh history' \
  compile'f*/*~*.zwc' blockf nocompletions \
    marlonrichert/zsh-hist \
  trigger-load'!gcomp' blockf \
  atclone'command rm -rf lib/*;git ls-files -z lib/ |xargs -0 git update-index --skip-worktree' \
  submods'RobSis/zsh-completion-generator -> lib/zsh-completion-generator;
  nevesnunes/sh-manpage-completions -> lib/sh-manpage-completions' \
  atload'gcomp(){gencomp "${@}" && zinit creinstall -q "${GENCOMP_DIR}" 1>/dev/null}' \
    Aloxaf/gencomp

zflai-log "zinit" "Trigger" $ztmp
# ]]] === trigger-load block ===

# === wait'0a' block === [[[
ztmp=$EPOCHREALTIME
zt 0a light-mode for \
  as'completion' atpull'zinit cclear' blockf \
    zsh-users/zsh-completions \
  atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  pick'you-should-use.plugin.zsh' \
    MichaelAquilina/zsh-you-should-use \
  pick'async.zsh' \
    mafredri/zsh-async \
    zdharma-continuum/zflai

zflai-log "zinit" "block" $ztmp
# ]]] === wait'0a' block ===

##================================0a$===============================##

##================================0b^===============================##
# === wait'0b' - patched === [[[
ztmp=$EPOCHREALTIME
zt 0b light-mode patch"${Zdirs[PATCH]}/%PLUGIN%.patch" reset nocompile'!' for \
  atinit'zicompinit_fast; zicdreplay;' atload'unset "FAST_HIGHLIGHT[chroma-man]"' \
  atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- $f};}' \
  compile'.*fast*~*.zwc' atpull'%atclone' nocompletions \
    zdharma-continuum/fast-syntax-highlighting \
  atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
  trackbinds \
    hlissner/zsh-autopair \
  trackbinds bindmap'\e[1\;6D -> ^[[1\;6D; \e[1\;6C -> ^[[1\;6C' \
    michaelxmcbride/zsh-dircycle \
  trackbinds bindmap'^H -> ^X^T' \
  atload'add-zsh-hook chpwd @chpwd_dir-history-var;
  add-zsh-hook zshaddhistory @append_dir-history-var; @chpwd_dir-history-var now' \
    kadaan/per-directory-history \
  
# ]]] === wait'0b' - patched ===


# === wait'0b' -trackbinds === [[[
zt 0b light-mode for \
  trackbinds atload'
    zstyle :zle:evil-registers:"[A-Za-z%#]" editor nvim
    zstyle :zle:evil-registers:"\*" put  - wl-paste -p
    zstyle :zle:evil-registers:"+"  put  - wl-paste
    zstyle :zle:evil-registers:"\*" yank - wl-copy -p
    zstyle :zle:evil-registers:"+"  yank - wl-copy -n
    zstyle :zle:evil-registers:"" put  - wl-paste
    zstyle :zle:evil-registers:"" yank - wl-copy
    bindkey -M viins "^Xr" →evil-registers::ctrl-r' \
    zsh-vi-more/evil-registers \
  atload'zstyle ":zce:*" keys "asdghklqwertyuiopzxcvbnmfj;23456789";
         zstyle ":zce:*" fg "fg=19,bold"' \
  atload'bindkey "^Xj" zce' \
    hchbaw/zce.zsh \
  nocompile'!' atinit"
    : ${APPZNICK::=${XZAPP:-XZ}}
    : ${XZCONF::=${XDG_CONFIG_HOME:-$HOME/.config}/xzmsg}
    : ${XZCACHE::=$XZCONF/cache}
    : ${XZINI::=$XZCACHE/${(L)APPZNICK}.xzc}
    : ${XZLOG::=$XZCACHE/${(L)APPZNICK}.xzl}
    : ${XZTHEME::=$XZCONF/themes/default.xzt}" \
    psprint/xzmsg \
  nocompile'!' atinit'
    zstyle ":iq:browse-symbol" key "\Cx\Cy"
    zstyle ":iq:action-complete:plugin-id" key "\ea"
    zstyle ":iq:action-complete:ice" key "\ec"' \
    psprint/zsh-angel-iq-system

# ]]] === wait'0b' -trackbinds ===
##================================0b$===============================##

##================================0b^===============================##

# === wait'0b' -binary === [[[
zt 0b light-mode binary lbin check'!%PLUGIN%' from'gh-r' for \
    eza-community/eza \
  atinit'export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"' \
  atload'eval "$(zoxide init --cmd cd zsh)"' \
    ajeetdsouza/zoxide \

# ]]] === wait'0b' -binary ===

zt 0b light-mode null check'!%PLUGIN%' for \
  lbin atinit'export _RAD_NO_ECHO=1; ' \
  atclone'cargo build --release' atpull'%atclone' \
  atload'alias ru="rualdi"' \
  atload'eval "$(rualdi init zsh)"' \
    lmburns/rualdi \
  lbin multisrc'shell/{completion,key-bindings}.zsh' \
  atclone'./install --bin'  atpull'%atclone' \
    junegunn/fzf \

zt 0b light-mode for \
  blockf compile'lib/*f*~*.zwc' \
    Aloxaf/fzf-tab \
  autoload'#manydots-magic' \
    knu/zsh-manydots-magic \
    RobSis/zsh-reentry-hook \
  trackbinds atload'
    vbindkey "Up" history-substring-search-up
    vbindkey "Down" history-substring-search-down
    vbindkey -M vicmd "k" history-substring-search-up;
    vbindkey -M vicmd "j" history-substring-search-down' \
    zsh-users/zsh-history-substring-search \
  compile'h*~*.zwc' atload'
    zstyle ":history-search-multi-word" highlight-color "fg=52,bold";
    zstyle ":history-search-multi-word" page-size "32";  # entries to show ($LINES/3)
    zstyle ":history-search-multi-word" synhl "yes";     # do syntax highlighting
    zstyle ":history-search-multi-word" active "bold fg=53";
    zstyle ":history-search-multi-word" check-paths "yes";
    zstyle ":history-search-multi-word" clear-on-cancel "no"' \
    zdharma-continuum/history-search-multi-word \
  atinit'alias wzman="ZMAN_BROWSER=w3m zman"
         alias zmand="info zsh "' \
    mattmc3/zman \
    
# === wait'0b' -plugin === [[[
zt 0b light-mode for \
  lbin pick'*vendored.zsh*' \
  atclone'rm -rf Cargo.lock' atclone'cargo build --release' atpull'%atclone' \
    m42e/zsh-histdb-skim \
  atinit'HISTDB_FILE="$Zdirs[DATA]/.zsh-history.db"' \
  pick'*plugin*' compile'*.zsh~*.zwc' src'histdb-interactive.zsh' \
    larkery/zsh-histdb \
  nocompletions \
  atclone'zsqlite-build' \
    Aloxaf/zsh-sqlite
# ]]] === wait'0b' -plugin ===
    
##================================0b$===============================##
##================================0c^===============================##
zt 0c light-mode binary lbin check'!%PLUGIN%' for \
    from'gh-r' @sharkdp/bat \
    from'gh-r' @sharkdp/fd \
    from'gh-r' @sharkdp/hyperfine \
    from'gh-r' @sharkdp/diskus \
    from'gh-r' @sharkdp/pastel \
  mv'*/rg -> rg' \
    from'gh-r' BurntSushi/ripgrep \
    from'gh-r' itchyny/mmv \
    from'gh-r' dandavison/delta \
    from'gh-r' MordechaiHadad/bob \
  atload'export FW_CONFIG_DIR="$XDG_CONFIG_HOME/fw"; alias wo="workon"' \
    from'gh-r' brocode/fw \
    from'gh-r' dimo414/bkt \
  # pick'sd' \
    # from'gh-r' chmln/sd \

    
zt 0c light-mode null check'!%PLUGIN%' for \
  lbin atclone'cargo build --release' atpull'%atclone' \
  atclone"./rip completions --shell zsh > _rip" \
    lmburns/rip \
  lbin atclone'cargo build --release' atpull'%atclone' \
    miserlou/loop \
    
zt 0c light-mode null id-as nocd for atload'autoload -Uz compinit; compinit' $null

extractf alias function export-plug keybindings-plug
zt 0c light-mode null id-as nocd for multisrc="$ZRCDIR/${^sourced[@]}" $null
##================================0c$===============================##
# === snippet block === [[[
ztmp=$EPOCHREALTIME
# Don't have to be recompiled to use
zt light-mode nocompile is-snippet for $ZDOTDIR/custom/*.zsh
# zt light-mode null for  \
#   atload'echo $ZDOTDIR/custom/*.zsh; source $ZDOTDIR/custom/*.zsh' \
#   $null
# zt light-mode is-snippet for $ZDOTDIR/snippets/bundled/*.(z|)sh
# zt light-mode is-snippet for $ZDOTDIR/snippets/zle/*.zsh

zflai-log "zinit" "Snippet" $ztmp

#  ]]] === snippet block ===
# ]]] == zinit closing ===

extractf paths; sourcef
zflai-msg "[zshrc]: ----- File Time ${(M)$((SECONDS * 1000))#*.?}ms ----------"
zflai-zprof
# vim: set sw=0 ts=2 sts=2 et ft=zsh
