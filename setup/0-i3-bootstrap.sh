#!/usr/bin/env bash

# Include multilib repository.
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Synchronize package databases.
sudo pacman -Sy

#
# Yay - AUR helper.
#
if [ ! -x "$(command -v yay)" ]; then
	# Install dependencies.
	sudo pacman -S --needed --noconfirm git

	# Create a temp working dir and navigate into it.
	mkdir -p /tmp/yay_install
	cd /tmp/yay_install || exit 1

	# Install yay from git.
	git clone https://aur.archlinux.org/yay.git .
	makepkg --noconfirm -si

	# Clean up.
	cd ~ || exit 1
	rm -rf /tmp/yay_install
fi

# Disable beep noises.
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

#
# Hyprland.
#
declare -A packages=(
	["hyprland"]="Hyprland - A dynamic tiling Wayland compositor"
	["hyprshadeA"]="HyprshadeA - Shader integration for Hyprland"
	["xdg-desktop-portal-hyprland"]="xdg-desktop-portal-hyprland - Portal for Hyprland"
	["bibata-cursor-theme"]="Bibata cursor theme"
	["waybar"]="Waybar - Taskbar"
	["swaylock-effects-git"]="Swaylock effects - Lock screen"
	["hyprlock"]="Hyprlock - Lock screen utility"
	["hypridle"]="Hypridle - Idle manager for Hyprland"
	["swww"]="Swww - Wallpaper daemon"
	["waypaper"]="Waypaper - Wallpaper manager"
	["wlogout"]="Wlogout - Logout menu"
	["nwg-look"]="Ngw-look - GTK settings editor like lxappearance"
	["cliphist"]="Cliphist - Clipboard history manager"
	["grimblast-git"]="Grimblast Git - Screenshot helper"
	["slurp"]="Slurp - Screenshot selection tool"
	["swappy"]="Swappy - Screenshot editing tool"
	["rofi-wayland"]="Rofi for password store"
	["rofi-pass-ydotool-git"]="Rofi for password store"
	["rofi-emoji-git"]="Rofi for emoji selector"
	["rofi-calc-git"]="Rofi for calculator"
	["pass"]="Pass - Password store"
	["pass-otp"]="Pass OTP - Password store otp extension"
	["polkit-gnome"]="Polkit-gnome - Auth agent"
	["dunst"]="Dunst - Notification daemon"
	["libnotify"]="Libnotify - Notification library"

	["oh-my-zsh-git"]="Oh-my-zsh - Zsh configuration framework"
	["fzf"]="Fzf - Fuzzy finder"
	["parallel"]="GNU Parallel"
	["jq"]="Jq - Command-line JSON processor"
	["imagemagick"]="ImageMagick - Image manipulation"
	["neovim"]="Neovim - Editor"
	["luarocks"]="Luarocks - Lua module manager (used by lazy.nvim)"
	["stylua"]="Stylua - Lua code formatter"
	["lua-language-server"]="lua-language-server - Lua language server"
	["neovim-luasnip-git"]="Luasnip - Snippet Engine for Neovim written in Lua"
	["nodejs-compose-language-service"]="Compose Language Server - Language service for Docker Compose documents"
	["dockerfile-language-server"]="Docker Language Server - Language server for Dockerfile"
	["vscode-langservers-extracted"]="VSCode Language Server Extracted - Language server extracted from VSCode"
	["nautilus"]="Nautilus - File manager"
	["ark"]="Ark - GUI archiver"
	["python-pyamdgpuinfo"]="Python pyamdgpuinfo - Show AMD GPU temperature and information"
	["tmux"]="Tmux - Terminal multiplexer"
	["man-pages"]="Man pages - Manual pages"
	["git-delta"]="Git delta - Git diff viewer"
	["less"]="Less - Terminal output pager"

	["google-chrome"]="Google Chrome - Browser"
)

hyprctl setcursor bibata 20

# Loop through the associative array to extract the keys (package names)
package_list=()
for pkg in "${!packages[@]}"; do
	package_list+=("$pkg") # Append the package name to the array
done
yay --noconfirm -S "${package_list[@]}"

# Hyprland plugins manager.
sudo pacman -S --needed --noconfirm cmake meson cpio
hyprpm update
hyprpm add https://github.com/outfoxxed/hy3
hyprpm enable hy3
hyprpm enable hyperbars

#
# Keyring
#
# Setup keyring: https://wiki.archlinux.org/title/GNOME/Keyring#SSH_keys
systemctl enable --user gcr-ssh-agent.socket
systemctl start --user gcr-ssh-agent.socket
echo "$SSH_AUTH_SOCK"
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

#
# Nautilus
#
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gtk.gtk4.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.gtk4.Settings.FileChooser sort-order 'ascending'

#
# Neovim
#
sudo pacman -S --needed --noconfirm neovim
mkdir -p ~/.config/nvim
ln -sf ~/.vimrc ~/.config/nvim/init.vim
# Some softwares may open vim using full path like /usr/bin/vim.
# Override it with nvim.
sudo cp /usr/bin/vim{,.original}
sudo ln -sf /usr/bin/nvim /usr/bin/vim

# Install vundle, Vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#
# Zsh
#
# Requires sudo due to ZSH_CUSTOM now using /usr/share/oh-my-zsh/custom global path.

# Fzf Tab
sudo git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"

# Zsh Completions
sudo git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# Zsh 256color
sudo git clone https://github.com/chrissicool/zsh-256color ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-256color

# Setup zsh-completions from https://github.com/zchee/zsh-completions
git clone https://github.com/zchee/zsh-completions ~/.zsh_completion/zchee_zsh-completions/

#
# ydotool
# Required by rofi-pass
#
systemctl --user enable ydotool.service
systemctl --user start ydotool.service

# Setup zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

# Setup powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k

#
# Keyd
#
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

#
# CoreDNS
#
# Setup DNS-over-TLS with CoreDNS
# yay -S --needed --noconfirm coredns-git
# cat <<EOF | sudo tee -a /etc/coredns/corefile
# . {
#     forward . tls://1.1.1.1 tls://1.0.0.1 {
#        tls_servername cloudflare-dns.com
#        health_check 5s
#     }
#     cache 30
# }
# EOF
# sudo systemctl stop systemd-resolved
# sudo systemctl disable systemd-resolved
# sudo systemctl enable coredns
# sudo systemctl start coredns
# sleep 1
# dig @127.0.0.1 arzhon.id
echo "Regardless, visit https://1.1.1.1/help to verify DoH/DoT\!"
