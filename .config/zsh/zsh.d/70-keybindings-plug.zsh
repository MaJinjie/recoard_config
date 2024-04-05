bindkey -M histdb-isearch '^P' _histdb-isearch-up
bindkey -M histdb-isearch '^N' _histdb-isearch-down
bindkey -M histdb-isearch '^D' _histdb-isearch-cd

# 历史搜索 单次
bindkey '^R' _histdb-isearch

# 寄存器
bindkey -M viins '^Xr' →evil-registers::ctrl-r

# 历史搜索，类似fzf
# bindkey "^O" history-search-multi-word

# fzf搜索命令历史
bindkey '^Xh' histdb-skim-widget
# 按键 -> 序列
bindkey "^Xq" vi-quoted-insert
