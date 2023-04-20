#!/usr/bin/env zsh

# Args to specify bare repo
config_git_args=("--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME")

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
        command /usr/bin/git "${config_git_args[@]}" submodule update --init --recursive --remote
    else
        command /usr/bin/git "${config_git_args[@]}" "$@"
    fi
}

# Use lazygit with our bare repo
lazyconf() {
    command lazygit "${config_git_args[@]}" "$@"
}

# Docker rebuild function
docker() {
    if [[ $@ == "--rebuild" ]]; then
        command docker compose down ;
        command docker compose build &&
        command docker compose up -d
    else
        command docker "$@"
    fi
}

# Change directory and list
cdl() {
    cd $@ && l
}

# Check for updates to the repo and pull if needed
repo_update_check() {
    local current_branch local_commit remote_commit repo
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
            config update
        fi
    fi
}
