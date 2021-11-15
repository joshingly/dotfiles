if [ ! -f /opt/homebrew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# load completions (homebrew)
export FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$HOMEBREW_PREFIX/share/zsh/functions:$FPATH

autoload -Uz compinit

if [ ! -f ~/.zcompdump ]; then
  compinit -u
fi

if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit -u
else
  compinit -C
fi

# load completions (custom)
source $HOME/.zsh/custom-completions.zsh

setopt auto_cd
setopt nocasematch
setopt menucomplete

export PATH=$HOME/.bin:$PATH
export EDITOR=$HOMEBREW_PREFIX/bin/vim

# nnn
export NNN_FCOLORS="040404a60005050ca0040400"

# rbenv
eval "$(rbenv init -)"

# load prompt
source ~/.zsh/prompt.zsh

# case insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# cdpath
export cdpath=($HOME/Sync $HOME/Dropbox)

# fzf
export FZF_DEFAULT_OPTS='
--color dark,hl:33,hl+:37,fg+:235,bg+:0,fg+:254
--color info:254,prompt:37,spinner:108,pointer:166,marker:235
--reverse
--inline-info
'

export FZF_DEFAULT_COMMAND='
rg --smart-case --files --no-ignore --hidden --follow \
--glob "!.git/*" --glob "!.DS_Store" --glob "!**/node_modules/*" \
--glob "!**/tmp/*"
'

# remove duped path entries (caused by tmux)
typeset -U PATH

# directory / file colors
alias ls='gls -C -F -h --color=always'
eval `gdircolors -b ~/.zsh/dircolors`

# make <C-s> work in terminal vim
stty -ixon

# fix <enter> producing ^M
ttyctl -f

# disable autocorrect
unsetopt correct_all

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt append_history
setopt inc_append_history
setopt share_history

# vim
bindkey -v
bindkey "^?" backward-delete-char
bindkey -M viins "jk" vi-cmd-mode
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward
bindkey -M vicmd '^P' history-beginning-search-backward
bindkey -M vicmd '^N' history-beginning-search-forward

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

# ALIASES
alias rm="trash"
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"
alias dc="docker-compose"
alias d="docker"
alias ds="$HOME/.rbenv/versions/$(rbenv global)/bin/docker-sync"

# tmux
alias tmux='echo -ne "\033]0;tmux\007"; tmux'
alias ta="tmux attach-session -t"
alias tls="tmux list-sessions"

# bundler
alias be="bundle exec"

# git
alias gco="git checkout"
alias gci="git commit -v"
alias grb="git rebase"
alias ga="git add"
alias gaa="git add --all"
alias gap="git add -p"
alias gs="git status -sbu"
alias gb="git branch"
alias gd='git diff --color'
alias gdc='git diff --color --cached'
alias gl="git l"
alias gll="git ll"
alias glf="git ll -u"
alias gp="git push"
alias gm="git merge"
alias gss="git stash save -u"
alias gsl="git stash list"
alias gsa="git stash apply"
alias gr="git reset"
alias gr1="git reset HEAD~"
alias gr2="git reset HEAD~2"
alias grh="git reset --hard"
alias grh1="git reset HEAD~ --hard"
alias grh2="git reset HEAD~2 --hard"
alias gcd="cd \$(git rev-parse --show-toplevel)"

print_colors() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( $i == 15 )) || (( $i > 15 )) && (( ($i-15) % 12 == 0 )); then
      echo;
    fi
  done
}

# nnn
n () {
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  nnn -o "$@" -e -H -d

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

# z
export _Z_NO_PROMPT_COMMAND=1
export _Z_EXCLUDE_DIRS=(
  $HOME/Downloads
  $HOME/Desktop
  $HOME/Library
  /usr
)

. $HOMEBREW_PREFIX/etc/profile.d/z.sh

_z_add() {
  local wd="${PWD:A}"

  # fix for z dir excluding, see z.sh line 45
  # - Removed quotes around $exclude*
  # - $* (args) -> $wd (var)
  local exclude
  for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
    case $wd in $exclude*) return;; esac
  done

  _z --add $wd
}

precmd() {
  # terminal title
  eval 'echo -ne "\033]0;${PWD##*/}\007"'

  # z
  _z_add
}
