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
./HyDE/Scripts/install.sh

echo "--> Upgrading to HyDE-ROG"

./Extra/manager.sh rmp bloatware.lst
./Extra/manager.sh ins pkg.lst

## Add flathub repository && packages
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Flatpak Tweaks (themes, icons, env)
echo "--> Applying Flatpak tweaks (themes, icons, environment)"

# Remove unused flatpaks
echo "    Removing unused Flatpak packages..."
flatpak remove --unused || true

# Get current GTK and icon theme
gtkTheme=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
gtkIcon=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")

# Set Flatpak overrides for themes and icons
echo "    Setting Flatpak filesystem overrides for themes and icons..."
flatpak --user override --filesystem=$HOME/.themes
flatpak --user override --filesystem=$HOME/.icons
flatpak --user override --filesystem=$HOME/.local/share/themes
flatpak --user override --filesystem=$HOME/.local/share/icons

# Set Flatpak environment variables for GTK and icon theme
echo "    Setting Flatpak GTK and icon theme environment variables..."
flatpak --user override --env=GTK_THEME=${gtkTheme}
flatpak --user override --env=ICON_THEME=${gtkIcon}

## Ask to install NvChad
read -p "Do you want to install NvChad? (y/n): " install_nvchad
if [[ "$install_nvchad" == "y" ]]; then
    echo "--> Installing NvChad"
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim
    git clone https://github.com/NvChad/starter "$HOME/.config/nvim"
    nvim || echo "Warning: nvim failed to launch."
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
    ./Extra/manager.sh rmt trash.lst
    ./Extra/workspace.sh
else
    echo "--> Skipping Workspace restoration"
fi

## Ask to recover personal data
read -p "Do you want to recover personal data? (y/n): " recover_personal_data
if [[ "$recover_personal_data" == "y" ]]; then
    ./Extra/personalizer.sh decrypt
else
    echo "--> Skipping personal data recovery."
fi