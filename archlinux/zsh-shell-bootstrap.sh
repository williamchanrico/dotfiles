#/usr/bin/env bash

# Synchronize package databases
sudo pacman -Sy

# Install zsh
sudo pacman -S zsh wget curl git --noconfirm
chsh -s /usr/bin/zsh william

# Install oh-my-zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
