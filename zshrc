autoload -U compinit && compinit
setopt auto_cd
setopt nocasematch
setopt menucomplete

# directory / file colors
alias ls=' gls -C -F -h --color=always'
export CLICOLOR=1
export LSCOLORS="gxfxcxdxbxegedabagacad"
eval `gdircolors -b ~/.zsh/dircolors.256dark`

# enable syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# load prompt
source ~/.zsh/prompt.zsh

# load completions (homebrew)
export FPATH=/usr/local/share/zsh-completions:/usr/local/share/zsh/functions:$FPATH

# case insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

export GOPATH=$HOME/Dropbox/Code/Go
export CDPATH=.:$HOME/Dropbox/Code:$HOME/Dropbox/Work

export PATH=$HOME/.bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export PATH=$HOME/.ruby/bin:$PATH
export PATH=$GOPATH/bin:$PATH

# remove duped path entries (caused by tmux)
typeset -U PATH

# make <C-s> work in terminal vim
stty -ixon

# disable autocorrect
unsetopt correct_all

# history
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
HISTIGNORE="heroku config*set*:"
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
bindkey -M vicmd 'GG' end-of-history
bindkey -M viins 'GG' end-of-history

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

# ALIASES
alias rm="rm -i"
alias psgrep="ps -Aco pid,comm | sed 's/^ *//'| sed 's/:/ /'|grep -iE"
alias cl="fc -e -|pbcopy" # copy output of last command
alias cpwd='pwd|tr -d "\n"|pbcopy' # copy working dir

# tmux
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

# tig
alias tig="tig --all"
