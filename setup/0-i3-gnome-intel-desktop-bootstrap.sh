#!/usr/bin/env bash

# Include multilib repository
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Synchronize package databases
sudo pacman -Sy

sudo pacman -S --noconfirm xorg-server xorg-apps xf86-video-intel \
	mesa gnome i3 networkmanager network-manager-applet nm-connection-editor

# Install yay
if [ ! -x "$(command -v yay)" ]; then
	# Install dependencies
	sudo pacman -S --needed --noconfirm git

	# Create a temp working dir and navigate into it
	mkdir -p /tmp/yay_install
	cd /tmp/yay_install || exit 1

	# Install yay from git
	git clone https://aur.archlinux.org/yay.git .
	makepkg --noconfirm -si

	# Clean up
	cd ~ || exit 1
	rm -rf /tmp/yay_install
fi

yay -S --noconfirm i3-gnome

# Disable beep noises
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo systemctl enable NetworkManager
sudo systemctl enable gdm
