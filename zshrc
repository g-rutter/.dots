# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH:"$PATH:/opt/nvim-linux-x86_64/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# The default version breaks curl https://github.com/curl/curl/issues/9884
# Though curl is at fault (I think?) and should be fixed someday
export no_proxy=10.0.0.0/8,127.0.0.1,172.16.0.0/12,192.168.0.0/16,localhost,.localdomain.com,.mavensecurities.com
export NO_PROXY=10.0.0.0/8,127.0.0.1,172.16.0.0/12,192.168.0.0/16,localhost,.localdomain.com,.mavensecurities.com

export CURL_CA_CERTS="/etc/ssl/certs/ca-certificates.crt"
export HTTPLIB2_CA_CERTS="/etc/ssl/certs/ca-certificates.crt"
export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

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

# Done for speed
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set simple window title (overridden by tmux)
export DISABLE_AUTO_TITLE="true"
echo -en "\033]0;❤️ ${$(hostname)%%.*}\a"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh # User configuration

alias v="vim -p"
alias drit="docker run -it"
alias gs="gst"
alias wp="which -a python"
alias tmas="tmux new -A -s"
alias vdi-prod="ssh vdi-prod -t 'zsh -l'"
alias ixqdsares01="ssh ixqdsares01 -t 'zsh -l'"
alias lcd="cd"  # Typo I often make

bindkey -v
unsetopt beep
export EDITOR='vim'
# Don't close terminal on Ctrl-D (which sends eof)
# I send this all the time by accident after using it inside a command...
set -o ignoreeof

# For the Python config library Hydra
export HYDRA_FULL_ERROR=1

alias k="kubectl"
alias kns="kubectl ns"
alias kctx="kubectl ctx"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH:$HOME/.local/bin"

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Disable terminal freezing on ctrl-s
stty -ixon

# When this file is found in the starting directory, launch a tmux session
# Useful for giving each Pycharm project its own tmux session
# First condition: .tmux_session_name should exist
# Second condition: $TMUX should be empty/unset
if [ -f .tmux-session-name ] && [ -z "${TMUX}" ]; then
    tmux_session_name=$(<.tmux-session-name)
    # Third condition: only attach if the session doesn't exist or is unattached
    if [[ $(tmux ls | grep "^${tmux_session_name}:.*(attached)$" | wc -c ) -eq 0 ]]; then
        tmas $tmux_session_name
    else
        echo "Not auto-attaching to attached tmux session. Attach with:\ntmas $tmux_session_name"
    fi
fi

if [ -n "${TMUX}" ] && [ -z "${VIRTUAL_ENV}" ]; then
    if [ -f .venv/bin/activate ]; then
        source .venv/bin/activate
    fi
fi

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

fpath+=~/.zfunc; autoload -Uz compinit; compinit
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
alias urf="uv run --frozen"
export UV_DEFAULT_INDEX="https://artifactory.mavensecurities.com/artifactory/api/pypi/mavenall-pypi-prod-eu/simple"
export UV_SYSTEM_CERTS=true

# Claude
if [[ -f "$HOME/.dots/litellm_api_key" ]]; then
    LITELLM_API_KEY="$(<$HOME/.dots/litellm_api_key)"
    SOURCEGRAPH_TOKEN="$(cat "$HOME/.dots/sourcegraph_api_key" 2>/dev/null)"
    SRSE_V7_DEFAULTS="$HOME/.dots/srse.v7.defaults"
    SRSE_V8_DEFAULTS="$HOME/.dots/srse.v8.defaults"
    # The below start command exposes only the relevant env variables to Claude.
    # Claude does not correctly handle Proxy env so vital these are removed
    claude() {
      env -i \
        PATH="$PATH" \
        HOME="$HOME" \
        USER="$USER" \
        ANTHROPIC_BASE_URL="https://llm-proxy.cs.mavensecurities.com" \
        ANTHROPIC_AUTH_TOKEN="$LITELLM_API_KEY" \
        SSL_CERT_FILE="$SSL_CERT_FILE" \
        NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE" \
        CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1 \
        SOURCEGRAPH_TOKEN="$SOURCEGRAPH_TOKEN" \
        SRSE_V7_DEFAULTS="$SRSE_V7_DEFAULTS" \
        SRSE_V8_DEFAULTS="$SRSE_V8_DEFAULTS" \
        TERM="xterm-256color" \
        claude "$@"
    }

    opencode() {
      env -i \
        PATH="$PATH" \
        HOME="$HOME" \
        USER="$USER" \
        TERM="xterm-256color" \
        OPENAI_API_KEY="$LITELLM_API_KEY" \
        OPENAI_BASE_URL="https://llm-proxy.cs.mavensecurities.com" \
        SOURCEGRAPH_TOKEN="$SOURCEGRAPH_TOKEN" \
        SSL_CERT_FILE="$SSL_CERT_FILE" \
        NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE" \
        "$HOME/.opencode/bin/opencode" "$@"
    }
fi


# fzf: prepend so it wins over any older distro fzf (e.g. /usr/bin/fzf
# 0.29 on jammy doesn't support --zsh).
export PATH="$HOME/.fzf/bin:$PATH"
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# validate-app completion (bash script via bashcompinit)
autoload -Uz bashcompinit && bashcompinit
source "/home/gil.rutter@mavensecurities.com/repos/k8s-deployments/util/packages/validate-app/validate-app-completion.bash"

# User completions (added by validate-app --install-tools)
fpath=(/home/gil.rutter@mavensecurities.com/.zsh/completions $fpath)
autoload -Uz compinit && compinit
