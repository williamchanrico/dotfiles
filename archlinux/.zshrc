# PATH environment variables
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH=/home/william/.oh-my-zsh

# Zsh theme
ZSH_THEME="mytheme"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Load oh-my-zsh plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

#
# User configuration
#

# Aliases
alias chownmodapache="sudo chown -R william:http * . && sudo chmod -R 770 * . && echo -e 'sudo chown -R william:http * .\nsudo chmod -R 770 * .'"
alias wow="WINEPREFIX=~/.wineWow __GL_THREADED_OPTIMIZATIONS=1 WINEDEBUG=-all wine /mnt/data/games/World\ of\ Warcraft/World\ of\ Warcraft\ Launcher.exe"
alias nf="ntfy"
alias nfmb="ntfy -o device_iden ujviRNYx41csjAiVsKnSTs -b pushbullet"

# Skip running screenfetch on tty because screenfetch needs informations that will delay tty startup
if [ "$TERM" = "linux" ]; then
	bash
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
export NVM_SOURCE="/usr/share/nvm"	# The AUR package installs it to here.
[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"	# Load NVM

# Set up Composer
export PATH=$HOME/.config/composer/vendor/bin:$PATH

# Go directory env
export GOPATH=/mnt/data/collections/src/go
export GOBIN=/mnt/data/collections/src/go/bin
export PATH=$GOBIN:$PATH
