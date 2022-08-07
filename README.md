# dotfiles-deploy

## What this script does
This script deploys my [dotfiles](https://github.com/0xBooper/dotfiles)
It then adds a user (if requested), updates all packages, installs required packages (e.g: awesome, xorg, neovim), installs ly (the login manager I use) and some other things. You'll see.

## A few warnings
This script ***WILL*** overwrite your existing dotfiles.

## Supported distros 
Any Arch Linux based distros (except Artix, as some of the things I use may not work on other init systems)

### Debian
This script currently won't work on Debian and Debian based distros.
However, Debian (and Debian based distros) are planned to be supported.

## Using it
1. Download it: `git clone https://github.com/0xBooper/dotfiles-deploy`
2. CD into the directory: `cd dotfiles-deploy`
3. Run the script: `./deploydotfiles-arch.sh`
4. If there are any errors relating to permissions, run `chmod +x deploydotfiles-arch.sh`

After the script has finished, your system now has my dotfiles!
It is probably best to reboot. Choose `awesome` in the login manager, then log in to your new AwesomeWM-configured desktop!

## Post-usage
There are some things the script cannot do automatically. Ideally right after the script finishes and you reboot (or don't), do these (any order):

- Open Neovim, and run `:PlugInstall` in the editor
- Select a wallpaper (run `nitrogen` in the terminal)
- Select a rofi theme (run `rofi-theme-selector` in the terminal)
- Configure my dotfiles and/or scripts to your taste!
