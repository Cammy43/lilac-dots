#!/bin/sh
echo "\nInstalling Lilac\n"

yay -S fastfetch  --noconfirm
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland hypridle lua gcc nano btop noctalia flatpak figlet --noconfirm
