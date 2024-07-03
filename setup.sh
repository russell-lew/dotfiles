#!/bin/bash

# Clone the dotfiles repository
folder="~/.dotfiles"
if ! git "clone https://github.com/russell-lew/dotfiles.git" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then 
	echo "[SETUP] Clone failed because the folder ${folder} already exists"
fi

# Create symlinks for tmux and nvim configuration
echo '[SETUP] Creating Symbolic links for tmux and nvim configuration'
ln -sf "${folder}/tmux/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf "${folder}/nvim/*" ~/.config/nvim/

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


echo '[SETUP] Complete setup'

