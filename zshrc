ZSH=$HOME/.oh-my-zsh

ZSH_THEME="antonishen"

plugins=(git brew gem osx ruby rails)

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/.bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/Applications/Postgres.app/Contents/MacOS/bin:$PATH
export PATH=/usr/local/lib/node_modules:/usr/local/share/npm/bin/:$PATH
export PATH=$HOME/.ruby/bin:$PATH

setopt auto_cd
export CDPATH=.:$HOME/Dropbox/Code:$HOME/Dropbox/Work

# make <C-s> work in terminal vim
stty -ixon

# disable autocorrect
unsetopt correct_all

# ignore duplicate history entries
setopt histignoredups

# BINDINGS
bindkey "^b" beginning-of-line

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
