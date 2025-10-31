#!/bin/bash

# --- Usage Check ---
if [[ $# -ne 5 ]]; then
    echo "Usage: $0 <pi-user> <pi-ip-file> <network> <remote-photo-dir> <local-dest-dir>"
    echo "Example: $0 pi pi_ip.txt home /home/pi/photos ~/Downloads/from-pi"
    exit 1
fi

PI_USER="$1"
PI_IP_FILE="$2"
NETWORK="$3"
REMOTE_DIR="$4"
LOCAL_DIR="$5"

# --- Read IP address from file ---
if [[ ! -f "$PI_IP_FILE" ]]; then
    echo "Error: IP address file '$PI_IP_FILE' does not exist."
    exit 2
fi

PI_HOST=$(awk -v net="$NETWORK" '$1 == net { print $2; exit }' "$PI_IP_FILE")
if [[ -z "$PI_HOST" ]]; then
    echo "Error: Network '$NETWORK' not found in '$PI_IP_FILE'."
    exit 3
fi

PI_ADDR="${PI_USER}@${PI_HOST}"

# --- Ensure local destination exists ---
mkdir -p "$LOCAL_DIR"

# --- Find and copy recent image files from Pi ---
ssh "$PI_ADDR" "find '$REMOTE_DIR' -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \)" | while read -r file; do
    echo "Copying $file from $PI_ADDR..."
    scp "$PI_ADDR:$(printf '%q' "$file")" "$LOCAL_DIR/"
done