#!/bin/bash
echo "[INFO]: Downloading files"
yay -S fastfetch  --noconfirm
sudo pacman -S --needed hyprland polkit xdg-desktop-portal-hyprland hyprshot hypridle hyprlock lua gcc foot nano btop noctalia flatpak quickshell figlet --noconfirm
