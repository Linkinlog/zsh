#!/usr/bin/env zsh

# Show hidden files for completion
setopt globdots

# Set keyboard repeat higher
xset r rate 190 60 2>/dev/null

# Other Aliases
alias nv="nvim"
alias vim="nvim"
alias ts="tmux new-session -s"
alias code='dir=~/codespaces;cd $dir/$(ls $dir|fzf); nvim'

# Laravel stuff
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Ruby stuff
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3
