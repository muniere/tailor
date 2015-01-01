#!/usr/bin/env bash

_tailor() {
  local options curword

  if [ $COMP_CWORD == 1 ]; then
    options="$(tailor complete --bash)"
  else
    options="$(tailor complete --bash ${COMP_WORDS[((COMP_CWORD - 1))]})"
  fi

  [ -z "$options" ] && return 1

  COMPREPLY=($(compgen -W "$options" ${COMP_WORDS[COMP_CWORD]}))
  return 0
}

complete -F _tailor tailor

# vim: ft=sh sw=2 ts=2 sts=2
