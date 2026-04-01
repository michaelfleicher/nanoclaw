#!/usr/bin/env bash
set -euo pipefail

SWAP_SIZE="1G"
SWAP_FILE="/swapfile"

if swapon --show | grep -q "$SWAP_FILE"; then
  echo "Swap already active at $SWAP_FILE"
  exit 0
fi

echo "Creating ${SWAP_SIZE} swap file..."
sudo fallocate -l "$SWAP_SIZE" "$SWAP_FILE"
sudo chmod 600 "$SWAP_FILE"
sudo mkswap "$SWAP_FILE"
sudo swapon "$SWAP_FILE"

# Persist across reboots
if ! grep -q "$SWAP_FILE" /etc/fstab; then
  echo "$SWAP_FILE swap swap defaults 0 0" | sudo tee -a /etc/fstab
fi

echo "Swap enabled: $(swapon --show)"
