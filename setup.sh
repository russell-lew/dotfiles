#!/bin/bash

folder=".dotfiles"

# Install editor tools and the system dependencies used by Mason, Treesitter,
# Telescope, and the NVM installer.
echo '[SETUP] Installing editor tools and dependencies'
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
	    sudo apt-get -qq update
	    sudo apt-get install -y \
            build-essential curl fd-find git make neovim ripgrep tmux unzip wget xclip
	    ;;
    Darwin*)
        if ! command -v brew >/dev/null 2>&1; then
            echo '[SETUP] Homebrew is required: https://brew.sh'
            exit 1
        fi
        if ! xcode-select -p >/dev/null 2>&1; then
            echo '[SETUP] Apple Command Line Tools are required. Run: xcode-select --install'
            exit 1
        fi
	    brew install curl fd git make neovim ripgrep tmux unzip wget
	    brew install --cask font-jetbrains-mono-nerd-font

	    ;;
#   CYGWIN*)    machine=Cygwin;;
#   MINGW*)     machine=MinGw;;
#   MSYS_NT*)   machine=Git;;
    *)
        echo "[SETUP] Unsupported operating system: ${unameOut}"
        exit 1
esac

# Clone the dotfiles repository
if ! git clone https://github.com/russell-lew/dotfiles.git "${HOME}/${folder}" 2>/dev/null; then
    if [ -d "${HOME}/${folder}" ]; then
        echo "[SETUP] Using existing ${HOME}/${folder}"
    else
        echo '[SETUP] Failed to clone the dotfiles repository'
        exit 1
    fi
fi

# Create symlinks for tmux and nvim configuration
echo '[SETUP] Creating symbolic links for tmux and nvim configuration'
ln -sf "${HOME}/${folder}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
mkdir -p "${HOME}/.config/nvim"
for file in "${HOME}/${folder}/nvim"/*; do
    ln -sf "$file" "${HOME}/.config/nvim/"
done

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
