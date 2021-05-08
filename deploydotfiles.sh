#!/usr/bin/env bash
# 0xBooper's dotfile deployer script. Licensed under the GPLv3 license.


# Proceed function
proceed () {
  cd ~
  echo "Updating system..."
  sudo pacman -Syu
  echo "Downloading required things..."
  sudo pacman -S awesome git neofetch neovim base-devel xorg xorg-xinit zsh --noconfirm
  echo "Getting dotfiles..."
  git clone https://github.com/0xBooper/dotfiles.git
  echo "Deploying dotfiles..."
  cd dotfiles
  rm -rf .git README.md LICENSE .gitignore
  mv -f * ~
  echo "Installing some other things..."
  cd ~
  git clone https://github.com/dylanaraps/pfetch.git
  cd pfetch
  sudo make install
  cd ~
  rm -rf pfetch
  echo "Dotfiles have been fully deployed!"
  echo "Enjoy your system!"
  exit 0
}

# Get confirmation
read -p "Are you sure you want to do this?\nThis will overwrite your existing dotfiles. (Y/n)" userinput
case $userinput in
  Y|y) proceed;;
  N|n) echo "Aborting..."; exit 0;;
  *) echo "Unknown input. Terminating..."; exit 1;;
esac
