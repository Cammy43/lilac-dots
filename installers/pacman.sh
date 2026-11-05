#!/bin/bash
echo "\nInstalling Lilac\n"

homeDir=$(pwd)
cd ~
mkdir .config/hypr
cd .config/hypr
configDir=$(pwd)
cd $homeDir

sudo rm -rf lilac-build
mkdir lilac-build
cd lilac-build
buildDir=$(pwd) # store the ACTUAL build directory

echo "[INFO]: Downloading files"
yay -S fastfetch  --noconfirm
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland hypridle lua gcc nano btop noctalia flatpak quickshell figlet --noconfirm

#clone the lilac repo and copy the config folders
git clone https://github.com/Cammy43/lilac-dots/ > /dev/null
cd lilac-dots


#create directory structure for config folders
mkdir ~/.config/hypr/lilac
mkdir ~/.config/hypr/lilac/kv
mkdir ~/.config/hypr/lilac/kv/lilacPM
mkdir ~/.config/hypr/lilac/kv/gamingmode
mkdir ~/.config/hypr/lilac/lilacPM
mkdir ~/.config/hypr/internal


#compile binaries
echo "[INFO]: Compiling binaries"
cd config/hypr/lilac

g++ gamingMode.cpp -Ofast -march=native -o ~/.config/hypr/lilac/gamingMode
rm gamingMode.cpp

cd lilacPM
g++ lockState.cpp -Ofast -march=native -o ~/.config/hypr/lilac/lilacPM/lockState
rm lockState.cpp

g++ chargeState.cpp -O3 -march=native -o ~/.config/hypr/lilac/lilacPM/chargeState
rm chargeState.cpp
echo "[OK]: Compiled binaries"

echo "[INFO]: Copying files"
cd $buildDir

echo $(pwd)
cd lilac-dots/config/hypr

cp *.lua ~/.config/hypr
cp lilac/*.lua ~/.config/hypr/lilac
cp lilac/lilacPM/*.lua ~/.config/hypr/lilac
cp lilac/kv/* ~/.config/hypr/kv -r
cp internal/* ~/.config/hypr/internal -r

echo "[OK]: Copied files"

cd $homeDir
sudo rm -rf $buildDir #praying this doesnt break someones computer
#todo: copy noctalia and quickshell configs

figlet Install complete!
