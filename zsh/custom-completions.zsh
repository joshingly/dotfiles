# https://github.com/wikimatze/padrino-zsh-completion/blob/master/_padrino

_l() {
  typeset -A opt_args

  _arguments -C \
    '1:cmd:->cmds' \
    '2:sub_cmd:->sub_cmds' \
  && ret=0

  case "$state" in
    (cmds)
       local commands; commands=(
        'help'
        'update'
        'clean'
        'conflicted'
        'reset'
       )

       _describe -t commands 'command' commands && ret=0
    ;;
    (sub_cmds)
      case $line[1] in
        (reset)
          local reset; resets=(
            'docker'
            'xcode'
          )

          _describe -t resets 'reset' resets && ret=0
        ;;
      esac
    ;;
  esac

  return 1
}

compdef _l l
