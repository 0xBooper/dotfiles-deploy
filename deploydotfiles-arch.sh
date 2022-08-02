#!/bin/sh
# 0xBooper's dotfile deployer script. Licensed under the GPLv3 license.

finish () {
  read -p "Would you like to install some of the applications I use? (discord, firefox) (Y/n)" USERINPUT
  case $USERINPUT in
      Y|y) sudo pacman -S --needed discord firefox --noconfirm;;
  esac

  echo "My (0xBooper)'s dotfiles have successfully been installed onto your system."
  echo "Take some time to look at them and configure it however you want."
  echo "Have a nice day/night."
  exit 0
}

echo -e "Are you sure you want to do this?\nThis will overwrite your existing dotfiles. (Y/n)" 
read USERINPUT
case $USERINPUT in
  Y|y) 
    read -p "Do you want to add a new user? (Y/n) " USERINPUT
    case $USERINPUT in
      Y|y) 
        read -p "Name of the user: " USERNAME
        read -p "Should this user have sudo permissions? (Y/n) " USERSUDO
        read -p "Groups (optional, separated by commas): " USERGROUPS
        
        [ -n $USERNAME ] && [ $USERSUDO = Y -o $USERSUDO = y ] && [ -n $USERGROUPS ] && echo "Creating user..." && sudo useradd -G wheel,$USERGROUPS -m $USERNAME && sudo passwd $USERNAME
        [ -n $USERNAME ] && [ -n $USERGROUPS ] && echo "Creating user..." && sudo useradd -G $USERGROUPS -m $USERNAME && sudo passwd $USERNAME
        [ -n $USERNAME ] && [ $USERSUDO = Y -o $USERSUDO = y ] && echo "Creating user..." && sudo useradd -G wheel -m $USERNAME && sudo passwd $USERNAME

        [ -n $USERNAME ] && su $USERNAME
        ;;
      N|n) echo "Proceeding..."  
      *) echo "Unknown input, proceeding anyways..."
    esac

    cd ~ 

    echo "Updating keyring..."
    sudo pacman -Sy archlinux-keyring --noconfirm
    
    echo "Updating system..."
    sudo pacman -Su --noconfirm
    
    echo "Installing required things..."
    sudo pacman -S --needed exa highlight awesome git neofetch neovim base-devel xorg xorg-xinit zsh dmenu nitrogen alacritty picom --noconfirm
    
    echo "Getting dotfiles..."
    git clone https://github.com/0xBooper/dotfiles.git 
    
    echo "Deploying dotfiles..."
    rm -rf ~/dotfiles/.git ~/dotfiles/README.md ~/dotfiles/LICENSE ~/dotfiles/.gitignore
    
    mkdir ~/.config
    mv -f ~/dotfiles/.config/* ~/.config
    mv -f ~/dotfiles/.bashrc ~
    mv -f ~/dotfiles/.bash_profile ~
    
    echo "Cleaning up..."
    rmdir ~/dotfiles
    
    echo "Downloading pfetch..."
    git clone https://github.com/dylanaraps/pfetch.git
    echo "Installing pfetch..."
    cd ~/pfetch && sudo make install
    echo "Cleaning up..."
    rm -rf ~/pfetch
    
    echo "Downloading yay (AUR helper)..."
    sudo pacman -S --needed base-devel --noconfirm 
    git clone https://aur.archlinux.org/yay.git
    
    echo "Installing yay (AUR helper)..."
    cd yay
    makepkg -si
    
    echo "Cleaning up..."
    cd ~
    rm -rf ~/yay
    
    echo "Getting yay setup..."
    yay -Y --gendb
    yay -Syu --devel
    yay -Y --devel --save
    
    echo "Installing ly (login manager)"
    yay -S ly
    
    echo "Installing plugin manager for Neovim... (vim-plug)"
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "To install the plugins, open Neovim and run :PlugInstall"
    sleep 1
    
    echo "Installing fonts required for Neovim..."
    sudo pacman -S --needed nerd-fonts --noconfirm
    
    echo "Downloading wallpapers..."
    git clone --depth 1 https://github.com/makccr/wallpapers.git
    
    echo "Deploying wallpapers..."
    mkdir --parents ~/Media/Wallpapers
    mv ~/wallpapers/wallpapers/*/*.jpg ~/Media/Wallpapers
    rm -rf ~/wallpapers
    
    echo "Setting .xinitrc..."
    echo "awesome" >> ~/.xinitrc
    
    read -p "Do you also want to install my scripts? (Y/n)" USERINPUT
    case $USERINPUT in
        Y|y) 
          echo "Downloading scripts..."
          git clone https://github.com/0xBooper/Scripts
          mkdir ~/temp
        
          mv ~/Scripts/Scripts/* ~/temp
          rm -rf ~/Scripts
          mkdir ~/Scripts
        
          echo "Deploying scripts..."
          mv ~/temp/* ~/Scripts
        
          echo "Cleaning up..."
          rm -rf ~/temp
    
          finish;;
        N|n) finish;;
        *) echo "Unknown input."; exit 1;;
    esac
    ;;
  N|n) echo "Aborting... (no changes made)"; exit 0;;
  *) echo "Unknown input, terminating with no changes made."; exit 1;;
esac
