#!/usr/bin/env zsh

# Args to specify bare repo
config_git_args=("--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME")

# To run git commands using the dotfiles repo
dotdo() {
    command /usr/bin/git "${config_git_args[@]}" "$@"
}

# To update the submodules properly
dotup() {
    dotdo submodule update --init --recursive --remote
}

# To easily run the main command for syncing
dotsync() {
    sudo -v
    command "$HOME/.local/bin/main.sh"
}

# To edit our config files
dotedit() {
    local cmd="$1"
    declare -A config_dirs=(
        ["nvim"]="$HOME/.config/nvim"
        ["tmux"]="$HOME/.config/tmux"
        ["zsh"]="$HOME/.config/zsh"
        ["main"]="$HOME/.local/bin/main.sh"
    )

    if [[ -z "${config_dirs[$cmd]}" ]]; then
        printf "Error: Command not recognized: %s\n" "$cmd"
        return 1
    fi

    if [[ ! -e "${config_dirs[$cmd]}" ]]; then
        printf "Error: Configuration file %s not found.\n" "${config_dirs[$cmd]}"
        return 1
    fi

    if [[ -d "${config_dirs[$cmd]}" ]]; then
        local returnDir="$(pwd)"
        cd "${config_dirs[$cmd]}" || return 1
        nvim
        cd "$returnDir" || return 1
    fi

    nvim "${config_dirs[$cmd]}"
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
    command cd $@ &&
    command l
}

# Check for updates to the repo and pull if needed
repo_update_check() {
    local current_branch local_commit remote_commit repo
    # Allows us to be on any branch
    current_branch=$(dotdo rev-parse --abbrev-ref HEAD)
    # Local/remote commit shows what point we are at in the git history for each
    repo="${DOTREPO:-Linkinlog/.dotfiles}"
    local_commit=$(dotdo rev-parse HEAD)
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
            dotdo pull --quiet --rebase origin "$current_branch"
            dotup
        fi
    fi
}
