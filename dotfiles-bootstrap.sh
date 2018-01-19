#!/usr/bin/env bash

# Check for system updates
sudo pacman -Syyu

if [ ! -x "$(command -v pacaur)" ]; then
    # Install dependencies
    sudo pacman -S --needed --noconfirm binutils make gcc fakeroot expac yajl git

    # Create a tmp-working-dir an navigate into it
    mkdir -p /tmp/pacaur_install
    cd /tmp/pacaur_install

    # Install "cower" from AUR
    curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
    makepkg PKGBUILD --skippgpcheck
    sudo pacman -U cower*.tar.xz --noconfirm

    # Install "pacaur" from AUR
    curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
    makepkg PKGBUILD
    sudo pacman -U pacaur*.tar.xz --noconfirm

    # Clean up...
    cd ~
    rm -r /tmp/pacaur_install
fi

# Set up YADM and dotfiles
pacaur -S yadm-git
yadm clone https://bitbucket.org/williamchanrico/dotfiles
