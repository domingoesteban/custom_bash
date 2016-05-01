#!/bin/bash

CUSTOM_BASH="$(cd "$(dirname "$0")" && pwd)"

# Check the OS that is running
if [ "$OSTYPE" != "linux-gnu" ]; then
    echo -e "\033[0;33mYou are not running 'linux-gnu' so I cannot ensure that this script will work correctly.\033[0m" >&2
    read -p "Do you still want to continue? [y/N]  " RESP
    if [[ ("$RESP" != "Y") && ("$RESP" != "y" ) ]]; then
      echo -e "\033[91mInstallation aborted.\033[m"
      exit 1;
    fi
fi

echo ""
echo "Installing custom_bash in $OSTYPE ..."
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

while true
do
    read -e -n 1 -r -p "Would you like to keep your $CONFIG_FILE and append custom_bash templates at the end? [y/N] " choice
    case $choice in
    [yY])
        test -w "$HOME/$CONFIG_FILE" &&
        cp -aL "$HOME/$CONFIG_FILE" "$HOME/$CONFIG_FILE.bak" &&
        echo -e "\033[0;32mYour original $CONFIG_FILE has been backed up to $CONFIG_FILE.bak\033[0m"

        (sed "s|{{CUSTOM_BASH}}|$CUSTOM_BASH|" "$CUSTOM_BASH/template/bashrc.template.bash" | tail -n +2) >> "$HOME/$CONFIG_FILE"
        echo -e "\033[0;32mCustom_bash template has been added to your $CONFIG_FILE\033[0m"
        break
        ;;
    [nN]|"")
        test -w "$HOME/$CONFIG_FILE" &&
        cp -aL "$HOME/$CONFIG_FILE" "$HOME/$CONFIG_FILE.bak" &&
        echo -e "\033[0;32mYour original $CONFIG_FILE has been backed up to $CONFIG_FILE.bak\033[0m"
        sed "s|{{CUSTOM_BASH}}|$CUSTOM_BASH|" "$CUSTOM_BASH/template/bashrc.template.bash" > "$HOME/$CONFIG_FILE"
        break
        ;;
    *)
        echo -e "\033[91mPlease choose y or n.\033[m"
        ;;
    esac
done

echo -e "\033[0;32mCopied the template $CONFIG_FILE into ~/$CONFIG_FILE, edit this file to customize custom_bash\033[0m"

echo ""
echo -e "\033[0;32mInstallation finished successfully!\033[0m"
echo -e "\033[0;32mTo start using it, open a new tab or 'source "$CONFIG_FILE"'.\033[0m"
echo ""
