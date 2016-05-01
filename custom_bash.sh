#!/bin/bash
# Initialize custom_bash

# Reload Library
case $OSTYPE in
  darwin*)
    alias reload='source ~/.bash_profile'
    ;;
  *)
    alias reload='source ~/.bashrc'
    ;;
esac

# Only set $CUSTOM_BASH if it's not already set
if [ -z "$CUSTOM_BASH" ];
then
    # Setting $BASH to maintain backwards compatibility
    # TODO: warn users that they should upgrade their .bash_profile
    export CUSTOM_BASH=$BASH
    export BASH=`bash -c 'echo $BASH'`
fi

# For backwards compatibility, look in old BASH_THEME location
#if [ -z "$BASH_IT_THEME" ];
#then
#    # TODO: warn users that they should upgrade their .bash_profile
#    export BASH_IT_THEME="$BASH_THEME";
#    unset $BASH_THEME;
#fi

# Load composure first, so we support function metadata
#source "${BASH_IT}/lib/composure.bash"

# support 'plumbing' metadata
#cite _about _param _example _group _author _version

# Load colors first so they can be use in base theme
#source "${CUSTOM_BASH}/themes/colors.theme.bash"
#source "${CUSTOM_BASH}/themes/base.theme.bash"

# library
LIB="${CUSTOM_BASH}/lib/*.bash"
for config_file in $LIB
do
  source $config_file
done

# Load enabled aliases, completion, plugins
for file_type in "aliases"
do
  _load_custom_bash_files $file_type
done
#for file_type in "aliases" "completion" "plugins"
#do
#  _load_bash_it_files $file_type
#done

# Load custom aliases, completion, plugins
#for file_type in "aliases" "completion" "plugins"
#do
#  if [ -e "${CUSTOM_BASH}/${file_type}/custom.${file_type}.bash" ]
#  then
#    source "${CUSTOM_BASH}/${file_type}/custom.${file_type}.bash"
#  fi
#done

# Custom
#CUSTOM="${BASH_IT}/custom/*.bash"
#for config_file in $CUSTOM
#do
#  if [ -e "${config_file}" ]; then
#    source $config_file
#  fi
#done

#unset config_file
#if [[ $PROMPT ]]; then
#    export PS1="\["$PROMPT"\]"
#fi

# Adding Support for other OSes
#PREVIEW="less"
#[ -s /usr/bin/gloobus-preview ] && PREVIEW="gloobus-preview"
#[ -s /Applications/Preview.app ] && PREVIEW="/Applications/Preview.app"

# Load all the Jekyll stuff

#if [ -e "$HOME/.jekyllconfig" ]
#then
#  . "$HOME/.jekyllconfig"
#fi
