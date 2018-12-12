#!/usr/bin/env bash

if [ ! -x "$(command -v yay)" ]; then
    # Install dependencies
    sudo pacman -S --needed --noconfirm git

    # Create a temp working dir and navigate into it
    mkdir -p /tmp/yay_install
    cd /tmp/yay_install

    # Install yay from git
    git clone https://aur.archlinux.org/yay.git .
    makepkg -si

    # Clean up
    cd ~
    rm -rf /tmp/yay_install
fi

yay -S --noconfirm google-chrome chrome-gnome-shell
