#!/usr/bin/env bash
# shellcheck disable=SC2154
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

cat <<"EOF"

-------------------------------------------------
        .
       / \         _       _  _      ___  ___
      /^  \      _| |_    | || |_  _|   \| __|
     /  _  \    |_   _|   | __ | || | |) | _|
    /  | | ~\     |_|     |_||_|\_, |___/|___|
   /.-'   '-.\                  |__/

-------------------------------------------------

EOF

# Initial setup and banner display
scrDir="$(dirname "$(realpath "$0")")"   # Gets the script's directory path
source "${scrDir}/global_fn.sh"          # Imports shared functions and variables

# Flag initialization
flg_Install=0    # Controls package installation
flg_Restore=0    # Controls config restoration
flg_Service=0    # Controls service enablement
flg_DryRun=0     # Enables test mode without actual execution
flg_Shell=0      # Controls shell selection
flg_Nvidia=1     # Controls Nvidia driver installation
flg_ThemeInstall=1  # Controls theme installation

# Command line option parsing
while getopts idrstmnh: RunStep; do
    case $RunStep in
    i) flg_Install=1 ;;                    # Basic installation
    d) flg_Install=1; use_default="--noconfirm" ;; # Non-interactive installation
    r) flg_Restore=1 ;;                    # Restore configs
    s) flg_Service=1 ;;                    # Enable services
    n) flg_Nvidia=0 ;;                     # Skip Nvidia
    h) flg_Shell=0 ;;                      # Reevaluate shell
    t) flg_DryRun=1 ;;                     # Test run
    m) flg_ThemeInstall=0 ;;               # Skip theme
    esac
done

# Log file setup
HYDE_LOG="$(date +'%y%m%d_%Hh%Mm%Ss')"   # Creates timestamped log identifier

# Package installation section
if [ ${flg_Install} -eq 1 ]; then
    # Prepares package list
    cp "${scrDir}/pkg_core.lst" "${scrDir}/install_pkg.lst"
    
    # Nvidia detection and setup
    if nvidia_detect; then
        # Adds appropriate Nvidia drivers if GPU detected
        if [ ${flg_Nvidia} -eq 1 ]; then
            cat /usr/lib/modules/*/pkgbase | while read -r kernel; do
                echo "${kernel}-headers" >>"${scrDir}/install_pkg.lst"
            done
        fi
    fi

    # User preferences for AUR helper and shell
    # Prompts user to select AUR helper if not already set
    # Sets default shell to fish

    # Package installation
    "${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"
fi

# Configuration restoration
if [ ${flg_Restore} -eq 1 ]; then
    # Restores fonts, configs, and themes
    "${scrDir}/restore_fnt.sh"
    "${scrDir}/restore_cfg.sh"
    "${scrDir}/restore_thm.sh"
    
    # Generates wallpaper cache
    "$HOME/.local/lib/hyde/swwwallcache.sh"
fi

# Service enablement
if [ ${flg_Service} -eq 1 ]; then
    # Enables and starts system services from list
    while read -r serviceChk; do
        if ! systemctl is-active "$serviceChk" &>/dev/null; then
            sudo systemctl enable "${serviceChk}.service"
            sudo systemctl start "${serviceChk}.service"
        fi
    done <"${scrDir}/system_ctl.lst"
fi

# Cleanup and finalization
if [ $flg_Install -eq 1 ]; then
    # Removes orphaned packages and clears package cache
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2> /dev/null
    sudo pacman -Scc --noconfirm 2> /dev/null
fi

# Offers reboot option after major changes
if [ $flg_Install -eq 1 ] || [ $flg_Restore -eq 1 ] || [ $flg_Service -eq 1 ]; then
    # Prompts for system reboot
    read -r answer
    if [[ "$answer" == [Yy] ]]; then
        systemctl reboot
    fi
fi
