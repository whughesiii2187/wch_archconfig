#!/bin/bash
# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START KVM/QEMU/VIRT MANAGER INSTALLATION..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
yay -S virt-manager virt-viewer qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm vim

# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
echo "Updating libvirtd.conf:"
echo 'unix_sock_group = "libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf
echo 'unix_sock_rw_perms = "0770"' | sudo tee -a /etc/libvirt/libvirtd.conf
echo 'log_filters="3:qemu 1:libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf
echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' | sudo tee -a /etc/libvirt/libvirtd.conf

# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
sudo usermod -a -G kvm,libvirt $(whoami)

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------
echo "Updating qenmu.conf:"
echo 'user = "libvirt-qemu"' | sudo tee -a /etc/libvirt/qemu.conf
echo 'group = "libvirt-qemu"' | sudo tee -a /etc/libvirt/qemu.conf

# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default

echo "Please restart your system with reboot."
