#!/usr/bin/env bash
# Title: custom-dconf
# Description: Apply dconf config
# Author: William Chanrico
# Date: 2-Sept-2018

ARRAY=("dconf/gnome-extentions:/org/gnome/shell/extensions"
	"dconf/gnome-desktop-keybindings:/org/gnome/desktop/wm"
	"dconf/gnome-media-keybindings:/org/gnome/settings-daemon/plugins"
	"dconf/gnome-desktop:/org/gnome/desktop")
	"dconf/mutter:/org/gnome/mutter/")

for data in "${ARRAY[@]}"; do
	dir="${data%%:*}"
	dconf_key="${data##*:}"

	for filename_full in $dir/*.dconf; do
		filepath=${filename_full%%.dconf}
		filename=${filepath##*/}
		echo "dconf load $dconf_key/$filename/ <$filename_full"
		dconf load $dconf_key/$filename/ <$filename_full
	done
done

echo "If tap-to-click is not working, run: 'gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true'"
