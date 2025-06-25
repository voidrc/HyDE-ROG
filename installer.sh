#!/usr/bin/env bash

# More robust script settings
set -euo pipefail

# Grant sudo elevation upfront
sudo -v

# Check for required commands
for cmd in git pacman; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

echo "--> Installing dependencies"
sudo pacman -S --needed --noconfirm git base-devel

if [ -d "HyDE" ]; then
    echo "--> Removing existing HyDE directory for a clean install"
    rm -rf "HyDE"
fi

echo "--> Cloning HyDE repository"
git clone --depth 1 https://github.com/HyDE-Project/HyDE

echo "--> Running install script"
cd ./HyDE/Scripts
./install.sh

echo "--> Upgrading to HyDE-ROG"
./Extra/manager.sh rmt trash.lst
./Extra/manager.sh rmp bloatware.lst
./Extra/manager.sh ins pkg.lst

## Ask to install NvChad
read -p "Do you want to install NvChad? (y/n): " install_nvchad
if [[ "$install_nvchad" == "y" ]]; then
    echo "--> Installing NvChad"
    if [[ -d "$HOME/.config/nvim" ]]; then
        echo "--> ~/.config/nvim already exists, skipping NvChad clone."
    else
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim"
        nvim || echo "Warning: nvim failed to launch."
    fi
else
    echo "--> Skipping NvChad installation."
fi

## Ask to install HyDE-ROG
read -p "Do you have Asus ROG Laptop? (y/n): " install_rog
if [[ "$install_rog" == "y" ]]; then
    ./Extra/manager.sh ins rog.lst
    ./Extra/manager.sh sys system.lst
else
    echo "--> Skipping ROG specific installation."
fi

## Ask to recover workspace
read -p "Do you want to recover workspace? (y/n): " recover_workspace
if [[ "$recover_workspace" == "y" ]]; then
    ./Extra/workspace.sh
else
    echo "--> Skipping ROG specific installation."
fi



## Ask to recover personal data
read -p "Do you want to recover personal data? (y/n): " recover_personal_data
if [[ "$recover_personal_data" == "y" ]]; then
    ./Extra/personalizer.sh decrypt
else
    echo "--> Skipping personal data recovery."
fi