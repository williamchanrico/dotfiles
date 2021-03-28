#!/usr/bin/env bash

# Setup neovim
sudo pacman -S --needed --noconfirm gvim neovim
mkdir -p ~/.config/nvim
ln -fs ~/.vimrc ~/.config/nvim/init.vim

# Install vundle, Vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Setup docker
sudo pacman -S --needed --noconfirm docker docker-compose
yay -S --needed --noconfirm hadolint
sudo usermod -aG docker william

# Setup ansible (use virtualenv)
# sudo pacman -S --needed --noconfirm ansible ansible-lint

# Setup ...
sudo pacman -S --needed --noconfirm binwalk tmux fzf clipmenu s-tui

# Setup golang
sudo pacman -S --needed --noconfirm go go-tools
mkdir -p ~/src/go/{src,bin}

export GOPATH=~/go
go get -u -v rsc.io/2fa
go get -u -v mvdan.cc/sh/cmd/shfmt
go get -u -v github.com/fatih/hclfmt
go get -u -v github.com/golang/dep/cmd/dep
go get -u -v github.com/mrtazz/checkmake
go get -u -v github.com/jackc/sqlfmt/...
go get -u -v github.com/yudppp/json2struct/cmd/json2struct
go get -u github.com/skip2/go-qrcode/...
go get -u -v github.com/cweill/gotests/...
GO111MODULE=on go get mvdan.cc/gofumpt/gofumports

# Setup exploits
yay -S --noconfirm exploit-db-git nikto gobuster-git burpsuite

git clone git@github.com:williamchanrico/wordlist.git ~/wordlist

# Setup fzf-tab
git clone https://github.com/Aloxaf/fzf-tab"$ZSH_CUSTOM/plugins/fzf-tab"

# Setup zsh-completions from https://github.com/zchee/zsh-completions
git clone https://github.com/zchee/zsh-completions ~/.zsh_completion/zchee_zsh-completions/

# Setup zsh-autosuggestions and completions from https://github.com/zsh-users
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}"/plugins/zsh-completions

# Setup powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/themes/powerlevel10k

# Setup AWS
yay -S --needed --noconfirm python-aws-mfa aws-cli

# Setup kubectl
yay -S --needed --noconfirm google-cloud-sdk kubectl-bin kubectx
git clone https://github.com/williamchanrico/kube-ps1 ~/.oh-my-zsh/custom/plugins/kube-ps1
git clone https://github.com/williamchanrico/gcloud-zsh-completion ~/.zsh_completion/gcloud-zsh-completion

# Prevent dropbox automatic updates
yay -S --needed --noconfirm dropbox nautilus-dropbox
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist

# Setup wallpapers and betterlockscreen-git cache image
yay -S --needed --noconfirm betterlockscreen-git
mkdir -p ~/Pictures/Wallpapers
cp ./wallpapers/* ~/Pictures/Wallpapers/
betterlockscreen -u ~/Pictures/Wallpapers/wallpaper-1920x1280.jpg
sudo systemctl enable betterlockscreen@william

# Setup DNSCrypt and Unbound
sudo pacman -S --needed --noconfirm dnscrypt-proxy unbound

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

# https://wiki.archlinux.org/index.php/Wine
# LINE on Wine
# sudo pacman -S wine wine-gecko wine-mono winetricks dex lib32-libpulse
# env $WINE_LINE winetricks allfonts # will also cache the fonts for future new prefixes
# env $WINE_LINE wine LineInst.exe

# Fix fonts smoothing
# cat <<EOF >/tmp/fontsmoothing
# REGEDIT4

# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "FontSmoothing"="2"
# "FontSmoothingOrientation"=dword:00000001
# "FontSmoothingType"=dword:00000002
# "FontSmoothingGamma"=dword:00000578

# [HKEY_CURRENT_USER\Software\Wine\X11 Driver]
# "ClientSideWithRender"="N"
# EOF

# env $WINE_LINE wine regedit /tmp/fontsmoothing 2> /dev/null

# Post-install messages
echo "Notes:"
echo ""
echo "> https://github.com/fphoenix88888/ttf-mswin10-arch for MS fonts"
echo ""
echo "> /etc/fstab for data hard disk (prevent update failures for linux steam)"
echo "UUID=2C7D50BE09066582 /run/media/william/data ntfs-3g  defaults,locale=en_US.utf8,uid=1000,gid=1000  0 0"
echo ""
echo "Docker will need vsyscall=emulate kernel parameter"
echo "https://wiki.archlinux.org/index.php/docker#Installation"
