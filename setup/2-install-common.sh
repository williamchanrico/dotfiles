#!/usr/bin/env bash

# Install common packages
sudo pacman -S --needed --noconfirm \
	# File manager
	ranger \
	# GNOME-based File Manager extension to allow launching programs via context menu
	filemanager-actions \
	# Image compression/manipulation
	imagemagick \
	lshw \
	libreoffice-fresh \
	# Screenshot
	flameshot \
	# Color picker
	gcolor2 \
	tmux \
	gimp \
	mpv \
	# X automation
	xdotool \
	# Filesystem helper
	dosfstools \
	tree \
	# Disk health
	smartmontools \
	# GNOME port of dialog windows
	zenity \
	p7zip \
	unrar \
	# GNOME config editor
	dconf-editor \
	# Parser for JSON
	jq \
	# Parser for YAML
	yq \
	asciinema \
	# Parser for XML
	expat \
	# Backup tool
	restic \
	# ASCII art generator
	figlet \
	# Clipboard selection and manipulation
	xsel \
	# C++ compiler API
	clang \
	# ASCII art generator
	cowsay \
	# Fuzzy finder
	fzf \
	# XCB utility functions for the X resource manager
	xcb-util-xrm \
	# Man pages but TLDR version
	tldr \
	# Prettifier
	prettier \
	lsof \
	# PNG compression
	pngquant \
	# Launcher
	dmenu \
	# Dmenu alternative
	rofi \
	# Configure modifier keys to act as other keys
	xcape \
	# Monitor X activity and can trigger a lock program
	xautolock \
	# Calendar
	gsimplecal \
	# GTK+ theme switcher of the LXDE
	lxappearance \
	# Compositor for X
	compton \
	# PDF reader
	zathura \
	# Support mupd rendering (MuPDF library can parse and render PDF, XPS, and EPUB)
	zathura-pdf-mupdf \
	# Image viewer
	feh \
	# Text-based browser
	w3m \
	# Converts sourcecode to HTML, XHTML, RTF, LaTeX, TeX, SVG, BBCode and terminal escape sequences with coloured syntax highlighting
	highlight \
	# Clipboard manager
	clipmenu \
	clipnotify \
	# Terminal
	rxvt-unicode \
	# Directory jumper
	z \
	# Notification daemon
	dunst \
	# Shell auto completions
	zsh-completions \
	# Internationalization and localization system
	gettext \
	# Linter for shell scripts
	shellcheck \
	# Show audio/video files
	mediainfo \
	# Bluetooth manager
	blueman \
	bluez-utils \
	# Audio manager
	pulseaudio-alsa \
	pulseaudio-bluetooth \
	# Audio control
	pavucontrol \
	# Decoder for ATSC A/52 streams
	a52dec \
	# Decoder for MPEG audio
	libmad \
	# Decoder for H.264/MPEG-4 AVC
	x264 \
	# Multimedia toolkit libraries
	gst-libav \
	gstreamer-vaapi \
	gst-plugins-ugly \
	# Only need the totem-video-thumbnailer
	totem \
	# Display blue light dimmer
	redshift \
	# Similar to pkg-audit based on Arch Security Team data
	arch-audit \
	# Hex dump/viewer
	xxd \
	hexyl \
	# Backblaze cloud storage CLI
	backblaze-b2 \
	# Parser for binary
	fq \
	# Monitoring nvme disk
	nvme-cli \
	# Monitoring system
	htop \
	# Vulkan toolkit
	vulkan-tools
yay -S --needed --noconfirm \
	# NodeJS manager
	nvm \
	spotify \
	nordic-theme-git \
	papirus-folders-nordic \
	python-pulsectl \
	python-rofi \
	global \
	# Notification tool
	ntfy \
	networkmanager-dmenu-git \
	# Rxvt terminal Perl extension
	urxvt-perls-git \
	i3-volume \
	sublime-text-dev

# Network related tools
sudo pacman -S --needed --noconfirm \
	netcat \
	tcpdump \
	iftop \
	nethogs \
	bind-tools \
	traceroute \
	tcpdump \
	nmap \
	mtr \
	aria2 \
	whois \
	vpnc \
	# Youtube-dl alternative
	yt-dlp \
	rsync
yay -S --needed --noconfirm \
	transmission-cli \
	transmission-remote-gtk \
	transmission-gtk
# Too lazy to type sudo & password
sudo setcap cap_net_raw=eip "$(command -v iftop)"

# Setup python
sudo pacman -S --needed --noconfirm python python-pip pyenv python-pipenv \
	python-virtualenv \
	python-pylint \
	python-black \
	flake8 \
	python-pynvim \
	python-psutil \
	python-netifaces

# Fonts
sudo pacman -S --needed --noconfirm \
	ttf-dejavu \
	ttf-font-awesome \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-hanazono \
	adobe-source-han-sans-otc-fonts
yay -S --needed --noconfirm ttf-awesome-fonts nerd-fonts-dejavu-complete \
	ttf-nerd-fonts-symbols ttf-font-icons ttf-ms-fonts
