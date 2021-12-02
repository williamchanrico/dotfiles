#!/usr/bin/env bash

# Synchronize package databases
sudo pacman -Sy --noconfirm

# Install zsh
sudo pacman -S --needed --noconfirm zsh wget curl git man-db man-pages
sudo chsh -s /usr/bin/zsh william

# Install oh-my-zsh
su william -
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || {
	echo "Could not install Oh My Zsh" >/dev/stderr
	exit 1
}

# Install google-chrome and gnome-shell-integration
yay -S --needed --noconfirm google-chrome chrome-gnome-shell

# Set up YADM and dotfiles
yay -S --needed --noconfirm yadm-git
yadm clone https://bitbucket.org/williamchanrico/dotfiles
#yadm decrypt

# Install powerline fonts
sudo pacman -S --needed --noconfirm awesome-terminal-fonts
yay -S --needed --noconfirm powerline-fonts-git nerd-fonts-dejavu-complete
