ZSH=$HOME/.oh-my-zsh

ZSH_THEME="antonishen"

plugins=(git rvm brew gem osx ruby rails)

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/.bin:/usr/local/sbin:/usr/local/bin:${PATH}
export NODE_PATH=/usr/local/lib/node_modules

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
__rvm_project_rvmrc
# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# make <C-s> work in terminal vim
stty -ixon

# ignore duplicate history entries
setopt histignoredups

# Bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# ALIASES
alias rm="rm -i"

# TMUX
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
alias gs="git status"
alias gb="git branch"
alias gd="git diff"
alias gl="git l"
alias gll="git ll"
