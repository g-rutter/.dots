# If not running interactively, don't do anything
[ -z "$PS1" ] && return

##############
#  Settings  #
##############

set -o vi #Work in Vi mode!

PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

#Stop ^S annoyingly freezing the terminal
stty stop undef

shopt -s cdspell #Minor errors in the spelling of a directory will be corrected (after enter is pressed)
shopt -s cmdhist #Save all lines of a multi-line command in the same hist entry.
shopt -s histappend
shopt -s histreedit #(With readline being used) user gets chance to re-edit failed history substitutions
shopt -s no_empty_cmd_completion #no completion when spamming <TAB> on an empty line.

if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
   shopt -s autocd #Directory names giving at the interative shell are interpreted as if they're an argument to cd.
   shopt -s dirspell #Correct directory spelling during word completion
fi

export EDITOR="vim -p"
export PLATFORM=`uname -s`
export LESS=-RFX
export PATH="$PATH:$HOME/bin"

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
alias lg="ll | grep "
alias l1="ls -1"
alias rm="rm -iv"             #-i: Ask you to confirm before deletions. Can be overridden at any time by using the -f option. -v: be verbose. Makes it say exactly what it is doing.
alias rmd="rm -rf" #remove a directory silently without asking
alias cp="cp -v"              #-v: Verbose
alias mv="mv -v"              #-v: Verbose
alias mkdir="mkdir -v"        #-v: Verbose
alias pdfgrep="pdfgrep -n --color=auto"
alias echo="echo -e"
alias tmux="tmux -2"
alias w3m="w3m -num -no-mouse -cookie"

#Shortcuts for moving around
alias d="cd ~/Documents"      #Typing d will take you to your documents.
alias ~="cd ~"                #Typing ~ will do cd ~, which takes you to your home directory.
alias dots="cd ~/.dots"
alias lammps="cd $HOME2/lammps/"
alias dynamo="cd $HOME2/dynamo/"
alias votesim="cd $HOME2/votesim/"
alias ~2="cd $HOME2"
alias ..="cd .."
alias 2..="cd .. && cd .."
alias 3..="cd .. && cd .. && cd .."
alias 4..="cd .. && cd .. && cd .. && cd .."

#Miscellaneous shortcuts
alias vimrc="vim ~/.vimrc"
alias tmuxrc="vim ~/.tmux.conf"
alias inputrc="vim ~/.inputrc"
alias bashrc="vim ~/.bashrc"
alias bashrc_local="vim ~/.bashrc_local"
alias h="history|grep"        #Search your command history by typing 'h <query>'
alias f="find . |grep"        #Search from your current directory downwards for matches in file name by typing 'f <query>'
alias p="ps aux |grep"
alias o="kde-open"            #Open a file in the default program that it would open in if you went to the file explorer and double clicked it eg 'o intro.pdf' to open it in the GUI pdf program.

#Get into vim faster
alias v="vim -p" # open with tabs by default
alias vs="vim -O" # opens a vertical split
alias sp="vim -o" # opens a vertical split

alias python3="LD_PRELOAD='' python3"
alias py="ipython"

alias makelmp="make openmpi2 && make makelib && make -f Makefile.lib openmpi2 && cp liblammps_openmpi2.a ~/lib/ && cp lmp_openmpi2 ~/bin/ && cp library.h ~/include/liblmp.h"

alias ack="ack --color-match=\"red bold\""
alias ick="ack -i --color-match=\"red bold\""

bblue=`printf "\033[1;34m"`
blue=`printf "\033[34m"`
white=`printf "\033[1;37m"`
reset=`printf "\033[00m"`

# Job managing aliases: qme to see all my jobs, qn to see all nazgul jobs, qda to delete all my jobs
alias qme="qstat -u phrlaq -t | tail -n +4 | sed 's/NDS  /  NDS/' | sed 's/^\(.\{21\}\)\(.\{9\}\)\(.\{26\}\)\(.\{9\}\)/\1\3/' | sed 2d | sed 's/^J.*/$white\0$reset/' | sed 's/\(^[0-9]\+\)\([a-z0-9\.]*\)  /$bblue\1 $reset\2 /'"
alias qn="qstat | grep nazgul | sed 's/\([0-9]\+\)\(\.[a-zA-Z]\+ \)/\1 \2/' | sed 's/\(^[0-9]*\)\(.*\)\( phrlaq \)/$bblue\1$reset\2$bblue\3$reset/' | sed 's/ nazgul *$//'"
alias qda="qdel all 2>&1 | grip -v '\(Deletion\)\|\(Unauthorized Request\)" #delete all my jobs without bothing me about other jobs.
alias kbn="killbyname"

###############
#  Functions  #
###############

= () { echo "$*" | bc -l;} #Basic calculator. e.g. type '= 2.2*2.2' to get the output '4.84'

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
   for line in $(ls -1F | grep /$ )
   do
      echo "\033[34m\033[1m$(du -h $line)\033[0m"
      cat $line/description 2> /dev/null
      echo '\n'
   done
}

h- () { #Print command history with negative index so that !-N:x-y type commands can be used
   hist=$(history | tail -n 70)

   nhist=$(( -1 * $( echo "$hist" | wc -l ) ))

   while read -r line; do
      line=$( echo "$line" | sed "s/^[0-9 ]\+//g" )
      echo -e "$nhist\t$line"
      nhist=$(( $nhist + 1 ))
   done <<< "$hist"
}

mkcd () { #Make a new dir and cd into it.
   mkdir -p "$*"
   cd "$*"
}

vt () { #Open all text files in pwd which are smaller than 100MB in Vim, in tabs
   echo "Opening the following files for editing:"

   LIST=""

   for FILE in `file * | ack ':.*ASCII.*text' | sed  's/:.*ASCII.*text.*//'`; do

      FILESIZE=$(stat -c%s "$FILE")

      if [[ $FILESIZE -lt 104857600 ]]; then
         printf "$FILE "
         LIST+="$FILE "
      fi

   done

   echo ""

   vim -p $LIST
}

#########################
#  Local-only settings  #
#########################

if [ -a ~/.bashrc_local ]; then
   source ~/.bashrc_local
fi

#################
#  Get TMUX up  #
#################

# No nesting, and no tmux in PBS interactive environment.
if [ "$TMUX" == '' ] && [ "$PBS_ENVIRONMENT" == '' ]
then
   existing_session_count=$(tmux ls | grep . -c)
   if [ $existing_session_count -eq '0' ]
   then
      tmux -2
   else
      tmux attach -d
   fi
fi
