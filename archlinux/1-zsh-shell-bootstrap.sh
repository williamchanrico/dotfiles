#/usr/bin/env bash

# Synchronize package databases
sudo pacman -Sy --noconfirm

# Install zsh
sudo pacman -S --needed --noconfirm zsh wget curl git
sudo chsh -s /usr/bin/zsh william

# Install oh-my-zsh
su william -
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install yay
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

# Install google-chrome and gnome-shell-integration
yay -S --needed --noconfirm google-chrome chrome-gnome-shell

# Set up YADM and dotfiles
yay -S --needed --noconfirm yadm-git
yadm clone https://bitbucket.org/williamchanrico/dotfiles
#yadm decrypt

# Install powerline fonts
yay -S --needed --noconfirm nerd-fonts-dejavu-complete powerline-fonts-git
