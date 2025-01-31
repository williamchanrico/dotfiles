#!/usr/bin/env bash

# Setup docker
sudo pacman -S --needed --noconfirm docker docker-compose docker-buildx
sudo usermod -aG docker william
sudo pacman -S --needed --noconfirm podman fuse-overlayfs slirp4netns

# Setup k6
K6_PWD="${HOME}/src/xk6"
mkdir -p "$K6_PWD"
podman run --userns=keep-id --rm -it -u "$(id -u):$(id -g)" -v "${K6_PWD}:/xk6" grafana/xk6 build latest \
	--with github.com/grafana/xk6-dashboard@latest

# Setup Ansible LSP (though will be using virtualenv for the Ansible itself)
sudo pacman -S --needed --noconfirm ansible ansible-lint
yay -S --needed --noconfirm ansible-language-server

# Setup golang
sudo pacman -S --needed --noconfirm go go-tools
export GOPATH=~/go
# Replaced by pass
# go get -u -v rsc.io/2fa
go install mvdan.cc/sh/cmd/shfmt@latest
go install github.com/fatih/hclfmt@latest
go install github.com/mrtazz/checkmake@latest
go install github.com/yudppp/json2struct/cmd/json2struct@latest
go install github.com/skip2/go-qrcode/...@latest
go install github.com/cweill/gotests/...@latest

# Setup SQL Formatter
# curl -o ~/bin/sqlfmt -L https://github.com/lopezator/sqlfmt/releases/download/v1.2.0/sqlfmt-v1.2.0-linux-amd64
# chmod +x ~/bin/sqlfmt

# Setup exploits
# yay -S --noconfirm exploit-db-git nikto gobuster-git burpsuite

# git clone git@github.com:williamchanrico/wordlist.git ~/wordlist

# Setup AWS
yay -S --needed --noconfirm python-aws-mfa aws-cli

# Setup kubectl
yay -S --needed --noconfirm google-cloud-cli kubectl kubectx google-cloud-cli-gke-gcloud-auth-plugin
git clone https://github.com/williamchanrico/kube-ps1 ~/.oh-my-zsh/custom/plugins/kube-ps1
git clone https://github.com/williamchanrico/gcloud-zsh-completion ~/.zsh_completion/gcloud-zsh-completion

# Prevent dropbox automatic updates
yay -S --needed --noconfirm dropbox
sudo pacman -S --needed --noconfirm dolphin-plugins
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist

# Setup openrgb
sudo pacman -S --needed --noconfirm openrgb
sudo modprobe i2c-dev

# Setup wallpapers and betterlockscreen-git cache image
# yay -S --needed --noconfirm betterlockscreen-git
# mkdir -p ~/Pictures/Wallpapers
# cp ./wallpapers/* ~/Pictures/Wallpapers/
# betterlockscreen -u vim ~/Pictures/Wallpapers/wallpaper-2-2560x1440.png
# sudo systemctl enable betterlockscreen@william

# Setup ntfy (notification tool)
# yay -S --needed --noconfirm ntfy-git

# Setup node exporter
sudo pacman -S prometheus-node-exporter prometheus-blackbox-exporter
sudo mkdir -p /etc/prometheus
cat <<-EOF | sudo tee /etc/prometheus/blackbox.yml
	modules:
	  icmp:
	    prober: icmp
	    timeout: 5s
	    icmp:
	      preferred_ip_protocol: "ip4"
	  http_2xx:
	    prober: http
	    http:
	      preferred_ip_protocol: "ip4"
	  http_post_2xx:
	    prober: http
	    http:
	      method: POST
EOF
sudo systemctl restart prometheus-node-exporter
sudo systemctl restart prometheus-blackbox-exporter
sudo systemctl enable prometheus-node-exporter
sudo systemctl enable prometheus-blackbox-exporter

# Configure HUD
sudo pacman -S --needed --noconfirm mangohud goverlay

# Fix random crashes on memory intensive softwares (i.e. AAA games)
# Sets the maximum number of memory map areas a process may have. Defaults to 65530.
echo "Setting vm.max_map_count=1048576 to increase the max amount of memory map areas a process may have."
echo "vm.max_map_count=1147483642" | sudo tee /usr/lib/sysctl.d/99-vm-max_map_count.conf

# Setup DNSCrypt and Unbound
# sudo pacman -S --needed --noconfirm dnscrypt-proxy unbound

# DNS request -> unbound :53 -> dnscrypt-proxy :53000 -> enabled dnscrypt resolver
# Change DNSCrypt-proxy port to 53000
# sudo sed -i -E -e "/^listen_addresses/s/:53'/:53000'/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Get root servers list for unbound
# sudo curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

# Unbound configuration
# cat <<-EOF | sudo tee /etc/unbound/unbound.conf
#     server:
#       use-syslog: yes
#       do-daemonize: no
#       username: "unbound"
#       directory: "/etc/unbound"
#       trust-anchor-file: trusted-key.key
#       private-domain: "intranet"
#       private-domain: "internal"
#       private-domain: "private"
#       private-domain: "corp"
#       private-domain: "home"
#       private-domain: "lan"
#       unblock-lan-zones: yes
#       insecure-lan-zones: yes
#       domain-insecure: "intranet"
#       domain-insecure: "internal"
#       domain-insecure: "private"
#       domain-insecure: "corp"
#       domain-insecure: "home"
#       domain-insecure: "lan"
#       root-hints: root.hints
#       do-not-query-localhost: no
#     forward-zone:
#       name: "."
#       forward-addr: ::1@53000
#       forward-addr: 127.0.0.1@53000
# EOF

# DNSSEC test
# echo "DNSSEC Test, you should see the ip address with '(secure)' next to"
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

#
# Post-install messages
#
echo "Notes:"
echo ""
echo "> https://github.com/fphoenix88888/ttf-mswin10-arch for MS fonts"
echo ""
echo "> /etc/fstab for data hard disk (prevent update failures for linux steam)"
echo "Adding library in steam may be problematic: https://github.com/ValveSoftware/steam-for-linux/issues/9640#issuecomment-1825064739"
echo "UUID=2C7D50BE09066582 /run/media/william/data ntfs-3g  defaults,locale=en_US.utf8,uid=1000,gid=1000  0 0"
echo ""
echo "Docker will need vsyscall=emulate kernel parameter"
echo "https://wiki.archlinux.org/index.php/docker#Installation"
echo ""
echo "To use both rear speaker and front headphone pluggin in:"
echo "alsamixer > F6 (Select card) > Auto-Mute Disabled"
echo ""
echo "For libvirt:"
echo "> Install spice-vdagent xf86-video-gxl"
