#!/usr/bin/env bash

# Install google-chrome and gnome-shell-integration
yay -S --needed --noconfirm google-chrome
sudo pacman -S --needed --noconfirm tmux less git-delta

# For hyprpm add https://github.com/outfoxxed/hy3
sudo pacman -S --needed --noconfirm cmake meson cpio
# hyprpm update
# hyprpm add https://github.com/outfoxxed/hy3

# Setup keyring: https://wiki.archlinux.org/title/GNOME/Keyring#SSH_keys
systemctl enable --user gcr-ssh-agent.socket
systemctl start --user gcr-ssh-agent.socket
echo "$SSH_AUTH_SOCK"
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

# Disable Nautilus recent files.
gsettings set org.gnome.desktop.privacy remember-recent-files false

# Setup Keyd (TBD)
# Add default config until YADM replaces it.
# sudo pacman -S --needed --noconfirm keyd
# mkdir -p ~/.config/keyd
# cat <<EOF | tee ~/.config/keyd/default.conf
# [ids]
# *

# [main]
# shift+esc = macro("~")
# EOF
# sudo systemctl enable keyd
# sudo systemctl start keyd

# Set up YADM and dotfiles
yay -S --needed --noconfirm yadm-git
echo "Generate App Password: https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/"
yadm clone https://bitbucket.org/williamchanrico/dotfiles
# yadm decrypt

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
