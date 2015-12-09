#!/bin/bash
##############################################################################################
# bootstrap.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
##############################################################################################

# Useful variables
OLD_DOT_DIR='dotfiles_old'
CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OLD_DOT_PATH=$CURRENT_PATH/$OLD_DOT_DIR

. $CURRENT_PATH/.domingo/scape_colors
. $CURRENT_PATH/.domingo/useful_functions

echo_color "Running bootstrap.sh in $CURRENT_PATH" $SCAPE_BLUE

# Pull repository
cd $CURRENT_PATH;
confirm "$(echo_color "Would you want to pull the current repository?" $SCAPE_BRED)" && git pull origin master;

#TODO
#Movy current dotfiles to .old_dotfiles
#Create symlinks to the dotfiles of this directory
#TODO 2
#Create a second script to remove symlinks and restore the old ones. (Like an uninstalling)
