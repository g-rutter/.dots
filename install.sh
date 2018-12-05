#!/bin/bash

##############
#  Settings  #
##############

dots_dir="$HOME/.dots"

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

ln  -sv  $dots_dir/profile           ~/.profile
ln  -sv  $dots_dir/tmux.conf         ~/.tmux.conf
ln  -sv  $dots_dir/bash_ps1          ~/.bash_ps1
ln  -sv  $dots_dir/inputrc           ~/.inputrc
ln  -sv  $dots_dir/gitconfig         ~/.gitconfig
ln  -sv  $dots_dir/config            ~/.config

##################
#  ssh symlinks  #
##################

echo -e ""
echo -e "$message_colour""#########################"
echo -e                  "#  Setting SSH aliases  #"
echo -e                  "#########################""$reset_style"
echo -e ""

mkdir -v ~/.ssh
ln  -sv  $dots_dir/ssh_config  ~/.ssh/config
chmod 600 ssh_config

#################
#  Install ack  #
#################

echo -e ""
echo -e "$message_colour""####################"
echo -e                  "#  Installing ack  #"
echo -e                  "####################""$reset_style"
echo -e ""

mkdir -v ~/bin
sh -c "curl -L http://beyondgrep.com/ack-2.22-single-file > ~/bin/ack && chmod 0755 ~/bin/ack"

############
#  Vimcat  #
############

cp vimcat ~/bin/

###########
#  nbtxt  #
###########

ln -sv $dots_dir/nbtxt ~/bin/nbtxt

######################
#  FZF installation  #
######################

echo -e ""
echo -e "$message_colour""####################"
echo -e                  "#  Setting up FZF  #"
echo -e                  "####################""$reset_style"
echo -e ""

git submodule update --init --recursive
echo -e "y\ny\ny\n" | $dots_dir/fzf/install

##################
#  Vim symlinks  #
##################

vimdir="$dots_dir/config/vim/"

echo -e ""
echo -e "$message_colour""####################"
echo -e                  "#  Setting up VIM  #"
echo -e                  "####################""$reset_style"
echo -e ""

mkdir -v ~/.vim
mkdir -v ~/.vim/syntax
mkdir -v ~/.vim/backup
mkdir -v ~/.vim/undo

ln -sv $dots_dir/vimrc                 ~/.vimrc
ln -sv $vimdir/lammps.vim ~/.vim/syntax/lammps.vim

# vimrc symlink for neovim
mkdir -p ~/.config/nvim
ln -s $dots_dir/vimrc ~/.config/nvim/init.vim
ln -s $dots_dir/config/vim/colors ~/.config/nvim/colors

echo -e "$message_colour""\nMaking symlinks for vim subdirectories.""$reset_style"
for DIR in spell bundle colors; do

   rm -rf ~/.vim/$DIR
   ln $ln_dir_options $vimdir/$DIR ~/.vim/$DIR

done

##########
#  Fish  #
##########

if [[ $SHELL =~ fish$ ]]; then
    curl -L https://get.oh-my.fish | fish
    fish -c "omf install"
fi 

############################
#  Vundle and vim bundles  #
############################

echo -e "$message_colour""\nGrabbing vundle.""$reset_style"

rm -rf $vimdir/bundle/vundle
mkdir -vp $vimdir/bundle
git clone https://github.com/VundleVim/Vundle.vim $vimdir/bundle/Vundle.vim

echo -e "$message_colour""\nLaunching Vim to install plugins. Press enter if required.""$reset_style"

vim +BundleInstall +qall --noplugin

# Build fzf for Vim
$vimdir/bundle/fzf/install --all

echo -ne "$message_colour""\nCompile YouCompleteMe's support libs? (Takes a while) [y]: ""$reset_style"
read answer
echo ""

if [[ $answer = 'y' || $answer = 'Y' ]]; then
   echo "Building..."
   cd $HOME/.vim/bundle/YouCompleteMe/
   git submodule update --init --recursive
   ./install.py
   cd $HOME/.vim/
fi

echo -e "$message_colour""Done!""$reset_style"
