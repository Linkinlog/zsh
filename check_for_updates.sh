#!/usr/bin/env bash

# Check for updates to our Github repo

# General git usage for config
config() {
    # Args to specify bare repo
    local git_args=("--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME")
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

repo_update_check() {
    local current_branch
    local local_commit
    local remote_commit
    local repo
    # Allows us to be on any branch
    current_branch=$(config rev-parse --abbrev-ref HEAD)
    # Local/remote commit shows what point we are at in the git history for each
    repo="Linkinlog/.dotfiles" # TODO make this not hardcoded
    local_commit=$(config rev-parse HEAD)
    remote_commit=$(curl --connect-timeout 2 -fsSL -H 'Accept: application/vnd.github.v3.sha' "https://api.github.com/repos/$repo/commits/$current_branch")

    # If the most recent remote commit isnt the commit we are on, assume we update
    if [[ "$local_commit" != "$remote_commit" ]]; then
        printf "There is an update available for the repository:\n"
        printf "Local commit: %s\n" "$local_commit"
        printf "Remote commit: %s\n" "$remote_commit"
        printf "Do you want to update now? (y/n): "
        read -r answer
        printf "\n"
        if [[ "$answer" == "y" ]]; then
            config pull --quiet --rebase origin "$current_branch"
        fi
    fi
}

repo_update_check
unset repo_update_check
