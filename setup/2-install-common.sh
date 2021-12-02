#!/usr/bin/env bash

# Install common packages
sudo pacman -S --needed --noconfirm \
	filemanager-actions imagemagick lshw libreoffice-fresh flameshot \
	gcolor2 tmux gimp mpv xdotool dosfstools tree pavucontrol smartmontools \
	zenity p7zip unrar rsync a52dec ntfs-3g libmad x264 gst-libav gstreamer-vaapi \
	gst-plugins-ugly totem dconf-editor jq asciinema expat restic figlet xsel \
	clang cowsay fzf xcb-util-xrm tldr the_silver_searcher prettier lsof pngquant \
	dmenu xcape xautolock gsimplecal lxappearance compton rofi zathura zathura-pdf-mupdf \
	feh ranger mediainfo w3m highlight clipmenu clipnotify rxvt-unicode z dunst zsh-completions \
	gettext shellcheck blueman pulseaudio-alsa pulseaudio-bluetooth bluez-utils redshift \
	arch-audit xxd hexyl rsync
yay -S --needed --noconfirm \
	nvm spotify gtk-theme-shades-of-gray newaita-icons-git \
	global ntfy networkmanager-dmenu-git urxvt-perls-git yq i3-volume \
	sublime-text-dev pulseaudio-bluetooth-a2dp-gdm-fix

# Fonts
sudo pacman -S --needed --noconfirm \
	ttf-dejavu ttf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji \
	ttf-hanazono adobe-source-han-sans-otc-fonts
yay -S --needed --noconfirm ttf-awesome-fonts nerd-fonts-dejavu-complete \
	ttf-nerd-fonts-symbols ttf-font-icons ttf-ms-fonts

# Network related tools
sudo pacman -S --needed --noconfirm \
	netcat tcpdump htop iftop bind-tools traceroute tcpdump nmap mtr \
	aria2 whois vpnc
yay -S --needed --noconfirm \
	youtube-dl transmission-cli transmission-remote-gtk transmission-gtk sshrc

# Too lazy to type sudo & password
sudo setcap cap_net_raw=eip "$(command -v iftop)"

# Setup python
sudo pacman -S --needed --noconfirm python python2 python-pip \
	python-virtualenv python-pylint \
	python-black flake8 python-pynvim \
	python-psutil python-netifaces
