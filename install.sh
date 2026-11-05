#!/bin/bash

tput setaf 1
echo "The installation will begin in: 5 seconds. BACK UP YOUR .config DIRECTORY BEFORE CONTINUING. Press CTRL + C to cancel"
sleep 1
echo " \n"


echo "5"
sleep 1
echo "4"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
tput setaf 5
echo "Initialising..."

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
buildDir=$(pwd)

devMode=0
if ["$0" = "dev"]; then
    devMode=1
fi

# Detect the current distribution using /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    distroName=$NAME
    distro_version=$VERSION_ID
else
    echo "[ERROR]: Unable to detect the distribution. Exiting."
    exit 1
fi

if [ "$distroName" = "Debian GNU/Linux" ]; then
    packageManager="apt"
    installCmd="sudo apt install -y"
    depInstall="sudo apt install -y git curl"
    updateCmd="sudo apt update && sudo apt upgrade -y"
    distroDir="$HOME/$Distro"
    
    elif [ "$distroName" = "Ubuntu" ]; then
    packageManager="apt"
    installCmd="sudo apt install -y"
    depInstall="sudo apt install -y git curl"
    updateCmd="sudo apt update && sudo apt upgrade -y"
    
    elif command -v pacman &> /dev/null; then
    packageManager="pacman"
    installCmd="sudo pacman -S --noconfirm"
    depInstall="sudo pacman -S git curl --noconfirm"
    updateCmd="sudo pacman -Syu --noconfirm"
    distroDir="$HOME/$Distro"
    
    elif command -v dnf &> /dev/null; then
    packageManager="dnf"
    installCmd="sudo dnf install -y"
    depInstall="sudo dnf install -y git curl"
    updateCmd="sudo dnf upgrade"
    distroDir="$HOME/$Distro"
    
    elif command -v zypper &> /dev/null; then
    packageManager="zypper"
    installCmd="sudo zypper install -y"
    depInstall="sudo zypper install -y git curl"
    updateCmd="sudo zypper up"
    
    distroDir="$HOME/$Distro"
    
    elif [ "$distroName" = "NixOS" ]; then
    packageManager="nix"
    installCmd="nix-shell"
    depInstall="nix-shell -p git curl pciutils"
    
    distroDir="$HOME/$Distro"
else
    echo "[ERROR] $distroName isn't a supported distro. Sorry."
    exit 1
fi

echo "[INFO] : Detected distro: $distroName"

if ! command -v fish &> /dev/null
then
    echo "[WARN] : fish not installed."
    bash -c "$installCmd fish"
fi

curl https://raw.githubusercontent.com/Cammy43/lilac-dots/refs/heads/main/installers/epic%20ascii%20logo #cool logo

echo "Updating packages"

bash -c "$updateCmd"
#get the appropriate installer
echo "Installing dependancies"

bash -c "$depInstall"

curl https://raw.githubusercontent.com/Cammy43/lilac-dots/refs/heads/main/installers/$packageManager.sh > install.sh

sh install.sh $devMode

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
cd lilac-dots/config/hypr

cp *.lua ~/.config/hypr
cp lilac/*.lua ~/.config/hypr/lilac
cp lilac/lilacPM/*.lua ~/.config/hypr/lilac
cp lilac/kv/* ~/.config/hypr/lilac/kv -r
cp internal/* ~/.config/hypr/internal -r

cd $buildDir
rm -rf lilac-dots/config/hypr
cp lilac-dots/config/* ~/.config -r

echo "[OK]: Copied files"

cd $homeDir
sudo rm -rf $buildDir #praying this doesnt break someones computer
#todo: copy noctalia and quickshell configs

figlet Install complete!

