#!/bin/bash

reset_style='\033[00m'
yellow=$reset_style'\033[0;33m'
bold_yellow=$reset_style'\[\033[1;33m\]'
bold_white=$reset_style'\[\033[1;29m\]'
bold_green=$reset_style'\[\033[1;32m\]'
bold_magenta=$reset_style'\033[0;35m'

PLATFORM=`uname -s | tr '[A-Z]' '[a-z]'`
echo $PLATFORM

if [ $PLATFORM == "mac" ]; then
   ln_dir_options="-svFfh"
elif [ $PLATFORM == "linux" ]; then
   ln_dir_options="--symbolic -sfnv --symbolic"
fi

ln  -sv  ~/.dots/profile     ~/.profile
ln  -sv  ~/.dots/tmux.conf   ~/.tmux.conf
ln  -sv  ~/.dots/bash_ps1    ~/.bash_ps1
ln  -sv  ~/.dots/inputrc     ~/.inputrc

echo -e "$bold_magenta""\nInstalling ssh config file.""$reset_style"
mkdir -v ~/.ssh
ln  -sv  ~/.dots/ssh_config  ~/.ssh/config

echo -e "$bold_magenta""\nInstalling .vimrc and bundles.""$reset_style"
mkdir -v     ~/.vim
mkdir -v     ~/.vim/backup
ln    -sv    ~/.dots/vimrc          ~/.vimrc
ln    $ln_dir_options ~/.dots/vim/bundle     ~/.vim/bundle
ln    $ln_dir_options ~/.dots/vim/colors     ~/.vim/colors
ln    $ln_dir_options ~/.dots/vim/Ultisnips  ~/.vim/Ultisnips
echo -e "$bold_magenta""Now run :BundleInstall inside Vim.""$reset_style"
