#!/bin/bash

#############################
#  Enable colourful output  #
#############################

reset_style='\033[00m'
mac_bold_magenta=$reset_style'\033[0;35m'
linux_bold_light_blue=$reset_style'\033[1;36m'
bold_red=$reset_style'\033[1;31m'

#####################################
#  Config before creating symlinks  #
#####################################

PLATFORM=`uname -s | tr '[A-Z]' '[a-z]'`

if [ $PLATFORM == "darwin" ]; then
   ln_dir_options="-svFfh"
   message_colour=$mac_bold_magenta
elif [ $PLATFORM == "linux" ]; then
   ln_dir_options="-sfnv"
   message_colour=$linux_bold_light_blue
else
   echo -e "$bold_red""System $PLATFORM not recognised. Update this file to include: $PLATFORM.""$reset_style"
   exit
fi

#############################
#  Create general symlinks  #
#############################

echo -e ""
echo -e "$message_colour""###############################"
echo -e                  "#  Creating general symlinks  #"
echo -e                  "###############################""$reset_style"
echo -e ""

ln  -sv  ~/.dots/profile     ~/.profile
ln  -sv  ~/.dots/tmux.conf   ~/.tmux.conf
ln  -sv  ~/.dots/bash_ps1    ~/.bash_ps1
ln  -sv  ~/.dots/inputrc     ~/.inputrc

##################
#  ssh symlinks  #
##################

echo -e ""
echo -e "$message_colour""#########################"
echo -e                  "#  Setting SSH aliases  #"
echo -e                  "#########################""$reset_style"
echo -e ""

mkdir -v ~/.ssh
ln  -sv  ~/.dots/ssh_config  ~/.ssh/config

#################
#  Install ack  #
#################

echo -e ""
echo -e "$message_colour""####################"
echo -e                  "#  Installing ack  #"
echo -e                  "####################""$reset_style"
echo -e ""

mkdir -v ~/bin
sh -c "curl http://beyondgrep.com/ack-2.04-single-file > ~/bin/ack && chmod 0755 ~/bin/ack"

##################
#  Vim symlinks  #
##################

echo -e ""
echo -e "$message_colour""####################"
echo -e                  "#  Setting up VIM  #"
echo -e                  "####################""$reset_style"
echo -e ""

mkdir -v ~/.vim
mkdir -v ~/.vim/backup

ln -sv ~/.dots/vimrc          ~/.vimrc
ln -sv ~/.dots/vim/lammps.vim ~/.vim/syntax/lammps.vim

echo -e "$message_colour""\nMaking symlinks for vim subdirectories.""$reset_style"
for DIR in bundle colors UltiSnips; do

   rm -rf ~/.vim/$DIR
   ln $ln_dir_options ~/.dots/vim/$DIR ~/.vim/$DIR

done

echo -e "$message_colour""\nInstalling vundle as submodule.""$reset_style"
rm -rf ~/.dots/vim/bundle/vundle
git submodule init
git submodule update

echo -e "$message_colour""Now run :BundleInstall inside Vim.""$reset_style"
