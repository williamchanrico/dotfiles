#/usr/bin/env bash

sudo pacman -S --needed --noconfirm \
	arc-gtk-theme filemanager-actions imagemagick lshw libreoffice-fresh \
	jre10-openjdk jdk10-openjdk openjdk10-doc deepin-screenshot \
	gcolor2 tmux gimp mpv xdotool dosfstools tree pavucontrol smartmontools \
	terminator zenity p7zip unrar rsync a52dec ntfs-3g libmad x264 gst-libav \
	gst-plugins-ugly totem dconf-editor jq asciinema expat restic figlet xsel \
	clang cowsay fzf xcb-util-xrm tldr the_silver_searcher prettier lsof pngquant \
	dmenu xcape

yay -S --needed --noconfirm \
	dropbox nautilus-dropbox peek vokoscreen nvm spotify-stable \
	betterlockscreen-git global ntfy

# Fonts
sudo pacman -S --needed --noconfirm \
	ttf-roboto ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts \
	ttf-hanazono ttf-dejavu

yay -S --needed --noconfirm ttf-emojione

# Network related tools
sudo pacman -S --needed --noconfirm \
	netcat tcpdump htop iftop bind-tools traceroute tcpdump nmap mtr \
	dnscrypt-proxy unbound aria2 whois

yay -S --needed --noconfirm \
	youtube-dl transmission-gtk sshrc

# Setup docker
sudo pacman -S --needed --noconfirm docker docker-compose
yay -S --needed --noconfirm hadolint
sudo usermod -aG docker william

# Setup ansible
sudo pacman -S --needed --noconfirm ansible ansible-lint

# Setup python
sudo pacman -S --needed --noconfirm python python2 python-pip python2-pip \
	python-virtualenv python2-virtualenv python-pylint \
	python2-pylint yapf flake8 python-neovim python2-neovim

# Setup golang
sudo pacman -S --needed --noconfirm go go-tools
mkdir -p ~/src/go/{src,bin}

# Setup go packages
export GOPATH=~/src/go/src
go get -u -v mvdan.cc/sh/cmd/shfmt
go get -u -v github.com/golang/dep/cmd/dep
go get -u -v github.com/mrtazz/checkmake
go get -u -v github.com/jackc/sqlfmt/...

# Setup kubectl
yay -S --needed --noconfirm google-cloud-sdk kubectl-bin kubectx
git clone https://github.com/williamchanrico/kube-ps1 ~/.oh-my-zsh/custom/plugins/kube-ps1
git clone https://github.com/williamchanrico/gcloud-zsh-completion ~/.zsh_completion/gcloud-zsh-completion

# Setup neovim
sudo pacman -S --needed --noconfirm gvim neovim
mkdir -p ~/.config/nvim
ln -fs ~/.vimrc ~/.config/nvim/init.vim

# Install vundle, Vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Prevent dropbox automatic updates
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist

# Setup wallpapers and betterlockscreen-git cache image
mkdir -p ~/Pictures/Wallpapers
cp ./wallpapers/* ~/Pictures/Wallpapers/
betterlockscreen -u ~/Pictures/Wallpapers/wallpaper-arch-1920x1280.png

# DNS request -> unbound :53 -> dnscrypt-proxy :53000 -> enabled dnscrypt resolver
# Change DNSCrypt-proxy port to 53000
sudo sed -i -E -e "/^listen_addresses/s/:53'/:53000'/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Get root servers list for unbound
sudo curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

# Unbound configuration
cat <<-EOF | sudo tee /etc/unbound/unbound.conf
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
#unbound-host -C /etc/unbound/unbound.conf -v sigok.verteiltesysteme.net

# Remove gnome-terminal version of 'Open in Terminal' in nautilus
#sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}

# Post-install messages
echo "Notes:"
echo "=== Gnome Exts ==="
echo "Alternatetab"
echo "Application Menu"
echo "Places status indicator"
echo "Removable drive menu"
echo "User themes"
echo "https://extensions.gnome.org/extension/307/dash-to-dock/"
echo "https://extensions.gnome.org/extension/906/sound-output-device-chooser/"
echo "https://extensions.gnome.org/extension/508/uptime-indicator/<Paste>"
echo "https://extensions.gnome.org/extension/120/system-monitor/"
echo "https://extensions.gnome.org/extension/779/clipboard-indicator/"
echo "https://extensions.gnome.org/extension/1403/remove-alttab-delay/"
echo ""
echo "Apply extensions setting in dconf dir"
echo ""
echo "> /etc/fstab for data hard disk (prevent update failures for linux steam)"
echo "UUID=2C7D50BE09066582 /run/media/william/data ntfs-3g  defaults,locale=en_US.utf8,uid=1000,gid=1000  0 0"
echo ""
echo "Docker will need vsyscall=emulate kernel parameter"
echo "https://wiki.archlinux.org/index.php/docker#Installation"
