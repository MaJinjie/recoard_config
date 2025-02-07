#!/usr/bin/env zsh

# FZF_MUL_DELIM 分隔符
_fps() {
    local render
    if (( $+commands[grcat] )); then
        render='grcat fps.grc'
    else
        render='cat'
    fi

    ps -eo user,pid,ppid,pgid,stat,tname,cmd | awk '
    BEGIN { "ps -p $$ -o pgid --no-headers | tr -d \"[:blank:]\"" | getline pgid } {
        if ($4 != pgid || $2 == pgid)
            print
    }' | ${(z)render}
}

setopt localoptions pipefail

local fzf_opts="--header-lines=1 -m \
${commands[grcat]:+--ansi} --height=50% \
--min-height=15 --tac --reverse \
--preview-window=down:2"

local fzf_preview_cmd="ps -o pcpu,pmem,vsz,rss,thcount,start_time,time -p {2}"

_fps | fzf ${(z)fzf_opts} --preview=$fzf_preview_cmd |
    awk -v sep=${FZF_MUL_DELIM:- } '{ printf "%s%c", $2, sep }' | sed -E "s/${FZF_MUL_DELIM:- }$//"
