#!/bin/bash

MY_BASH="$(cd "$(dirname "$0")" && pwd)"

# Check the OS that is running
if [ "$OSTYPE" != "linux-gnu2" ]; then
    echo -e "\033[0;33mYou are not running 'linux-gnu' so I cannot ensure that this script will work correctly.\033[0m" >&2
    read -p "Do you still want to continue? [y/N]  " RESP
    if [[ ("$RESP" != "Y") && ("$RESP" != "y" ) ]]; then
      echo -e "\033[91mInstallation aborted.\033[m"
      exit 1;
    fi
fi

echo ""
echo "Installing my_bash++ in $OSTYPE"
CONFIG_FILE=.bashrc
BACKUP_FILE=$CONFIG_FILE.bak

if [ -e "$HOME/$BACKUP_FILE" ]; then
    echo -e "\033[0;33mBackup file already exists. Make sure to backup your .bashrc before running this installation.\033[0m" >&2
    while true
        do
        read -e -n 1 -r -p "Would you like to overwrite the existing backup? This will delete your existing backup file ($HOME/$BACKUP_FILE) [y/N] " RESP
        case $RESP in
            [yY])
                break
                ;;
            [nN]|"")
                echo -e "\033[91mInstallation aborted.\033[m"
                exit 1
                ;;
            *)
                echo -e "\033[91mPlease choose y or n.\033[m"
                ;;
        esac
    done
fi

echo ""
echo -e "\033[0;32mInstallation finished successfully!\033[0m"
echo -e "\033[0;32mTo start using it, open a new tab or 'source "$CONFIG_FILE"'.\033[0m"
echo ""

