# PATH environment variables
export PATH=$HOME/bin:/usr/local/bin:$HOME/.config/composer/vendor/bin:$PATH

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
