#!/usr/bin/env bash

_tailor() {
  if [ $COMP_CWORD == 1 ]; then
    COMPREPLY=($(compgen -W "$(tailor -l)" ${COMP_WORDS[COMP_CWORD]})) 
    return 0
  fi

  return 1
}

complete -F _tailor tailor

# vim: ft=sh sw=2 ts=2 sts=2
