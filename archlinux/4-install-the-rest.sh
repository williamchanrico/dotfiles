#/usr/bin/env bash

# Synchronize package databases
sudo pacman -Sy

sudo pacman -S --noconfirm \
	arc-gtk-theme filemanager-actions uget imagemagick lshw \
	libreoffice-fresh jre10-openjdk jdk10-openjdk openjdk10-doc \
	deepin-screenshot gcolor2 tmux tcpdump htop iftop gimp mpv \
	dosfstools tree bind-tools pavucontrol smartmontools traceroute \
	xdotool ttf-dejavu ttf-liberation adobe-source-han-sans-otc-fonts \
	ttf-hanazono go go-tools terminator zenity p7zip unrar rsync a52dec \
	libmad x264 gst-libav gst-plugins-ugly totem dconf-editor ntfs-3g \
	jq tcpdump asciinema dnscrypt-proxy unbound expat restic figlet \
	cowsay python python2 python-pip python2-pip python-virtualenv \
	python2-virtualenv python-pylint python2-pylint yapf flake8 fzf \
	xcb-util-xrm tldr the_silver_searcher

yay -S --noconfirm \
	dropbox nautilus-dropbox transmission-gtk peek vokoscreen \
	adobe-source-han-sans-otc-fonts nvm spotify-stable visual-studio-code-bin \
	betterlockscreen-git global

# Setup neovim
ln -s ~/.vimrc ~/.config/nvim/init.vim
cp /usr/bin/vim /usr/bin/vim8
ln -fs /usr/bin/nvim /usr/bin/vim

# Install vundle, Vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Setup golang
mkdir -p ~/src/go/{src,bin}

# Remove gnome-terminal version of 'Open in Terminal' in nautilus
#sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}

# Prevent dropbox automatic updates
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist

# Setup wallpapers and betterlockscreen-git cache image
mkdir -p ~/Pictures/Wallpapers
cp ./wallpapers/* ~/Pictures/Wallpapers/
betterlockscreen -u ~/Pictures/Wallpapers/wallpaper-arch-1920x1280.png

# DNS request -> unbound :53 -> dnscrypt-proxy :53000 -> enabled dnscrypt resolver
# Change DNSCrypt-proxy port to 53000
sed -i -E -e "/^listen_addresses/s/:53'/:53000'/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Get root servers list for unbound
curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

# Unbound configuration
cat <<-EOF > /etc/unbound/unbound.conf
server:
  use-syslog: yes
  do-daemonize: no
  username: "unbound"
  directory: "/etc/unbound"
  trust-anchor-file: trusted-key.key
  private-domain: "intranet"
  private-domain: "internal"
  private-domain: "private"
  private-domain: "corp"
  private-domain: "home"
  private-domain: "lan"
  unblock-lan-zones: yes
  insecure-lan-zones: yes
  domain-insecure: "intranet"
  domain-insecure: "internal"
  domain-insecure: "private"
  domain-insecure: "corp"
  domain-insecure: "home"
  domain-insecure: "lan"
  root-hints: root.hints
  do-not-query-localhost: no
forward-zone:
  name: "."
  forward-addr: ::1@53000
  forward-addr: 127.0.0.1@53000
EOF

# DNSSEC test
echo "DNSSEC Test, you should see the ip address with '(secure)' next to"
unbound-host -C /etc/unbound/unbound.conf -v sigok.verteiltesysteme.net

# Install Powerline fonts
git clone https://github.com/powerline/fonts
./fonts/install.sh
rm -rf fonts

# Post-install messages
echo "Notes:"
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
echo "Clipboard Indicator"
echo ""
echo "Apply extensions setting in dconf dir"
echo ""
