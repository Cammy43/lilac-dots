#!/bin/bash
#shits still broken lol
tput setaf 5
echo "Initialising..."
devMode=0
if ["$0" = "dev"]; then
    devMode=1
fi


if [ "$distroName" = "Debian GNU/Linux" ]; then
    packageManager="apt"
    installCmd="sudo apt install -y"
    gitInstall="sudo apt install -y git"
    distroDir="$HOME/$Distro"
    
    elif [ "$distroName" = "Ubuntu" ]; then
    p ackageManager="apt"
    installCmd="sudo apt install -y"
    gitInstall="sudo apt install -y git"
    
    elif command -v pacman &> /dev/null; then
    packageManager="pacman"
    installCmd="sudo pacman -S --noconfirm"
    gitInstall="sudo pacman -S git --noconfirm"
    distroDir="$HOME/$Distro"
    
    elif command -v dnf &> /dev/null; then
    packageManager="dnf"
    installCmd="sudo dnf install -y"
    gitInstall="sudo dnf install -y git"
    distroDir="$HOME/$Distro"
    
    elif command -v zypper &> /dev/null; then
    packageManager="zypper"
    installCmd="sudo zypper install -y"
    gitInstall="sudo zypper install -y git"
    distroDir="$HOME/$Distro"
    
    elif [ "$distroName" = "NixOS" ]; then
    packageManager="nix"
    installCmd="nix-shell"
    gitInstall="nix-shell -p git curl pciutils"
    
    distroDir="$HOME/$Distro"
else
    echo "${ERROR} $distroName isn't a supported distro. Sorry."
    exit 1
fi

echo "[INFO] : Detected distro: $distroName"

if ! command -v fish &> /dev/null
then
    echo "[WARN] : fish not installed."
    bash -c "$installCmd fish"
fi
fish install.fish $devMode
