# os
declare -gx ABSD=${${(M)OSTYPE:#*(darwin|bsd)*}:+1}
# declare -gx GENCOMP_DIR="$Zdirs[COMPL]"
# declare -gx GENCOMPL_FPATH="$GENCOMP_DIR"
declare -gx ZLOGF="${Zdirs[CACHE]}/my-zsh.log"
declare -gx LFLOGF="${Zdirs[CACHE]}/lf-zsh.log"


typeset -g WORDCHARS="${WORDCHARS/\//}"

export LIST_OPTS="-F --icons --sort=accessed --reverse --across"
export RG_DEFAULT_OPTS="--line-number --no-heading --smart-case --color=always --colors 'path:fg:blue' --colors 'match:fg:Magenta' --colors 'match:style:bold'"
export FD_DEFAULT_OPTS="--hidden --follow --exclude '.git' --exclude 'node_modules'"

#export LS_COLORS="$(vivid generate catppuccin-mocha)"

## history
typeset -g SAVEHIST=$(( 10 ** 7 ))  # 10_000_000
typeset -g HISTSIZE=$(( 1.2 * SAVEHIST ))
typeset -g HISTFILE="${Zdirs[DATA]}/.history"
typeset -g HIST_STAMPS="yyyy-mm-dd"
typeset -g HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1 # all search results returned will be unique NOTE: for what

## copy paste xclip
#xsel
typeset -g CP_TRIM="--trim"
typeset -g COPY_CMD_CLIP="xsel -b"
typeset -g COPY_CMD_PRIM="xsel -p"
typeset -g COPY_CMD_SECOND="xsel -secondary"
typeset -g PASTE_CMD_CLIP="xsel -io -b"
typeset -g PASTE_CMD_PRIM="xsel -io -p"
typeset -g PASTE_CMD_SECOND="xsel -io -secondary"
#xclip
typeset -g COPY_CMD_CLIP="xclip -selection clipboard"
typeset -g COPY_CMD_PRIM="xclip -selection primary"
typeset -g COPY_CMD_SECOND="xclip -selection secondary"
typeset -g PASTE_CMD_CLIP="xclip -out -selection clipboard"
typeset -g PASTE_CMD_PRIM="xclip -out -selection primary"
typeset -g PASTE_CMD_SECOND="xclip -out -selection secondary"

## man
export MANPAGER="sh -c 'col -bx | bat -l man --number'"
export MANROFFOPT="-c"

typeset -g DIRSTACKSIZE=20
typeset -g LISTMAX=50                               # Size of asking history
typeset -g ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;)'       # Don't eat space with | with tabs
typeset -g ZLE_SPACE_SUFFIX_CHARS=$'&|'
typeset -g MAILCHECK=0                 # Don't check for mail
typeset -g KEYTIMEOUT=25               # Key action time
typeset -g FCEDIT=$EDITOR              # History editor
typeset -g READNULLCMD=$PAGER          # Read contents of file with <file
typeset -g TMPPREFIX="${TMPDIR%/}/zsh" # Temporary file prefix for zsh
typeset -g PROMPT_EOL_MARK="%F{14}⏎%f" # Show non-newline ending # no_prompt_cr
# typeset -g REPORTTIME=5 # report about cpu/system/user-time of command if running longer than 5 seconds
# typeset -g LOGCHECK=0   # interval in between checks for login/logout activity
typeset -g PERIOD=3600                    # how often to execute $periodic
function periodic() { builtin rehash; }   # this overrides the $periodic_functions hooks
watch=(notme)

# ls lse ls@ ls. lsl lsS lsX lsr
# ll lla lls llb llr llsr lle ll.
# lj lp lpo
# lsm lsmr lsmo lsmn
# lsc lscr lsco lscn
# lsb lsbr lsbo lsbn
# lsat lsbt lsa2 lsb2
# lsa lsao lsan
# lst lsts lstx lstl lstr
# lsd lsdl lsdo lsdn lsde lsdf lsd2
# lsz lszr lszb lszs lsz0 lsze
# lss lssa
# lsur
typeset -ga histignore=(
  # mv cp cat bat vi vim nvim cd rm pushd popd
  youtube-dl you-get yt-dlp history exit tree tmux exit clear reset bg fg pwd
  'ls[sSXletr.@]'
  'll(|[abre.][r]#)'
  'l[pj][o]#'
  'lsm[ron]#'
  'lsc[ron]#'
  'lsb[ron]#'
  'ls[ab][t2]'
  'lsa[on]#'
  'lst[sxlr]#'
  'lsd[lonef2]#'
  'lsz[rbs0e]#'
  'lss[a]#'
  'lsur'
)

# Various highlights for CLI
typeset -ga zle_highlight=(
  # region:fg="#a89983",bg="#4c96a8"
  # paste:standout
  region:standout
  special:standout
  suffix:bold
  isearch:underline
  paste:none
)

() {
  # local i; i=${(@j::):-%\({1..36}"e,$( echoti cuf 2 ),)"}
  # typeset -g PS4=$'%(?,,\t\t-> %F{9}%?%f\n)'
  # PS4+=$'%2<< %{\e[2m%}%e%22<<             %F{10}%N%<<%f %3<<  %I%<<%b %(1_,%F{11}%_%f ,)'

  declare -g SPROMPT="Correct '%F{17}%B%R%f%b' to '%F{20}%B%r%f%b'? [%F{18}%Bnyae%f%b] : "  # Spelling correction prompt
  declare -g PS2="%F{1}%B>%f%b "  # Secondary prompt
  declare -g RPS2="%F{14}%i:%_%f" # Right-hand side of secondary prompt

  autoload -Uz colors; colors
  local red=$fg_bold[red] blue=$fg[blue] rst=$reset_color
  declare -g TIMEFMT=(
    "$red%J$rst"$'\n'
    "User: $blue%U$rst"$'\t'"System: $blue%S$rst  Total: $blue%*Es$rst"$'\n'
    "CPU:  $blue%P$rst"$'\t'"Mem:    $blue%M MB$rst"
  )
}

# === Custom zsh variables =============================================== [[[
