#!/bin/bash
echo "[INFO]: Downloading files"
yay -S fastfetch  --noconfirm
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland shelly polkit hyprpolkitagent hyprshot hypridle hyprlock lua gcc foot nano btop noctalia flatpak quickshell figlet ttf-jetbrains-mono --noconfirm
