#!/usr/bin/env bash

set -euo pipefail

ARCHIVE_NAME="personal_data.tar.zst"
ENCRYPTED_FILE=".personal_data.age"
DECRYPTED_ARCHIVE=".decrypted_personal_data.tar.zst"
PERSONAL_DIR="$HOME/.personal"
PERSONAL_LIST="personal_data.lst"

# Dependency checks
deps=(age tar zstd)
for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        echo "Error: Required command '$dep' is not installed." >&2
        exit 1
    fi
done

usage() {
    echo "Usage: $0 [encrypt|decrypt]"
    exit 1
}

MODE="${1:-}"
case "$MODE" in
    decrypt)
        mkdir -p "$PERSONAL_DIR"
        echo "[*] Personal data recovery starting..."
        read -s -p "[?] Enter your recovery password: " PASSWORD
        echo
        if [[ ! -f "$ENCRYPTED_FILE" ]]; then
            echo "[!] Encrypted file $ENCRYPTED_FILE not found."
            exit 1
        fi
        if echo "$PASSWORD" | age -d -p "$ENCRYPTED_FILE" -o "$DECRYPTED_ARCHIVE" 2>/dev/null; then
            echo "[+] Decryption successful. Extracting personal data..."
            tar --use-compress-program=zstd -xf "$DECRYPTED_ARCHIVE" -C "$PERSONAL_DIR"
            echo "[✓] Personal data restored to: $PERSONAL_DIR"
            rm -f "$DECRYPTED_ARCHIVE"
        else
            echo "[!] Wrong password or decryption failed. Skipping data restore."
        fi
        ;;
    encrypt)
        echo "[*] Archiving personal data..."
        if [[ ! -f "$PERSONAL_LIST" ]]; then
            echo "[!] $PERSONAL_LIST not found."
            exit 1
        fi
        # Only archive files that exist
        FILES_TO_ARCHIVE=()
        while IFS= read -r file; do
            [[ -z "$file" || "$file" =~ ^# ]] && continue
            if [[ -e "$file" ]]; then
                FILES_TO_ARCHIVE+=("$file")
            else
                echo "[!] Warning: $file not found, skipping."
            fi
        done < "$PERSONAL_LIST"
        if [[ ${#FILES_TO_ARCHIVE[@]} -eq 0 ]]; then
            echo "[!] No valid files to archive."
            exit 1
        fi
        rm -rf "$ARCHIVE_NAME" "$ENCRYPTED_FILE"
        tar --use-compress-program=zstd -cf "$ARCHIVE_NAME" "${FILES_TO_ARCHIVE[@]}"
        echo "[*] Encrypting archive with password..."
        age -p -o "$ENCRYPTED_FILE" "$ARCHIVE_NAME"
        echo "[✓] Done. Encrypted secrets stored in: $ENCRYPTED_FILE"
        rm -f "$ARCHIVE_NAME"
        ;;
    *)
        usage
        ;;
esac
