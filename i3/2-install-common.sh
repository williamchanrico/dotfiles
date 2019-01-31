#/usr/bin/env bash

# Install common packages
sudo pacman -S --needed --noconfirm \
	arc-gtk-theme filemanager-actions imagemagick lshw libreoffice-fresh \
	jre10-openjdk jdk10-openjdk openjdk10-doc flameshot \
	gcolor2 tmux gimp mpv xdotool dosfstools tree pavucontrol smartmontools \
	terminator zenity p7zip unrar rsync a52dec ntfs-3g libmad x264 gst-libav \
	gst-plugins-ugly totem dconf-editor jq asciinema expat restic figlet xsel \
	clang cowsay fzf xcb-util-xrm tldr the_silver_searcher prettier lsof pngquant \
	dmenu xcape xautolock gsimplecal lxappearance compton rofi zathura zathura-pdf-mupdf \
	feh gpicview ranger mediainfo w3m highlight clipmenu clipnotify
yay -S --needed --noconfirm \
	peek vokoscreen nvm spotify-stable \
	global ntfy networkmanager-dmenu-git polybar

# Fonts
sudo pacman -S --needed --noconfirm \
	ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts \
	ttf-hanazono ttf-dejavu ttf-roboto ttf-font-awesome
yay -S --needed --noconfirm ttf-emojione ttf-awesome-fonts nerd-fonts-dejavu-complete \
	ttf-nerd-fonts-symbols ttf-font-icons

# Network related tools
sudo pacman -S --needed --noconfirm \
	netcat tcpdump htop iftop bind-tools traceroute tcpdump nmap mtr \
	aria2 whois
yay -S --needed --noconfirm \
	youtube-dl transmission-gtk sshrc

# Setup python
sudo pacman -S --needed --noconfirm python python2 python-pip python2-pip \
	python-virtualenv python2-virtualenv python-pylint \
	python2-pylint yapf flake8 python-neovim python2-neovim \
	python-psutil python-netifaces
