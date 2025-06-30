#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 [rmt|rmp|ins|sys|fltk] <listfile>"
    exit 1
}

MODE="${1:-}" 
LISTFILE="${2:-}"

if [[ -z "$MODE" || -z "$LISTFILE" ]]; then
    usage
fi

if [[ ! -f "$LISTFILE" ]]; then
    echo "Warning: $LISTFILE not found, skipping operation."
    exit 0
fi

# Detect AUR helper
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
else
    AUR_HELPER=""
fi

case "$MODE" in
    rmt)
        while IFS= read -r trash; do
            [[ -z "$trash" || "$trash" =~ ^# ]] && continue
            echo "[*] Removing $trash"
            rm -rf "$trash"
        done < "$LISTFILE"
        ;;
    rmp)
        while IFS= read -r bloat; do
            [[ -z "$bloat" || "$bloat" =~ ^# ]] && continue
            echo "[*] Removing $bloat"
            if [[ -n "$AUR_HELPER" ]]; then
                "$AUR_HELPER" -Rns --noconfirm "$bloat" || echo "[!] $bloat not installed or already removed."
            else
                sudo pacman -Rns --noconfirm "$bloat" || echo "[!] $bloat not installed or already removed."
            fi
        done < "$LISTFILE"
        ;;
    ins)
        while IFS= read -r pkg; do
            [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
            echo "[*] Installing $pkg"
            if sudo pacman -S --needed --noconfirm "$pkg"; then
                continue
            else
                echo "[!] $pkg not found in official repos. Trying AUR..."
                if [[ -n "$AUR_HELPER" ]]; then
                    "$AUR_HELPER" -S --needed --noconfirm "$pkg"
                else
                    echo "[!] No AUR helper (yay/paru) found. Cannot install $pkg from AUR."
                fi
            fi
        done < "$LISTFILE"
        ;;
    sys)
        while IFS= read -r svc; do
            [[ -z "$svc" || "$svc" =~ ^# ]] && continue
            echo "[*] Enabling $svc"
            sudo systemctl enable "$svc"
            echo "[*] Starting $svc"
            sudo systemctl start "$svc"
        done < "$LISTFILE"
        ;;
    fltk)
        if ! command -v flatpak &>/dev/null; then
            echo "[!] flatpak is not installed. Please install flatpak first."
            exit 1
        fi
        while IFS= read -r fpkg; do
            [[ -z "$fpkg" || "$fpkg" =~ ^# ]] && continue
            echo "[*] Installing Flatpak package: $fpkg"
            flatpak install -y "$fpkg"
        done < "$LISTFILE"
        ;;
    *)
        usage
        ;;
esac