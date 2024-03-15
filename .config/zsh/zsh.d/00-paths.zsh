# === fPaths ============================================================== [[[

# === Paths ============================================================== [[[
typeset -g HELPDIR='/usr/share/zsh/help'
if [[ ! -d $HELPDIR ]]; then
  HELPDIR="/usr/share/zsh/${ZSH_VERSION}/help"
fi

path=( 
  "$Zdirs[BIN]"
  "${path[@]:#}" 
)

path=( 
  "${path[@]:#}"
  "$CARGO_HOME/bin"
  "$RUSTUP_HOME/bin"
  )   # remove empties (if any)

cdpath=( $XDG_CONFIG_HOME )

manpath=(
  $ZINIT[MAN_DIR]
  $Zdirs[MAN]
  "${manpath[@]}"
)

infopath=(
  /usr/share/info
  "${infopath[@]}"
)
