#!/usr/bin/env zsh

# Args to specify bare repo
config_git_args=("--git-dir=$HOME/.dotfiles.git/" "--work-tree=$HOME")

# To run git commands using the dotfiles repo
dotdo() {
    command /usr/bin/git "${config_git_args[@]}" "$@"
}

# Easy git pull
dotpull() {
    dotdo pull
}

# Easy git status
dotstatus() {
    dotdo status
}

# To update the submodules properly
dotsync() {
    local current_branch remote merge tracking
    # Allows us to be on any branch
    current_branch=$(dotdo symbolic-ref --short HEAD)
    remote=$(dotdo config branch."$current_branch".remote)
    merge=$(dotdo config branch."$current_branch".merge)
    tracking=${merge##/refs/heads/}
    printf "\e[34m🛠️ Pulling config repo... \e[0m\n"
    dotdo fetch -q "$remote" "$tracking"
    dotdo merge -q FETCH_HEAD
    printf "\e[32m✅ All up-to-date!\e[0m\n"
}

# For updating packages
dotpkgs() {
    sudo -v
    command "$HOME/.local/bin/main.sh"
}

# Run lazygit on respective directories
dotlazy() {
    local cmd="$1"
    # TODO refactor two sources of truth (source 1)
    declare -A config_dirs=(
        ["nvim"]="$HOME/.config/nvim"
        ["tmux"]="$HOME/.config/tmux"
        ["zsh"]="$HOME/.config/zsh"
        ["bin"]="$HOME/.local/bin"
    )

    if [[ -z "${config_dirs[$cmd]}" ]]; then
        command lazygit "${config_git_args[@]}" "$@"
        return 0
    fi

    if [[ ! -e "${config_dirs[$cmd]}" ]]; then
        printf "\e[31m❌ Error: Configuration dir %s not found.\e[0m\n" \
            "${config_dirs[$cmd]}"
        return 1
    fi

    if [[ -d "${config_dirs[$cmd]}" ]]; then
        gitdir=$(cat "${config_dirs[$cmd]}/.git" | cut -d ' ' -f 2)
        abspath=$(readlink -f $gitdir)
        lazygit --work-tree="${config_dirs[$cmd]}" --git-dir=$abspath
    fi
}

# To edit our config files
dotedit() {
    local cmd="$1"
    # TODO source 2
    declare -A config_dirs=(
        ["nvim"]="$HOME/.config/nvim"
        ["tmux"]="$HOME/.config/tmux"
        ["zsh"]="$HOME/.config/zsh"
        ["main"]="$HOME/.local/bin/main.sh"
    )

    if [[ -z "${config_dirs[$cmd]}" ]]; then
        printf "\e[31m❌ Error: Command not recognized: %s\e[0m\n" "$cmd"
        return 1
    fi

    if [[ ! -e "${config_dirs[$cmd]}" ]]; then
        printf "\e[31m❌ Error: Configuration file %s not found.\e[0m\n" \
            "${config_dirs[$cmd]}"
        return 1
    fi

    if [[ -d "${config_dirs[$cmd]}" ]]; then
        local returnDir="$(pwd)"
        cd "${config_dirs[$cmd]}" || return 1
        nvim
        cd "$returnDir"
        return
    fi

    if [[ -e "${config_dirs[$cmd]}" ]]; then
        nvim "${config_dirs[$cmd]}"
        return
    fi

    if [[ -d "$HOME/.config/$cmd" ]]; then
        local returnDir="$(pwd)"
        cd "$HOME/.config/$cmd" || return 1
        nvim
        cd "$returnDir"
        return
    fi

}

dotload() {
    source $HOME/.zshrc
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
    local current_branch repo local_commit remote_commit
    # Allows us to be on any branch
    current_branch=$(dotdo rev-parse --abbrev-ref HEAD) || { printf "\e[31m❌ Error: could not parse head\e[0m\n"; return 1; }
    # Local/remote commit shows what point we are at in the git history for each
    repo="${DOTREPO:-Linkinlog/.dotfiles}"
    local_commit=$(dotdo rev-parse HEAD) || { printf "\e[31m❌ Error: could not parse local commit hash\e[0m\n"; return 1; }
    remote_commit=$(curl --connect-timeout 2 -fsSL \
        -H 'Accept: application/vnd.github.v3.sha' \
        "https://api.github.com/repos/$repo/commits/$current_branch") || { printf "\e[31m❌ Error: could not get remote commit\e[0m\n"; return 1; }

    # If the most recent remote commit isn't the commit we are on, assume we update
    if [[ "$local_commit" != "$remote_commit" ]]; then
        printf "\e[33m🚀 Heads up! There's an update ready for your dotfiles!\e[0m\n"
        printf "\e[34m🛠️ local commit: \e[35m%s\e[0m\n" "$local_commit"
        printf "\e[34m🛠️ latest remote commit: \e[35m%s\e[0m\n" "$remote_commit"
        printf "\e[36m✨ update now? (y/n): \e[0m"
        read -r answer
        if [[ "$answer" == "y" ]]; then
            dotsync
        fi
    fi
}

# set up a new InternetExercise in go
ie() {
    mkdir -p $1
    cd $_
    echo "package main" > main.go
    echo "package main" > main_test.go
    go mod init $1
}

# wrap neovim
n() {
    nvim $@
}

# find and edit from local source
nl() {
    local file
    if [[ -n $1 ]]; then
        file=$(find . -iname "*$1*" | fzf --tac)
    else
        file=$(fzf)
    fi

    if [[ -z $file ]]; then
        return
    fi

    nvim "$file"
}

# find and edit from global source
ng() {
    local file
    if [[ -n $1 ]]; then
        file=$(ls "$1" | fzf --tac)
    else
        file=$(fzf)
    fi

    if [[ -z $file ]]; then
        return
    fi

    nvim "$1"/"$file"
}

# split run
sr() {
    tmux split-window -h $2
    sh -c $1
}

# concord commands
cb() {
    git switch -c "bugfix/COPA-$1"
}
cf() {
    git switch -c "feature/COPA-$1"
}
