# vim: set filetype=sh:
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

##############
#  Settings  #
##############

export EDITOR="v"
export PLATFORM=`uname -s | tr '[A-Z]' '[a-z]'`
export LESS=-RFX

export PATH="$PATH:$HOME/bin"

export PBSdir="/home/theory/phrlaq/scripts/MD/PBS/"
export MDdir="$HOME/scripts/MD/"

export PYTHONSTARTUP="$HOME/.dots/python_interactive_startup.py"

set -o vi #Work in Vi mode!
unset SSH_ASKPASS #No gui interface when asking me for git password

if [[ `readonly | ack "COMMAND=" | wc -l` -eq 0 ]]; then
    PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
fi

#Stop ^S annoyingly freezing the terminal
stty stop undef

shopt -s cdspell #Minor errors in the spelling of a directory will be corrected (after enter is pressed)
shopt -s cmdhist #Save all lines of a multi-line command in the same hist entry.
shopt -s histappend
shopt -s histreedit #(With readline being used) user gets chance to re-edit failed history substitutions
shopt -s no_empty_cmd_completion #no completion when spamming <TAB> on an empty line.

if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s autocd #Directory names given at the interative shell are interpreted as if they're an argument to cd.
    shopt -s dirspell #Correct directory spelling during word completion
fi

#################################
#  Platform-dependent settings  #
#################################

if [[ $PLATFORM = darwin ]]; then
    # Enable macports binaries
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

    alias ll='ls -lFhG'
    alias la='ls -AlFhG'
    alias ls='ls -G'
else
    alias ll='ls -alFh --color=auto'
    alias la="ls -A"
fi

####################
#  PS1 prettifier  #
####################

if [ -f "$HOME/.bash_ps1" ]; then
  . "$HOME/.bash_ps1"
fi

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD")'

####################
#  Custom aliases  #
####################

# Better git defaults
alias gitb="git branch -av"
alias gits="git status"
alias gitd="git diff"
alias gitl="git log"
alias gitr="git remote -v"

#mysql usage on scl servers
alias mysqle="mysql --pass=$(cat ~/.mysql-passwd) -e"
alias mysql_show="mysql --pass=$(cat ~/.mysql-passwd) -e \"SHOW PROCESSLIST\""
alias mysql_sf="mysql --pass=$(cat ~/.mysql-passwd) -e \"SHOW FULL PROCESSLIST\""

#Change default options for basic commands
alias cp="cp -v"              #-v: Verbose
alias mv="mv -v"              #-v: Verbose
alias mkdir="mkdir -v"        #-v: Verbose
alias pdfgrep="pdfgrep -n --color=auto"
alias echo="echo -e"
alias tmux="tmux -2"
alias w3m="w3m -num -no-mouse -cookie"
alias pause="echo \"The command you're looking for is called sleep.\""
alias parallel="parallel --ungroup"
alias xmgrace="xmgrace -hdevice EPS"
#Shortcuts for moving around
alias d="cd ~/Documents"      #Typing d will take you to your documents.
alias dots="cd ~/.dots"
alias ..="cd .."
alias ...="cd ../.."
alias 2..="cd ../.."
alias 3..="cd ../../.."
alias 4..="cd ../../../.."

#Miscellaneous shortcuts
alias vimrc="v ~/.vimrc"
alias tmuxrc="v ~/.tmux.conf"
alias inputrc="v ~/.inputrc"
alias bashrc="v ~/.bashrc"
alias profile="v ~/.profile"
alias bashrc_local="v ~/.bashrc_local"
alias p="ps aux |grep"
alias o="gnome-open 2>/dev/null"            #Open a file in the default program that it would open in if you went to the file explorer and double clicked it eg 'o intro.pdf' to open it in the GUI pdf program.

if hash nvim 2>/dev/null; then
    alias v="nvim -p"
else
    alias v="vim -p"
fi

alias py="ipython --TerminalInteractiveShell.editing_mode=vi"

alias ack="ack --color-match=\"red bold\""
alias ick="ack -i --color-match=\"red bold\""

###############
#  Functions  #
###############

= () {
    A=`echo "$*" | bc -l`
    echo A=$A
} #Basic calculator. e.g. type '= 2.2*2.2' to get the output '4.84'

mkcd () { #Make a new dir and cd into it.
    mkdir -p "$*"
    cd "$*"
}

#################################################
#  Load up my Python virtualenv on the servers  #
#################################################

if [[ "$HOSTNAME" =~ svr-0[0-9]\..*int.sclgroup\.cc|ip-10-160-180-7 ]]
then
    VIRTUAL_ENV_DISABLE_PROMPT=true
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
    PIP_REQUIRE_VIRTUALENV=true

    workon develop
fi

#############################
#  Local-specific settings  #
#############################

if [ -a $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

#################
#  Get TMUX up  #
#################

# Launch TMUX if not already launched
if [ "$TMUX" == '' ]
then
    existing_session_count=$(tmux ls | grep . -c)
    if [ $existing_session_count -eq '0' ]
    then
        tmux
    else
        tmux attach -d
    fi
fi
