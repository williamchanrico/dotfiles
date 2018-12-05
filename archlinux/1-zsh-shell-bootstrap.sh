#/usr/bin/env bash

# Install zsh
sudo pacman -S --noconfirm zsh wget curl git vim gvim
chsh -s /usr/bin/zsh william

# Install oh-my-zsh
su william -
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
