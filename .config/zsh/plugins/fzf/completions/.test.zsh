#!/bin/env zsh

set -x
  local params cmd str 
  params=(${(s: :)1}) 
  cmd=$params[1]
  str=$params[-1]

  print $cmd $str
