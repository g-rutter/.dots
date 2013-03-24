#!/bin/sh

reset_style='\033[00m'
yellow=$reset_style'\033[0;33m'
bold_yellow=$reset_style'\[\033[1;33m\]'
bold_white=$reset_style'\[\033[1;29m\]'
bold_green=$reset_style'\[\033[1;32m\]'
bold_magenta=$reset_style'\033[0;35m'

ln  -sv  ~/.dots/profile     ~/.profile
ln  -sv  ~/.dots/tmux.conf   ~/.tmux.conf
ln  -sv  ~/.dots/bash_ps1    ~/.bash_ps1
ln  -sv  ~/.dots/inputrc     ~/.inputrc

echo "$bold_magenta""\nInstalling ssh config file.""$reset_style"
mkdir -v ~/.ssh
ln  -sv  ~/.dots/ssh_config  ~/.ssh/config

echo "$bold_magenta""\nInstalling .vimrc and bundles.""$reset_style"
ln  -sv    ~/.dots/vimrc       ~/.vimrc
ln  -svFfh ~/.dots/vim/bundle  ~/.vim/bundle
ln  -svFfh ~/.dots/vim/colors  ~/.vim/colors
ln  -svFfh ~/.dots/vim/Ultisnips  ~/.vim/Ultisnips
echo "$bold_magenta""Now run :BundleInstall inside Vim.""$reset_style"
