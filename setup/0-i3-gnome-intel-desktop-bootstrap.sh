#!/usr/bin/env bash

# Include multilib repository
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Synchronize package databases
sudo pacman -Sy

sudo pacman -S --noconfirm xorg-server xorg-apps xf86-video-intel \
	mesa gnome i3 networkmanager network-manager-applet nm-connection-editor
yay -S --noconfirm i3-gnome

# Disable beep noises
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo systemctl enable NetworkManager
sudo systemctl enable gdm
