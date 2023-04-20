#!/usr/bin/env bash

# Check for updates to our Github repo

# Args to specify bare repo
git_args=("--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME")
# TODO make this not hardcoded
REPO="Linkinlog/.dotfiles"
# Allows us to be on any branch
CURRENT_BRANCH=$(config rev-parse --abbrev-ref HEAD)
# Local/remote commit shows what point we are at in the git history for each
LOCAL_COMMIT=$(config rev-parse HEAD)
REMOTE_COMMIT=$(curl --connect-timeout 2 -fsSL -H 'Accept: application/vnd.github.v3.sha' "https://api.github.com/repos/$REPO/commits/$CURRENT_BRANCH")

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

# If the most recent remote commit isnt the commit we are on, assume we update
if [[ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]]; then
    echo "There is an update available for the repository:"
    echo "Local commit: $LOCAL_COMMIT"
    echo "Remote commit: $REMOTE_COMMIT"
    echo -n "Do you want to update now? (y/n): "
    read -r answer
    if [[ "$answer" == "y" ]]; then
        config pull --rebase
    fi
fi
