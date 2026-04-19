#!/bin/bash
set -euo pipefail

# ────────────────────────────────
# Paths
# ────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="${SCRIPT_DIR}/assets"
SETUP_SCRIPT="${ASSETS_DIR}/linux.sh"
SUDOERS_DROP="/etc/sudoers.d/99-setup-nopasswd"

# ────────────────────────────────
# Network check
# ────────────────────────────────
if ! ping -c 1 1.1.1.1 &>/dev/null; then
  echo "Error: No network connection detected."
  exit 1
fi

# ────────────────────────────────
# Display summary
# ────────────────────────────────
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[00;33m'

echo
echo -e "${GREEN}Linux setup script:${NC} $SETUP_SCRIPT"
echo

# ────────────────────────────────
# Confirmation before continuing
# ────────────────────────────────
read -rp "Proceed with setup? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Setup aborted."
  exit 0
fi

# ────────────────────────────────
# Passwordless for unattended install
# ────────────────────────────────

echo "Enter your password once — setup will run unattended from here."
sudo bash -c "echo '${USER} ALL=(ALL) NOPASSWD: ALL' > ${SUDOERS_DROP} && chmod 440 ${SUDOERS_DROP}"

trap 'echo "Cleaning up passwordless sudo..."; sudo rm -f "$SUDOERS_DROP"' EXIT

# ────────────────────────────────
# Hand off to linux.sh
# ────────────────────────────────
source "$SETUP_SCRIPT"
