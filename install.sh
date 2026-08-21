#!/bin/bash
echo "Initialising..."

get_package_manager() {
    if command -v apt-get &>/dev/null; then
        manager= "apt-get"
    elif command -v dnf &>/dev/null; then
         manager= "dnf"
    elif command -v yum &>/dev/null; then
         manager= "yum"
    elif command -v pacman &>/dev/null; then
         manager= "pacman"
    elif command -v zypper &>/dev/null; then
         manager= "zypper"
    elif command -v apk &>/dev/null; then
         manager= "apk"
    elif command -v brew &>/dev/null; then
         manager= "brew"
    else
         manager= "unknown"
        return 1
    fi
}

if ! command -v fish &> /dev/null
then
    echo "[ERR]  : Some dependancies are not installed! Installing them now."
    if ! command -v git &> /dev/null
fi


