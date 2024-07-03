#!/bin/bash

# Clone the dotfiles repository
folder = '.dotfiles'
if ! git clone https://github.com/russell-lew/dotfiles.git ~/${folder} 2>/dev/null && [ -d "${folder}"] ; then 
	echo '[SETUP] Clone failed because the folder ${folder} already exists'
fi

# Create symlinks for tmux and nvim configuration
echo '[SETUP] Creating Symbolic links for tmux and nvim configuration'
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/* ~/.config/nvim/

# Install tmux and nvim if not already installed (example for Ubuntu)
echo '[SETUP] Installing tmux and nvim'
sudo apt-get -qq update
sudo apt-get install -y tmux neovim

echo '[SETUP] Complete'

