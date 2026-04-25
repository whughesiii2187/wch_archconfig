#!/bin/bash
set -euo pipefail

echo -e "${GREEN}Updating system...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${GREEN}Verifying Prereqs...${NC}"
sudo pacman -S --needed --noconfirm debugedit fakeroot base-devel curl vim

# Install yay (AUR helper)
# Check if aur.archlinux.org is up
echo -e "${GREEN}Checking if aur.archlinux.org is reachable...${NC}"
URL="https://aur.archlinux.org"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
if [ "$STATUS" -eq 200 ]; then
  echo -e "${GREEN}AUR is up. Installing yay from aur.archlinux.org...${NC}"
  source "$ASSETS_DIR"/install_yay.sh
fi

## Install_All
source "$ASSETS_DIR"/install_all.sh

# Enable services
echo -e "${GREEN}Enabling services...${NC}"
sudo systemctl enable ly@tty2.service
sudo systemctl enable bluetooth.service
sudo systemctl enable tlp.service
sudo systemctl enable --now tlp-pd.service
sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable --now cups.service
sudo systemctl stop iwd && sudo systemctl disable iwd
sudo systemctl stop systemd-networkd && sudo systemctl disable systemd-networkd
sudo systemctl stop wpa_supplicant && sudo systemctl disable wpa_supplicant
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service pipewire.service 2>/dev/null || true
elephant service enable

sudo cp -R "$SCRIPT_DIR"/etc/modprobe.d/alsa.conf /etc/modprobe.d/alsa.conf

if [ ! -d "/etc/containers" ]; then
  sudo mkdir -p /etc/containers
fi

sudo touch /etc/containers/nodocker

echo -e "${GREEN}Changing shell to zsh ${NC}"
chsh -s $(which zsh)

echo -e "${GREEN}Creating user home dirs ${NC}"
xdg-user-dirs-update

echo -e "${GREEN}Setup Plymouth, snapper snapshots ${NC}"
sudo plymouth-set-default-theme abstract_ring
sudo mkinitcpio -P

echo -e "${GREEN}Creating initial snapshot ${NC}"
sudo snapper create -d "Arch New System"

echo -e "${GREEN}✅ Done!! Rebooting system in 30 seconds... ${NC}"
sleep 30s
reboot
