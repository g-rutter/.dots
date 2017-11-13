set PATH /opt/local/bin /opt/local/sbin $PATH

fish_vi_key_bindings

#######################################################################
#                               Aliases                               #
#######################################################################

if hash nvim 2>/dev/null
    alias v="nvim -p"
else
    alias v="vim -p"
end

alias py="ipython --TerminalInteractiveShell.editing_mode=vi"

alias vimrc="v ~/.vimrc"
alias tmuxrc="v ~/.tmux.conf"

# Git aliases
alias gits="git status"
alias gitd="git diff"
alias gitb="git branch -avv"
alias gitr="git remote -v"
