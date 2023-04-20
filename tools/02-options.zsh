#!/usr/bin/env zsh

# Show hidden files for completion
setopt globdots

# Set keyboard repeat higher
xset r rate 190 60 2>/dev/null

# Other Aliases
alias nv="nvim"
alias ts="tmux new-session -s"

# Samcart configs
if [[ $HOST == "samcart-"* ]]; then
    alias appexec="docker compose exec app"
    alias mgmtexec="docker compose exec mgmt"
    alias tf="tmux new-session -s foundation -c ~/workspaces/foundation/"
fi
