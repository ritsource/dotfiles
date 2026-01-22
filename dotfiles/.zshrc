#export PATH=/usr/local/bin:$PATH If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# # Path to your oh-my-zsh installation.
# export ZSH="/Users/P.rit/.oh-my-zsh"
#
clear

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# plugins
plugins=(
    git
    zsh-autosuggestions # source - https://apple.stackexchange.com/a/140770/351278
    zsh-syntax-highlighting
)

# homebrew
export PATH=/opt/homebrew/bin:$PATH

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# ...........................
# ...........................
# from now custom stuff .....
# ...........................
# ...........................

source $ZSH/oh-my-zsh.sh

# kaybindings for H,J,K,L navgation on terminal
# source - https://unix.stackexchange.com/a/323279/359073
#
# mapping is something like
# ctrl + k => up-arrow
# ctrl + j => down-arrow
# ctrl + h => left-arrow
# ctrl + l => right-arrow
#
bindkey '^k' up-history
bindkey '^j' down-history
bindkey '^h' backward-char
bindkey '^l' forward-char
#

# setting tabsize equal to 2 characters
tabs -2
#

# # path, this was already there, so not messing up n
# export PATH="$PATH:`pwd`/flutter/bin:/usr/local/Cellar/python/3.7.7/bin:/Users/P.rit/Library/Python/2.7/bin:~/.custom/scripts/bin"
# #

# exporting path for custom scripts
# to find out more ~/.custom/scripts
#
export PATH=$PATH:~/.custom/scripts/bin
#

# Go-path export (golang)
#
## export GOPATH=$HOME/go
# source - https://stackoverflow.com/a/22878128/9406420
# export GOROOT=/usr/local/Cellar/go/1.14.3/libexec
# export GOTOOLDIR=/usr/local/Cellar/go/1.14.3/libexec/pkg/tool/darwin_amd64
#
# export PATH=$PATH:$GOPATH/bin
## export PATH=$PATH:$(go env GOPATH)/bin
#


export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# export PATH=$PATH:/usr/local/go/bin

# # exporting nvim as default text editor
# # source https://unix.stackexchange.com/questions/501862/how-can-i-set-the-default-editor-as-nano-on-my-mac
# #
# export EDITOR="nvim"
# export VISUAL="$EDITOR"
# #

alias c="cursor"
alias c.="cursor ."
alias c..="cursor .."
alias c....="cursor ../.."

alias z="zed"
alias z.="zed ."
alias z..="zed .."
alias z....="zed ../.."

alias cl="claude"

# useful aliases
#
alias hist="history"
alias clip="pbcopy"
# alias sl="ls"
#

# for refreshing terminal source
#
alias refresh="source ~/.bash_profile; source ~/.zshrc; source ~/.profile"
#

# shortcut aliases
#
alias rr="refresh"
alias cc="clear"
alias wh="which"
alias la="ls -a"
alias tt="todo.sh ls"
alias :q="exit"
alias tm="tmux"
#

# application/tool aliases
#
alias bree="broot"
alias rust="cargo"
alias todo="todo.sh"
alias ripgrep="rg"
#

# vi-vim-nvim aliases, all resolving to nvim
#
alias vi="nvim"
alias vim="nvim"
alias vi="nvim ."
# alias .="nvim ."
#

# git alias, shortcuts for most
# used git related commands
#
alias gits="git status"
alias gita="git add"
alias gitaa="git add --all"
alias gitc="git commit"
alias gitb="git branch"
alias gitck="git checkout"
alias gitbclip="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"
alias gitpo="git push origin"
#

# alias for custom scripts
# to find out more ~/.custom/script
#
alias ce_zsh="confedit zsh"
alias ec_zsh="confedit zsh"
alias ce_vim="confedit nvim"
alias ec_vim="confedit nvim"
alias ce_nvim="confedit nvim"
alias ec_nvim="confedit nvim"
alias ce_nvimex="confedit nvim --ex"
alias ec_nvimex="confedit nvim --ex"
alias co_nfe="confedit"
alias co_nf="confedit"
#

alias python="python3"
alias py3="python3"
alias py2="python2"
alias py="python3"

# startup command
# random number between 0 to 10, if 1 then print
if [ 3 -gt $(python -S -c "from random import randrange; print(randrange(10))") ]; then
    fortune | cowsay -f sodomized | lolcat -a -d 1
fi
#

# language stuff I think, NO IDEA
# source - https://stackoverflow.com/a/56743150/9406420
export LC_ALL=en_US.UTF-8
#

# clear

# Prompting a line between each command
# Source - https://stackoverflow.com/a/20615683/9406420
#
STARTUP=true
precmd() {
    if $STARTUP; then
        STARTUP=false
    else
        echo
    fi
}
#
#

source ~/.bashrc

export PATH="/Users/rit/.local/bin:$PATH"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="$PATH:~/development/flutter/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by Windsurf
export PATH="/Users/rit/.codeium/windsurf/bin:$PATH"

# opencode
export PATH=/Users/rit/.opencode/bin:$PATH



alias yarn="pnpm"
