# dotfiles-deploy

## NOTICE
**Debian does not work currently, do NOT use it on a primary machine**
**If you decide to use it, please make an issue and put whatever bugs or issues you have there**
**Thanks for testing!**

## What this script does
This script deploys my [dotfiles](https://github.com/0xBooper/dotfiles)
It then adds a user (if requested), updates all packages, installs required packages (e.g: awesome, xorg, neovim), installs ly (the login manager I use) and some other things. You'll see.

## A few warnings
This script ***WILL*** overwrite your existing dotfiles.

## Supported distros 
Any Arch Linux based distros (except Artix, as some of the things I use may not work on other init systems)
Debian based distros (**NOT TESTED, IN DEVELOPMENT**)

## Debian and Debian based distros
**WARNING: THIS MAY NOT WORK**
**USE AT YOUR OWN RISK, AS THIS MAY RUIN YOUR DISTRO**

### Using it
1. Download it: `git clone https://github.com/0xBooper/dotfiles-deploy`
2. CD into the directory: `cd dotfiles-deploy`
3. Run the script `./debiandeploy`


## Arch and Arch based distros
### Using it
1. Download it: `git clone https://github.com/0xBooper/dotfiles-deploy`
2. CD into the directory: `cd dotfiles-deploy`
3. Run the script: `./archdeploy`

---

After the script has finished, your system now has my dotfiles!

## Post-usage
After the script finishes, do these things, unless you already have.

1. Reboot the system (`sudo reboot`)
2. Open Neovim, and run `:PlugInstall` in the editor
3. Select a wallpaper (run `nitrogen` in the terminal)
4. Select a rofi theme (run `rofi-theme-selector` in the terminal)
5. Configure my dotfiles and/or scripts to your taste!

---

Thanks for using this script! I highly encourage you to tinker around and change it to your taste, just use this as a starting ground!
