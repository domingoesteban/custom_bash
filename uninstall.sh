#!/bin/bash
if [ -z "$MY_BASH" ];
then
  MY_BASH="$HOME/.my_bash++"
fi

# Check the OS that is running
if [ "$OSTYPE" != "linux-gnu" ]; then
    echo -e "\033[0;33mYou are not running 'linux-gnu' so I cannot ensure that this script will work correctly.\033[0m" >&2
    read -p "Do you still want to continue? [y/N] " RESP
    if [[ ("$RESP" != "Y") && ("$RESP" != "y" ) ]]; then
        echo -e "\033[91mUninstallation aborted.\033[m"
        exit 1;
    fi
fi

echo ""
echo "Uninstalling my_bash++ in $OSTYPE ..."
CONFIG_FILE=.bashrc
BACKUP_FILE=$CONFIG_FILE.bak

if [ ! -e "$HOME/$CONFIG_FILE" ]; then
    echo -e "\033[91mNo $HOME/$CONFIG_FILE has been found. Uninstallation aborted.\033[m"
    exit 1
fi

if [ ! -e "$HOME/$BACKUP_FILE" ]; then
  echo -e "\033[0;33mBackup file "$HOME/$BACKUP_FILE" not found!!\033[0m" >&2
    while true
        do
        read -e -n 1 -r -p "Your $HOME/$CONFIG_FILE will be removed. Do you still want to continue? [y/N] " RESP
        case $RESP in
        [yY])
            break
            ;;
        [nN]|"")
            echo -e "\033[91mUninstallation aborted.\033[m"
            exit 1
            ;;
        *)
            echo -e "\033[91mPlease choose y or n.\033[m"
            ;;
        esac
    done

  test -w "$HOME/$CONFIG_FILE" &&
    mv "$HOME/$CONFIG_FILE" "$HOME/$CONFIG_FILE.uninstall" &&
    echo -e "\033[0;32mMoved your $HOME/$CONFIG_FILE to $HOME/$CONFIG_FILE.uninstall.\033[0m" && 
  echo -e "\033[0;33mRemember that you now do not have the "$HOME/$CONFIG_FILE" file.\033[0m" >&2
else
  test -w "$HOME/$BACKUP_FILE" &&
    cp -a "$HOME/$BACKUP_FILE" "$HOME/$CONFIG_FILE" &&
    rm "$HOME/$BACKUP_FILE" &&
    echo -e "\033[0;32mThe original $CONFIG_FILE has been restored.\033[0m"
fi

echo ""
echo -e "\033[0;32mUninstallation finished successfully!\033[0m"
echo ""
echo "Final steps to complete the uninstallation:"
echo "  -> Remove the $MY_BASH folder"
echo "  -> Open a new shell/tab/terminal"
