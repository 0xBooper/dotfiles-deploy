#!/usr/bin/env bash

function deploy () {
    echo "Installing required programs..."
    sudo pacman -S awesome xorg xorg-xinit
    echo "Deploying dotfiles..."
    cd ~
    git clone https://github.com/0xBooper/dotfiles.git
    cd dotfiles
    rm -rf .git 
    cp -r -f .* ~
    echo "Dotfiles have been deployed! Run bash or run zsh to enter my dotfiles!"
    exit 0
}

echo "Are you sure you want to deploy my dotfiles? They will overwrite your existing dotfiles. (Y/n)"
read input
case $input in
    Y|y) deploy;;
    N|n) echo "Aborting..."; exit 0;;
    *) echo "Unknown input. Terminating..."; exit 1;;
esac
