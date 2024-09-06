#!/bin/bash

# Clone the dotfiles repository
folder=".dotfiles"
if ! git "clone https://github.com/russell-lew/dotfiles.git" "${HOME}/${folder}" 2>/dev/null && [ -d "${HOME}/${folder}" ] ; then 
	echo "[SETUP] Clone failed because the folder ${HOME}/${folder} already exists"
fi

# Create symlinks for tmux and nvim configuration
echo '[SETUP] Creating Symbolic links for tmux and nvim configuration'
ln -sf "${HOME}/${folder}/tmux/.tmux.conf" ${HOME}/.tmux.conf
mkdir -p ~/.config/nvim
for file in "${HOME}/${folder}/nvim"/*; do
    ln -sf "$file" "${HOME}/.config/nvim/"
done

# Install tmux and nvim if not already installed (example for Ubuntu)
echo '[SETUP] Installing tmux and nvim'
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
	    machine=Linux
	    sudo apt-get -qq update
	    sudo apt-get install -y tmux neovim
	    ;;
    Darwin*)    
	    machine=Mac
	    brew install tmux neovim
	    ;;
#   CYGWIN*)    machine=Cygwin;;
#   MINGW*)     machine=MinGw;;
#   MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Install NVM (Node Version Manager)
echo '[SETUP] Installing NVM'
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    echo '[SETUP] NVM is already installed'
fi

# Install Node.js using NVM
echo '[SETUP] Installing Node.js'
if command -v nvm &> /dev/null; then
    nvm install --lts
    nvm use --lts
    nvm alias default node
else
    echo '[SETUP] NVM installation failed, Node.js will not be installed'
fi

echo '[SETUP] Complete setup'

