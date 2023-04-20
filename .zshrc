export CONF="$HOME/.config/zsh"

# Load all of the config files in ~/.config/zsh/tools that end in .zsh
for tool ("$CONF"/tools/*.zsh); do
    source "$tool"
done

# Check the repo for updates
repo_update_check
