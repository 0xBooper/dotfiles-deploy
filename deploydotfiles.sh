#/usr/bin/env bash

# Proceed function
function proceed () {
  echo "Installing required things..."
  pacman -S awesome xorg xorg-xinit zsh --noconfirm
  echo "Getting dotfiles..."
  git clone https://github.com/0xBooper/dotfiles.git
  echo "Deploying dotfiles..."
  cd dotfiles
  rm -rf .git README.md LICENSE .gitignore images
  mv -f .* ~
  echo "Deploying wallpapers for AwesomeWM"
  mv -f Wallpapers ~
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
