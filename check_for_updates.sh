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
            cd "$config_dir" || exit
            command nvim
            cd - >/dev/null 2>&1 || exit
        else
            printf "Error: Configuration directory %s not found.\n" "$config_dir"
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
    printf "There is an update available for the repository:\n"
    printf "Local commit: %s\n" "$LOCAL_COMMIT"
    printf "Remote commit: %s\n" "$REMOTE_COMMIT"
    printf "Do you want to update now? (y/n): "
    read -r answer
    printf "\n"
    if [[ "$answer" == "y" ]]; then
        config pull --quiet --rebase origin "$CURRENT_BRANCH"
    fi
fi
