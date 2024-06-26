#!/usr/bin/env bash

# Remove comments before exec
# sed '/^.*#/d;/^$/d' ./setup/2-install-common.tmpl.sh >./setup/2-install-common.sh && chmod +x ./setup/2-install-common.sh

# Install common packages
sudo pacman -S --needed --noconfirm \
	# OCR
	tesseract \
	tesseract-data-eng  \
	# Subtitle Editor
	gaupol \
	# Graph Visualizer
	graphviz \
	# List open files
	lsof \
	# Similar to pkg-audit based on Arch Security Team data
	arch-audit \
	# Fuzzy finder
	fzf \
	# C++ compiler API
	clang \
	# Text-based browser
	w3m \
	# Internationalization and localization system
	gettext \
	# Display blue light dimmer
	redshift \
	# Man pages but TLDR version
	tldr \
	# Clipboard manager
	clipmenu \
	clipnotify \
	# Notification daemon
	dunst \
	# Launcher
	dmenu \
	# Dmenu alternative
	rofi \
	rofi-calc \
	# Terminal
	# rxvt-unicode \
	wezterm \
	# Directory jumper
	z \
	# File manager
	ranger \
	nemo \
	nemo-fileroller \
	# Terminal multiplexer
	tmux \
	# Tree view of directory
	tree \
	# Shell auto completions
	zsh-completions \
	# ASCII art generator
	figlet \
	# ASCII art generator
	cowsay \
	# GNOME config editor
	dconf-editor \
	# GNOME port of dialog windows
	zenity \
	# DesktopEntry Execution, generate and execute DesktopEntry
	dex \
	# GNOME-based File Manager extension to allow launching programs via context menu
	filemanager-actions \
	# Calendar
	gsimplecal \
	# GTK+ theme switcher of the LXDE
	lxappearance \

	# Files management (compress/backup)
	p7zip \
	unrar \
	# Backup tool
	restic \

	#
	# Docs
	#

	# Office suite
	# libreoffice-fresh \
	# PDF reader
	zathura \
	# Support mupd rendering (MuPDF library can parse and render PDF, XPS, and EPUB)
	zathura-pdf-mupdf \
	# Converts sourcecode to HTML, XHTML, RTF, LaTeX, TeX, SVG, BBCode and terminal escape sequences with coloured syntax highlighting
	highlight \
	pdftk \

	#
	# Multimedia (Audio/Video)
	#

	# Image compression/manipulation
	imagemagick \
	# Screenshot
	flameshot \
	# Color picker
	gcolor3 \
	# Image Editor
	gimp \
	# Recorder for terminal
	asciinema \
	# PNG compression
	pngquant \
	# Image viewer and simple image editor
	feh \
	eog \
	shotwell \
	# Player
	mpv \
	# PulseAudio plugin
	# pulseaudio-alsa \
	# pulseaudio-bluetooth \
	pipewire \
	pipewire-pulse \
	pipewire-alsa \
	wireplumber \
	pipewire-v4l2 \
	lib32-pipewire-v4l2 \
	# PulseAudio GTK volume control
	pavucontrol \
	qpwgraph \
	# Effect/tuner
	easyeffects \
	calf \
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
	# Thumbnails for video
	ffmpegthumbnailer \
	# Screen recorder
	peek \
	vokoscreen \

	# MIME Manager
	handlr \

	#
	# Parser
	#

	# SQL Parser
	sqlfluff \
	# Hex dump/viewer
	xxd \
	hexyl \
	# Parser for binary
	fq \
	# Parser for JSON
	jq \
	# Parser for YAML
	yq \
	yaml-language-server \
	# Parser for XML
	expat \
	# Prettifier
	prettier \
	# Linter for shell scripts (replaced shellcheck with shellcheck-bin from AUR to avoid haskell runtime dep)
	shfmt \
	bash-language-server \
	# Show audio/video files
	mediainfo \

	#
	# Hardware monitor/troubleshooting
	#

	# Bluetooth
	blueman \
	bluez-utils \
	# Hardware list
	lshw \
	# Disk health
	smartmontools \
	# Filesystem helper
	dosfstools \
	# Vulkan toolkit
	vulkan-tools \
	# Monitoring nvme disk
	nvme-cli \
	# Monitoring system
	htop \
	# Monitoring sensor (removed due to bloat icons dependency)
	# psensor \

	#
	# X Server
	#

	# X automation
	xdotool \
	# Clipboard selection and manipulation
	xsel \
	# XCB utility functions for the X resource manager
	xcb-util-xrm \
	# Configure modifier keys to act as other keys
	xcape \
	# Monitor X activity and can trigger a lock program
	xautolock
yay -S --needed --noconfirm \
	# Backblaze cloud storage CLI
	backblaze-b2 \
	# Linter for Docker
	hadolint-bin \
	# Linter for shell scripts (replaced shellcheck with shellcheck-bin from AUR to avoid haskell runtime dep)
	shellcheck-bin \
	# NodeJS manager
	nvm \
	# Audio streaming
	spotify \
	# GTK theme
	nordic-theme-git \
	papirus-folders-nordic \
	# PulseAudio SDK
	python-pulsectl \
	# Rofi SDK
	python-rofi \
	# Notification tool
	ntfy \
	# dmenu support for NetworkManager
	networkmanager-dmenu-git \
	# Rxvt terminal Perl extension (deprecated over wezterm)
	# urxvt-perls-git \
	# Volume control for i3
	i3-volume \
	# Text editor
	sublime-text-dev \
	# MIME Manager
	handlr \
	# Messaging
	ferdium-bin

# Setup i3 status bar
yay -S --needed --noconfirm \
	bumblebee-status
sudo pacman -S --needed --noconfirm \
	# For it's iwgetid used by bumblebee-status
	wireless_tools \
	# For spotify plugin
	playerctl \
	python-dbus


# Network related tools
sudo pacman -S --needed --noconfirm \
	# Network troubleshooting
	net-tools \
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
	ttf-dejavu-nerd \
	ttf-nerd-fonts-symbols \
	ttf-nerd-fonts-symbols-mono \
	ttf-font-awesome \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-hanazono \
	adobe-source-han-sans-otc-fonts
yay -S --needed --noconfirm \
	ttf-font-icons ttf-ms-fonts
