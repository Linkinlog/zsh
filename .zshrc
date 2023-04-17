# If you come from bash you might have to change your $PATH.
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=/usr/local/go/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

zstyle ':omz:update' mode auto      # update automatically without asking
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	bgnotify
	branch
	command-not-found
	docker
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
	)


source $ZSH/oh-my-zsh.sh
source $HOME/.config/zsh/check_for_updates.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Show hidden files for completion
setopt globdots

# Set keyboard repeat higher
xset r rate 190 60 2>/dev/null

# Overwrite the default agnoster with our theme
ln -sf $HOME/.config/zsh/agnoster.zsh-theme $ZSH_CUSTOM/themes/agnoster.zsh-theme

# Samcart configs
if [[ $HOST == "samcart-dseyler" ]]; then
    alias appexec="docker compose exec app"
    alias mgmtexec="docker compose exec mgmt"
    alias tf="tmux new-session -s foundation -c ~/workspaces/foundation/"
fi

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

# Other Aliases
alias nv="nvim"
alias ts="tmux new-session -s"

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
