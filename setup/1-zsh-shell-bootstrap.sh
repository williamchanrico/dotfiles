#!/usr/bin/env bash

# Set up YADM and dotfiles
yay -S --needed --noconfirm yadm-git
echo "Generate App Password: https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/"
yadm clone https://bitbucket.org/williamchanrico/dotfiles
yadm decrypt
