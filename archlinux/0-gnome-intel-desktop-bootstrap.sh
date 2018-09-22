#/usr/bin/env bash

# Include multilib repository
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Synchronize package databases
sudo pacman -Sy

sudo pacman -S --noconfirm xorg-server xorg-apps xf86-video-intel mesa gnome

sudo systemctl enable gdm
