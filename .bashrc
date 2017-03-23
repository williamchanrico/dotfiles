#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Setting Palette
echo -en "\e]P0000000"
echo -en "\e]P1d01b24"
echo -en "\e]P2a7d32c"
echo -en "\e]P3d8cf67"
echo -en "\e]P461b8d0"
echo -en "\e]P5695abb"
echo -en "\e]P6d53864"
echo -en "\e]P7fefffe"
echo -en "\e]P8262626"
echo -en "\e]P9d01b24"
echo -en "\e]PAa7d32c"
echo -en "\e]PBd8cf67"
echo -en "\e]PC61b8d0"
echo -en "\e]PD695abb"
echo -en "\e]PEd53864"
echo -en "\e]PFfefffe"
clear

if [ "$TERM" = "linux" ]; then
	echo "                 _"
	echo "   __ _ _ __ ___| |__   ___  _ __"
	echo "  / _' | '__|_  / '_ \\ / _ \| '_ \\"
	echo " | (_| | |   / /| | | | (_) | | | |"
	echo "  \\__,_|_|  /___|_| |_|\\___/|_| |_|"
	echo ""
	echo " Hello, William!"
	echo ""
else
	screenfetch
fi
