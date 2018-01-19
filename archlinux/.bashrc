# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH environment variables
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Aliases
alias ls='ls --color=auto'
alias chownmodapache="sudo chown -R william:http * . && sudo chmod -R 770 * . && echo -e 'sudo chown -R william:http * .\nsudo chmod -R 770 * .'"
alias wow="WINEPREFIX=~/.wineWow __GL_THREADED_OPTIMIZATIONS=1 WINEDEBUG=-all wine /mnt/data/games/World\ of\ Warcraft/World\ of\ Warcraft\ Launcher.exe"
alias ntfymb="ntfy -o device_iden ujviRNYx41csjAiVsKnSTs -b pushbullet"

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

# Set up Node Version Manager
export NVM_DIR="$HOME/.nvm"
export NVM_SOURCE="/usr/share/nvm"  # The AUR package installs it to here.
[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"   # Load NVM

# Set up Composer
export PATH=$HOME/.config/composer/vendor/bin:$PATH

# Go directory env
export GOPATH=/mnt/data/collections/src/go
export GOBIN=/mnt/data/collections/src/go/bin
export PATH=$GOBIN:$PATH
