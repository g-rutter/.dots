#!/bin/bash

#############################
#  Enable colourful output  #
#############################

reset_style='\033[00m'
bold_magenta=$reset_style'\033[0;35m'
bold_red=$reset_style'\033[1;31m'

#####################################
#  Config before creating symlinks  #
#####################################

PLATFORM=`uname -s | tr '[A-Z]' '[a-z]'`

if [ $PLATFORM == "darwin" ]; then
   ln_dir_options="-svFfh"
elif [ $PLATFORM == "linux" ]; then
   ln_dir_options="-sfnv"
else
   echo -e "$bold_red""System $PLATFORM not recognised. Update this file to include: $PLATFORM.""$reset_style"
   exit
fi

#############################
#  Create general symlinks  #
#############################

ln  -sv  ~/.dots/profile     ~/.profile
ln  -sv  ~/.dots/tmux.conf   ~/.tmux.conf
ln  -sv  ~/.dots/bash_ps1    ~/.bash_ps1
ln  -sv  ~/.dots/inputrc     ~/.inputrc

##################
#  ssh symlinks  #
##################

echo -e "$bold_magenta""\nInstalling ssh config file.""$reset_style"
mkdir -v ~/.ssh
ln  -sv  ~/.dots/ssh_config  ~/.ssh/config

##################
#  Vim symlinks  #
##################

echo -e "$bold_magenta""\nInstalling .vimrc and bundles.""$reset_style"

mkdir -v ~/.vim
mkdir -v ~/.vim/backup

ln -sv ~/.dots/vimrc ~/.vimrc

ln    $ln_dir_options ~/.dots/vim/bundle     ~/.vim/bundle
ln    $ln_dir_options ~/.dots/vim/colors     ~/.vim/colors
ln    $ln_dir_options ~/.dots/vim/UltiSnips  ~/.vim/UltiSnips

rm -rf ~/.dots/vim/bundle/vundle
git submodule init
git submodule update

echo -e "$bold_magenta""Now run :BundleInstall inside Vim.""$reset_style"
