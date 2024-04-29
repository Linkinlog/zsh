#!/usr/bin/env zsh

# Other Aliases
alias nv="nvim"
alias vim="nvim"
alias ts="tmux new-session -s"
alias code='dir=~/codespaces;cd $dir/$(ls $dir|fzf); nvim'
alias work='dir=~/work;cd $dir/$(ls $dir|fzf); nvim'

if [[ $(uname) == "Darwin" ]]; then
    alias gdb="arm-none-eabi-gdb"
fi

# Laravel stuff
alias s='[ -f sail ] && sh sail || sh vendor/bin/sail'

export PATH="$PATH:$(go env GOPATH)/bin/:$HOME/.local/bin:$HOME/gems/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CONF="$HOME/.config/zsh"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='nvim'

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ruby/Jekyll stuff
export GEM_HOME="$HOME/gems"

# Rust stuff
if [ -f ~/export-esp.sh ]; then
    source ~/export-esp.sh
fi


# Ruby stuff
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3
