# 目录选择前500条记录，全局选择前3000条记录 local > glob
function :command_history ()
{
  emulate -L zsh
	setopt EXTENDED_GLOB
	
	# [[ $tmp_histfile ]] || tmp_histfile=/tmp/tmp_histfile
	# 
	#
 #  [[ -r $HISTFILE ]] && command tail -3000 $HISTFILE > $tmp_histfile 
 #  [[ -r "$_per_directory_history_path" ]] && command tail -500 $_per_directory_history_path >> $tmp_histfile
  
  result=$(
    fzf +m \
    --bind='enter:accept' \
		--prompt="Hist> " < <(command cat ${HISTFILE:-/dev/null} ${_per_directory_history_path:-/dev/null} |
	                          tac | awk 'BEGIN{FS=";"}!x[$2]++{print $2}' | lscolors)
  )
  
  # 需要，不然画面不完整
  zle reset-prompt
  [[ -n $result ]] && {
    LBUFFER=$result
  }
}

zle -N :command_history

bindkey -M viins '^O' :command_history
