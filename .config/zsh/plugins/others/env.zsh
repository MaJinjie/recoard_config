#!/bin/env zsh 

## autosuggest-complete
export ZSH_AUTOSUGGEST_USE_ASYNC=
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1E624E,bold"
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( \
  vi-add-eol vi-end-of-line \
  end-of-line \
)
export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=( \
  vi-forward-char \
  vi-forward-word vi-forward-word-end \
  vi-forward-blank-word vi-forward-blank-word-end \
  forward-word \
)



## z 
export ZSHZ_CMD=z
#export ZSHZ_CD=
export ZSHZ_DATA="$C_ZSH_DATA/z"
export ZSHZ_TILDE=1
export ZSHZ_TRAILING_SLASH=1
export ZSHZ_CASE=smart
