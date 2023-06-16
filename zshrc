# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set simple window title (overridden by tmux)
export DISABLE_AUTO_TITLE="true"
echo -en "\033]0;❤️\a"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode fzf)

source $ZSH/oh-my-zsh.sh # User configuration

alias ca="conda activate"
alias conde="conda deactivate"
alias conie="conda info --envs"
alias v="vim -p"
alias drit="docker run -it"
alias gs="gst"
alias wp="which -a python"
alias tmas="tmux new -A -s"
alias i3tree="conda run -n i3 py3tree"

bindkey -v
unsetopt beep
export EDITOR='vim'
# Don't close terminal on Ctrl-D (which sends eof)
# I send this all the time by accident after using it inside a command...
set -o ignoreeof

alias k="kubectl"
alias kns="kubectl ns"
alias kctx="kubectl ctx"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH:$HOME/.local/bin"

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Disable terminal freezing on ctrl-s
stty -ixon

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# When this file is found in the starting directory, launch a tmux session
# Useful for giving each Pycharm project its own tmux session
# First condition: .tmux_session_name should exist
# Second condition: $TMUX should be empty/unset
if [ -f .tmux_session_name ] && [ -z "${TMUX}" ]; then
    tmux_session_name=$(<.tmux_session_name)
    # Third condition: only attach if the session doesn't exist or is unattached
    if [[ $(tmux ls | grep "^${tmux_session_name}.*(attached)$" | wc -c ) -eq 0 ]]; then
        tmas $tmux_session_name
    else
        echo "Not auto-attaching. Attach with:\ntmas $tmux_session_name"
    fi
fi

