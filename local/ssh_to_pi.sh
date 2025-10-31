#!/bin/bash

# Usage check
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <username> <ip-file> <network>"
    echo "Example: $0 sparsh pi_ip.txt home"
    exit 1
fi

# Parameters
USERNAME="$1"
IP_FILE="$2"
NETWORK="$3"

# Check that the IP file exists and is not empty
if [[ ! -f "$IP_FILE" || ! -s "$IP_FILE" ]]; then
    echo "Error: IP file '$IP_FILE' not found or empty."
    exit 1
fi

# Extract IP for the given network
TARGET=$(awk -v net="$NETWORK" '$1 == net { print $2; exit }' "$IP_FILE")

# If no matching network found
if [[ -z "$TARGET" ]]; then
    echo "Error: No entry found for network '$NETWORK' in '$IP_FILE'."
    exit 1
fi

# Confirm connection and run SSH
echo "Connecting to ${USERNAME}@${TARGET} ..."
sleep 0.5
ssh "${USERNAME}@${TARGET}"