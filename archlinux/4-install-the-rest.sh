#/usr/bin/env bash

# Synchronize package databases
sudo pacman -Sy

sudo pacman -S --noconfirm \
	arc-gtk-theme filemanager-actions uget imagemagick lshw libreoffice-fresh jre10-openjdk \
	jdk10-openjdk openjdk10-doc deepin-screenshot gcolor2 tmux tcpdump htop iftop gimp mpv dosfstools tree bind-tools \
	pavucontrol smartmontools traceroute xdotool ttf-dejavu ttf-liberation adobe-source-han-sans-otc-fonts ttf-hanazono \
	go go-tools terminator zenity p7zip unrar rsync a52dec libmad x264 gst-libav gst-plugins-ugly dnscrypt-proxy totem \
	dconf-editor ntfs-3g jq

sudo systemctl enable dnscrypt-proxy
sudo systemctl start dnscrypt-proxy

# Setup golang
mkdir -p ~/src/go/{src,bin}

# Remove gnome-terminal version of 'Open in Terminal' in nautilus
sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}

yay -S --noconfirm \
	dropbox nautilus-dropbox transmission-gtk peek adobe-source-han-sans-otc-fonts nvm spotify visual-studio-code-bin \
	vokoscreen

# Prevent dropbox automatic updates
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist

# Post-install messages
echo "Notes:"
echo ""
echo "=== DNSCrypt ==="
echo "Uncomment 'name_servers=127.0.0.1' in /etc/resolvconf.conf"
echo "Select resolver for dnscrypt at '/etc/dnscrypt-proxy/dnscrypt-proxy.toml'"
echo "server_names = ['cloudflare', 'cloudflare-ipv6']"
echo "Don't forget to restart dnscrypt-proxy.service"
echo ""
echo "=== Gnome Exts ==="
echo "Alternatetab"
echo "Application Menu"
echo "Dash to dock"
echo "Places status indicator"
echo "Removable drive menu"
echo "Sound input & output device chooser"
echo "Uptime indicator"
echo "User themes"
echo "System-monitor"
echo ""
echo "Apply extensions setting in dconf dir"
echo ""
