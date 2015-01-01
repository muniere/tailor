#compdef tailor

local -a options

if (( CURRENT == 2 )); then
  # options
  IFS=$'\n' options=($(tailor complete --zsh))

  # describe
  _describe -t subcommands 'subcommands' options && return 0
else
  # options
  IFS=$'\n' options=($(tailor complete --zsh ${words[((CURRENT - 1))]}))

  # guard
  [ -z "$options" ] && return 1

  # describe
  _describe -t projects 'projects' options && return 0
fi

# vim: ft=zsh sw=2 ts=2 sts=2
