#!/bin/bash

# Power menu options
options="Shutdown\nReboot\nLogout\nSleep"

# Show the menu using wofi
selected_option=$(echo -e "$options" | wofi --dmenu --prompt="Power Menu")

case $selected_option in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Sleep)
        systemctl suspend
        ;;
    *)
        exit 1
        ;;
esac
