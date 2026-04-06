#!/bin/sh

#!/usr/bin/env bash
set -euo pipefail

# Helper function to install a package
install_pkg() {
    local pkg="$1"

    echo -e "${GREEN}Installing $pkg...${NC}"

    # Try yay first
    if command -v yay &>/dev/null; then
        if yay -S --noconfirm --needed "$pkg"; then
            echo -e "${GREEN}$pkg installed via yay.${NC}"
            return 0
        else
            echo -e "${YELLOW}yay failed for $pkg. Trying yay-down.sh...${NC}"
            if [[ -x ./yay-down.sh ]]; then
                ./yay-down.sh "$pkg" && return 0
            fi
        fi
    fi

    # Final fallback to pacman
    echo -e "${YELLOW}Falling back to pacman for $pkg...${NC}"
    sudo pacman -S --noconfirm --needed "$pkg"
}

# Function to install a whole group
install_group() {
    local group_name="$1"
    local -n group_ref="$group_name"   # <-- Proper nameref (Bash 4.3+)

    echo -e "${YELLOW}=== Installing group: $group_name ===${NC}"

    for pkg in "${group_ref[@]}"; do
        install_pkg "$pkg"
    done
}

# Package groups
core_packages=(
btrfs-progs brightnessctl cups cups-browsed cups-filters cups-pdf dust fd gazelle-tui gdu inetutils inotify-tools nwg-displays ly modemmanager networkmanager networkmanager-openvpn plymouth plymouth-theme-abstract-ring-git stow tlp tlp-pd udiskie ufw unzip usbutils wget wireguard-tools zsh bolt 
)

hypr_packages=(
elephant elephant-bluetooth elephant-calc elephant-clipboard elephant-desktopapplications elephant-files elephant-menus elephant-providerList elephant-runner elephant-symbols elephant-todo elephant-unicode elephant-websearch gpu-screen-recorder hplip hypridle hyprland hyprland-guiutils hyprland-preview-share-picker hyprlock hyprnotify hyprpaper hyprsunset mako swayosd system-config-printer walker-bin waybar wayfreeze wayland wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs gtk3 gtk4 qt5-wayland qt6-wayland grim slurp waypaper-git
)

audio_packages=(
bluez bluez-obex bluez-utils bluetuith pamixer pipewire pipewire-jack pipewire-pulse playerctl wiremix wireplumber ffplay vlc sof-firmware pipewire-alsa libpulse
)

fonts_packages=(
otf-font-awesome ttf-0xproto-nerd ttf-fira-code ttf-firacode-nerd ttf-fira-sans noto-fonts-emoji ttg-jetbrains-mono-nerd
)

apps_packages=(
bitwarden btop evince fastfetch ghostty lazygit libreoffice-fresh neovim pinta podman podman-compose podman-docker ripgrep spotify thunar tmux zen-browser-bin figlet fzf gum satty
)

install_group core_packages
install_group audio_packages
install_group hypr_packages
install_group fonts_packages
install_group apps_packages

echo -d "${GREEN} Installing some addons. Brew, TMUX TPM, oh-my-zsh..${NC}"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "${GREEN}All packages installed successfully!${NC}"

echo -e "${GREEN} Configure limine and snapper for snapshots${NC}"

source "$ASSETS_DIR"/config-limine-snapper.sh

## Clone and Stow Dotfiles ##
source "$ASSETS_DIR"/install_dotfiles.sh

## Setup VPN ##
# ./install_vpn.sh
