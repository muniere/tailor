#compdef tailor

local curcontext=$curcontext state line

declare presets

presets=($(tailor -l))

_presets() {
    _describe -t presets "presets" presets
}

_arguments -w -S -C \
  {-h,--help}'[show this help message]: :->noargs' \
  {-l,--list}'[print list of available environments]: :->noargs' \
  '*:presets:_presets'

# vim: ft=zsh sw=2 ts=2 sts=2
