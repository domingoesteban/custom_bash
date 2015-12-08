#!/bin/bash
##############################################################################################
# bootstrap.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
##############################################################################################

# Useful variables
CURRENT_DIR=`pwd`
. .domingo/scape_colors
. .domingo/useful_functions

echo_color "Running bootstrap.sh in $CURRENT_DIR" $SCAPE_BLUE

# Pull repository
cd $CURRENT_DIR;
confirm "$(echo_color "Would you want to pull the current repository?" $SCAPE_BRED)" && git pull origin master;

#TODO
#Movy current dotfiles to .old_dotfiles
#Create symlinks to the dotfiles of this directory
#TODO 2
#Create a second script to remove symlinks and restore the old ones. (Like an uninstalling)
