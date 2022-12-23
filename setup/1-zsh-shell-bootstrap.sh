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
echo "Generate App Password: https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/"
yadm clone https://bitbucket.org/williamchanrico/dotfiles
# yadm decrypt

# Install powerline fonts
sudo pacman -S --needed --noconfirm awesome-terminal-fonts
yay -S --needed --noconfirm powerline-fonts-git nerd-fonts-dejavu-complete

# Setup DNS-over-TLS with CoreDNS
yay -S --needed --noconfirm coredns-git
cat <<EOF | sudo tee -a /etc/coredns/corefile
. {
    forward . tls://1.1.1.1 tls://1.0.0.1 {
       tls_servername cloudflare-dns.com
       health_check 5s
    }
    cache 30
}
EOF
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo systemctl enable coredns
sudo systemctl start coredns
sleep 1
dig @127.0.0.1 arzhon.id
echo "Visit https://1.1.1.1/help to verify\!"
