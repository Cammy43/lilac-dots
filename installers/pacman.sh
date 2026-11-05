#!/bin/sh
echo "\nInstalling Lilac\n"
cd ~
mkdir .config/hypr
cd .config/hypr
configDir = ${pwd}

yay -S fastfetch  --noconfirm
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland hypridle lua gcc nano btop noctalia flatpak quickshell figlet --noconfirm

#clone the lilac repo and copy the config folders
echo "[INFO]: Downloading files"
mkdir lilac-build
cd lilac-build
buildDir = ${pwd}
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

cd config/hypr
cp *.lua ~/.config/hypr

cd lilacPM
cp *.lua ~/.config/hypr

cd ..
cp kv/* ~/.config/hypr/kv -r

cd ..
cp internal/* ~/.config/hypr/internal -r

echo "[OK]: Copied files"

#todo: copy noctalia and quickshell configs
