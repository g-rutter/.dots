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
alias lammps="cd $HOME2/lammps/"
alias dynamo="cd $HOME2/dynamo/"
alias ~2="cd $HOME2"
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

#Get into vim faster
alias v="vim -p" # open with tabs by default

alias python3="LD_PRELOAD='' python3"
alias py="ipython"

alias makelmp="make openmpi2 && make makelib && make -f Makefile.lib openmpi2 && cp liblammps_openmpi2.a ~/lib/ && cp lmp_openmpi2 ~/bin/ && cp library.h ~/include/liblmp.h"
alias makedynamo="BOOST_BUILD_PATH=~/boost/tools/build/v2/ ~/boost/bjam install toolset=gcc link=static runtime-link=static include=~/boost/ linkflags=\"-L ~/boost/stage/lib/\""

alias ack="ack --color-match=\"red bold\""
alias ick="ack -i --color-match=\"red bold\""

bblue=`printf "\033[1;34m"`
blue=`printf "\033[34m"`
white=`printf "\033[1;37m"`
reset=`printf "\033[00m"`

# Job managing aliases: qme to see all my jobs, qn to see all nazgul jobs, qda to delete all my jobs
alias qme="qstat -u phrlaq | tail -n +4 | sed 's/NDS  /  NDS/' | sed 's/^\(.\{21\}\)\(.\{9\}\)\(.\{26\}\)\(.\{9\}\)/\1\3/' | sed 2d | sed 's/^J.*/$white\0$reset/' | sed 's/\(^[^\.]\+\)\([a-z0-9\.]*\)  /$bblue\1 $reset\2 /'"
alias qmt="qstat -u phrlaq -t | tail -n +4 | sed 's/NDS  /  NDS/' | sed 's/^\(.\{21\}\)\(.\{9\}\)\(.\{26\}\)\(.\{9\}\)/\1\3/' | sed 2d | sed 's/^J.*/$white\0$reset/' | sed 's/\(^[^\.]\+\)\([a-z0-9\.]*\)  /$bblue\1 $reset\2 /'"
alias qn="qstat | grep nazgul | sed 's/\([0-9]\+\)\(\.[a-zA-Z]\+ \)/\1 \2/' | sed 's/\(^[0-9]*\)\(.*\)\( phrlaq \)/$bblue\1$reset\2$bblue\3$reset/' | sed 's/ nazgul *$//'"
alias qda="qdel all 2>&1 | grip -v '\(Deletion\)\|\(Unauthorized Request\)" #delete all my jobs without bothing me about other jobs.
alias kbn="killbyname"

###############
#  Functions  #
###############

#rm () {
    #mkdir -p /tmp/recycle_bin/
    #mv $* /tmp/recycle_bin/
    #chmod 700 $*
#}

vmdcd () {
    #Automatically find a matching PSF file

    PSF_FILES=($(find . -maxdepth 1 -name '*.psf'))

    if [[ -z "${PSF_FILES[0]}" ]]; then
           PSF_FILES=($(find .. -maxdepth 1 -name *.psf))
    fi

    PSF_FILE=${PSF_FILES[0]}

    echo vmd $* -psf ${PSF_FILE}
    vmd $* -psf ${PSF_FILE}
}

swap () {
    # Swap files $1 and $2. With no args given, swap last 2 files swapped.
    args=("$@")
    n_args=${#args[@]}
    swapfnfiles=("" "")
    temp=${RANDOM}

    #Try to populate swapfnfiles if at least 1 arg was given.
    #Ohtherwise, rely on it already being populated.
    if [[ $n_args -eq 2 ]]; then
        swapfnfiles=("${args[0]}" "${args[1]}")
    elif [[ $n_args -eq 1 ]]; then
        echo "1 arg"
        swapfnfiles[0]="${args[0]}"
        if [[ "${args[0]:(-4)}" = ".bck" ]]; then
            swapfnfiles[1]="${args[0]%.bck}"
        else
            swapfnfiles[1]="${args[0]}.bck"
        fi
    fi

    #Swap if swapfnfiles is populated
    if [[ ${#swapfnfiles[@]} -eq 2 ]]; then
        mv -fn ${swapfnfiles[0]} ${swapfnfiles[1]}.$temp >/dev/null
        mv -fn ${swapfnfiles[1]} ${swapfnfiles[0]}       >/dev/null
        mv -fn ${swapfnfiles[1]}.$temp ${swapfnfiles[1]} >/dev/null
        echo $bblue"Created `ls ${swapfnfiles[0]} ${swapfnfiles[1]}`"$reset
    else
        echo "No files to swap. Please pass some args."
    fi

}

= () {
    A=`echo "$*" | bc -l`
    echo A=$A
} #Basic calculator. e.g. type '= 2.2*2.2' to get the output '4.84'

killbyname () { # Kills ALL processes that match the name e.g. 'killbyname firefox'. You can't accidentally kill other people's stuff, but you can lose unsaved work etc and make your session screw up.

    Nresults_before=`ps ax | grep $1 | grep -v grep | wc -l`

    for i in `ps ax | grep $1 | grep -v grep | sed 's/ *//' | sed 's/[^0-9].*//'`
    do
        kill -9 $i
    done

    Nresults_after=`ps ax | grep $1 | grep -v grep | wc -l`

    echo "Killed $(($Nresults_before - $Nresults_after)) process(es)."
}

desc () { #print the description of a job folder
    cat $1/description 2> /dev/null
}

dall () { #Describe all: print the description of every folder.
    for line in `ls -1F | grep /$`
    do
        echo "\033[34m\033[1m$(du -h $line)\033[0m"
        cat $line/description 2> /dev/null
        echo '\n'
    done
}

h () { #Print command history with negative index so that !-N:x-y type commands can be used
    if [ -n "$*" ]; then
        n_entries=`history | wc -l`
    else
        n_entries=30
    fi

    hist=`history $n_entries`
    nhist=$(( -1 * `history $n_entries | wc -l` ))
    maxlen=${#nhist}

    while read -r line; do
        line=`echo "$line" | sed "s/^[0-9 ]\+//g" | ack "$*"`
        if [ -n "$line" ]; then
            echo "$bblue$nhist $reset"$line
        fi
        nhist=`printf "%${maxlen}s" $(( $nhist + 1 ))`
    done <<< "$hist"
}

mkcd () { #Make a new dir and cd into it.
    mkdir -p "$*"
    cd "$*"
}

t () { #Open all text files in pwd which are smaller than 100MB in Vim, in tabs, if they match any of the following arguments

    search=`echo $*| sed 's/ /|/g'`
    FINAL_LIST=""

    TEXT_FILES=`file * | ack ':.*text' | sed  's/:.*text.*//' | ack "$search"`

    for FILE in `file * | ack ':.*text' | sed  's/:.*text.*//' | ack "$search"`; do

        FILESIZE=$(stat -c%s "$FILE")

        if [[ $FILESIZE -lt 104857600 ]]; then
            FINAL_LIST+="$FILE "
        fi

    done

    if [[ ${#FINAL_LIST} -ge 1 ]]; then
        echo "Opening the following files for editing:"
        echo $FINAL_LIST
        $EDITOR $FINAL_LIST
    else
        echo "Nothing to open."
    fi
}

qd () {

    jobs=(`qstat -u phrlaq -t | tail -n +6 | sed 's/\..\+$//'`)
    jobnumber=${jobs[ $(($1 - 1)) ]}

    if [ -n "$jobnumber" ]; then
        echo Deleting job $jobnumber
        qdel $jobnumber
    else
        echo No such job
    fi

    sleep 0.3
    qme
}

################################
#  Platform-specific settings  #
################################

PLATFORM_BASHRC=$HOME/.bashrc_$PLATFORM

#Deprecated in favour of local-only .bashrc shown below
if [ -a $PLATFORM_BASHRC ]; then
    source $PLATFORM_BASHRC
fi

if [ -a $HOME/.bashrc_local ]; then
    source $HOME/.bashrc_local
fi

#################
#  Get TMUX up  #
#################

# Launch TMUX on bittern if not already launched
if [ "$TMUX" == '' ] && [ "$HOST" == 'bittern' ]
then
    existing_session_count=$(tmux ls | grep . -c)
    if [ $existing_session_count -eq '0' ]
    then
        tmux -2
    else
        tmux attach -d
    fi
fi
