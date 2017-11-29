# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'

# Custom prompt
PS1='[\u@\h \W]\$ '

# Skip running screenfetch on tty because screenfetch needs informations that will delay tty startup
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
