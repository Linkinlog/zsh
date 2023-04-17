#!/usr/bin/env bash

# Config Editing

# Args to specify bare repo
local git_args=( "--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME" )

# General git usage for config
config() {
    if [[ $1 == "nvim" ]] || [[ $1 == "tmux" ]] || [[ $1 == "zsh" ]]; then
        local config_dir="$HOME/.config/$1"
        if [[ -d $config_dir ]]; then
            cd "$config_dir"
            command nvim
            cd - >/dev/null 2>&1
        else
            echo "Error: Configuration directory $config_dir not found."
        fi
    elif [[ $1 == "update" ]]; then
        command /usr/bin/git "${git_args[@]}" submodule update --init --recursive --remote
    else
        command /usr/bin/git "${git_args[@]}" "$@"
    fi
}

# Use lazygit with our bare repo
lazyconf() {
   command lazygit "${git_args[@]}" "$@"
}

# Get the current branch
CURRENT_BRANCH=$(config rev-parse --abbrev-ref HEAD)

# Fetch the latest changes from the remote repository
config fetch >/dev/null 2>&1

# Get the local and remote commit hashes
LOCAL_COMMIT=$(config rev-parse HEAD)
REMOTE_COMMIT=$(config ls-remote origin -h refs/heads/$CURRENT_BRANCH | cut -f1)

# Check if there's an update available
if [[ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]]; then
    echo "There is an update available for the repository:"
    echo "Local commit: $LOCAL_COMMIT"
    echo "Remote commit: $REMOTE_COMMIT"
    echo -n "Do you want to update now? (y/n): "
    read -r answer
    if [[ "$answer" == "y" ]]; then
        # Update your local repository
        config pull --rebase
    fi
fi
