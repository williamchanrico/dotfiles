#!/usr/bin/env bash
# Title: 
# Description: Apply dconf config for gnome shell extensions
# Author: William Chanrico
# Date: 2-Sept-2018 

for filename in *.dconf; do
	file=${filename%%.dconf}
	echo "dconf load /org/gnome/shell/extensions/$file/ < $filename"
	dconf load /org/gnome/shell/extensions/$file/ < $filename
done
