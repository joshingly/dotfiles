# https://wikimatze.de/writing-zsh-completion-for-padrino/

_l() {
  typeset -A opt_args

  _arguments -C \
    '1:cmd:->cmds' \
    '2:reset:->reset_list' \
  && ret=0

  case "$state" in
    (cmds)
       local commands; commands=(
        'help'
        'update'
        'clean'
        'reset'
       )

       _describe -t commands 'command' commands && ret=0
    ;;
    (reset_list)
      local resets; resets=(
        'docker'
      )

      _describe -t resets 'reset' resets && ret=0
    ;;
  esac

  return 1
}

compdef _l l
