#!/usr/bin/env zsh

# If you come from bash you might have to change your $PATH.
#export GOPATH=$HOME/go
#export GOROOT=/usr/local/go
export PATH=$PATH:$(go env GOPATH)/bin/
#export PATH=/usr/local/go/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CONF="$HOME/.config/zsh"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
else
    export EDITOR='nvim'
fi

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ruby/Jekyll stuff
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# Work stuff
if [[ -f "$HOME/.config/samcart/.env" ]]; then
    source "$HOME/.config/samcart/.env"
fi

