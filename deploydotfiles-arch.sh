#!/bin/sh
# 0xBooper's dotfile deployer script. Licensed under the GPLv3 license.
# PS: If the code is spaghetti to you (which it probably is), that's because im a terrible shell scripter, sorry.
# PS Part Two, Electric Boogaloo: The $LOOPs are for restarting the prompt in case a user inputs some wrong stuff.

finish () {
  echo "My (0xBooper)'s dotfiles have successfully been installed onto your system."
  echo "Take some time to look at them and configure it however you want."
  echo "Have a nice day/night."
  exit 0
  
  # Cleanup variables
  unset $USERINPUT
  unset $LOOP_MAIN_DONE
  unset $LOOP_USERADD_DONE
  unset $LOOP_OPTAPP_DONE 
  unset $LOOP_OPTGRUB_DONE
  unset $LOOP_SCRIPTS_DONE
}

while [ -z $LOOP_MAIN_DONE ]; do
  echo -e "Are you sure you want to do this?\nThis will overwrite your existing dotfiles. (Y/n)" 
  read USERINPUT
  case $USERINPUT in
    Y|y) 

      while [ -z $LOOP_USERADD_DONE ]; do
        read -p "Do you want to add a new user? (Y/n) " USERINPUT
        case $USERINPUT in
          Y|y) 
            while [ -z $LOOP_USERADD_DONE ]; do
              read -p "Name of the user (required): " USERNAME
              read -p "Should this user have sudo permissions? (Y/n): " USERSUDO
              read -p "Groups (optional, separated by commas): " USERGROUPS
              
              # Check if the username is nonexistant
              [ -z $LOOP_USERADD_DONE ] && [ -z $USERNAME ] && echo "The name of the user is required!"

              # Check for met values
              [ -z $LOOP_USERADD_DONE ] && [ -n $USERNAME ] && [ $USERSUDO = Y -o $USERSUDO = y ] && [ -n $USERGROUPS ] && echo "Creating user..." && sudo useradd -G wheel,$USERGROUPS -m $USERNAME && sudo passwd $USERNAME && su $USERNAME && LOOP_USERADD_DONE=yes
              [ -z $LOOP_USERADD_DONE ] && [ -n $USERNAME ] && [ -n $USERGROUPS ] && echo "Creating user..." && sudo useradd -G $USERGROUPS -m $USERNAME && sudo passwd $USERNAME && su $USERNAME && LOOP_USERADD_DONE=yes
              [ -z $LOOP_USERADD_DONE ] && [ -n $USERNAME ] && [ $USERSUDO = Y -o $USERSUDO = y ] && echo "Creating user..." && sudo useradd -G wheel -m $USERNAME && sudo passwd $USERNAME && su $USERNAME && LOOP_USERADD_DONE=yes
            done
            ;;
          N|n) echo "Proceeding..." && LOOP_USERADD_DONE=yes;;
          *) echo "Unknown input.";;
        esac
      done
  
      cd ~ 
  
      echo "Updating keyring..."
      sudo pacman -Sy archlinux-keyring --noconfirm --needed
      
      echo "Updating system..."
      sudo pacman -Su --noconfirm --needed
      
      echo "Installing required things..."
      sudo pacman -S --needed exa highlight awesome git neofetch neovim base-devel xorg xorg-xinit zsh rofi nitrogen kitty picom kmix network-manager-applet --noconfirm
      
      echo "Getting dotfiles..."
      git clone https://github.com/0xBooper/dotfiles.git 
      
      echo "Deploying dotfiles..."
      rm -rf ~/dotfiles/.git ~/dotfiles/README.md ~/dotfiles/LICENSE ~/dotfiles/.gitignore
      
      [ ! -d ~/.config ] && mkdir ~/.config
      mv -f ~/dotfiles/.config/* ~/.config
      mv -f ~/dotfiles/.bashrc ~
      mv -f ~/dotfiles/.bash_profile ~
      mv -f ~/dotfiles/.editorconfig ~

      while [ -z $LOOP_OPTGRUB_DONE ]; do
        read -p "Do you want to install my grub wallpaper (and config?) (Y/n) " USERINPUT
        case $USERINPUT in
          Y|y) 
            [ ! -d ~/Media/Wallpapers ] && mkdir --parents ~/Media/Wallpapers
            sudo mv -f ~/dotfiles/grub/grub  /etc/default/grub
            mv -f ~/dotfiles/grub/sunset.png ~/Media/Wallpapers
            LOOP_OPTGRUB_DONE=yes
            ;;
          N|n)
            echo "Proceeding..."
            LOOP_OPTGRUB_DONE=yes
            ;;
          *) echo "Unknown input";;
        esac
      done
      
      echo "Cleaning up..."
      rm -rf ~/dotfiles
      
      echo "Downloading wallpapers..."
      git clone --depth 1 https://github.com/makccr/wallpapers.git

      echo "Deploying wallpapers..."
      [ ! -d ~/Media/Wallpapers ] && mkdir --parents ~/Media/Wallpapers
      mv ~/wallpapers/wallpapers/*/*.jpg ~/Media/Wallpapers
      rm -rf ~/wallpapers

      echo "Downloading pfetch..."
      git clone https://github.com/dylanaraps/pfetch.git
      echo "Installing pfetch..."
      cd ~/pfetch && sudo make install
      echo "Cleaning up..."
      cd ~ && rm -rf ~/pfetch
      
      echo "Downloading yay (AUR helper)..."
      sudo pacman -S --needed base-devel --noconfirm 
      git clone https://aur.archlinux.org/yay.git
      
      echo "Installing yay (AUR helper)..."
      cd ~/yay && makepkg -si
      
      echo "Cleaning up..."
      cd ~ && rm -rf ~/yay
      
      echo "Getting yay setup..."
      yay -Y --gendb
      yay -Syu --devel
      yay -Y --devel --save
      
      echo "Installing ly (login manager)..."
      yay -S ly

      echo "Enabling ly (login manager)..."
      sudo systemctl enable ly
      
      echo "Installing plugin manager for Neovim... (vim-plug)"
      curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      echo "To install the plugins, open Neovim and run :PlugInstall"
      sleep 1
      
      echo "Installing fonts required for Neovim..."
      sudo pacman -S --needed nerd-fonts ttf-fira-code --noconfirm
      
      echo "Setting .xinitrc..."
      echo "awesome" >> ~/.xinitrc
      
      echo "Setting rofi up..."
      mkdir --parents ~/.config/rofi
      rofi -dump-config > ~/.config/rofi/config.rasi

      echo "Downloading nord theme (rofi)..."
      git clone https://github.com/lr-tech/rofi-themes-collection
      mkdir -p ~/.local/share/rofi/themes
      cp ~/rofi-themes-collection/themes/*.rasi ~/.local/share/rofi/themes/

      echo "A prompt will open. Select the nord theme, or any other preferrable rofi theme."
      sleep 1
      rofi-theme-selector

      echo "Cleaning up..."
      rm -rf ~/rofi-themes-collection

      while [ -z $LOOP_SCRIPTS_DONE ]; do
        read -p "Do you also want to install my scripts? (Y/n) " USERINPUT
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

              LOOP_SCRIPTS_DONE=yes
              ;;
            N|n) echo "Proceeding..." && LOOP_SCRIPTS_DONE=yes;;
            *) echo "Unknown input.";;
        esac
      done

      while [ -z $LOOP_OPTAPP_DONE ]; do
        read -p "Would you like to install some of the applications I use? (discord, firefox) (Y/n)" USERINPUT
        case $USERINPUT in
            Y|y) sudo pacman -S --needed discord firefox --noconfirm;;
            N|n) echo "Proceeding..." && LOOP_OPTAPP_DONE=yes;;
            *) echo "Unknown input";;
        esac
      done

      LOOP_MAIN_DONE=yes
      finish;;
    N|n) echo "Aborting... (no changes made)" && LOOP_MAIN_DONE=yes && exit 0;;
    *) echo "Unknown input.";;
  esac
done
