ZSH=$HOME/.oh-my-zsh

ZSH_THEME="antonishen"

plugins=(git brew gem osx ruby rails)

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/.bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/Applications/Postgres93.app/Contents/MacOS/bin:$PATH
export PATH=/usr/local/lib/node_modules:/usr/local/share/npm/bin/:$PATH
export PATH=$HOME/.ruby/bin:$PATH

export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

setopt auto_cd
export CDPATH=.:$HOME/Dropbox/Code:$HOME/Dropbox/Work

# make <C-s> work in terminal vim
stty -ixon

# disable autocorrect
unsetopt correct_all

# history
setopt histignoredups
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# vim
bindkey -v
bindkey "^?" backward-delete-char
bindkey -M viins "jk" vi-cmd-mode
bindkey -M vicmd "q" push-line
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward
bindkey -M vicmd '^P' history-beginning-search-backward
bindkey -M vicmd '^N' history-beginning-search-forward
bindkey -M menuselect '^P' reverse-menu-complete
bindkey -M menuselect '^N' menu-complete
bindkey -M vicmd 'G' end-of-history

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

# ALIASES
alias rm="rm -i"
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"
alias cl="fc -e -|pbcopy" # copy output of last command
alias cpwd='pwd|tr -d "\n"|pbcopy' # copy working dir

# ios
alias ios="open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app"

# tmux
alias t="tmux -u new -s"
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
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git l"
alias gll="git ll"
alias glf="git ll -u"
alias gld="git ld"
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

# rails
alias rg="rails generate"
alias rd="rails destroy"

# 'prev' will cd you to the last directory that you cd'ed into
export PREV_PATH=$HOME/.prev-path

# run everytime you cd
function chpwd {
  echo $(pwd) >! $PREV_PATH
}

prev() {
  if [[ -f $PREV_PATH ]]; then
    echo "$(cat $PREV_PATH)"
    cd "$(cat $PREV_PATH)"
  fi
}
