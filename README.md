# HyDE-ROG Customization

This project provides a set of scripts to automate the setup and customization of an Arch Linux environment, specifically tailored for ASUS ROG laptops. It builds upon the HyDE project to create a personalized, feature-rich desktop experience with minimal manual intervention.

## Features

- **Automated Installation**: Installs core dependencies, official packages from `pacman`, and AUR packages using a helper like `yay` or `paru`.
- **Modular Package Management**: Uses a single `manager.sh` script to handle package installation, removal of bloatware, and system cleanup based on simple list files.
- **Flatpak Integration**: Installs Flatpak applications and applies system-wide themes and icon settings to ensure a consistent look and feel.
- **Systemd Service Management**: Automatically enables and starts required system services from a predefined list.
- **ROG-Specific Setup**: Includes dedicated logic to install and configure packages and services for ASUS ROG laptops.
- **Workspace & Personal Data Recovery**: Provides interactive prompts to restore a user's workspace and decrypt personal/sensitive configuration files.

## Prerequisites

- An Arch-based Linux distribution (e.g., Arch Linux, EndeavourOS).
- `git` `git-lfs` and `base-devel` packages must be installed.
- An AUR helper (`yay` or `paru`) is recommended for installing AUR packages.
- `age` for encrypting/decrypting personal data.

## Installation

The main `installer.sh` script automates the entire process.

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/voidrc/HyDE-ROG.git
    cd HyDE-ROG
    git lfs pull
    ```

2.  **Run the installer:**
    ```sh
    ./installer.sh
    ```

The script will guide you through the installation, including:
- Installing dependencies.
- Cloning and setting up the base HyDE project.
- Removing bloatware and installing packages from your lists.
- Setting up Flatpak and ROG-specific configurations.
- Interactively asking to restore your workspace and personal data.

## Scripts Overview

-   **`installer.sh`**: The master script that orchestrates the entire setup. It calls other scripts in the correct order and handles user interaction.
-   **`Extra/manager.sh`**: A versatile, modular script for various management tasks. It takes a command and a list file as arguments.
    -   `rmt <file.lst>`: Removes files and directories.
    -   `rmb <file.lst>`: Removes packages with `pacman` and/or `AUR helper`.
    -   `ins <file.lst>`: Installs packages from official repos and the AUR.
    -   `sys <file.lst>`: Enables and starts systemd services.
    -   `fltk <file.lst>`: Installs Flatpak applications.
-   **`Extra/workspace.sh`**: A utility to synchronize a `WorkSpace` directory with your `$HOME` directory, restoring your development environment.
-   **`Extra/personalizer.sh`**: (If available) A script for encrypting and decrypting sensitive files (e.g., SSH keys, credentials) using `age` encryption.

## Configuration Lists (`.lst` files)

The automation is driven by simple text files (`.lst`), where each line represents an item to be processed. Lines starting with `#` and empty lines are ignored.

-   **`trash.lst`**: List of files/directories to be deleted.
-   **`bloatware.lst`**: List of `pacman` packages to be removed.
-   **`pkg.lst`**: List of official and AUR packages to install.
-   **`flatpak.lst`**: List of Flatpak applications to install.
-   **`rog.lst`**: List of packages specific to ASUS ROG laptops.
-   **`system.lst`**: List of systemd services to enable and start.
-   **`personal.lst`**: List of sensitive files to be archived and encrypted. 