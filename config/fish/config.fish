fish_vi_key_bindings
fzf_key_bindings

title "Local"

if hash nvim 2>/dev/null
    set EDITOR "nvim -p"
else
    set EDITOR "vim -p"
end

#######################################################################
#                               Aliases                               #
#######################################################################

alias v="$EDITOR"

#alias py="ipython --TerminalInteractiveShell.editing_mode=vi"
#alias py3="ipython3-3.6 --TerminalInteractiveShell.editing_mode=vi"

alias vimrc="v ~/.vimrc"
alias tmuxrc="v ~/.tmux.conf"

# Git aliases
alias gits="git status"
alias gitd="git diff"
alias gitb="git branch -avv"
alias gitr="git remote -v"
alias gitl="git log"

############
#  Colors  #
############

set fish_color_operator 007B7B
