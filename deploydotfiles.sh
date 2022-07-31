#!/bin/sh
# 0xBooper's dotfile deployer script. Licensed under the GPLv3 license.

# Install scripts function
scriptsInstall () {
  git clone https://github.com/0xBooper/Scripts
  mkdir ~/temp
  mv ~/Scripts/Scripts/* ~/temp
  rm -rf ~/Scripts

  mkdir ~/Scripts
  mv ~/temp/* ~/Scripts
  rm -rf ~/temp

  finish 
}

# Finish function
finish () {
    echo "My (0xBooper)'s dotfiles have successfully been installed onto your system."
    echo "Have a nice day/night."
    exit 0
}

# Proceed function
proceed () {
  cd ~
  
  echo "Updating system..."
  sudo pacman -Syu --noconfirm
  
  echo "Installing required things..."
  sudo pacman -S awesome git neofetch neovim base-devel xorg xorg-xinit zsh --noconfirm
  
  echo "Getting dotfiles..."
  git clone https://github.com/0xBooper/dotfiles.git 
  
  echo "Deploying dotfiles..."
  cd dotfiles
  rm -rf .git README.md LICENSE .gitignore
  mv -f * ~

  echo "Downloading pfetch..."
  git clone https://github.com/dylanaraps/pfetch.git
  echo "Installing pfetch..."
  cd ~/pfetch && sudo make install
  echo "Cleaning up..."
  rm -rf ~/pfetch

  echo "Installing dmenu..."
  sudo pacman -S dmenu
  
  echo "Installing plugin manager for Neovim... (vim-plug)"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "To install the plugins, open Neovim and run :PlugInstall"
  sleep 1

  echo "Installing fonts required for Neovim..."
  sudo pacman -S nerd-fonts

  echo "Downloading wallpapers..."
  git clone https://github.com/makccr/wallpapers.git
  
  echo "Deploying wallpapers..."
  mkdir --parents ~/Media/Wallpapers
  mv ~/wallpapers/wallpapers/*.jpg ~/Media/Wallpapers
  rm -rf ~/wallpapers

  read -p "Do you also want to install my scripts? (Y/n)" userinput
  case $userinput in
      Y|y) scriptsInstall;;
      N|n) finish;; 
      *) echo "Unknown input."; exit 1;;
  esac
}

# Get confirmation
read -p "Are you sure you want to do this?\nThis will overwrite your existing dotfiles. (Y/n)" userinput
case $userinput in
  Y|y) proceed;;
  N|n) echo "Aborting..."; exit 0;;
  *) echo "Unknown input, terminating with no changes made."; exit 1;;
esac
