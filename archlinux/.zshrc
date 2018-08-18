# PATH environment variables
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH=/home/william/.oh-my-zsh

# Zsh theme
ZSH_THEME="mytheme"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Load oh-my-zsh plugins
plugins=(git k)

source $ZSH/oh-my-zsh.sh

#
# User configuration
#

# Functions
ipinfo() {
	curl ipinfo.io/$1
}

tkp-ssh() {
	# https://phab.tokopedia.com/w/tech/devops/teleport/
	# tsh-tkp binary: https://github.com/tokopedia/teleport/releases/tag/v2.4.5.1
	if [[ $1 == "ls" ]]; then
		tsh-tkp ls | grep "$2"
	elif [[ $1 == "login" ]]; then
		tsh-tkp login --proxy=ports2.tokopedia.net:3080 --user=william.chanrico
	else
		tsh-tkp ssh root@$1
	fi
}

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
export GOPATH=/home/william/src/go
export GOBIN=/home/william/src/go/bin
export PATH=$GOBIN:$PATH

export ANSIBLE_ROLES_PATH=/etc/ansible/roles

# Aliases
alias nf="ntfy"
alias nfmb="ntfy -o device_iden ujviRNYx41csjAiVsKnSTs -b pushbullet"

alias yee="yeecli"
alias yeeb="yeecli brightness"
alias yeet="yeecli toggle"

alias dpoff="xset dpms force off"

alias spnd="systemctl suspend"

alias cdgo="cd $GOPATH/src"
alias cdgoo="cd $GOPATH/src/github.com/williamchanrico"
