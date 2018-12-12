#!/usr/bin/env bash

# Set up YADM and dotfiles
yay -S --noconfirm yadm-git
yadm clone https://bitbucket.org/williamchanrico/dotfiles
#yadm decrypt

ln -s ~/.vimrc ~/.config/nvim/init.vim
