#!/bin/bash
##############################################################################################
# prueba.sh
#
##############################################################################################

# Get path
CURRENT_PATH=$(dirname $(readlink --canonicalize --no-newline $BASH_SOURCE))
echo "Running prueba.sh in $CURRENT_PATH"

# Execute another script (point and source)
. $CURRENT_PATH/.domingo/scape_colors
source $CURRENT_PATH/.domingo/useful_functions
echo_color "Using echo_color function in $CURRENT_PATH/.domingo/useful_functions" $SCAPE_BLUE

# Check if file exists 
if [ -f $CURRENT_PATH/bootstrap.sh ]; then
  echo "File exists"
else
  echo "File DOESN'T exist"
fi

# Check if a folder exists
if [ -d $CURRENT_PATH/.domingo ]; then
  echo "Directory exists"
else
  echo "Directory DOESN'T exist"
fi

# Confirmation example (Using .domingo's function)
confirm "$(echo_color "Would you want to show a message?" $SCAPE_BRED)" && echo "Showing an message with confirmation";
