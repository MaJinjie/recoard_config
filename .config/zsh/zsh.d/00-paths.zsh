path=( 
  "${path[@]:#}"
  "$CUSTOM_HOME/bin"
  "$CARGO_HOME/bin"
  "$RUSTUP_HOME/bin"
  )   

path=( "${(u)path[@]}" )

cdpath=( $XDG_CONFIG_HOME )

manpath=(
  $ZINIT[MAN_DIR]
  "${manpath[@]}"
)
manpath=("${(u)manpath[@]}")

infopath=(
  /usr/share/info
  "${infopath[@]}"
)
