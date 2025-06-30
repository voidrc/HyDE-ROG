#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="WorkSpace"
HOME_DIR="$HOME"

# Check if WorkSpace directory exists
if [[ ! -d "$WORKSPACE_DIR" ]]; then
    echo "Error: $WORKSPACE_DIR directory not found in current location."
    echo "Please run this script from the directory containing $WORKSPACE_DIR"
    exit 1
fi

# Show what will be copied
echo "This script will copy all contents from '$WORKSPACE_DIR' to '$HOME_DIR'"
echo "This will overwrite any existing files with the same names."
echo
echo "Contents to be copied:"
ls -la "$WORKSPACE_DIR"
echo

# Ask for confirmation
read -p "Do you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "--> Copying WorkSpace contents to home directory..."

# Copy all contents from WorkSpace to home directory
# Using rsync for better control and progress
if command -v rsync &>/dev/null; then
    rsync -av --progress "$WORKSPACE_DIR"/ "$HOME_DIR"/
else
    # Fallback to cp if rsync is not available
    cp -rv "$WORKSPACE_DIR"/* "$HOME_DIR"/
fi

echo "--> Setting proper permissions..."
# Ensure user owns all copied files
sudo chown -R "$USER:$USER" "$HOME_DIR"

echo "✓ WorkSpace contents successfully copied to home directory!"
echo "Your home directory now contains all WorkSpace files and directories."
